//
//  TrainGroupListCell.h
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainGroupAndTopicModel.h"

@interface TrainGroupListCell : UITableViewCell

@property(nonatomic,strong) TrainGroupModel  *model;
@property(nonatomic,strong) NSString         *searchTitle;

@end
