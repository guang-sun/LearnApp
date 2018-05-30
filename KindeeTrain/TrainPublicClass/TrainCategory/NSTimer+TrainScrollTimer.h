//
//  NSTimer+TrainScrollTimer.h
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTimer (TrainScrollTimer)
- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
