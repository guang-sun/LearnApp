//
//  TrainControllerUtil.h
//  SOHUTrain
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TrainControllerUtil : NSObject
//获取rootviewcontroller
+ (UIViewController *)getTrainRootVC;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getTrainCurrentVC;
@end
