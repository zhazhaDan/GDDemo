//
//  Person.h
//  GDDemo
//
//  Created by GDD on 2021/8/24.
//  Copyright © 2021 GDD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy)NSMutableArray * scores;
@property (nonatomic, copy)NSMutableArray <Person *> * students;
@property (nonatomic, copy)NSString * name;

- (void)changeScores:(NSArray *)s;

- (void)changeAge:(NSInteger)age;
- (void)changeName:(NSString *)name;
- (void)setStudent:(Person *)p;

- (void)setNick:(NSString *)nick;

- (NSString *)nick;
@end

NS_ASSUME_NONNULL_END
