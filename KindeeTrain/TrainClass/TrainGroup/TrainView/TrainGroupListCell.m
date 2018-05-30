//
//  TrainGroupListCell.m
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainGroupListCell.h"



@interface TrainGroupListCell ()
{
    UIImageView             *leftIconImageV;
    UILabel                 *titleLab ,*writerLab, *dateLab, *contentLab;
    UIButton                *peoNumBtn, *topicNumBtn, *replyBtn, *supportBtn;
    UIView                  *bgView;
    UILabel                 *iconLab;
}
@end

@implementation TrainGroupListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    leftIconImageV =[[UIImageView alloc]init];
    leftIconImageV.image =[UIImage imageNamed:@"GROUP"];
    leftIconImageV.contentMode = UIViewContentModeScaleAspectFill;
    leftIconImageV.layer.masksToBounds = YES ;
    [self.contentView addSubview:leftIconImageV];
    
    titleLab =[[UILabel alloc]creatTitleLabel];
    [self.contentView addSubview:titleLab];
    
    iconLab = [[UILabel alloc]creatContentLabel];
    iconLab.backgroundColor = TrainColorFromRGB16(0xDB524B);
    iconLab.textColor = [UIColor whiteColor];
    iconLab.layer.cornerRadius = 3.0f;
    iconLab.layer.masksToBounds  =YES;
    iconLab.textAlignment = NSTextAlignmentCenter;
    iconLab.text = @"密";
    [titleLab addSubview:iconLab];
    
    
    writerLab =[[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:writerLab];
    
    
    dateLab =[[UILabel alloc]creatContentLabel];
    dateLab.cusFont = 10.0f;
    dateLab.textAlignment = NSTextAlignmentRight;
    dateLab.adjustsFontSizeToFitWidth = YES;
    dateLab.minimumScaleFactor = 10.0f;
    [self.contentView addSubview:dateLab];
    
    
    contentLab =[[UILabel alloc]creatContentLabel];
    contentLab.textColor =TrainColorFromRGB16(0x565656);
    [self.contentView addSubview:contentLab];
    
    
    UIView  *lineV =[[UIView alloc]initWithLine1View];
    [self.contentView addSubview:lineV];
    
    bgView =[[UIView alloc]init];
    [self.contentView addSubview:bgView];
    
    
    UIView  *lineV2 =[[UIView alloc]initWithLine1View];
    [bgView addSubview:lineV2];
    
    
    UIView  *lineV3 =[[UIView alloc]initWithLine1View];
    [bgView addSubview:lineV3];
    
    UIView  *lineV4 =[[UIView alloc]initWithLine1View];
    [bgView addSubview:lineV4];
    
    
    peoNumBtn =[[UIButton alloc]initImageLeftCustomButton];
    peoNumBtn.userInteractionEnabled =NO;
    peoNumBtn.image  = [UIImage imageSizeWithName:@"Train_Group_member"];
    //    [UIImage OriginImage:[UIImage imageNamed:@"Train_Group_member"] scaleToSize:CGSizeMake(TrainScaleWith6(20), TrainScaleWith6(20))];
    
    [bgView addSubview:peoNumBtn];
    
    topicNumBtn =[[UIButton alloc]initImageLeftCustomButton];
    topicNumBtn.userInteractionEnabled =NO;
    
    topicNumBtn.image = [UIImage imageSizeWithName:@"Train_Group_topic"];
    //    [UIImage imageNamed:@"Train_Group_topic"];
    [bgView addSubview:topicNumBtn];
    
    
    replyBtn =[[UIButton alloc]initImageLeftCustomButton];
    replyBtn.userInteractionEnabled =NO;
    replyBtn.image = [UIImage imageSizeWithName:@"Train_Group_reply"];
    //     [UIImage imageNamed:@"Train_Group_reply"];
    [bgView addSubview:replyBtn];
    
    supportBtn =[[UIButton alloc]initImageLeftCustomButton];
    
    supportBtn.userInteractionEnabled =NO;
    supportBtn.image = [UIImage imageSizeWithName:@"Train_Group_support"];
    //    [UIImage imageNamed:@"Train_Group_support"];
    [bgView addSubview:supportBtn];
    
    
    UIView *lineV1 =[[UIView alloc]init];
    lineV1.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:lineV1];
    
    UIView *supView =self.contentView;
    
    //    [supView sd_addSubviews:@[leftIconImageV,titleLab,writerLab,dateLab,contentLab,bgView,lineV,lineV1]];
    //
    //    [bgView sd_addSubviews:@[peoNumBtn,topicNumBtn,replyBtn,supView,lineV2,lineV3,lineV4]];
    
    leftIconImageV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .widthIs(trainAutoLoyoutImageSize(trainIconWidth))
    .heightEqualToWidth();
    
    titleLab.sd_layout
    .leftSpaceToView(leftIconImageV,10)
    .rightSpaceToView(supView,130)
    .topEqualToView(leftIconImageV)
    .heightIs(trainAutoLoyoutImageSize(20));
    
    iconLab.sd_layout
    .leftSpaceToView(titleLab,0)
    .topEqualToView(titleLab)
    .widthIs(iconLab.font.lineHeight +4)
    .heightIs(trainAutoLoyoutImageSize(20));
    
    
    
    writerLab.sd_layout
    .leftEqualToView(titleLab)
    .topSpaceToView(titleLab,10)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(trainAutoLoyoutImageSize(20));
    
    
    dateLab.sd_layout
    .leftSpaceToView(titleLab,5)
    .topEqualToView(titleLab)
    .rightSpaceToView(supView,10)
    .heightRatioToView(titleLab,1);
    
    
    
    contentLab.sd_layout
    .leftEqualToView(leftIconImageV)
    .rightSpaceToView(supView,10)
    .topSpaceToView(leftIconImageV,10)
    .autoHeightRatio(0)
    .maxHeightIs(contentLab.font.lineHeight *3);
    
    
    lineV.sd_layout
    .leftEqualToView(supView)
    .rightSpaceToView(supView,0)
    .topSpaceToView(contentLab,9)
    .heightIs(0.6);
    
    bgView.sd_layout
    .leftEqualToView(supView)
    .rightSpaceToView(supView,0)
    .topSpaceToView(contentLab,10)
    .heightIs(TrainCLASSHEIGHT);
    
    bgView.sd_equalWidthSubviews = @[peoNumBtn,topicNumBtn,replyBtn,supportBtn];
    
    
    peoNumBtn.sd_layout
    .leftEqualToView(bgView)
    .topEqualToView(bgView)
    .heightIs((TrainCLASSHEIGHT));
    
    
    topicNumBtn.sd_layout
    .leftSpaceToView(peoNumBtn,2)
    .topEqualToView(peoNumBtn)
    .heightIs((TrainCLASSHEIGHT));
    
    replyBtn.sd_layout
    .leftSpaceToView(replyBtn,2)
    .topEqualToView(replyBtn)
    .heightIs(TrainCLASSHEIGHT);
    
    supportBtn.sd_layout
    .leftSpaceToView(supportBtn,2)
    .rightEqualToView(bgView)
    .topEqualToView(supportBtn)
    .heightIs(TrainCLASSHEIGHT);
    
    lineV2.sd_layout
    .leftSpaceToView(peoNumBtn,0)
    .widthIs(1)
    .centerYEqualToView(bgView)
    .heightIs((TrainCLASSHEIGHT/2));
    
    lineV3.sd_layout
    .leftSpaceToView(topicNumBtn,0)
    .widthIs(1)
    .centerYEqualToView(bgView)
    .heightIs((TrainCLASSHEIGHT/2));
    
    
    lineV4.sd_layout
    .leftSpaceToView(replyBtn,0)
    .widthIs(1)
    .centerYEqualToView(bgView)
    .heightIs((TrainCLASSHEIGHT/2));
    
    lineV1.sd_layout
    .leftEqualToView(supView)
    .rightEqualToView(supView)
    .topSpaceToView(bgView,0)
    .heightIs(10);
    
    [self setupAutoHeightWithBottomView:lineV1 bottomMargin:0];
    
}
-(void)setModel:(TrainGroupModel *)model{
    
    NSString  *imageStr =(model.logo)?model.logo:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:@"/upload/group/pic"]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"/upload/group/pic/%@",imageStr];
    }
    [leftIconImageV sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"GROUP"] options:SDWebImageAllowInvalidSSLCertificates];
    
    NSString  * groupName = model.title;
    
    if (model.join_condition && ![model.join_condition isEqualToString:@"PUBLIC"]) {
        iconLab.hidden = NO ;
        
        NSString  *iconNull ;
        NSString *deviceName = [TrainStringUtil getCurrentDeviceModel];
        if([deviceName rangeOfString:@"iPad"].location != NSNotFound) {
            iconNull = @"            ";
        }else {
            iconNull = @"      ";
        }
        groupName = [NSString stringWithFormat:@"%@%@",iconNull,model.title];
    }else {
        iconLab.hidden = YES ;
    }
    
    if (! TrainStringIsEmpty(_searchTitle) ) {
        NSAttributedString  *attstr =[groupName dealwithstring:_searchTitle andFont:TrainTitleFont];
        titleLab.attributedText =attstr;
    }else{
        titleLab.text = groupName;
    }
    dateLab.text =model.create_date;
    
    writerLab.text = [NSString  stringWithFormat:@"%@  发起",notEmptyStr(model.username)];
    contentLab.text =model.about;
    
    peoNumBtn.cusTitle =([model.member_num intValue]>0)?model.member_num:@"成员";
    topicNumBtn.cusTitle =([model.topic_num intValue]>0)?model.topic_num:@"话题";
    replyBtn.cusTitle =([model.post_num intValue]>0)?model.post_num:@"回复";
    supportBtn.cusTitle =([model.top_num intValue]>0)?model.top_num:@"0";
    
    
    
}


@end
