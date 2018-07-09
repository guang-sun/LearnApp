//
//  TrainNewClassListTableViewCell.h
//  KindeeTrain
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainNewClassModel.h"

@protocol  TrainClassListDelegate <NSObject>

- (void)rzClassListMates:(TrainNewClassModel *)model ;

- (void)rzClassListTopicGroup:(TrainNewClassModel *)model ;

- (void)rzClassListCollect:(TrainNewClassModel *)model ;

@end

@interface TrainNewClassListTableViewCell : UITableViewCell

@property (nonatomic, assign) id<TrainClassListDelegate>  delegate ;

@property (nonatomic, strong) TrainNewClassModel  *model ;

@end
