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
@implementation Person {
    NSString * nickName;
}

- (void)setNick:(NSString *)nick {
    nickName = nick;
}

- (NSString *)nick {
    return  nickName;
}

- (void)changeAge:(NSInteger)age {
    _age = age;
}
- (void)changeName:(NSString *)name {
//    self.student.name = name;
    nickName = name;
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

- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing  _Nullable *)outError {
    return YES;
}

- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKeyPath:(NSString *)inKeyPath error:(out NSError *__autoreleasing  _Nullable *)outError {
    return YES;
}
@end
