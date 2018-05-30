//
//  TrainMoviePlayerViewController.h
//  SOHUEhr
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseViewController.h"
#import "TrainCourseAndClassModel.h"

@interface TrainMoviePlayerViewController : TrainBaseViewController

@property(nonatomic, strong) NSDictionary               *courseDic;
@property(nonatomic, strong) TrainCourseAndClassModel   *courseModel;

@end
