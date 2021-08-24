//
//  NSObject+SafeKVO.m
//  GDDemo
//
//  Created by GDD on 2021/8/24.
//  Copyright © 2021 GDD. All rights reserved.
//

#import "NSObject+SafeKVO.h"
#import "GDSafeObserveModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define forceInline __inline__ __attribute__((always_inline))

static NSString * const kSafeKVOClassPrefix = @"SafeKVONotifying_";
static NSString * const kSafeKVOAssiociateObservers = @"SafeKVOAssiociateObservers";




//通过属性获取setter(set 访问器)
static forceInline SEL GD_setterSelectorFromPropertyName(NSString *propertyName) {
    if (propertyName.length <= 0)
        return nil;
    NSString *setterString = [NSString stringWithFormat:@"set%@%@:", [[propertyName substringToIndex:1] uppercaseString], [propertyName substringFromIndex:1]];
    return NSSelectorFromString(setterString);
}
// 通过 setter 获取属性


static forceInline NSString * GD_propertyNameFromSetterString(NSString *setterString) {
    if (setterString.length <= 0 || ![setterString hasPrefix: @"set"] || ![setterString hasSuffix: @":"])
        return nil;
    NSRange range = NSMakeRange(3, setterString.length - 4);
    NSString *propertyName = [setterString substringWithRange:range];
    propertyName = [propertyName stringByReplacingCharactersInRange: NSMakeRange(0, 1) withString:[[propertyName substringToIndex: 1] lowercaseString]];
    return propertyName;
}

static forceInline NSString * GD_propertyNameFromSetterSEL(SEL _cmd) {
    return GD_propertyNameFromSetterString(NSStringFromSelector(_cmd));
}


static forceInline Class GD_getSuperclass(id self) {
    return class_getSuperclass(object_getClass(self));
}


static forceInline void GD_setter(id self, SEL _cmd, id newValue) {
    @synchronized (self) {
        NSString * propertyName = GD_propertyNameFromSetterSEL(_cmd);
        NSParameterAssert((propertyName));
        if (!propertyName) {
            return;
        }
        
        NSMutableArray * observers = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kSafeKVOAssiociateObservers));
        for (GDSafeObserveModel * model in observers) {
            if ([model.keyPath containsString:propertyName]) {
                model.oldValue = [model.observed valueForKey:model.keyPath];
            }
        }
        //调用父类的set 访问器
        struct objc_super superClass = {
            .receiver = self,
            .super_class = GD_getSuperclass(self)
        };
        
        void (*superSetter)(void *, SEL, id) = (void *)objc_msgSendSuper;
        superSetter(&superClass, _cmd, newValue);
        for (GDSafeObserveModel * model in observers) {
            //观察者未释放
            if ([model.keyPath containsString:propertyName] && model.observer) {
                // 不能直接用newValue，因为可能有计算 通过KVC获取
                model.valueChange(model.observed, propertyName, model.oldValue, [model.observed valueForKey:model.keyPath]);
                model.oldValue = nil;
            }
        }
    }
}

// 创建一个安全的KVO监听类
static forceInline Class createSafeKVOClass(id object) {
    // 获取以SafeKVONotifying_为前缀拼接类名的子类
    Class observedClass = object_getClass(object);
    NSString * observedClassName = NSStringFromClass(observedClass);
    NSString * subClassName = [kSafeKVOClassPrefix stringByAppendingString:observedClassName];
    Class subClass = NSClassFromString(subClassName);
    
    // 判断该类是否已经存在
    if (subClass) {
        return subClass;
    }
    
    // 通过runtime动态创建该类
    // 分配类和元类的内存
    subClass = objc_allocateClassPair(observedClass, subClassName.UTF8String, 0);
    // 修改class实现，返回父类Class
    Method classMethod = class_getInstanceMethod(observedClass, @selector(class));
    const char * types = method_getTypeEncoding(classMethod);
    class_addMethod(subClass, @selector(class), (IMP)GD_getSuperclass, types);
    //注册到runtime
    objc_registerClassPair(subClass);
    return subClass;
}

// 判断当前类中是否有对应的selector
static forceInline BOOL objectHasSelector(id object, SEL selector) {
    BOOL result = NO;
    unsigned int count = 0;
    Class observedClass = object_getClass(object);
    Method * methods = class_copyMethodList(observedClass, &count);
    for (int i = 0; i < count; i++) {
        SEL sel = method_getName(methods[i]);
        if (sel == selector) {
            result = YES;
            break;;
        }
    }
    free(methods);
    return result;
}




@implementation NSObject (SafeKVO)
- (void)GD_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath observeValueChanged:(GD_ObservedValueChanged)change {
    @synchronized (self) {
        NSMutableArray * observers = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kSafeKVOAssiociateObservers));
        for (GDSafeObserveModel * model in observers) {
            //如果是已添加的监听就不重复添加了
            if (model.observer == observer && model.observed == self && [model.keyPath isEqualToString:keyPath]) {
                return;
            }
        }
        
        // 通过keypath的.依次找到子类的set方法
        NSArray * keys = [keyPath componentsSeparatedByString:@"."];
        NSInteger index = 0;
        id object = self;
        while (index < keys.count) {
            SEL setterSelector = GD_setterSelectorFromPropertyName(keys[index]);
            Method setterMethod = class_getInstanceMethod([object class], setterSelector);
            NSParameterAssert((setterMethod));
            if (!setterMethod) {
                return;;
            }
            id nextObject = [object valueForKey:keys[index]];
            Class observedClass = object_getClass(object);
            NSString * observedClassName = NSStringFromClass(observedClass);
            if (![observedClassName hasPrefix:kSafeKVOClassPrefix]) {
                // 创建子类并修改本类isa指向子类
                observedClass = createSafeKVOClass(object);
                object_setClass(object, observedClass);
            }
            if (!objectHasSelector(object, setterSelector)) {
                // 重写set方法在方法里调用父类的set 并通过block回调上层，完成整个监听过程
                const char * types = method_getTypeEncoding(setterMethod);
                class_addMethod(observedClass, setterSelector, (IMP)GD_setter, types);
            }
            
            // 添加监听者到类的关联对象数组
            observers = objc_getAssociatedObject(object, (__bridge  const void *)kSafeKVOAssiociateObservers);
            if (!observers) { //保存观察者
                observers = [NSMutableArray array];
                objc_setAssociatedObject(object, (__bridge  const void *)kSafeKVOAssiociateObservers, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            GDSafeObserveModel * model = [[GDSafeObserveModel alloc] initWithObserver:object observed:self forKeyPath:keyPath valueChanged:change];
            [observers addObject:model];
            
            object = nextObject;
            index ++;
        }
        
    }
}


- (void)GD_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    @synchronized (self) {
        NSArray * keys = [keyPath componentsSeparatedByString:@"."];
        NSInteger index = 0;
        id object = self;
        while (index < keys.count) {
            GDSafeObserveModel * removeModel = nil;
            NSMutableArray * observers = objc_getAssociatedObject(self, (__bridge const void *)kSafeKVOAssiociateObservers);
            for (GDSafeObserveModel * model in observers) {
                if (model.observer == observer && model.observed == self && [model.keyPath isEqualToString:keyPath]) {
                    removeModel = model;
                    break;;
                }
            }
            
            if (removeModel) {
                [observers removeObject:removeModel];
                if (!observers.count) {
                    object_setClass(object, [object class]); //将当前类的isa指回父类的
                }
            } else {
                object_setClass(object, [object class]);
            }
            object = [object valueForKey:keys[index]];
            index++;
        }
    }
}
@end
