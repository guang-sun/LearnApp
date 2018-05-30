//
//  TrainCourseNoteCell.h
//  SOHUEhr
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainCourseDetailModel.h"

@interface TrainCourseNoteCell : UITableViewCell
@property(nonatomic,copy) void                       (^unfoldBlock)() ;
@property(nonatomic,strong) TrainCourseNoteModel  *model;
@end
