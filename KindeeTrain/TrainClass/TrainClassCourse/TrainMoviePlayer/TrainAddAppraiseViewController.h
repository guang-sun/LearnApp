//
//  TrainAddAppraiseViewController.h
//  SOHUEhr
//
//  Created by apple on 16/10/8.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseViewController.h"

@protocol trainAppraiseDelegate <NSObject>

-(void)saveAppraiseSuccess:(NSDictionary *)dic;

@end

@interface TrainAddAppraiseViewController : TrainBaseViewController

/**type room_id hour_id  object_id  c_id */
@property(nonatomic, strong) NSDictionary               *infoDic;
@property(nonatomic, assign) id<trainAppraiseDelegate>  delegate;

@end
