//
//  TrainProgressHUD.m
//  SOHUEhr
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainProgressHUD.h"

@implementation TrainProgressHUD

+(instancetype)shareinstance{
    
    static TrainProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TrainProgressHUD alloc] init];
    });
    
    return instance;
    
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(TrainProgressMode )myMode{
    [self show:msg inView:view mode:myMode customImgView:nil];
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(TrainProgressMode )myMode customImgView:(UIImageView *)customImgView{
    //如果已有弹框，先消失
    if (customImgView && [TrainProgressHUD shareinstance].hud != nil ) {
        return;
    }else{
        if ([TrainProgressHUD shareinstance].hud != nil) {
            [[TrainProgressHUD shareinstance].hud hideAnimated:YES];
            [TrainProgressHUD shareinstance].hud = nil;
        }
    }
    //4\4s屏幕避免键盘存在时遮挡
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [view endEditing:YES];
    }
    
    [TrainProgressHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    [TrainProgressHUD shareinstance].hud.dimBackground = YES;    //是否显示透明背景
    
    [TrainProgressHUD shareinstance].hud.userInteractionEnabled = NO;
    [TrainProgressHUD shareinstance].hud.minShowTime = 0.5f;
    [TrainProgressHUD shareinstance].hud.removeFromSuperViewOnHide = YES;
    [TrainProgressHUD shareinstance].hud.margin = 10.f;
    [TrainProgressHUD shareinstance].hud.bezelView.color =  [UIColor colorWithWhite:0.2 alpha:0.8];
    [TrainProgressHUD shareinstance].hud.contentColor = [UIColor whiteColor];

    [TrainProgressHUD shareinstance].hud.detailsLabel.text = msg;
    [TrainProgressHUD shareinstance].hud.detailsLabel.font = [UIFont systemFontOfSize:14.0f];
    [TrainProgressHUD shareinstance].hud.detailsLabel.textColor = TrainNavColor;
    [TrainProgressHUD shareinstance].hud.animationType =MBProgressHUDAnimationFade;

    
    switch (myMode) {
        case TrainProgressModeOnlyText:
            [TrainProgressHUD shareinstance].hud.mode = MBProgressHUDModeText;
            break;
            
        case TrainProgressModeLoading:
            [TrainProgressHUD shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;
            
        case TrainProgressModeCircleLoading:{
            [TrainProgressHUD shareinstance].hud.mode = MBProgressHUDModeDeterminate;
        
                        break;
                    }
        case TrainProgressModeSuccess:
            [TrainProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [TrainProgressHUD shareinstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
            break;
        case TrainProgressModeCustomAnimation:
        {
            [TrainProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            
            [TrainProgressHUD shareinstance].hud.contentColor = TrainNavColor;

            [TrainProgressHUD shareinstance].hud.bezelView.color =  [UIColor colorWithWhite:0.8 alpha:1];
//
            [TrainProgressHUD shareinstance].hud.customView = customImgView;
            [TrainProgressHUD shareinstance].hud.square = YES;
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


+(void)hide{
    if ([TrainProgressHUD shareinstance].hud != nil) {
        [[TrainProgressHUD shareinstance].hud hideAnimated:YES];
        [TrainProgressHUD shareinstance].hud = nil;

    }
}


+(void)showMessage:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:TrainProgressModeOnlyText];
    [[TrainProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
}



+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg inView:view mode:TrainProgressModeOnlyText];
    [[TrainProgressHUD shareinstance].hud hideAnimated:YES afterDelay:delay];
}

+(void)showSuccess:(NSString *)msg inview:(UIView *)view{
    [self show:msg inView:view mode:TrainProgressModeSuccess];
    [[TrainProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
    
}


+(void)showProgress:(NSString *)msg inView:(UIView *)view{
    
    [self show:msg inView:view mode:TrainProgressModeLoading];
}


+(MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view{
    if (view == nil) view =  [UIApplication sharedApplication].keyWindow ;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = msg;
    return hud;
    
    
}


+(void)showMsgWithoutView:(NSString *)msg{
    UIWindow *view = [UIApplication sharedApplication].keyWindow ;
    [self show:msg inView:view mode:TrainProgressModeOnlyText];
    [[TrainProgressHUD shareinstance].hud hideAnimated:YES afterDelay:2.0];
    
}


+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view{
    
//    UIImageView *showImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Train_loading"]];
//    showImageView.frame = CGRectMake(-50, -50, 50, 50);
//    showImageView.animationImages = imgArry;
//    [showImageView setAnimationRepeatCount:0];
//    [showImageView setAnimationDuration:0.01];
//    [showImageView startAnimating];
    
    UIImage *image = [UIImage imageThemeColorWithName:@"Train_loading"];
    UIImage  *newImage = [UIImage OriginImage:image scaleToSize:CGSizeMake(50, 50)];

    UIImageView *imgView = [[UIImageView alloc] initWithImage:newImage];
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima.toValue = @(M_PI*2);
    anima.duration = 1.0f;
    anima.repeatCount = 20;
    [imgView.layer addAnimation:anima forKey:nil];
    
    UIWindow *windowView = [UIApplication sharedApplication].keyWindow;
    
    [self show:msg inView:windowView mode:TrainProgressModeCustomAnimation customImgView:imgView];
    
    //这句话是为了展示几秒，实际要去掉
//    [[TrainProgressHUD shareinstance].hud hideAnimated:YES afterDelay:8.0];
    
    
}

@end
