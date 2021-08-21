//
//  OCTestViewController.m
//  GDDemo
//
//  Created by GDD on 2021/8/20.
//  Copyright © 2021 GDD. All rights reserved.
//

#import "OCTestViewController.h"
#import "GCDBarrierSafeArray.h"

@interface OCTestViewController ()

@end

@implementation OCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"2");

    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"串行队列中的同步任务");
    });

    NSLog(@"2");


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

@end
