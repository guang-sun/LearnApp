//
//  UIAlertController+TrainWindow.h
//  KindeeTrain
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (TrainWindow)

- (void)show;
- (void)show:(BOOL)animated;
@end

@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end
