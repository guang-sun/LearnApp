//
//  TrainClassCommendViewController.h
//  KindeeTrain
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainBaseViewController.h"

#import "TrainMovieDetailDelegate.h"
#import "WMStickyPageViewController.h"

@interface TrainClassCommendViewController : TrainBaseViewController <WMStickyPageViewControllerDelegate>

@property (nonatomic, strong) TrainBaseTableView *infoTableView ;

@property (nonatomic, copy) NSString  *class_id;

@property (nonatomic, assign) BOOL          isRegister;

@end
