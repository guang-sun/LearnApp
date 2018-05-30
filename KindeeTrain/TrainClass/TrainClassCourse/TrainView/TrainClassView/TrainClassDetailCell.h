//
//  TrainClassDetailCell.h
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrainClassDetailModel.h"

@interface TrainClassDetailCell : UITableViewCell

@property(nonatomic,assign) BOOL                        isDetail;
@property(nonatomic,assign) TrainClassDetailStatus      status;

@property(nonatomic,strong) TrainClassUserModel         *model;
@property(nonatomic,strong) TraingailanDatelisModel     *gailanModel;
@property(nonatomic,copy) void (^gaiLanUnfoldblock)();

@end
