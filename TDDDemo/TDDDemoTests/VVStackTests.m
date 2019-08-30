//
//  VVStackTests.m
//  TDDDemoTests
//
//  Created by zsp on 2019/8/30.
//  Copyright © 2019 woop. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "VVStack.h"

SPEC_BEGIN(SimpleStringSpec)

//Given SimpleString
//When assigned to xxx
//Then it should exist and should equal to xxx


//三者共同构成了Kiwi测试中的行为描述。
describe(@"SimpleString", ^{//1、describe描述需要测试的对象内容，也即我们三段式中的Given，
    context(@"when assigned to 'Hello world'", ^{//2、context描述测试上下文，也就是这个测试在When来进行
        NSString *str = @"Hello world";
        it(@"should exist", ^{//3、最后it中的是测试的本体，描述了这个测试应该满足的条件
//实际的测试写在it里，是由一个一个的期望(Expectations)来进行描述的，期望相当于传统测试中的断言，
//要是运行的结果不能匹配期望，则测试失败。
//在Kiwi中期望都由should或者shouldNot开头，并紧接一个或多个判断的的链式调用，
//大部分常见的是be或者haveSomeCondition的形式。
            [[str shouldNot] beNil];
        });
        
        it(@"should equal to 'Hello world'", ^{
            [[str should] equal:@"Hello world"];
        });
    });
});

//建议一个测试文件应该专注于测试一个类
//一个describe可以包含多个context，来描述类在不同情景下的行为；
//一个context可以包含多个it的测试例。

//除了这三个之外，Kiwi还有一些其他的行为描述关键字，其中比较重要的包括
//
//beforeAll(aBlock) - 当前scope内部的所有的其他block运行之前调用一次
//afterAll(aBlock) - 当前scope内部的所有的其他block运行之后调用一次
//beforeEach(aBlock) - 在scope内的每个it之前调用一次，对于context的配置代码应该写在这里
//afterEach(aBlock) - 在scope内的每个it之后调用一次，用于清理测试后的代码
//specify(aBlock) - 可以在里面直接书写不需要描述的测试
//pending(aString, aBlock) - 只打印一条log信息，不做测试。这个语句会给出一条警告，可以作为一开始集中书写行为描述时还未实现的测试的提示。
//xit(aString, aBlock) - 和pending一样，另一种写法。因为在真正实现时测试时只需要将x删掉就是it，但是pending语意更明确，因此还是推荐pending
//可以看到，由于有context的存在，以及其可以嵌套的特性，测试的流程控制相比传统测试可以更加精确。我们更容易把before和after的作用区域限制在合适的地方。

SPEC_END

SPEC_BEGIN(VVStackSpec)

describe(@"VVStack", ^{
    context(@"when created", ^{
        
        __block VVStack *stack=nil;
        
        beforeEach(^{
            stack = [VVStack new];
        });
        
        afterEach(^{
            stack = nil;
        });
        
        it(@"should have the class VVStack", ^{
            [[[VVStack class] shouldNot] beNil];
        });
        
        it(@"should exist", ^{
            [[stack shouldNot] beNil];
        });
        
        it(@"should be able to push and get top", ^{
            [stack push:2.3];
//对于标量，需要先将其转换为对象。
//Kiwi提供了一个标量转对象的语法糖，叫做theValue，
//在做精确比较的时候一般使用带有精度的比较期望来进行描述，即equal:withDelta:
            [[theValue([stack top]) should] equal:theValue(2.3)];
            
            [stack push:4.6];
            [[theValue([stack top]) should] equal:theValue(4.6)];
        });
        
        it(@"should equal contains 0 element", ^{
            [[theValue(stack.count) should] equal:theValue(0)];
//            [[stack should] beEmpty];
//            [[stack should] haveCountOf:0];
        });
        
        //测试异常的抛出
        it(@"should raise a exception when pop", ^{
            [[theBlock(^{
                [stack pop];
            }) should] raiseWithName:@"VVStackPopEmptyException"];
        });
    });
    
    context(@"when new created and push 4.6", ^{
        __block VVStack *stack=nil;
        
        beforeEach(^{
            stack = [VVStack new];
            [stack push:4.6];
        });
        
        afterEach(^{
            stack = nil;
        });
        
        it(@"can be poped and the value equals 4.6 in VVStack", ^{
            [[theValue([stack pop]) should] equal:theValue(4.6)];
        });
        
        it(@"should contains 0 element after pop", ^{
            [stack pop];
            [[stack should] beEmpty];
        });
    });
});

SPEC_END
