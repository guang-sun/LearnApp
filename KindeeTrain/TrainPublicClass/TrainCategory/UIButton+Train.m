//
//  UIButton+Train.m
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import "UIButton+Train.h"


@implementation UIButton (Train)

@dynamic cusTitle;
@dynamic cusTitleColor;
@dynamic image;
@dynamic cusFont;
@dynamic cusSelectTitle;
-(id)initCustomButton{
    
    self = [super init];
    if (self) {
        [self setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
        self.titleLabel.font =[UIFont systemFontOfSize:TrainTitleFont];
        //        self.titleEdgeInsets =UIEdgeInsetsMake(0, 5, 0, -5);
        //        self.imageEdgeInsets =UIEdgeInsetsMake(0, -5, 0, 5);
    }
    
    return self;
}
-(id)initImageLeftCustomButton{

    self = [super init];
    if (self) {
        [self setTitleColor:TrainColorFromRGB16(0x818181) forState:UIControlStateNormal];
        self.titleLabel.font =[UIFont systemFontOfSize:TrainContentFont];
        self.titleEdgeInsets =UIEdgeInsetsMake(0, 5, 0, -5);
        self.imageEdgeInsets =UIEdgeInsetsMake(0, -5, 0, 5);
    }
    
    return self;
}
-(id)initWithImageButton{

    self = [super init];
    if (self) {
        [self setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
        self.titleLabel.font =[UIFont systemFontOfSize:TrainTitleFont];
        CGFloat  width = trainAutoLoyoutImageSize(22);
        self.imageEdgeInsets =UIEdgeInsetsMake(0,width, 0, -width);
        self.titleEdgeInsets =UIEdgeInsetsMake(0, -width, 0, width);
    }
    
    return self;
}
-(void)setCusTitle:(NSString *)cusTitle{
    [self setTitle:cusTitle forState:UIControlStateNormal];
}
-(void)setCusSelectTitle:(NSString *)cusSelectTitle{
    [self setTitle:cusSelectTitle forState:UIControlStateSelected];
    
}
-(void)setCusTitleColor:(UIColor *)cusTitleColor{
    [self setTitleColor:cusTitleColor forState:UIControlStateNormal];
}
-(void)setImage:(UIImage *)image{
    [self setImage:image forState:UIControlStateNormal];
}
-(void)setCusFont:(CGFloat)cusFont{
    self.titleLabel.font =[UIFont systemFontOfSize:trainAutoLoyoutTitleSize (cusFont)];
    
}
-(void)addTarget:(id)sup action:(SEL)selector{
    [self addTarget:sup action:selector forControlEvents:UIControlEventTouchUpInside];
    
}



@end
