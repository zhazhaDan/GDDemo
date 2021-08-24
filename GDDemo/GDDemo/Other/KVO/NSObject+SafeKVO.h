//
//  NSObject+SafeKVO.h
//  GDDemo
//
//  Created by GDD on 2021/8/24.
//  Copyright © 2021 GDD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GD_ObservedValueChanged)(id object, NSString * keyPath, id oldValue, id newValue);

@interface NSObject (SafeKVO)

/// 添加安全观察者
/// @param observer 观察者
/// @param keyPath 属性链
/// @param change 回调
- (void)GD_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath observeValueChanged:(GD_ObservedValueChanged)change;

/// 移除观察者
/// @param observer 观察者
/// @param keyPath 属性链
- (void)GD_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

