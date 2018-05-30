//
//  TrainTopicDetailHeadView.h
//  KindeeTrain
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainGroupAndTopicModel.h"

typedef void (^trainGetHeightBlock) (CGFloat height);
typedef void (^trainIconTouchBlock) (NSString *user_id);
typedef void (^trainTopAndCollectBlock) (NSString *str,TrainTopicModel * topicModel);
typedef void (^trainGetTopicUrlBlock) (NSString *url);

@interface TrainTopicDetailHeadView : UIView

@property(nonatomic,copy) trainTopAndCollectBlock   topicTopandCollectBlock;
@property(nonatomic,copy) trainIconTouchBlock       topicIconTouchBlock;
@property(nonatomic,copy) trainGetTopicUrlBlock     topicContentTouchBlock;

-(void)updateViewHeightWith:(TrainTopicModel *)topicModel andGetHeight:(trainGetHeightBlock)getHeight;

@end
