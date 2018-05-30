//
//  UILabel+TrainCustomLabel.m
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import "UILabel+TrainCustomLabel.h"

@implementation UILabel (TrainCustomLabel)
@dynamic cusFont;

-(id)creatTitleLabel{
    if ([super init]) {
        self.font = [UIFont systemFontOfSize: trainAutoLoyoutTitleSize(TrainTitleFont)];
        self.numberOfLines =0;
        self.textColor = TrainTitleColor;
    }
    return self;
    

}

-(id)creatContentLabel{
    if ([super init]) {
        self.font = [UIFont systemFontOfSize:trainAutoLoyoutTitleSize(TrainContentFont)];
        self.numberOfLines =0;
        self.textColor = TrainContentColor;
    }
    return self;
    

}

-(id)initCustomLabel{
    
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize: trainAutoLoyoutTitleSize(TrainTitleFont)];
        self.numberOfLines =0;
        self.textColor = [UIColor grayColor];
    }
    return self;
    
}
-(void)setCusFont:(CGFloat)cusFont{
    self.font = [UIFont systemFontOfSize: trainAutoLoyoutTitleSize(cusFont)];
    
}
@end
