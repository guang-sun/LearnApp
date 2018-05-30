//
//  TrainTopicSearchListCell.m
//  SOHUEhr
//
//  Created by apple on 16/11/3.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainTopicSearchListCell.h"


@interface TrainTopicSearchListCell ()
{
    UIImageView             *rightAskImageV;
    UIImageView             *rightTopImageV;
    UIImageView             *rightPrefectImageV;
    UILabel                 *titleLab;
    UILabel                 *contentLab;
    UILabel                 *adressLab;
    UIButton                *eyeBtn;
    UIButton                *replyBtn;
    
}
@end

@implementation TrainTopicSearchListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    
    rightAskImageV =[[UIImageView alloc]init];
    rightAskImageV.image =[UIImage imageNamed:@"Train_Topic_problem"];
    rightAskImageV.hidden =YES;
    
    rightTopImageV =[[UIImageView alloc]init];
    rightTopImageV.image =[UIImage imageNamed:@"Train_Topic_top"];
    rightTopImageV.hidden =YES;
    
    
    rightPrefectImageV =[[UIImageView alloc]init];
    rightPrefectImageV.image =[UIImage imageNamed:@"Train_Topic_pre"];
    rightPrefectImageV.hidden =YES;
    
    titleLab =[[UILabel alloc]creatTitleLabel];
   
    
    contentLab =[[UILabel alloc]creatContentLabel];
    
    adressLab =[[UILabel alloc]initCustomLabel];
    adressLab.cusFont =12.f;
    adressLab.textColor =TrainColorFromRGB16(0xFF8A10);
    
    eyeBtn =[[UIButton alloc]initCustomButton];
    eyeBtn.image =[UIImage imageNamed:@"Train_Topic_eye"];
    eyeBtn.cusTitleColor =TrainColorFromRGB16(0x9D9D9D);
    eyeBtn.cusFont =10.f;
    
    replyBtn =[[UIButton alloc]initCustomButton];
    replyBtn.image =[UIImage imageNamed:@"Train_Topic_reply"];
    replyBtn.cusTitleColor =TrainColorFromRGB16(0x9D9D9D);
    replyBtn.cusFont =10.f;
    
    UIView *lineV1 =[[UIView alloc]init];
    lineV1.backgroundColor =TrainColorFromRGB16(0xD9D9D9);
    
    UIView *supView =self.contentView;
    
    [supView sd_addSubviews:@[rightAskImageV,rightPrefectImageV,rightTopImageV,titleLab,contentLab,adressLab,eyeBtn,replyBtn,lineV1]];
    
    
    titleLab.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .heightIs((15));
    
    contentLab.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(titleLab,5)
    .autoHeightRatio(0)
    .maxHeightIs([UIFont systemFontOfSize:14].lineHeight *3);
    
    
    eyeBtn.sd_layout
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(contentLab,10)
    .heightIs((20))
    .widthIs((50));
    
    replyBtn.sd_layout
    .rightSpaceToView(eyeBtn,5)
    .topEqualToView(eyeBtn)
    .heightIs((20))
    .widthIs((50));
    
    adressLab.sd_layout
    .leftEqualToView(contentLab)
    .rightSpaceToView(replyBtn,5)
    .topEqualToView(eyeBtn)
    .heightIs((20));
    
    
    
    
    lineV1.sd_layout
    .leftEqualToView(supView)
    .rightEqualToView(supView)
    .topSpaceToView(adressLab,9)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:lineV1 bottomMargin:1];
    
    
    //    NSString *str =@"阿萨飒飒加水果的建安公司的价格阿sasasasasasa萨德";
    //    titleLab.attributedText =[str dealwithstring:@"公司" andFont:14];
    //    contentLab.text =@"阿舍不得把书都不卡就被冻结阿布都几把几把多叫阿布都几把就是打不开叫阿布都看见巴萨的酒吧开手机百度奥斯卡不对劲啊不是可敬的客户收到就安徽的哈动画打卡上看到卡死的按时打卡合适的卡号是肯定还是的卡号上看到哈是打开速度卡打卡SD卡打卡SD卡萨达阿萨德";
    //    adressLab.text =@"可查那是>>可是:安徽省爱空间都会卡机会多看哈圣诞贺卡阿斯达克a啊";
    
    
}
-(void)updateThreeImage:(TrainTopicModel *)model{
    
//    BOOL  isNotPre =([model.is_elite intValue]==0)?YES:NO;
//    rightPrefectImageV.hidden   = isNotPre;
//    BOOL  isNotTop =([model.is_stick intValue]==0)?YES:NO;
//    rightTopImageV.hidden       = isNotPre;
    BOOL  isNotAsk =([model.is_elite intValue]==0)?YES:NO;
    
    if (isNotAsk) {
        
        rightAskImageV.hidden =YES;
        titleLab.sd_layout.leftSpaceToView(self.contentView,TrainMarginWidth);

    }else{
        rightAskImageV.hidden =NO;
        
        rightAskImageV.sd_layout
        .leftSpaceToView(self.contentView,15)
        .topSpaceToView(self.contentView,10)
        .widthIs((15))
        .heightEqualToWidth();
        titleLab.sd_layout.leftSpaceToView(rightAskImageV,5);

    }
    

//    rightAskImageV.sd_layout
//    .leftSpaceToView(self.contentView,15)
//    .topSpaceToView(self.contentView,10)
//    .widthIs((15))
//    .heightEqualToWidth();
//    
//    rightPrefectImageV.sd_layout
//    .rightSpaceToView(supView,15)
//    .topEqualToView(titleLab)
//    .widthIs((15))
//    .heightEqualToWidth();
//    
//    rightTopImageV.sd_layout
//    .rightSpaceToView(rightPrefectImageV,5)
//    .topEqualToView(titleLab)
//    .widthIs((15))
//    .heightEqualToWidth();
//
//    if (isAsk) {
//        rightAskImageV.hidden =NO;
//        titleLab.sd_layout.leftSpaceToView(rightAskImageV,5);
//        
//    }else{
//        rightAskImageV.hidden =YES;
//        titleLab.sd_layout.leftSpaceToView(self.contentView,10);
//        
//    }
    [titleLab updateLayout];
}
-(void)setSearchStr:(NSString *)searchStr{
    _searchStr=searchStr;
}
-(void)setModel:(TrainTopicModel *)model{
    
    
    _searchStr =(_searchStr)?_searchStr:@"";
    NSAttributedString  *attstr =[model.title dealwithstring:_searchStr andFont:14.0];
    titleLab.attributedText =attstr;
    
    contentLab.text =model.content;
  
    [self updateThreeImage:model];
    
    
    eyeBtn.cusTitle =([model.hit_num intValue]>0)?model.hit_num:@"查看";
    replyBtn.cusTitle =([model.post_num intValue]>0)?model.post_num:@"回复";
    NSString  *gg_title =(model.gg_title)?model.gg_title:@"";
    NSString  *full = (model.full_name)?model.full_name:@"";
    NSString  *adress =[NSString  stringWithFormat:@"%@>>%@",gg_title,full];
    adressLab.text =adress;
    
}


@end
