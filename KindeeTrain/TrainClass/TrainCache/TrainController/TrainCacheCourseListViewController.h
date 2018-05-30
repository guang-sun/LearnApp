//
//  TrainCacheCourseListViewController.h
//  SOHUEhr
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 com.sohu-inc. All rights reserved.
//

#import "TrainBaseViewController.h"

@interface TrainCacheCourseListViewController : TrainBaseViewController

@property(nonatomic,copy) void (^updateFileArr)(NSArray  *arr);

@property(strong ,nonatomic) NSArray  *fileArr;
@property(assign ,nonatomic) int      index;

@end
