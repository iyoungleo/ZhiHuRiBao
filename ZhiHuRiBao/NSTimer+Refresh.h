//
//  NSTimer+Refresh.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/25.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Refresh)

+ (NSTimer *)timerWithRepeatTimeInterval:(NSTimeInterval)seconds target:(id)target selector:(SEL)selector;

- (void)start;

- (void)resumeAfter:(NSTimeInterval)seconds;

- (void)stop;

@end
