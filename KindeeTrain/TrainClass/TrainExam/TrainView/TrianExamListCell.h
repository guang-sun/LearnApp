//
//  TrianExamListCell.h
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainExamModel.h"

@interface TrianExamListCell : UITableViewCell

@property(nonatomic,copy)       void  (^joinTouch)();
@property(nonatomic,copy)       void  (^readTouch)();
@property(nonatomic, copy)      void  (^returnWebUrlBlock)(NSString *webUrl);
@property(nonatomic ,assign)    BOOL   isHasLogo;
@property(nonatomic ,assign)    BOOL   isCanLearn; //能否学习 默认YES  班级未开始或已结束  不能学习
@property(nonatomic, assign)   TrainExamStyle   examStyle;
@property(nonatomic,strong)    TrainExamModel  *model;

@end
