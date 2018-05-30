//
//  TrainGroupSearchViewController.h
//  SOHUEhr
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseViewController.h"

@interface TrainGroupSearchViewController : TrainBaseViewController

@property(nonatomic, strong) NSString     *searchText;
@property(nonatomic, strong) NSString     *group_id;

-(void)searchTitleDate:(int)index;
@end
