//
//  GDSafeObserveModel.h
//  GDDemo
//
//  Created by GDD on 2021/8/23.
//  Copyright © 2021 GDD. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^GD_ObservedValueChanged)(id object, NSString * keyPath, id oldValue, id newValue);

@interface GDSafeObserveModel : NSObject
@property (nonatomic, weak) NSObject *observer;// 观察者
@property (nonatomic, weak) NSObject *observed;// 被观察者
@property (nonatomic, copy) NSString *keyPath;// 属性链
@property (nonatomic, copy) GD_ObservedValueChanged valueChange; // 观察者回调
@property (nonatomic, strong) NSObject *oldValue;// 被观察属性原值
- (instancetype)initWithObserver:(NSObject *)observer observed:(NSObject *)observed forKeyPath:(NSString *)keyPath valueChanged:(GD_ObservedValueChanged)changed;
@end
