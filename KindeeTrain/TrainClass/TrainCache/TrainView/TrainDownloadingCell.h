//
//  TrainDownloadingCell.h
//  SOHUEhr
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 com.sohu-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainDownloadModel.h"
@interface TrainDownloadingCell : UITableViewCell


@property(nonatomic,copy) void  (^selectTouch)(BOOL isSelect);
@property(nonatomic,copy) void  (^downFinish)();
@property(nonatomic,strong) TrainDownloadModel   *model;
@property(nonatomic,assign) BOOL                 showSelectView;

@end
