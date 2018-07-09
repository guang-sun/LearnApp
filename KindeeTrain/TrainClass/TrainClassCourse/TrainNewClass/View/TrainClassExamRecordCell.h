//
//  TrainClassExamRecordCell.h
//  KindeeTrain
//
//  Created by admin on 2018/6/19.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrainClassPhaseModel.h"

@interface TrainClassExamRecordCell : UITableViewCell

@property (nonatomic, copy) void (^rzClassExamJoinBlock)(NSString *webURL);

@property (nonatomic, copy) void (^rzClassExamReadBlock)(NSString *webURL);

- (void)rzUpdateClassExamWithModel:(TrainClassResModel *)model ;

@end
