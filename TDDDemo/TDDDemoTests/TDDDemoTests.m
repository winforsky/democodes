//
//  TDDDemoTests.m
//  TDDDemoTests
//
//  Created by zsp on 2019/8/30.
//  Copyright © 2019 woop. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VVStack.h"

@interface TDDDemoTests : XCTestCase

@end

@implementation TDDDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testStackExist {
    XCTAssertNotNil([VVStack class], "VVStack class should exist.");
}

- (void)testStackCanBeCreated {
    VVStack *stack = [VVStack new];
    XCTAssertNotNil(stack, "VVStack object should be created.");
}

- (void)testStackPushAndGet {
    VVStack *stack = [VVStack new];
    double inNumber = 2.5;
    [stack push:inNumber];
    double topNumber = [stack top];
    XCTAssertEqual(topNumber, inNumber, "VVStack should can be pushed and has that top value");
    
    inNumber = 4.5;
    [stack push:inNumber];
    topNumber = [stack top];
    XCTAssertEqual(topNumber, inNumber, "The top value should be the last pushed value in VVStack");
    
    double popNumber=[stack pop];
    XCTAssertEqual(popNumber, inNumber, "The pop value should be the last pushed value in VVStack");
}

@end
