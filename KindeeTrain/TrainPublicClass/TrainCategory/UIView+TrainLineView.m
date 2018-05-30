//
//  UIView+TrainLineView.m
//  SOHUEhr
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年  . All rights reserved.
//

#import "UIView+TrainLineView.h"

@implementation UIView (TrainLineView)

-(instancetype)initWithLineView{
    if (self = [self init]) {
        self.backgroundColor = TrainLineColor;
    }
    return self;
}

-(instancetype)initWithLine1View{
    if (self = [self init]) {
        self.backgroundColor = TrainLineColor1;
    }
    return self;
}

@end
