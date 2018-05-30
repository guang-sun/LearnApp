//
//  TrainCourseAppraiseCell.m
//  SOHUEhr
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCourseAppraiseCell.h"

@interface TrainCourseAppraiseCell ()
{
    UIImageView     *userIconImageV;
    UILabel         *contentLab, *userNameLab, *dateLab;
    UIButton        *openButton;
    UIView          *starBgView , *deleteStarBgView;
    
    UIView          *deleteView ,*AppreiseView;
    BOOL            isCreat;
    BOOL            isApprasaCreat;
}
@end

@implementation TrainCourseAppraiseCell

CGFloat maxAppraiseHeight = 0; // 根据具体font而定

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        isCreat = YES;
        isApprasaCreat= YES;
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)creatUI{
    
    
    deleteView =[[UIView alloc]init];
    deleteView.hidden =YES;
    deleteView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:deleteView];
    deleteView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    deleteStarBgView =[[UIView alloc]init];
    [deleteView addSubview:deleteStarBgView];
    
    deleteStarBgView.sd_layout
    .centerXEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .widthIs(240)
    .bottomEqualToView(self.contentView);
    
    

    
    AppreiseView =[[UIView alloc]init];
    AppreiseView.backgroundColor =[UIColor whiteColor];
    [self.contentView addSubview:AppreiseView];
    AppreiseView.hidden = NO;
    AppreiseView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    userIconImageV =[[UIImageView  alloc]init];
    userIconImageV.image =[UIImage imageNamed:@"user_avatar_default.png"];
    [AppreiseView addSubview:userIconImageV];
    
    contentLab =[[UILabel alloc] creatContentLabel];
    contentLab.textColor =TrainColorFromRGB16(0x9D9D9D);
    [AppreiseView addSubview:contentLab];
    
    if (maxAppraiseHeight == 0) {
        maxAppraiseHeight = contentLab.font.lineHeight * 4;
    }
    
    openButton =[[UIButton  alloc]initCustomButton];
    openButton.cusFont =12.0f;
    openButton.cusTitleColor =TrainNavColor;
    openButton.cusTitle=@"更多";
    openButton.cusSelectTitle =@"收起";
    [openButton addTarget:self action:@selector(Unfold)];

    [AppreiseView addSubview:openButton];
    
    
    
    userNameLab =[[UILabel alloc]creatContentLabel];

    [AppreiseView addSubview:userNameLab];
    
    dateLab =[[UILabel alloc]creatContentLabel];
    [AppreiseView addSubview:dateLab];
    
    starBgView =[[UIView alloc]init];
    starBgView.backgroundColor =[UIColor whiteColor];
    [AppreiseView addSubview:starBgView];
    
    
    UIView  *line =[[UIView alloc]initWithLineView];
    [AppreiseView addSubview:line];
    
    
    
    UIView  *supView =AppreiseView;
    
    userIconImageV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .widthIs(40)
    .heightEqualToWidth();
    userIconImageV.sd_cornerRadiusFromWidthRatio =@(0.5);
    
    contentLab.sd_layout
    .leftSpaceToView(userIconImageV,10)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .autoHeightRatio(0);
    
    openButton.sd_layout
    .rightEqualToView(contentLab)
    .topSpaceToView(contentLab,0)
    .widthIs(50);
    
        
    userNameLab.sd_layout
    .leftEqualToView(contentLab)
    .widthIs(40)
    .heightIs(20);
   
    starBgView.sd_layout
    .rightSpaceToView(supView,10)
    .topEqualToView(userNameLab)
    .widthIs(80)
    .heightIs(20);
    
    dateLab.sd_layout
    .leftSpaceToView(userNameLab,5)
    .rightSpaceToView(starBgView,5)
    .topEqualToView(userNameLab)
    .heightIs(20);
    

    
    line.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .bottomSpaceToView(supView,1)
    .heightIs(0.5);
    [AppreiseView setupAutoHeightWithBottomView:userNameLab bottomMargin:10];
    [self setupAutoHeightWithBottomView:userNameLab bottomMargin:10];
    
}
-(void)creatGroupAppraise{
    
    AppreiseView.hidden =YES;
    deleteView.hidden =NO;
    
    if (isApprasaCreat) {
        
        isApprasaCreat = NO;
       
        UIView  *lastView = [[UIView alloc]init];
        for (int i = 0; i < 5; i++) {
            UIImageView  *image =[[UIImageView alloc]init];
            NSString  *name = @"star_big";
            image.image =[UIImage imageNamed:name];
            [deleteStarBgView addSubview:image];
            
            image.sd_layout
            .leftSpaceToView(lastView,15)
            .centerYEqualToView(deleteStarBgView)
            .widthIs(30)
            .heightIs(30);
            lastView =image;
            
        }
        
    }
    
    
    
}
-(void)creatStarImage:(int )grade{
    
    AppreiseView.hidden =NO;
    deleteView.hidden =YES;
    if (isCreat) {
        
        isCreat = NO;
        UIView  *lastView =nil;
        for (int i = 0; i < 5; i++) {
            UIImageView  *image =[[UIImageView alloc]init];
            NSString  *name =(i < grade)?@"star_big_selected":@"star_big.png";
            image.image =[UIImage imageNamed:name];
            [starBgView addSubview:image];
            
            image.sd_layout
            .leftSpaceToView(lastView,3)
            .centerYEqualToView(starBgView)
            .widthIs(13)
            .heightIs(13);
            lastView =image;
            
        }
    }
}

-(void)Unfold{
    if (_unfoldBlock) {
        _unfoldBlock();
    }
}

-(void)setModel:(TrainCourseAppraiseModel *)model{
    
    if (_isFirst) {
        if (model.grade && model.grade.intValue > 0) {
            [self creatStarImage:[model.grade intValue]];
        }else{
            [self creatGroupAppraise];
            return;
        }
    }else{
        
        [self creatStarImage:[model.grade intValue]];
    }
    
    NSString  *imageStr =(model.mphoto)?model.mphoto:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:@"/upload/user/pic"]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"/upload/user/pic/%@",imageStr];
    }

    [userIconImageV sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"user_avatar_default"] options:SDWebImageAllowInvalidSSLCertificates];
    contentLab.text = (TrainStringIsEmpty( model.content))?@" ":model.content;
    
    if (model.isShowButton) { // 如果文字高度超过60
        openButton.sd_layout.heightIs(20);
        openButton.hidden = NO;
        userNameLab.sd_layout.topSpaceToView(openButton,0);
        if (model.isOpen) { // 如果需要展开
            contentLab.sd_layout.maxHeightIs(MAXFLOAT);
            openButton.selected =YES;
        } else {
            contentLab.sd_layout.maxHeightIs(maxAppraiseHeight);
            openButton.selected=NO;
        }
    } else {
        openButton.sd_layout.heightIs(0);
        openButton.hidden = YES;
        userNameLab.sd_layout.topSpaceToView(contentLab,5);
        
    }
    userNameLab.text = model.create_name;
    dateLab.text = model.create_date;
    
    
}

@end
