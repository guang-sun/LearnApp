//
//  TrainClassMoreHeaderView.m
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainClassMoreHeaderView.h"


@interface TrainClassMoreHeaderView ()
{
    UILabel         *lable;
    UIButton        *moreButton;
}
@end

@implementation TrainClassMoreHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    UIView  *view =[[UIView alloc]init];
    view.backgroundColor =TrainNavColor;
    [self.contentView addSubview:view];
    
    lable =[[UILabel alloc]initCustomLabel];
    lable.textColor =[UIColor blackColor];
    [self.contentView addSubview:lable];
    
    moreButton =[[UIButton  alloc]initCustomButton];
    moreButton.cusTitle =@"更多";
    moreButton.image =[UIImage imageNamed:@"Train_Cell_right"];
    moreButton.cusTitleColor =TrainNavColor;
    moreButton.titleEdgeInsets =UIEdgeInsetsMake(0, -10, 0, 10);
    moreButton.imageEdgeInsets =UIEdgeInsetsMake(0, 30, 0, -30);
    [moreButton addTarget:self action:@selector(touch)];
    [self.contentView addSubview:moreButton];
    
    UIView  *supView =self.contentView;
    view.sd_layout
    .leftEqualToView(supView)
    .widthIs(3)
    .centerYEqualToView(supView)
    .heightIs(20);
    
    moreButton.sd_layout
    .rightSpaceToView(supView,15)
    .widthIs(50)
    .topSpaceToView(supView,10)
    .heightIs(20);
    
    lable.sd_layout
    .leftSpaceToView(supView,15)
    .topSpaceToView(supView,10)
    .rightSpaceToView(moreButton,10)
    .heightIs(20);
    
}
-(void)touch{
    if (_headerTouch) {
        _headerTouch();
    }
}
-(void)setIsshowMore:(BOOL)isshowMore{
    moreButton.hidden =!isshowMore;
}
-(void)setTitle:(NSString *)title{
    lable.text =title;
}


@end
