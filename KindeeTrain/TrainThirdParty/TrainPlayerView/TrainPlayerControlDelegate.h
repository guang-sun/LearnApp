//
//  TrainPlayerControlDelegate.h
//  NewLearning
//
//  Created by apple on 16/12/1.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#ifndef TrainPlayerControlDelegate_h
#define TrainPlayerControlDelegate_h


#endif /* TrainPlayerControlDelegate_h */

@protocol TrainPlayerControlViewDelagate <NSObject>

@optional
/**  返回按钮事件 */
- (void)Train_controlView:(UIView *)controlView backAction:(UIButton *)sender;
/**  cell播放中小屏状态 关闭按钮事件 */
- (void)Train_controlView:(UIView *)controlView closeAction:(UIButton *)sender;
/** 播放按钮事件 */
- (void)Train_controlView:(UIView *)controlView playAction:(UIButton *)sender;
/** 全屏按钮事件 */
- (void)Train_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender;
/** 锁定屏幕方向按钮时间 */
- (void)Train_controlView:(UIView *)controlView lockScreenAction:(UIButton *)sender;
/** 重播按钮事件 */
- (void)Train_controlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender;
/** 中间播放按钮事件 */
- (void)Train_controlView:(UIView *)controlView cneterPlayAction:(UIButton *)sender;
/** 加载失败按钮事件 */
- (void)Train_controlView:(UIView *)controlView failAction:(UIButton *)sender;
/** 下载按钮事件 */
- (void)Train_controlView:(UIView *)controlView downloadVideoAction:(UIButton *)sender;
/** 切换分辨率按钮事件 */
- (void)Train_controlView:(UIView *)controlView resolutionAction:(UIButton *)sender;
/** slider的点击事件（点击slider控制进度） */
- (void)Train_controlView:(UIView *)controlView progressSliderTap:(CGFloat)value;
/** 开始触摸slider */
- (void)Train_controlView:(UIView *)controlView progressSliderTouchBegan:(UISlider *)slider;
/** slider触摸中 */
- (void)Train_controlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider;
/** slider触摸结束 */
- (void)Train_controlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider;


@end
