//
//  TrainCourseAppraiseCell.h
//  SOHUEhr
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainCourseDetailModel.h"

@interface TrainCourseAppraiseCell : UITableViewCell
@property(nonatomic,copy)   void                    (^unfoldBlock)() ;
@property(nonatomic,assign) BOOL                    isFirst;
@property(nonatomic,copy) TrainCourseAppraiseModel  *model;
@end
