//
//  UIViewController+TrainNavigationExtension.h
//  KindeeTrain
//
//  Created by apple on 17/2/13.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  TrainNavigationController ;

@interface UIViewController (TrainNavigationExtension)
@property (nonatomic, assign) BOOL Train_fullScreenPopGestureEnabled;
@property (nonatomic, assign) BOOL Train_PopGestureEnabled;

@property (nonatomic, weak) TrainNavigationController *Train_navigationController;

@end
