//
//  TrainNewMovieViewController.h
//  KindeeTrain
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import "WMPageController.h"
#import "TrainCourseAndClassModel.h"

//static CGFloat const kNavigationBarHeight = 64;

@interface TrainNewMovieViewController : WMPageController
@property(nonatomic, strong) NSDictionary               *courseDic;
@property(nonatomic, strong) TrainCourseAndClassModel   *courseModel;

@end
