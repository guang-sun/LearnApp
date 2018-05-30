//
//  TrainPlayerControlView.h
//  NewLearning
//
//  Created by apple on 16/12/1.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"
#import "TrainPlayerHeader.h"


typedef void(^ChangeResolutionBlock)(UIButton *button);
typedef void(^SliderTapBlock)(CGFloat value);


@interface TrainPlayerControlView : UIView

@property (nonatomic,assign) BOOL       islocalMovie;
@property (nonatomic,assign) BOOL       isFinish;

@end
