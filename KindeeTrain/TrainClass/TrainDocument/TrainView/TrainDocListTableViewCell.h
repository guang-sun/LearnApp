//
//  TrainDocListTableViewCell.h
//  SOHUEhr
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrainDocListModel.h"
@interface TrainDocListTableViewCell : UITableViewCell

@property(nonatomic, copy)   void               (^trainDocCollectStatus)(NSString *msg);
@property(nonatomic, strong) TrainDocListModel  *model;
@property(nonatomic, copy)   NSString           *searchStr;

@end
