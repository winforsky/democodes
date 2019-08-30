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
    if (self.numbers.count == 0) {
        [NSException raise:@"VVStackPopEmptyException" format:@"No element can be poped in stack"];
    }
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

//Given a team, when newly created, it should have a name, and should have 11 players
//行为描述（Specs）和期望（Expectations），Kiwi测试的基本结构

//传统测试的文件名一般以Tests为后缀，表示这个文件中含有一组测试，
//而在Kiwi中，一个测试文件所包含的是一组对于行为的描述（Spec），
//因此习惯上使用需要测试的目标类来作为名字，并以Spec作为文件名后缀。
