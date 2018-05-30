//
//  TrainControllerUtil.m
//  SOHUTrain
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainControllerUtil.h"

@implementation TrainControllerUtil
//获取rootviewcontroller
+ (UIViewController *)getTrainRootVC{
    TrainControllerUtil *controllerUtil = [[TrainControllerUtil alloc] init];
    return [controllerUtil getRootVC];
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getTrainCurrentVC{
    TrainControllerUtil *controllerUtil = [[TrainControllerUtil alloc] init];
    return [controllerUtil getCurrentVC];
}

//获取rootviewcontroller
- (UIViewController *)getRootVC
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    NSLog(@"%@",[window subviews]);
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}
@end
