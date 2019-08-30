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

//Kiwi相对高级的用法包括模拟对象 (mock)，桩程序(stub)，参数捕获和异步测试等内容。
//这些方法都是在测试中会经常用到的，用来减少我们测试的难度的手段，特别是在耦合复杂的情况下的测试以及对于 UI 事件的测试。

//很多时候你会发现有些代码是“无法测试”的，因为代码之间存在较高的耦合程度，
//因此绕不开对于其他类的依赖，来对某个类单独测试其正确性。

//人为地让一个对象对某个方法返回我们事先规定好的值，这就叫做 stub。

//Person *person = [Person somePerson];
//[person stub:@selector(name) andReturn:@“Tom”];
//对于 Kiwi 的 stub，需要注意的是它不是永久有效的，
//在每个 it block 的结尾 stub 都会被清空，超出范围的方法调用将不会被 stub 截取到。


//Mock
//可以将 mock 看做是一种更全面和更智能的 stub。
//mock 其实就是一个对象，它是对现有类的行为一种模拟（或是对现有接口实现的模拟）。
//在 objc 的 OOP 中，类或者接口就是指导对象行为的蓝图，而 mock 则遵循这些蓝图并模拟它们的实例对象。
//从这方面来说，mock 与 stub 最大的区别在于
//stub 只是简单的方法替换，而不涉及新的对象，被 stub 的对象可以是业务代码中真正的对象。
//而 mock 行为本身产生新的（不可能在业务代码中出现的）对象，并遵循类的定义相应某些方法。


//WeatherRecorder.m
//-(void) writeResultToDatabaseWithTemprature:(NSInteger)temprature
//humidity:(NSInteger)humidity
//{
//    id result = [self.weatherForecaster resultWithTemprature:temprature humidity:humidity];
//    [self write:result];
//}
// stub
//[weatherForecaster stub:@selector(resultWithTemprature:humidity:)
//              andReturn:someResult
//          withArguments:theValue(23),theValue(50)];
//mock
//模拟
//id weatherForecasterMock = [WeatherForecaster mock];
//[[weatherForecasterMock should] receive:@selector(resultWithTemprature:humidity:)
//                              andReturn:someResult
//                          withArguments:theValue(23),theValue(50)];
//使用
//[weatherRecorder stub:@selector(weatherForecaster) andReturn:weatherForecasterMock];

//参数捕获
//有时候我们会对 mock 对象的输入参数感兴趣，比如期望某个参数符合一定要求，
//但是对于 mock 而言一般我们是通过调用别的方法来验证 mock 是否被调用的，
//所以很可能无法拿到传给 mock 对象的参数。
//这种情况下我们就可以使用参数捕获来获取输入的参数。
//比如对于上面的 weatherForecasterMock，如果我们想捕获温度参数，可以在调用测试前使用
//
//KWCaptureSpy *spy = [weatherForecasterMock captureArgument:@selector(resultWithTemprature:humidity:) atIndex:0];
//来加一个参数捕获。
//这样，当我们在测试中使用 stub 将 weatherForecaster 替换为我们的 mock 后，再进行如下调用
//
//[weatherRecorder writeResultToDatabaseWithTemprature:23 humidity:50]
//后，我们可以通过访问 spy.argument 来拿到实际输入 resultWithTemprature:humidity: 的第一个参数。

//异步测试
//异步测试是为了对后台线程的结果进行期望检验时所需要，Kiwi可以对某个对象的未来的状况书写期望，并进行检验。
//通过将要检验的对象加上 expectFutureValue，然后使用 shouldEventually 即可。就像这样：
//
//[[expectFutureValue(myObject) shouldEventually] beNonNil];
//
//[[expectFutureValue(theValue(myBool)) shouldEventually] beYes];

//context(@"Fetching service data", ^{
//    it(@"should receive data within one second", ^{
//
//        __block NSString *fetchedData = nil;
//
//        [[LRResty client] get:@"http://www.example.com" withBlock:^(LRRestyResponse* r) {
//            NSLog(@"That's it! %@", [r asString]);
//            fetchedData = [r asString];
//        }];
//        [[expectFutureValue(fetchedData) shouldEventually] beNonNil];
//    });
//
//    });

//https://onevcat.com/2014/05/kiwi-mock-stub-test/
