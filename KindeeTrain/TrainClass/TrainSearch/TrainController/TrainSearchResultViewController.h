//
//  TrainSearchResultViewController.h
//  SOHUEhr
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseViewController.h"

@interface TrainSearchResultViewController : TrainBaseViewController
@property(nonatomic,assign) TrainSearchStyle    selectMode;
@property(nonatomic,assign) BOOL                isTag;
@property(nonatomic,strong) NSString            *searchTitle;

@end
