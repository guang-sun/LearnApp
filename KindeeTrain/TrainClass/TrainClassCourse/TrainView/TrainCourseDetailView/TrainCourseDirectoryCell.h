//
//  TrainCourseDirectoryCell.h
//  SOHUEhr
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainCourseDetailModel.h"
#import "TrainDownloadModel.h"

@interface TrainCourseDirectoryCell : UITableViewCell

@property (nonatomic,strong) TrainCourseDirectoryModel   *model;
@property (nonatomic,strong) TrainDownloadModel          *downModel;
@property (nonatomic,assign) BOOL           isRegister;
@property (nonatomic,copy)   void (^trainDownloadStatus)(BOOL isFinish);

@end
