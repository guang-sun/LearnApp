//
//  TrainPhotoBrowserConfig.h
//  SOHUEhr
//
//  Created by apple on 16/11/18.
//  Copyright © 2016年  . All rights reserved.
//

#ifndef TrainPhotoBrowserConfig_h
#define TrainPhotoBrowserConfig_h

typedef enum {
    TrainWaitingViewModeLoopDiagram, // 环形
    TrainWaitingViewModePieDiagram // 饼型
} TrainWaitingViewMode;

#define kMinZoomScale 1.0f
#define kMaxZoomScale 2.0f

#define kAPPWidth [UIScreen mainScreen].bounds.size.width
#define KAppHeight [UIScreen mainScreen].bounds.size.height

#define kiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


#define kIsFullWidthForLandScape YES //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES

//是否支持横屏
#define shouldLandscape NO

// 图片保存成功提示文字
#define TrainPhotoBrowserSaveImageSuccessText @" 保存成功 ";

// 图片保存失败提示文字
#define TrainPhotoBrowserSaveImageFailText @" 保存失败 ";

// browser背景颜色
#define TrainPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:1]

// browser中图片间的margin
#define TrainPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define TrainPhotoBrowserShowImageAnimationDuration 0.35f

// browser中隐藏图片动画时长
#define TrainPhotoBrowserHideImageAnimationDuration 0.35f

// 图片下载进度指示进度显示样式（TrainWaitingViewModeLoopDiagram 环形，TrainWaitingViewModePieDiagram 饼型）
#define TrainWaitingViewProgressMode TrainWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define TrainWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
//#define TrainWaitingViewBackgroundColor [UIColor clearColor]

// 图片下载进度指示器内部控件间的间距
#define TrainWaitingViewItemMargin 10


#endif /* TrainPhotoBrowserConfig_h */
