//
//  GCDBarrierSafeArray.h
//  GDDemo
//  利用栅栏实现一个多读单写线程安全的数组
//  Created by GDD on 2021/8/19.
//  Copyright © 2021 GDD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDBarrierSafeArray : NSObject
- (NSMutableArray *)array;
- (NSInteger)count;

- (void)addObject:(id)object;
- (void)addObjectsFromArray:(NSArray *)array;
- (void)insertObject:(id)object atIndex:(NSInteger)index;

- (void)removeObjectAtIndex:(NSInteger)index;
- (void)removeObject:(id)object;
- (void)removeAllObjects;
- (void)removeLastObject;

- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)object;

- (id)objectAtIndex:(NSInteger)index;
- (NSInteger)indexOfObject:(id)object;

@end

NS_ASSUME_NONNULL_END
