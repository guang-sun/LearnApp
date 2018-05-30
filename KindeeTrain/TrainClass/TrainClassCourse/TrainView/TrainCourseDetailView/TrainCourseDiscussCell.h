//
//  TrainCourseDiscussCell.h
//  SOHUEhr
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrainCourseDetailModel.h"

typedef  void (^topicCommentLine)(TrainCourseDiscussModel  *model,NSString   *userName);
typedef  void (^topicCommentName)(NSString  *str);

@interface TrainCourseDiscussCell : UITableViewCell

@property(nonatomic,copy) TrainCourseDiscussModel  *model;
@property(nonatomic,assign) NSInteger           index;
@property(nonatomic,copy) topicCommentLine      topicLine;
@property(nonatomic,copy) topicCommentName      topicName;

@end
