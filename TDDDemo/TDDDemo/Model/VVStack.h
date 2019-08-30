//
//  VVStack.h
//  TDDDemo
//
//  Created by zsp on 2019/8/30.
//  Copyright © 2019 woop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VVStack : NSObject

- (void)push:(double)num;
- (double)top;
- (double)pop;

@end

NS_ASSUME_NONNULL_END
