//
//  TrainClassMenuCollectionViewCell.m
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainClassMenuCollectionViewCell.h"

@interface TrainClassMenuCollectionViewCell ()
{
    UILabel  *lable;
}

@end

@implementation TrainClassMenuCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    
    
    lable =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.height)];
    lable.backgroundColor =[UIColor whiteColor];
    lable.textAlignment =NSTextAlignmentCenter;
    lable.layer.borderColor = [UIColor whiteColor].CGColor;
    lable.layer.borderWidth = 0.5f;
    lable.font =[UIFont systemFontOfSize:TrainTitleFont];
    lable.textColor = TrainTitleColor;
    [self.contentView addSubview:lable];
    
    
    
    
}
-(void)setTitle:(NSString *)title{
    lable.text =title;
}
-(void)setTitleColor:(UIColor *)titleColor{
    lable.textColor =titleColor;
}
-(void)setCusborderColor:(UIColor *)cusborderColor{
    if (cusborderColor ==nil) {
        lable.layer.borderColor = [UIColor whiteColor].CGColor;
  
    }else{
        lable.layer.borderColor = cusborderColor.CGColor;

    }
    
}
-(void)setLabbackgroup:(UIColor *)labbackgroup{
    lable.backgroundColor =labbackgroup;
}
-(void)setIstable:(BOOL)istable{
    if (!istable) {
        
        lable.layer.borderWidth =1.0f;
        lable.layer.borderColor =[UIColor groupTableViewBackgroundColor].CGColor;
        lable.layer.cornerRadius =self.frame.size.height/2;
        lable.layer.masksToBounds =YES;
        lable.font =[UIFont systemFontOfSize:TrainTitleFont];
        lable.textColor = TrainTitleColor;
        
    }else{
        
        UIView *view =[[UIView alloc]initWithLineView];
        [self.contentView addSubview:view];
        view.sd_layout
        .centerYEqualToView(self.contentView)
        .heightIs(self.frame.size.height*0.5)
        .rightSpaceToView(self.contentView,3)
        .widthIs(2);
        
    }
}
@end
