//
//  Person.m
//  GDDemo
//
//  Created by GDD on 2021/8/24.
//  Copyright © 2021 GDD. All rights reserved.
//

#import "Person.h"

@interface Person()
@property (nonatomic, assign)NSInteger age;
@property (nonatomic, strong)Person * student;
@end
@implementation Person

- (void)changeAge:(NSInteger)age {
    _age = age;
}
- (void)changeName:(NSString *)name {
//    self.student.name = name;
    self.name = name;
}

- (void)setStudent:(Person *)p {
    _student = p;
}

- (void)changeScores:(NSArray *)s {
    [self.scores addObjectsFromArray:s];
}

- (NSMutableArray *)scores {
    if (!_scores) {
        _scores = [NSMutableArray array];
    }
    return  _scores;
}
@end
