//
//  TrainMovieDetailTableViewController.h
//  KindeeTrain
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrainMovieDetailDelegate.h"
#import "TrainCourseAndClassModel.h"



@interface TrainMovieDetailTableViewController : UITableViewController

@property (nonatomic ,assign) TrainCourseDetailMode         courseMode;
@property (nonatomic ,strong) NSString                  *condition;
@property (nonatomic ,strong) NSString                  *object_id;
@property (nonatomic ,strong) NSString                  *defaultImageURL;
@property (nonatomic ,assign) BOOL                          isRegister;
@property (nonatomic ,assign) id<TrainMovieDetailDelegate>  delegate;

@property (nonatomic ,strong) TrainCourseAndClassModel      *courseDetailModel;


-(void)updateDataWithVC;

-(void)updateCurrentHourDataWithVC:(TrainCourseDirectoryModel *)hourModel;


-(void)updateLearningRecord:(TrainCourseDirectoryModel *)hourModel andreload:(BOOL)isReload;

// 点击 headview 上开始学习
-(void)startLearnHour;
// 发表笔记后 更新笔记
-(void)updateNoteDataWith:(NSDictionary *)dic;

-(void)autoPlayHour ;

//
//-(void)sendCommentViewWith:(NSString  *)sendStr;
//-(BOOL )commentViewTouch;

@end
