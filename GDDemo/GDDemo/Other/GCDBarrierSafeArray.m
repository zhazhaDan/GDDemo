//
//  GCDBarrierSafeArray.m
//  GDDemo
//  利用栅栏实现一个多读单写线程安全的数组
/*
dispatch_barrier_async
Calls to this function always return immediately after the block is submitted and never wait for the block to be invoked. When the barrier block reaches the front of a private concurrent queue, it is not executed immediately. Instead, the queue waits until its currently executing blocks finish executing. At that point, the barrier block executes by itself. Any blocks submitted after the barrier block are not executed until the barrier block completes.
The queue you specify should be a concurrent queue that you create yourself using the dispatch_queue_create function. If the queue you pass to this function is a serial queue or one of the global concurrent queues, this function behaves like the dispatch_async function.
*/
/*
 1. 立马返回 == 不阻塞当前线程
 2. 通过 dispatch_queue_create 创建的 并发线程
 3. 当一个 barrier block到栈底了，它不会立马执行，会等到当前并发队列之行完当前的 block
 4. 如果你用了一个串行队列或者全局并发队列，这个函数的作用就和 dispatch_async 的作用一样了。
 */


/**
 dispatch_barrier_sync
 This function submits a barrier block to a dispatch queue for synchronous execution. Unlike dispatch_barrier_async, this function does not return until the barrier block has finished. Calling this function and targeting the current queue results in deadlock.
 When the barrier block reaches the front of a private concurrent queue, it is not executed immediately. Instead, the queue waits until its currently executing blocks finish executing. At that point, the queue executes the barrier block by itself. Any blocks submitted after the barrier block are not executed until the barrier block completes.
 The queue you specify should be a concurrent queue that you create yourself using the dispatch_queue_create function. If the queue you pass to this function is a serial queue or one of the global concurrent queues, this function behaves like the dispatch_sync function.
 Unlike with dispatch_barrier_async, no retain is performed on the target queue. Because calls to this function are synchronous, it "borrows" the reference of the caller. Moreover, no Block_copy is performed on the block.
 As an optimization, this function invokes the barrier block on the current thread when possible.
 */
/*
 1. 不会立马返回，block执行完之后返回 == 阻塞当前线程
 2. 通过 dispatch_queue_create 创建的 并发线程
 3. 当一个 barrier block到栈底了，它不会立马执行，会等到当前并发队列之行完当前的 block
 4. 如果你用了一个串行队列或者全局并发队列，这个函数的作用就和 dispatch_sync 的作用一样了
 5. 他不会对block进行copy，也不会对他进行retain，因为他是同步的
 6. 在当前队列中调用 dispatch_barrier_sync 会导致死锁
 */
//  Created by GDD on 2021/8/19.
//  Copyright © 2021 GDD. All rights reserved.
//

#import "GCDBarrierSafeArray.h"


@implementation GCDBarrierSafeArray
{
    NSMutableArray * _array;
    dispatch_queue_t _concurrentQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _concurrentQueue = dispatch_queue_create("GCDBarrierSafeArray", DISPATCH_QUEUE_CONCURRENT);
        _array = [NSMutableArray array];
    }
    return self;
}

- (NSMutableArray *)array {
    __block NSMutableArray * safeArray;
    dispatch_sync(_concurrentQueue, ^{
        safeArray = _array;
    });
    return safeArray;
}
- (NSInteger)count {
    __block NSInteger count;
    dispatch_sync(_concurrentQueue, ^{
        count = _array.count;
    });
    return count;
}

- (void)addObject:(id)object {
    if (!object) { return; }
    dispatch_barrier_async(_concurrentQueue, ^{
        [self->_array addObject:object];
//        NSLog(@"%@  %@", object, [NSThread currentThread]);
    });
}
- (void)addObjectsFromArray:(NSArray *)array {
    if (array.count == 0) { return; }
    dispatch_barrier_async(_concurrentQueue, ^{
        [self->_array addObjectsFromArray:array];
    });
}
- (void)insertObject:(id)object atIndex:(NSInteger)index {

    dispatch_barrier_async(_concurrentQueue, ^{
        if (object && index < self->_array.count) {
            [self->_array insertObject:object atIndex:index];
        }
    });
}

- (void)removeObjectAtIndex:(NSInteger)index {
    dispatch_barrier_async(_concurrentQueue, ^{
        [self->_array removeObjectAtIndex:index];
    });
}
- (void)removeObject:(id)object {
    if (!object) { return; }
    dispatch_barrier_async(_concurrentQueue, ^{
        [self->_array removeObject:object];
    });
}
- (void)removeAllObjects {
    dispatch_barrier_async(_concurrentQueue, ^{
        [self->_array removeAllObjects];
    });
}
- (void)removeLastObject {
    dispatch_barrier_async(_concurrentQueue, ^{
        [self->_array removeLastObject];
    });
}

- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)object {
    dispatch_barrier_async(_concurrentQueue, ^{
        if (object && index < self->_array.count) {
            [self->_array replaceObjectAtIndex:index withObject:object];
        }
    });
}

- (id)objectAtIndex:(NSInteger)index {
    __block id obj;
    dispatch_barrier_sync(_concurrentQueue, ^{
        if (index < self->_array.count) {
            obj = [self->_array objectAtIndex:index];
        }
    });
    return obj;
}
- (NSInteger)indexOfObject:(id)object {
    __block NSInteger index;
    dispatch_barrier_sync(_concurrentQueue, ^{
        index = [self->_array indexOfObject:object];
    });
    return index;
}

- (void)dealloc
{
    if (_concurrentQueue) {
        _concurrentQueue = NULL;
    }
}

@end
