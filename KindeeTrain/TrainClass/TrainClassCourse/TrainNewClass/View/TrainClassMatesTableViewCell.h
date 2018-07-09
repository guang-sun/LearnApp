//
//  TrainClassMatesTableViewCell.h
//  KindeeTrain
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrainClassDetailModel.h"


@interface TrainClassMatesTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray        *gradeArr;

@property (nonatomic, copy) void  (^rzgetMoreMatesblock)(void );


@end
