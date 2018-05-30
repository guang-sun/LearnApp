//
//  TrainProgressHUD.h
//  SOHUEhr
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
typedef NS_ENUM(NSInteger){
    TrainProgressModeOnlyText=10,            //文字
    TrainProgressModeLoading,                //加载菊花
    TrainProgressModeCircleLoading,          //加载圆形
    TrainProgressModeCustomAnimation,        //自定义加载动画（序列帧实现）
    TrainProgressModeSuccess                 //成功
    
}TrainProgressMode;

@interface TrainProgressHUD : NSObject

/*===============================   属性   ================================================*/

@property (nonatomic,strong) MBProgressHUD  *hud;


/*===============================   方法   ================================================*/

+(instancetype)shareinstance;

//显示
+(void)show:(NSString *)msg inView:(UIView *)view mode:(TrainProgressMode )myMode;

//隐藏
+(void)hide;

//显示提示（1秒后消失）
+(void)showMessage:(NSString *)msg inView:(UIView *)view;

//显示提示（N秒后消失）
+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay;

//显示进度(转圈)
+(MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view;

//显示进度(菊花)
+(void)showProgress:(NSString *)msg inView:(UIView *)view;

//显示成功提示
+(void)showSuccess:(NSString *)msg inview:(UIView *)view;

//在最上层显示
+(void)showMsgWithoutView:(NSString *)msg;

//+(void)showMsgErrorWithoutView:(NSString *)msg;

//显示自定义动画(自定义动画序列帧  找UI做就可以了)
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view;
@end
