//
//  VVStack.m
//  TDDDemo
//
//  Created by zsp on 2019/8/30.
//  Copyright © 2019 woop. All rights reserved.
//

#import "VVStack.h"

@interface VVStack ()

@property(nonatomic, strong)NSMutableArray* numbers;

@end

@implementation VVStack

- (instancetype)init {
    if (self=[super init]) {
        _numbers=[NSMutableArray array];
    }
    return self;
}

- (void)push:(double)num {
    [self.numbers addObject:@(num)];
}

- (double)top {
    return [[self.numbers lastObject] doubleValue];
}

- (double)pop {
    double top=[self top];
    [self.numbers removeLastObject];
    return top;
}

@end

//BDD其实就是在讲故事。
//一个典型的BDD的测试用例包活完整的三段式上下文，
//测试大多可以翻译为Given..When..Then的格式，读起来轻松惬意。
//describe(@"Team", ^{
//    context(@"when newly created", ^{
//        it(@"has a name", ^{
//            id team = [Team team];
//            [[team.name should] equal:@"Black Hawks"];
//        });
//        
//        it(@"has 11 players", ^{
//            id team = [Team team];
//            [[[team should] have:11] players];
//        });
//    });
//});
