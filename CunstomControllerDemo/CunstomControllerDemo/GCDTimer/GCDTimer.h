//
//  GCDTimer.h
//  CunstomControllerDemo
//
//  Created by zsp on 2019/8/14.
//  Copyright © 2019 woop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDTimer : NSObject

+ (GCDTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                    repeats:(BOOL)repeats
                                      queue:(dispatch_queue_t)queue
                                      block:(void(^)(void))block;
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
