//
//  TrainPlayerView.h
//  NewLearning
//
//  Created by apple on 16/12/1.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainPlayerModel.h"
#import "TrainPlayerHeader.h"
//#import "TrainPlayerControlView.h"
#import "TrainPlayerControlDelegate.h"
@class  TrainPlayerControlView;

@protocol TrainPlayerDelegate <NSObject>
@optional

/** 返回按钮事件 */
- (void)Train_playerBackAction:(NSInteger )lastTime;
/** 下载视频 */
- (void)Train_playerDownload:(NSString *)url;

-(void)Train_playerFinish:(NSInteger )lastTime;
-(void)Train_playerError;
-(void)Train_playerNotPan;
-(void)Train_playerStartPlay;
-(void)Train_playerStopPauseTime:(NSInteger)pauseTime;
-(void)Train_playerStartPauseTime;
-(void)Train_playerChangeMovie:(NSInteger )lastTime;
//-(void)Train_playerplayTag:(hourTimeNodeModel  *)nodeModel;


@end

// playerLayer的填充模式（默认：等比例填充，直到一个维度到达区域边界）
typedef NS_ENUM(NSInteger, TrainPlayerLayerGravity) {
    TrainPlayerLayerGravityResize,           // 非均匀模式。两个维度完全填充至整个视图区域
    TrainPlayerLayerGravityResizeAspect,     // 等比例填充，直到一个维度到达区域边界
    TrainPlayerLayerGravityResizeAspectFill  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
};

// 播放器的几种状态
typedef NS_ENUM(NSInteger, TrainPlayerState) {
    TrainPlayerStateFailed,     // 播放失败
    TrainPlayerStateBuffering,  // 缓冲中
    TrainPlayerStatePlaying,    // 播放中
    TrainPlayerStateStopped,    // 停止播放
    TrainPlayerStatePause       // 暂停播放
};

@interface TrainPlayerView : UIView<TrainPlayerControlViewDelagate>

/** 视频model */
//@property (nonatomic, strong) TrainPlayerModel    *playerLayerGravity;

/** 设置playerLayer的填充模式 */
@property (nonatomic, assign) TrainPlayerLayerGravity       playerLayerGravity;
/** 是否有下载功能(默认是关闭) */
@property (nonatomic, assign) BOOL                          hasDownload;
/** 是否开启预览图 */
@property (nonatomic, assign) BOOL                          hasPreviewView;
/** 设置代理 */
@property (nonatomic, assign) id<TrainPlayerDelegate>         delegate;
/** 是否被用户暂停 */
@property (nonatomic, assign, readonly) BOOL                isPauseByUser;
/** 播发器的几种状态 */
@property (nonatomic, assign, readonly) TrainPlayerState    state;
/** 静音（默认为NO）*/
@property (nonatomic, assign) BOOL                          mute;
/** 当cell划出屏幕的时候停止播放（默认为NO） */
//@property (nonatomic, assign) BOOL                    stopPlayWhileCellNotVisable;
/** 当cell播放视频由全屏变为小屏时候，是否回到中间位置(默认YES) */
//@property (nonatomic, assign) BOOL                    cellPlayerOnCenter;

/**
 *  单例，用于列表cell上多个视频
 *
 *  @return TrainPlayer
 */
+ (instancetype)sharedPlayerView;

/**
 * 指定播放的控制层和模型
 */
- (void)playerControlView:(TrainPlayerControlView *)controlView playerModel:(TrainPlayerModel *)playerModel;

/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo;

/**
 *  重置player
 */
- (void)resetPlayer;

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(TrainPlayerModel *)playerModel;

/**
 *  播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

/**
 * 停止  pop
 */
- (void)stopPlayer;


/**
 播放完成 自动播放
 */
- (void)changeFullScreen ;
@end
