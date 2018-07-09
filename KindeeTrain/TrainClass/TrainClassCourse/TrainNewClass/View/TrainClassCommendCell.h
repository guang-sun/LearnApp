//
//  TrainClassCommendCell.h
//  KindeeTrain
//
//  Created by admin on 2018/6/10.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainCourseDetailModel.h"

@interface TrainClassCommendCell : UITableViewCell

@property (nonatomic, copy) void (^rzAddComemdAppresiseBlock)(void);

- (void)rzUpdateClassCommentWithModel:(TrainCourseAppraiseModel *)model ;


@end
