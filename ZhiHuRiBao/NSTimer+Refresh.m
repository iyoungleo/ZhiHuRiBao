//
//  NSTimer+Refresh.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/25.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "NSTimer+Refresh.h"

@implementation NSTimer (Refresh)

+ (NSTimer *)timerWithRepeatTimeInterval:(NSTimeInterval)seconds
                                  target:(id)target
                                selector:(SEL)selector {
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:seconds
                                             target:target
                                           selector:selector
                                           userInfo:nil
                                            repeats:YES];
    // 加入NSRunLoopCommonModes模式的runLoop中
    [[NSRunLoop mainRunLoop] addTimer:timer
                              forMode:NSRunLoopCommonModes];
    return timer;
}

- (void)start {
    [self setFireDate:[NSDate distantPast]];
}

- (void)resumeAfter:(NSTimeInterval)seconds {
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:5.0f]];
}

- (void)stop {
    [self setFireDate:[NSDate distantFuture]];
}

@end
