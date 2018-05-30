//
//  TrainLocalVideoViewController.h
//  SOHUEhr
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 com.sohu-inc. All rights reserved.
//

#import "TrainBaseViewController.h"
#import "TrainDownloadModel.h"
#import "TrainLocalLearnRecord.h"

@interface TrainLocalVideoViewController : TrainBaseViewController

@property (nonatomic, copy) void  (^trainSaveLocalBlock)(BOOL isfinish , TrainLocalLearnRecord *record );

@property (nonatomic, strong) TrainDownloadModel  *videoModel;
@property (nonatomic, assign) BOOL  isfinishVideo;
@property (nonatomic, copy) NSString  *object_id ;


@end
