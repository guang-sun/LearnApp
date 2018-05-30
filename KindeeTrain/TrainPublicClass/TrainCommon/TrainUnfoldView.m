//
//  TrainUnfoldView.m
//  SOHUEhr
//
//  Created by apple on 16/10/8.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainUnfoldView.h"

@interface TrainUnfoldView ()
{
    UILabel   *lable;
    UIButton  *button;
    UIView    *view;
    NSString  *str;
}
@end

@implementation TrainUnfoldView

-(instancetype)initWithMaxHeight:(float)height{
    self =[super init];
    if (self) {
        _maxHeight = height;
        [self creatUI];
        
    }
    return self;
}
-(void)creatUI{
    
    lable =[[UILabel alloc]creatContentLabel];
    [self addSubview:lable];
    
    button =[[UIButton alloc]initCustomButton];
    button.cusTitleColor = TrainNavColor;
    button.cusTitle=@"更多";
    //    button.image =[UIImage  imageNamed:@"Select_down"];
    [button setTitle:@"收起" forState:UIControlStateSelected];
    //    [button setImage:[UIImage imageNamed:@"Select_up"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(UnfoldTouch:)];
    //    button.imageEdgeInsets =UIEdgeInsetsMake(0, 22, 0,  -22);
    //    button.titleEdgeInsets =UIEdgeInsetsMake(0, -22, 0, 22);
    
    [self addSubview:button];
    
    view =[[UIView alloc]init];
    view.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self addSubview:view];
    
    
    lable.sd_layout
    .leftSpaceToView(self,15)
    .rightSpaceToView(self,15)
    .topEqualToView(self)
    .autoHeightRatio(0)
    .maxHeightIs( lable.font.lineHeight*_maxHeight);
    
    button.sd_layout
    .rightSpaceToView(self,15)
    .topSpaceToView(lable,0)
    .widthIs(40)
    .heightIs(0);
    
    button.hidden =YES;
    
    view.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(button,10)
    .heightIs(0.7);
    [self setupAutoHeightWithBottomView:view bottomMargin:0];
    
}
-(void)UnfoldTouch:(UIButton *)btn{
    if (btn.selected) {
        lable.sd_layout.maxHeightIs(lable.font.lineHeight*_maxHeight);
    }else{
        lable.sd_layout.maxHeightIs(MAXFLOAT);
    }
    btn.selected =!btn.selected;
    [lable updateLayout];
    
}
-(void)setText:(NSString *)text{
    lable.text =text;
    
   CGFloat height = [TrainStringUtil trainGetStringSize:text andMaxSize:CGSizeMake(TrainSCREENWIDTH-30, 9999) AndLabelFountSize:lable.font.pointSize].height;
    if ( height > lable.font.lineHeight*_maxHeight) {
        button.hidden =NO;
        button.sd_layout
        .heightIs(20);
    }else{
        button.sd_layout
        .heightIs(0);
        button.hidden =YES;
    }
    view.sd_layout
    .topSpaceToView(button,10);
    [lable updateLayout];
}
-(void)setMaxHeight:(float)maxHeight{
    _maxHeight =maxHeight;
    
    lable.sd_layout.maxHeightIs( lable.font.lineHeight*_maxHeight);
}


@end
