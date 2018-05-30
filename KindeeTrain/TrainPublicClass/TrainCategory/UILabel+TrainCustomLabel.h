//
//  UILabel+TrainCustomLabel.h
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrainMacroDefine.h"


@interface UILabel (TrainCustomLabel)
@property(nonatomic,assign)  CGFloat  cusFont;

-(id)creatTitleLabel;
-(id)creatContentLabel;
-(id)initCustomLabel;

@end
