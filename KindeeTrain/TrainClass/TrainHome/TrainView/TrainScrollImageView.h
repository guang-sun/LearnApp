//
//  TrainScrollImageView.h
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainMacroDefine.h"
#import "NSTimer+TrainScrollTimer.h"

typedef void(^scrollTouchBlock)(NSInteger  tapIndex) ;


@interface TrainScrollImageView : UIView

@property (nonatomic, assign) NSTimeInterval    AutoScrollDelay;
@property (nonatomic, copy)   NSArray           *netImageArr;
@property (nonatomic, copy)   NSArray           *localImageArr;
@property (nonatomic, copy)   scrollTouchBlock  tapimageAction;
@property (nonatomic,strong)  NSTimer           *timer;

- (instancetype) initWithFrame:(CGRect)frame WithDelay:(NSTimeInterval )delay;
- (void)cycleScrollViewStretchingWithOffset:(CGFloat)offset;
@end
