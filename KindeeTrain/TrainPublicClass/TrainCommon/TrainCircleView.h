//
//  TrainCircleView.h
//  SOHUEhr
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainMacroDefine.h"

typedef NS_ENUM(NSInteger){
    TraincircleModeCircle =  0,   //圆
    TraincircleModeArc            //半圆
}TraincircleMode;

@interface TrainCircleView : UIView



@property (nonatomic, assign) CGFloat percent; // 百分比 0 - 100
@property (nonatomic, copy)   NSString *text; // 文字
@property (nonatomic, strong) UIImage *bgImage; // 背景图片

@property(nonatomic,strong)  UIColor    *circleBgLineColor;
@property(nonatomic,strong)  UIColor    *progressColor;
@property (nonatomic, assign) CGFloat lineWidth; // 弧线宽度

-(instancetype)initWithFrame:(CGRect)frame andcircleMode:(TraincircleMode )mode;

@end
