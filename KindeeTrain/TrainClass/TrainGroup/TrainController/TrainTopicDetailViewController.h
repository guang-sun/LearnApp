//
//  TrainTopicDetailViewController.h
//  SOHUEhr
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseViewController.h"
#import "TrainGroupAndTopicModel.h"

@interface TrainTopicDetailViewController : TrainBaseViewController


@property(nonatomic, copy)void  (^updateModel)(TrainTopicModel *mod);

@property(nonatomic, strong)  TrainTopicModel           *model;

@end
