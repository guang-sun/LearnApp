//
//  TrainNewClassInfoViewController.h
//  KindeeTrain
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainBaseViewController.h"

#import "TrainMovieDetailDelegate.h"
#import "WMStickyPageViewController.h"

@interface TrainNewClassInfoViewController : TrainBaseViewController <WMStickyPageViewControllerDelegate>

@property (nonatomic, copy) NSString  *class_id;

@property (nonatomic, strong) NSDictionary  *classInfo;


@property (nonatomic, strong) TrainBaseTableView *infoTableView ;

- (void)rzGetGradeInfo ;

@end
