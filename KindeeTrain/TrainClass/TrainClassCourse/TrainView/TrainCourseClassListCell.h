//
//  TrainCourseClassListCell.h
//   KingnoTrain
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainCourseAndClassModel.h"
@interface TrainCourseClassListCell : UITableViewCell


@property(nonatomic,assign) BOOL  isClass;
@property(nonatomic,assign) BOOL  isMyCourse;

@property(nonatomic,copy)   NSString        *searchStr;

@property(nonatomic,strong) TrainCourseAndClassModel   *model;
@end
