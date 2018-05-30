//
//  TrainTopicSearchListCell.h
//  SOHUEhr
//
//  Created by apple on 16/11/3.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrainGroupAndTopicModel.h"
@interface TrainTopicSearchListCell : UITableViewCell

//@property(nonatomic,assign) BOOL isAD;
@property(nonatomic,copy)   NSString        *searchStr;

@property(nonatomic,strong) TrainTopicModel   *model;
@end
