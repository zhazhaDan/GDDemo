//
//  GDSafeObserveModel.m
//  GDDemo
//
//  Created by GDD on 2021/8/23.
//  Copyright © 2021 GDD. All rights reserved.
//

#import "GDSafeObserveModel.h"

@implementation GDSafeObserveModel

- (instancetype)initWithObserver:(NSObject *)observer observed:(NSObject *)observed forKeyPath:(NSString *)keyPath valueChanged:(GD_ObservedValueChanged)changed {
    if (self = [super init]) {
        self.observer = observer;
        self.observed = observed;
        self.keyPath = keyPath;
        self.valueChange = changed;
    }
    return self;
}
@end
