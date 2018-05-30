//
//  TrainTopicDetailCommentCell.h
//  SOHUEhr
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainGroupAndTopicModel.h"

typedef  void (^topicCommentLine)(TrainTopicCommentModel  *model,NSString   *userName,NSInteger  selectIndex);
typedef  void (^topicRemovePost)(NSInteger  selectIndex, NSString *str);
typedef  void (^topicCommentName)(NSString  *str);

@interface TrainTopicDetailCommentCell : UITableViewCell

@property(nonatomic,strong) TrainTopicCommentModel   *model;
@property(nonatomic,assign) NSInteger               index;
@property(nonatomic,assign) NSInteger               pv_flag;
@property(nonatomic,copy) topicCommentLine          topicLine;
@property(nonatomic,copy) topicCommentName          topicName;
@property(nonatomic,copy) topicRemovePost           topicRemove;

@end
