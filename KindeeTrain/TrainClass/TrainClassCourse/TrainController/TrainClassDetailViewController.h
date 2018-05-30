//
//  TrainClassDetailViewController.h
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseViewController.h"

typedef  NS_ENUM(NSInteger, RZClassStatus) {
    RZClassStatusDafeult ,
    RZClassStatusNotStart ,
    RZClassStatusEnd ,
};

@interface TrainClassDetailViewController : TrainBaseViewController

@property(nonatomic, copy) NSString    *class_id;
@property(nonatomic, copy) NSString    *room_id;
@property(nonatomic, copy) NSString    *navTitle;

@property(nonatomic, assign) RZClassStatus    status;

@end
