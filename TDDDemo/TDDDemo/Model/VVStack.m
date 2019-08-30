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
