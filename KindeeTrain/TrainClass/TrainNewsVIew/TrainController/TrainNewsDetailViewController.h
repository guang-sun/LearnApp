//
//  TrainNewsDetailViewController.h
//  KindeeTrain
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainBaseViewController.h"
#import "TrainNewsModel.h"

@interface TrainNewsDetailViewController : TrainBaseViewController

@property (nonatomic, strong) TrainNewsModel *newsModel ;

@property (nonatomic, assign) BOOL      readStatus; // 0未 1已 


@end

