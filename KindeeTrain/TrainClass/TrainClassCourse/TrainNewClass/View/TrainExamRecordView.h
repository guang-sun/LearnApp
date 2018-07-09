//
//  TrainExamRecordView.h
//  KindeeTrain
//
//  Created by admin on 2018/6/20.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainClassPhaseModel.h"

@interface TrainExamRecordView : UIView

@property (nonatomic, copy) void  (^trainExamRecordBlock)(NSInteger index);

- (void)rzUpdateExamRecordWithModel:(TrainClassExamModel *)model  index:(NSInteger)index;

@end
