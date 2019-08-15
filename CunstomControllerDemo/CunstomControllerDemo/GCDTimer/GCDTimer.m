//
//  GCDTimer.m
//  CunstomControllerDemo
//
//  Created by zsp on 2019/8/14.
//  Copyright © 2019 woop. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer ()

@property(nonatomic, strong) dispatch_source_t timer;
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSTimeInterval lastTS;

@end

@implementation GCDTimer

+ (GCDTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                    repeats:(BOOL)repeats
                                      queue:(dispatch_queue_t)queue
                                      block:(void(^)(void))block {
    GCDTimer *timer = [[GCDTimer alloc] initWithTimeInterval:interval
                                                     repeats:repeats queue:queue block:block];
    return timer;
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)interval
                             repeats:(BOOL)repeats
                               queue:(dispatch_queue_t)queue
                               block:(void(^)(void))block {
    if (self=[super init]) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        
        __weak typeof(self) weakSelf=self;
        
        dispatch_source_set_event_handler(_timer, ^{
            
            typeof(weakSelf) strongSelf=weakSelf;
            if (!repeats) {
                dispatch_source_cancel(strongSelf.timer);
            }
            
            if (block) {
                block();
            }
            
            [strongSelf onTimeout];
        });
        dispatch_resume(_timer);
    }
    return self;
}

- (void)dealloc {
    [self invalidate];
}

- (void)invalidate {
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

- (void)onTimeout {
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSLog(@"===GCDTimer====>%ld %.5f", _count++, ts - _lastTS);
    _lastTS = ts;
}

@end
