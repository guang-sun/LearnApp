//
//  TrainPlayerModel.h
//  NewLearning
//
//  Created by apple on 16/12/1.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainPlayerModel : NSObject

/** 视频标题 */
@property (nonatomic, copy  ) NSString     *title;
/** 视频URL */
@property (nonatomic, strong) NSURL        *videoURL;
/** 视频封面本地图片 */
@property (nonatomic, strong) UIImage      *placeholderImage;
/**
 * 视频封面网络图片url
 * 如果和本地图片同时设置，则忽略本地图片，显示网络图片
 */
@property (nonatomic, copy  ) NSString     *placeholderImageURLString;
/** 视频分辨率 */
@property (nonatomic, strong) NSDictionary *resolutionDic;
/** 从xx秒开始播放视频(默认0) */
@property (nonatomic, assign) NSInteger    seekTime;
@property (nonatomic, assign) BOOL         isLocked; // 固定屏幕方向
@property (nonatomic, assign) BOOL         isFinish; // 视频是否学完

/** 播放器View的父视图（必须指定父视图）*/
@property (nonatomic, weak  ) UIView       *fatherView;


@end

