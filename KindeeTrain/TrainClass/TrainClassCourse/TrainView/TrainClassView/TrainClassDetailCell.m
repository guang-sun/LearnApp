//
//  TrainClassDetailCell.m
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainClassDetailCell.h"


@interface TrainClassDetailCell ()
{
    UIImageView     *iconImageV;
    UILabel         *nameLab;
    UILabel         *contentLab;
    UIButton        *openButton;
    UIView          *starBgView;
}
@end

@implementation TrainClassDetailCell

CGFloat maxClassHeight = 0; // 根据具体font而定

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  self;
    
}
-(void)creatUI{
    
    for (UIView *view  in  [self.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    iconImageV =[[UIImageView alloc]init];
    iconImageV.image =[UIImage imageNamed:@"user_avatar_default"];
    iconImageV.contentMode = UIViewContentModeScaleAspectFit;
    //    leftImageV.backgroundColor =[UIColor grayColor];
    
    nameLab =[[UILabel alloc]initCustomLabel];
    nameLab.cusFont =14;
    nameLab.textColor =TrainColorFromRGB16(0x000000);
    
    contentLab =[[UILabel alloc]creatContentLabel];
    
    UIView  *lineV =[[UIView alloc]init];
    lineV.backgroundColor =TrainColorFromRGB16(0xD9D9D9);
    
    starBgView  =[[UIView alloc]init];
    
    
    [self.contentView sd_addSubviews:@[iconImageV,nameLab,contentLab,starBgView,lineV]];
    
    
    UIView *supView =self.contentView;
    iconImageV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .widthIs(40)
    .heightIs(40);
//    iconImageV.sd_cornerRadiusFromWidthRatio =@(0.5);
    
    nameLab.sd_layout
    .leftSpaceToView(iconImageV,10)
    .topEqualToView(iconImageV)
    .rightSpaceToView(supView,TrainMarginWidth+110)
    .heightIs(20);
    
    
    contentLab.sd_layout
    .leftEqualToView(nameLab)
    .rightSpaceToView(supView,15)
    .topSpaceToView(nameLab,0)
    .heightIs(20);
    
    starBgView.sd_layout
    .leftSpaceToView(nameLab,10)
    .topEqualToView(iconImageV)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(20);
    
    lineV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(iconImageV,9)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:iconImageV bottomMargin:10];
    
}

-(void)creatStarImage:(int )grade{
    
    UIView  *lastView =nil;
    for (int i = 0; i < 5; i++) {
        UIImageView  *image =[[UIImageView alloc]init];
        NSString  *name =(i < grade)?@"Class_Detail_Star":@"Class_Detail_UnStar";
        image.image =[UIImage imageNamed:name];
        [starBgView addSubview:image];
        
        image.sd_layout
        .leftSpaceToView(lastView,3)
        .topEqualToView(starBgView)
        .widthIs(17)
        .heightIs(17);
        lastView =image;
        
    }
}
-(void)creatContentUI{
    for (UIView *view  in  [self.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    contentLab =[[UILabel alloc]initCustomLabel];
    contentLab.textColor =TrainColorFromRGB16(0x969696);
    contentLab.cusFont =14.0f;
    if (maxClassHeight == 0) {
        maxClassHeight = contentLab.font.lineHeight * 3;
    }
    
    openButton =[[UIButton  alloc]initCustomButton];
    openButton.cusTitleColor = TrainNavColor;
    openButton.cusTitle=@"更多";
    openButton.cusSelectTitle =@"收起";
    [openButton addTarget:self action:@selector(UnfoldTouch:)];
    
    UIView  *lineV =[[UIView alloc]initWithLineView];
    
    
    [self.contentView sd_addSubviews:@[contentLab,openButton, lineV]];
    
    UIView   *supView =self.contentView;
    
    contentLab.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,5)
    .autoHeightRatio(0);
    
    openButton.sd_layout
    .rightEqualToView(contentLab)
    .topSpaceToView(contentLab,0)
    .widthIs(70);
    
    
}
-(void)UnfoldTouch:(UIButton *)btn{
    if (_gaiLanUnfoldblock) {
        _gaiLanUnfoldblock();
    }
}
-(void)setIsDetail:(BOOL )isDetail{
    if (isDetail) {
        [self creatContentUI];
    }else{
        [self creatUI];
    }
}
-(void)setModel:(TrainClassUserModel *)model{
    
    NSString  *imageStr =(model.photo)?model.photo:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:@"/upload/user/pic/"]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"/upload/user/pic/%@",imageStr];
    }
    [iconImageV sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"user_avatar_default"] options:SDWebImageAllowInvalidSSLCertificates];

    nameLab.text =notEmptyStr(model.full_name);
    
    if (_status  == TrainClassDetailStatusTeacher) {
        contentLab.text =notEmptyStr(model.l_level); ;
    }else if(_status == TrainClassDetailStatusStudent){
        contentLab.text = notEmptyStr(model.group_name);
    }
    
}

-(void)setGailanModel:(TraingailanDatelisModel *)gailanModel{
    
    NSString  *contentStr = (TrainStringIsEmpty(gailanModel.content)) ? @"暂无" : gailanModel.content;
    contentLab.text = contentStr;
    
    if (gailanModel.isShowButton) { // 如果文字高度超过60
        openButton.sd_layout.heightIs(20);
        openButton.hidden = NO;
        if (gailanModel.isOpen) { // 如果需要展开
            contentLab.sd_layout.maxHeightIs(MAXFLOAT);
            openButton.selected =YES;
        } else {
            contentLab.sd_layout.maxHeightIs(maxClassHeight);
            openButton.selected=NO;
        }
    } else {
        openButton.sd_layout.heightIs(0);
        openButton.hidden = YES;
        
    }
    [self setupAutoHeightWithBottomView:openButton bottomMargin:10];
    
}

-(void)setStatus:(TrainClassDetailStatus)status{
    _status =status;
}
//-(void)setIsApparise:(BOOL)isApparise{
//    starBgView.hidden = !isApparise;
//    
//    if (isApparise) {
//        [self creatStarImage:arc4random()%5];
//    }
//}


@end
