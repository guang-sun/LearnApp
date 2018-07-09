//
//  TrainClassInfoTableViewCell.h
//  KindeeTrain
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainClassInfoTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString        *contentText;
@property (nonatomic, assign) BOOL          isMore;          //
@property (nonatomic, assign) BOOL          isShowMore; // 显示更多按钮

@property (nonatomic, copy) void  (^rzMoreBlock)(BOOL  isSelect);

@end
