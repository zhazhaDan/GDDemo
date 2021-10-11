//
//  OCTestViewController.m
//  GDDemo
//
//  Created by GDD on 2021/8/20.
//  Copyright © 2021 GDD. All rights reserved.
//

#import "OCTestViewController.h"
#import "GCDBarrierSafeArray.h"
#import "CustomOperation.h"
#import "Person.h"
#import "NSObject+SafeKVO.h"

@interface OCTestViewController ()

@end

@implementation OCTestViewController


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"keypath is %@, value is %@", keyPath, change);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    Person * person = [[Person alloc] init];
    [person scores];
//    [person setStudent:[Person new]];
//    [person GD_addObserver:self forKeyPath:@"student.name" observeValueChanged:^(id object, NSString *keyPath, id oldValue, id newValue) {
//        NSLog(@"%@'s keypath: %@ value changed old value is %@, new value is %@", object, keyPath, oldValue, newValue);
//    }];
//

    
    [person addObserver:self forKeyPath:@"scores" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [person addObserver:self forKeyPath:@"nick" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    person.nick = @"GDD";
//    person.nick = @"LMN";
//    [person changeScores:@[@1,@2]];
//    person.scores = @[@1,@2,@3];
    
    person.students = [NSMutableArray array];
    Person * student1 = [[Person alloc] init];
    [student1 changeAge:10];
    Person * student2 = [[Person alloc] init];
    [student2 changeAge:20];
    person.students = [NSMutableArray arrayWithArray:@[student1, student2]];

    NSLog(@"max %@", [person.students valueForKeyPath:@"@max.age"]);
    NSLog(@"sum %@", [person.students valueForKeyPath:@"@distinctUnionOfObjects.age"]);
    NSLog(@"student %@", [person.students valueForKeyPath:@"students"]);
//        [person changeName:@"GDD"];
//        [person changeName:@"LEE"];
//        [person changeName:@"HUUU"];
    
//
//    NSMutableArray * array = [NSMutableArray array];
//
//
//    CustomOperation * custom = [[CustomOperation alloc] init];
//
////    [operation start];
//
//    NSBlockOperation * block = [[NSBlockOperation alloc] init];
//
//    [block addExecutionBlock:^{ //可能开启新线程
//        for (int i = 0; i < 2; i++) {
//            [array addObject:@(i+10)];
//            NSLog(@"NSBlockOperation %d, at thread %@", i+10, [NSThread currentThread]);
//        }
//    }];
//    [block addExecutionBlock:^{
//        for (int i = 0; i < 9; i++) {
//            [array addObject:@(i+20)];
//            NSLog(@"NSBlockOperation %d, at thread %@", i+20, [NSThread currentThread]);
//        }
//
//    }];
//
//
//    [block addExecutionBlock:^{
//        for (int i = 0; i < 9; i++) {
//            [array addObject:@(i+30)];
//            NSLog(@"NSBlockOperation %d, at thread %@", i+30, [NSThread currentThread]);
//        }
//
//    }];
//    [block addExecutionBlock:^{
//        for (int i = 0; i < 9; i++) {
//            [array addObject:@(i+40)];
//            NSLog(@"NSBlockOperation %d, at thread %@", i+40, [NSThread currentThread]);
//        }
//
//    }];
//
//    [block setCompletionBlock:^{ //所有的block结束后执行 可能开启子线程
//        NSLog(@"NSBlockOperation complete at thread %@", [NSThread currentThread]);
//    }];
//
//
//    NSInvocationOperation * invocat = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test) object:nil];
//    [invocat setCompletionBlock:^{
//        NSLog(@"NSInvocationOperation complete at thread %@", [NSThread currentThread]);
//
//    }];
//
////    [invocat start];
////    [operation start];
//
//    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
////    [queue setMaxConcurrentOperationCount:2];
////    [operation addDependency:invocat];
////    [custom addDependency:block];
////    [custom addDependency:invocat];
//    [queue addOperation:block];
//    [queue addOperation:invocat];
//    [queue addOperation:custom];
//    [block setQueuePriority:NSOperationQueuePriorityLow];
//    [invocat setQueuePriority:NSOperationQueuePriorityHigh];
//
//    [queue addOperationWithBlock:^{
//        for (int i = 0; i < 9; i++) {
//            [array addObject:@(i+50)];
//            NSLog(@"NSOperationQueue add block %d, at thread %@", i+50, [NSThread currentThread]);
//        }
//    }];
//
//    [queue addBarrierBlock:^{
//        NSLog(@"%ld, %@", array.count, array);
//    }];
//    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        NSLog(@"dispatch_async thread %@", [NSThread currentThread]);
//        [self performSelector:@selector(test) withObject:nil afterDelay:2];
//    });
//
//    NSLog(@"dispatch_async end thread %@", [NSThread currentThread]);
//
//    NSLog(@"current thread %@", [NSThread currentThread]);
//
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
//
//    dispatch_async(queue, ^{
//        NSLog(@"dispatch_async %@", [NSThread currentThread]);
//        dispatch_semaphore_signal(semaphore);
//    });
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    NSLog(@"dispatch_semaphore_wait %@", [NSThread currentThread]);
//
//
//    dispatch_async(queue, ^{
//        NSLog(@"dispatch_async1 %@", [NSThread currentThread]);
//        dispatch_semaphore_signal(semaphore);
//    });
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    NSLog(@"dispatch_semaphore_wait1 %@", [NSThread currentThread]);
//
//
//    dispatch_async(queue, ^{
//        NSLog(@"dispatch_async2 %@", [NSThread currentThread]);
//        dispatch_semaphore_signal(semaphore);
//    });
//
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    NSLog(@"dispatch_semaphore_wait2 %@", [NSThread currentThread]);


//    CFAbsoluteTime currentTime0 = CFAbsoluteTimeGetCurrent();
//    for (int i ; i < 10000; i++) { }
//    CFAbsoluteTime totalTime0 = CFAbsoluteTimeGetCurrent() - currentTime0;
//    NSLog(@"for loop total time is %f", totalTime0);
//
//    CFAbsoluteTime currentTime1 = CFAbsoluteTimeGetCurrent();
//    dispatch_apply(10000, queue, ^(size_t index) {
//
//    });
//    CFAbsoluteTime totalTime1 = CFAbsoluteTimeGetCurrent() - currentTime1;
//    NSLog(@"dispatch_apply total time is %f", totalTime1);
//
//    CFAbsoluteTime currentTime2 = CFAbsoluteTimeGetCurrent();
//    dispatch_sync(queue, ^{
//        for (int i ; i < 10000; i++) { }
//    });
//    CFAbsoluteTime totalTime2 = CFAbsoluteTimeGetCurrent() - currentTime2;
//    NSLog(@"dispatch_sync total time is %f", totalTime2);

//    dispatch_once_t one;
//    dispatch_once(&one, ^{
//        NSLog(@"1 at thread %@", [NSThread currentThread]);
//    });
//    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
////        dispatch_once_t one;
//        NSLog(@"dispatch_async at thread %@", [NSThread currentThread]);
//        dispatch_once(&one, ^{
//            NSLog(@"2 at thread %@", [NSThread currentThread]);
//        });
//    });


//    NSLog(@"1");

//    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), queue, ^{
//        NSLog(@"dispatch_after current thread %@", [NSThread currentThread]);
//    });
//
//    dispatch_async(queue, ^{
//        NSLog(@"dispatch_async at thread %@", [NSThread currentThread]);
//    });
//
//    dispatch_sync(queue, ^{
//        NSLog(@"dispatch_sync at thread %@", [NSThread currentThread]);
//    });

//    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
//    __block int a = 5;
//    for (int i = 0; i < 100; i++) {
//        dispatch_async(queue, ^{
//            a++;
//            NSLog(@"%d %@", a, [NSThread mainThread]);
//        });
//    }
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("GDSerialQueue", DISPATCH_QUEUE_CONCURRENT); //并发队列
//
//    GCDBarrierSafeArray * safeArray = [[GCDBarrierSafeArray alloc] init];
//    for (int i = 0; i < 100; i++) {
//        dispatch_async(concurrentQueue, ^{
//            NSString *str = [NSString stringWithFormat:@"%d",i];
//            [safeArray addObject:str];
//        });
//    }
//
//    NSLog(@"result is %ld  === %@", safeArray.count, [safeArray array]);

//    NSMutableArray * array = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 10000; i++) {
////        dispatch_async(concurrentQueue, ^{
//            NSString *str = [NSString stringWithFormat:@"%d",i];
//            [array addObject:str];
////        });
//    }





    // tempArray的访问
//       dispatch_queue_t queue_t00 = dispatch_queue_create("dispatch_queue00", DISPATCH_QUEUE_CONCURRENT);
//       dispatch_queue_t queue_t01 = dispatch_queue_create("dispatch_queue01", DISPATCH_QUEUE_CONCURRENT);
//       CFAbsoluteTime currentTime0 = CFAbsoluteTimeGetCurrent();
//       dispatch_apply(5000, queue_t00, ^(size_t index0) {
//           NSLog(@"index: %zu --- %@", index0, [safeArray objectAtIndex:index0]);
//       });
//       dispatch_apply(5000, queue_t01, ^(size_t index0) {
//           NSLog(@"index: %zu --- %@", index0, [safeArray objectAtIndex:index0+4999]);
//       });
//       CFAbsoluteTime totalTime0 = CFAbsoluteTimeGetCurrent() - currentTime0;
//
//       // array的访问
//       dispatch_queue_t queue_t10 = dispatch_queue_create("dispatch_queue10", DISPATCH_QUEUE_CONCURRENT);
//       dispatch_queue_t queue_t11 = dispatch_queue_create("dispatch_queue11", DISPATCH_QUEUE_CONCURRENT);
//       CFAbsoluteTime currentTime1 = CFAbsoluteTimeGetCurrent();
//    dispatch_apply(5000, queue_t10, ^(size_t index0) {
//        NSLog(@"index: %zu --- %@", index0, [array objectAtIndex:index0]);
//    });
//    dispatch_apply(5000, queue_t11, ^(size_t index0) {
//        NSLog(@"index: %zu --- %@", index0, [array objectAtIndex:index0+4999]);
//    });
//       CFAbsoluteTime totalTime1 = CFAbsoluteTimeGetCurrent() - currentTime1;
//
//       // 两个访问时间对比
//       NSLog(@"totalTime0:%f - totalTime1:%f",totalTime0,totalTime1);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)test {
    NSLog(@"test at thread %@", [NSThread currentThread]);
    for (int i = 0; i < 10; i++) {
        NSLog(@"NSInvocationOperation %d, at thread %@", i + 100, [NSThread currentThread]);
    }
}

@end
