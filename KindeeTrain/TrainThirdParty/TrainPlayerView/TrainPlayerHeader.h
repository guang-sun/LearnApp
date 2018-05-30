//
//  TrainPlayerHeader.h
//  NewLearning
//
//  Created by apple on 16/12/1.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#ifndef TrainPlayerHeader_h
#define TrainPlayerHeader_h


#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 监听TableView的contentOffset
#define kTrainPlayerViewContentOffset          @"contentOffset"
// player的单例
#define TrainPlayerShared                      [TrainBrightnessView sharedBrightnessView]
// 屏幕的宽
#define playScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define playScreenHeight                        [[UIScreen mainScreen] bounds].size.height
// 颜色值RGB
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 图片路径
#define TrainPlayerSrcName(file)               [@"TrainPlayer.bundle" stringByAppendingPathComponent:file]
#define TrainPlayerImage(file)                 [UIImage imageNamed:TrainPlayerSrcName(file)] ? :[UIImage imageNamed:TrainPlayerSrcName(file)]

//#define TrainPlayerSrcName(file)   [[NSBundle mainBundle] pathForResource:file ofType:@"png" ];
//#define TrainPlayerImagePath  [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"TrainPlayer.bundle"]

//#define TrainPlayerSrcName(file)  [TrainPlayerImagePath stringByAppendingPathComponent:file]

//#define TrainPlayerImage(file)                 [UIImage imageWithContentsOfFile:TrainPlayerSrcName(file)]
#define TrainPlayerOrientationIsLandscape      UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)

#define TrainPlayerOrientationIsPortrait       UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)


#import "TrainPlayerView.h"
#import "TrainPlayerModel.h"
#import "TrainPlayerControlView.h"
#import "TrainBrightnessView.h"
#import "UITabBarController+ZFPlayerRotation.h"
#import "UIViewController+ZFPlayerRotation.h"
#import "UINavigationController+ZFPlayerRotation.h"
#import "UIImageView+ZFCache.h"

#import "TrainPlayerControlDelegate.h"
#import "Masonry.h"

#endif /* TrainPlayerHeader_h */
