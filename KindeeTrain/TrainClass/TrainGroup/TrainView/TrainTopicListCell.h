//
//  TrainTopicListCell.h
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainGroupAndTopicModel.h"

@interface TrainTopicListCell : UITableViewCell

@property(nonatomic,copy ) void   (^topicTouchBlock)(NSString  *str,TrainTopicModel *topicModel);

@property(nonatomic,strong) TrainTopicModel    *model;
@property(nonatomic,assign) BOOL               isImageTap;
@property(nonatomic,assign) int                maxCount;
@end
