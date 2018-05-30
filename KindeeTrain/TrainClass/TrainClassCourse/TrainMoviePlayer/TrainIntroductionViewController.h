//
//  TrainIntroductionViewController.h
//  KindeeTrain
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainMovieDetailDelegate.h"

@interface TrainIntroductionViewController : UIViewController

@property (nonatomic ,strong) UIScrollView    *introScrollView;
@property (nonatomic ,strong) NSDictionary    *introInfo;
@property (nonatomic ,assign) id<TrainMovieDetailDelegate>  delegate;

-(void)updateDataWith:(NSDictionary *)infoDic;

@end
