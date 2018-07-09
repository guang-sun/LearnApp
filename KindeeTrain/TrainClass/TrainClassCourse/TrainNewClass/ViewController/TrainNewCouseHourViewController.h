//
//  TrainNewCouseHourViewController.h
//  KindeeTrain
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainBaseViewController.h"
#import "TrainMovieDetailDelegate.h"
#import "WMStickyPageViewController.h"

@interface TrainNewCouseHourViewController : TrainBaseViewController<WMStickyPageViewControllerDelegate>

@property (nonatomic ,assign) id<TrainMovieDetailDelegate>  delegate;

@property (nonatomic, strong) UITableView    *infoTableView ;

@property (nonatomic, copy) NSString        *class_id;

@property (nonatomic, assign) BOOL          isRegister;

// 点击 headview 上开始学习
-(void)startLearnHour;
// 发表笔记后 更新笔记
-(void)updateNoteDataWith:(NSDictionary *)dic;

-(void)autoPlayHour ;

-(void)updateLearningRecord:(TrainCourseDirectoryModel *)hourModel andreload:(BOOL)isReload;

@end
