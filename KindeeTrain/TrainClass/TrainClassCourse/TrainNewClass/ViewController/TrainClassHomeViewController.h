//
//  TrainClassHomeViewController.h
//  KindeeTrain
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 Kindee. All rights reserved.
//

//#import "WMPageController.h"
#import "TrainClassDetailViewController.h"
#import "WMStickyPageViewController.h"


@interface TrainClassHomeViewController : WMStickyPageViewController

@property(nonatomic, copy) NSString    *class_id;

@property(nonatomic, copy) NSString    *room_id;

@property(nonatomic, copy) NSString    *navTitle;

@property(nonatomic, assign) RZClassStatus    status;

@end
