//
//  TrainNavigationController.h
//  KindeeTrain
//
//  Created by apple on 17/2/13.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+TrainNavigationExtension.h"

@interface TrainWrapViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *rootViewController;

+ (TrainWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController;

@end

@interface TrainNavigationController : UINavigationController

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, assign) BOOL fullScreenPopGestureEnabled;
@property (nonatomic, assign) BOOL popGestureEnabled;

@property (nonatomic, copy, readonly) NSArray *Train_viewControllers;

@end
