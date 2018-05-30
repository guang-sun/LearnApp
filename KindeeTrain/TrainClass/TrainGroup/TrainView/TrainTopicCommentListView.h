//
//  TrainTopicCommentListView.h
//  SOHUEhr
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrainGroupAndTopicModel.h"

typedef  void (^commentLineTouch)(TrainTopicCommentModel  *model,NSInteger  selectIndex);
typedef  void (^commentNameTouch)(NSString  *str);
typedef  void (^commentRemoveTouch)(NSInteger  selectIndex);

@interface TrainTopicCommentListView : UIView

@property(nonatomic,copy) commentLineTouch   topicComLine;
@property(nonatomic,copy) commentNameTouch   topicComName;
@property(nonatomic,copy) commentRemoveTouch topicComRemovePost;
@property(nonatomic,assign) NSInteger        pv_flag;

- (void)setupWithcommentItemsArray:(NSArray *)commentItemsArray;

@end
