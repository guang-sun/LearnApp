//
//  NSTimer+TrainScrollTimer.m
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import "NSTimer+TrainScrollTimer.h"

@implementation NSTimer (TrainScrollTimer)

- (void)pauseTimer
{
    if (![self isValid])
    {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}
- (void)resumeTimer
{
    if (![self isValid])
    {
        return ;
    }
    [self setFireDate:[NSDate date]];
}
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid])
    {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}


@end
