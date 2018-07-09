//
//  TrainNewMovieViewController.h
//  KindeeTrain
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import "WMPageController.h"
#import "TrainCourseAndClassModel.h"
#import "WMStickyPageViewController.h"


typedef NS_ENUM(NSInteger, WMPageScrollStatus){
    WMPageScrollStatusNULL,
    WMPageScrollStatusUP,
    WMPageScrollStatusDOWN
};

@interface TrainNewMovieViewController : WMStickyPageViewController

@property(nonatomic, strong) NSDictionary               *courseDic;
@property(nonatomic, strong) TrainCourseAndClassModel   *courseModel;

@end
