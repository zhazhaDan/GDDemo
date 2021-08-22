//
//  CustomOperation.m
//  GDDemo
//
//  Created by GDD on 2021/8/22.
//  Copyright © 2021 GDD. All rights reserved.
//

#import "CustomOperation.h"

@interface CustomOperation()
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@end

@implementation CustomOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (void)main {
    if (self.isCancelled) {
        return;
    }
    NSLog(@"begin executing %@ at %@", NSStringFromSelector(_cmd), [NSThread currentThread]);

    for (int i = 0; i < 10; i++) {
        if (self.isCancelled) {
            self.executing = NO;
            self.finished = NO;
            return;
        }
        NSLog(@"%@ at thread %@", NSStringFromClass([self class]), [NSThread currentThread]);
    }
    self.executing = NO;
    self.finished = YES;
    NSLog(@"finish executing %@ at %@", NSStringFromSelector(_cmd), [NSThread currentThread]);
}

- (void)start {
    @synchronized (self) {

        if (self.isCancelled) {
            return;
        }
        [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil]; //默认start在主线程，如果想开启子线程，就需要手动开始子线程执行
    //    [self main];
        self.executing = YES;
    }
}

- (void)cancel {
    @synchronized (self) {
        if (self.isFinished) {
            return;
        }
        [super cancel];
        if (self.isExecuting) {
            self.executing = NO;
        }
        if (!self.isFinished) {
            self.finished = YES;
        }
    }
}



- (BOOL)isAsynchronous {
    return YES;
}


// custom 通知KVO
- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
