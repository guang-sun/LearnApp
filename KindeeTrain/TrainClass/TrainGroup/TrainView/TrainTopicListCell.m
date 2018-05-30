//
//  TrainTopicListCell.m
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainTopicListCell.h"
#import "TrainShowImageView.h"
#import "TrainNetWorkAPIClient.h"

@interface TrainTopicListCell ()
{
    UIImageView             *leftIconImageV, *rightAskImageV, *rightTopImageV,
                            *rightPrefectImageV;

    UILabel                 *titleLab, *writerLab, *originLab, *dateLab, *contentLab;
    
    UIButton                *eyeBtn, *replyBtn, *supportBtn, *collectBtn;
    UIView                  *bgView;
    TrainShowImageView      *showImageView;
    UIView                  *lineV2,*lineV3,  *lineV4;

}
@end

@implementation TrainTopicListCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        _maxCount = TrainTopicListMaxImageCount ;
        _isImageTap = NO;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    leftIconImageV =[[UIImageView alloc]init];
    leftIconImageV.image =[UIImage imageNamed:@"user_avatar_default"];
    leftIconImageV.contentMode = UIViewContentModeScaleAspectFill;

    rightAskImageV =[[UIImageView alloc]init];
    rightAskImageV.image =[UIImage imageNamed:@"Train_Topic_ask"];
    rightAskImageV.hidden =YES;
    
    rightTopImageV =[[UIImageView alloc]init];
    rightTopImageV.image =[UIImage imageNamed:@"Train_Topic_top"];
    rightTopImageV.hidden =YES;
    
    rightPrefectImageV =[[UIImageView alloc]init];
    rightPrefectImageV.image =[UIImage imageNamed:@"Train_Topic_pre"];
    rightPrefectImageV.hidden =YES;
    
    titleLab =[[UILabel alloc]creatTitleLabel];

    
    writerLab =[[UILabel alloc]creatContentLabel];

    
    originLab =[[UILabel alloc]initCustomLabel];
    originLab.textColor = TrainOrangeColor;
    originLab.cusFont   = TrainContentFont;
    
//    dateLab =[[UILabel alloc]creatContentLabel];
    
    contentLab =[[UILabel alloc]creatContentLabel];

    contentLab.textColor = TrainContentColor;
    
    showImageView =[[TrainShowImageView alloc]init];
    showImageView.userInteractionEnabled = _isImageTap;

    
    UIView  *lineV =[[UIView alloc]initWithLine1View];
    
    bgView =[[UIView alloc]init];
    
    lineV2 =[[UIView alloc]initWithLine1View];
    
    lineV3 =[[UIView alloc]initWithLine1View];

    lineV4 =[[UIView alloc]initWithLine1View];
    
    
    eyeBtn =[[UIButton alloc]initImageLeftCustomButton];
    eyeBtn.userInteractionEnabled =NO;
    eyeBtn.image =[UIImage imageSizeWithName:@"Train_Group_eye"];
    
    replyBtn =[[UIButton alloc]initImageLeftCustomButton];
    replyBtn.userInteractionEnabled =NO;
    replyBtn.image =[UIImage imageSizeWithName:@"Train_Group_reply"];
    
    supportBtn =[[UIButton alloc]initImageLeftCustomButton];
    supportBtn.image =[UIImage imageSizeWithName:@"Train_Group_support"];
    
    UIImage *supimage = [UIImage imageSizeWithName:@"Train_Group_support1"];
    [supportBtn setImage:[supimage imageTintWithColor:TrainNavColor] forState:UIControlStateSelected];
    [supportBtn addTarget:self action:@selector(supportTouch:)];
    
    collectBtn =[[UIButton alloc]initImageLeftCustomButton];
    collectBtn.image =[UIImage imageSizeWithName:@"Train_Collect"];
    [collectBtn setImage:[UIImage imageSizeWithName:@"Train_Group_collect"] forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(collectTouch:)];
    
    
    UIView *lineV1 =[[UIView alloc]init];
    lineV1.backgroundColor =[UIColor groupTableViewBackgroundColor];
    
    UIView *supView =self.contentView;
    
    [supView sd_addSubviews:@[leftIconImageV,rightAskImageV,rightPrefectImageV,rightTopImageV,titleLab,writerLab,originLab,contentLab,showImageView,bgView,lineV,lineV1]];
    
    [bgView sd_addSubviews:@[eyeBtn,replyBtn,supportBtn,collectBtn,lineV2,lineV3,lineV4]];
    
    leftIconImageV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,TrainMarginWidth)
    .widthIs(trainAutoLoyoutImageSize(trainIconWidth))
    .heightEqualToWidth();
    
//    leftIconImageV.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    titleLab.sd_layout
    .leftSpaceToView(leftIconImageV,10)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topEqualToView(leftIconImageV)
    .heightIs(trainAutoLoyoutImageSize(20));
    
    
    
    originLab.sd_layout
    .leftEqualToView(titleLab)
    .topSpaceToView(titleLab,5)
    .rightSpaceToView(supView, TrainMarginWidth)
    .heightIs(trainAutoLoyoutImageSize(10));
    
    writerLab.sd_resetLayout
    .leftEqualToView(titleLab)
    .topSpaceToView(originLab,5)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(trainAutoLoyoutImageSize(10));
//    .widthIs(100);
    
//    dateLab.sd_layout
//    .leftSpaceToView(writerLab,10)
//    .rightSpaceToView(supView,15)
//    .topEqualToView(writerLab)
//    .heightIs(15);
    
    
    contentLab.sd_layout
    .leftEqualToView(leftIconImageV)
    .rightSpaceToView(supView,15)
    .topSpaceToView(leftIconImageV,10)
    .autoHeightRatio(0)
    .maxHeightIs(contentLab.font.lineHeight *2);
    
    showImageView.sd_layout
    .leftEqualToView(leftIconImageV);
    
    
    lineV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(showImageView,9)
    .heightIs(0.6);
    
    bgView.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(contentLab,10)
    .heightIs(TrainCLASSHEIGHT);
    

    lineV1.sd_layout
    .leftEqualToView(supView)
    .rightEqualToView(supView)
    .topSpaceToView(bgView,0)
    .heightIs(10);
    
    [showImageView updateLayout];
    showImageView.picLocalArr = @[];
    showImageView.sd_layout.topSpaceToView(contentLab, 0);
    bgView.sd_layout.topSpaceToView(showImageView,10);
    
    [self setupAutoHeightWithBottomView:bgView bottomMargin:10];

    
    

}
-(void)setMaxCount:(int)maxCount{
    _maxCount = maxCount;
}
-(void)setIsImageTap:(BOOL)isImageTap{
    _isImageTap = isImageTap;
    showImageView.userInteractionEnabled = isImageTap;
    
}

-(void)updateBgViewUI:(BOOL )isAsk{
    isAsk = NO;
    if (isAsk) {
        CGFloat  width = (TrainSCREENWIDTH -2 * TrainMarginWidth - 4)/3;
        
        collectBtn.hidden = YES;
        lineV4.hidden  = YES;
        eyeBtn.sd_layout
        .leftEqualToView(bgView)
        .topEqualToView(bgView)
        .widthIs(width)
        .heightIs(TrainCLASSHEIGHT);
        
        
        replyBtn.sd_layout
        .leftSpaceToView(eyeBtn,2)
        .topEqualToView(eyeBtn)
        .widthIs(width)
        .heightIs(TrainCLASSHEIGHT);
        
        supportBtn.sd_layout
        .leftSpaceToView(replyBtn,2)
        .widthIs(width)
        .topEqualToView(replyBtn)
        .heightIs(TrainCLASSHEIGHT);
        
        lineV2.sd_layout
        .leftSpaceToView(eyeBtn,0)
        .widthIs(1)
        .centerYEqualToView(bgView)
        .heightIs(20);
        
        lineV3.sd_layout
        .leftSpaceToView(replyBtn,0)
        .widthIs(1)
        .centerYEqualToView(bgView)
        .heightIs(20);
        
    }else{
        collectBtn.hidden = NO;
        CGFloat  width = (TrainSCREENWIDTH -2 * TrainMarginWidth - 6)/4;
        lineV4.hidden  = NO;

        eyeBtn.sd_layout
        .leftEqualToView(bgView)
        .topEqualToView(bgView)
        .widthIs(width)
        .heightIs(TrainCLASSHEIGHT);
        
        
        replyBtn.sd_layout
        .leftSpaceToView(eyeBtn,2)
        .topEqualToView(eyeBtn)
        .widthIs(width)
        .heightIs(TrainCLASSHEIGHT);
        
        supportBtn.sd_layout
        .leftSpaceToView(replyBtn,2)
        .topEqualToView(replyBtn)
        .widthIs(width)
        .heightIs(TrainCLASSHEIGHT);
        
        collectBtn.sd_layout
        .leftSpaceToView(supportBtn,2)
        .widthIs(width)
        .topEqualToView(supportBtn)
        .heightIs(TrainCLASSHEIGHT);
        
        lineV2.sd_layout
        .leftSpaceToView(eyeBtn,0)
        .widthIs(1)
        .centerYEqualToView(bgView)
        .heightIs(20);
        
        lineV3.sd_layout
        .leftSpaceToView(replyBtn,0)
        .widthIs(1)
        .centerYEqualToView(bgView)
        .heightIs(20);
        
        lineV4.sd_layout
        .leftSpaceToView(supportBtn,0)
        .widthIs(1)
        .centerYEqualToView(bgView)
        .heightIs(20);
        
        
    }
    [bgView updateLayout];
}


-(void)setModel:(TrainTopicModel *)model{
    _model = model;
    NSString  *imageStr =(model.sphoto)?model.sphoto:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:@"/upload/user/pic"]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
       image = [TrainIP stringByAppendingFormat:@"/upload/user/pic/%@",imageStr];
    }
    
    [leftIconImageV sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"user_avatar_default"] options:SDWebImageAllowInvalidSSLCertificates];
   
    titleLab.text = notEmptyStr( model.title);

    NSString  *oriStr =(model.gg_title  && ![model.gg_title isEqualToString:@""])?model.gg_title:@"";
    originLab.text =[NSString  stringWithFormat:@"来源:%@",oriStr];

    NSString *formWhereStr =([model.is_mobile isEqualToString:@"Y"])?@"移动端":@"PC端";
    NSString *writeStr = [NSString stringWithFormat:@"%@    %@    来自 %@",notEmptyStr(model.full_name),notEmptyStr(model.timeDifference),formWhereStr];
    
    writerLab.text = writeStr;
 
    
    
//    dateLab.text = notEmptyStr(model.timeDifference);

    NSArray   *arr ;
    if (_maxCount == 0) {
        
        contentLab.sd_layout.maxHeightIs(MAXFLOAT);
        arr = model.pics;

    }else  {
        
        if (_maxCount != TrainTopicListMaxImageCount && TrainTopicListMaxImageCount != TrainTopicDetailMaxImageCount ) {

            contentLab.sd_layout.maxHeightIs(MAXFLOAT);

        }
        
        arr =(model.pics.count > _maxCount)?[model.pics subarrayWithRange:NSMakeRange(0, _maxCount)]:model.pics;
    }
    showImageView.picCount = model.pics.count;

    showImageView.picNetArr = arr;
   
    CGFloat picContainerTopMargin = 0;
    if (model.pics.count >0) {
        picContainerTopMargin = 10;
    }
    
    [showImageView updateLayout];
    showImageView.sd_layout.topSpaceToView(contentLab, picContainerTopMargin);
    bgView.sd_layout.topSpaceToView(showImageView,10);
    
    [self setupAutoHeightWithBottomView:bgView bottomMargin:10];
    
   
    contentLab.text =model.content;
    
    BOOL  isAsk =([model.type isEqualToString:@"Q"])?YES:NO;
    [self updateThreeIcon:model];
    
    [self updateBgViewUI:isAsk];
    
    eyeBtn.cusTitle =([model.hit_num intValue]>0)?model.hit_num:@"查看";
    replyBtn.cusTitle =([model.post_num intValue]>0)?model.post_num:@"回复";
    supportBtn.cusTitle =([model.top_num intValue]>0)?model.top_num:@"点赞";
    collectBtn.cusTitle =([model.collect_num intValue]>0)?model.collect_num:@"收藏";
    collectBtn.selected =([model.collected isEqualToString:@"Y"])?YES:NO;
    
    collectBtn.tintColor =TrainNavColor;
    supportBtn.selected =([model.toped isEqualToString:@"Y"])?YES:NO;
//    supportBtn.userInteractionEnabled =!supportBtn.selected;
    
    
    
}

-(void)updateThreeIcon:(TrainTopicModel *)model{
    
    BOOL  ispre =([model.is_elite intValue])?YES:NO;
    BOOL  istop =([model.is_stick intValue])?YES:NO;
    BOOL  isAsk =([model.type isEqualToString:@"Q"])?YES:NO;
    
    float  width = 0.0f;
    rightPrefectImageV.hidden   = !ispre;
    rightAskImageV.hidden       = !isAsk;
    rightTopImageV.hidden       = !istop;
    if (ispre) {
        
        rightPrefectImageV.sd_layout
        .rightSpaceToView(self.contentView,TrainMarginWidth)
        .topEqualToView(titleLab)
        .widthIs(15)
        .heightEqualToWidth();
        width = width + 20.0f ;

    }

    if (istop) {
        
        rightTopImageV.sd_layout
        .rightSpaceToView(self.contentView,width + TrainMarginWidth)
        .topEqualToView(titleLab)
        .widthIs(15)
        .heightEqualToWidth();
        width = width + 20.0f ;

    }

    if (isAsk) {
        rightAskImageV.sd_layout
        .rightSpaceToView(self.contentView,width + TrainMarginWidth)
        .topEqualToView(titleLab)
        .widthIs(15)
        .heightEqualToWidth();
        width = width + 20.0f ;
        
    }
    titleLab.sd_layout.rightSpaceToView(self.contentView, width +TrainMarginWidth);

}

-(void)supportTouch:(UIButton *)btn{
    
    if(supportBtn.selected == NO){
        __block NSString  *str = @"";
        [[TrainNetWorkAPIClient client] trainTopicSupportWithtopic_id:self.model.topic_id Success:^(NSDictionary *dic) {
            
            if ([dic[@"status"] boolValue]) {
                self.model.toped =@"Y";
                self.model.top_num =[NSString stringWithFormat:@"%d",[self.model.top_num intValue]+1];
                str = @"赞一个";
                if(_topicTouchBlock){
                    _topicTouchBlock(str,self.model);
                }
            }
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            str =@"点赞失败";
            if(_topicTouchBlock){
                _topicTouchBlock(str,self.model);
            }
        }];
    }else{
        if(_topicTouchBlock){
            _topicTouchBlock(@"您已经赞过了",self.model);
        }
    }
    
   
    
   }
-(void)collectTouch:(UIButton *)btn{
    
    __block NSString  *str = @"";
    [[TrainNetWorkAPIClient client] trainTopicCollectWithtopic_id:self.model.topic_id Success:^(NSDictionary *dic) {
        
        if ([dic[@"status"] boolValue]) {
            BOOL  btnselect =([self.model.collected isEqualToString:@"Y"])?YES:NO;
            if (!btnselect) {
                self.model.collect_num =[NSString stringWithFormat:@"%d",[self.model.collect_num intValue]+1];
            }else{
                self.model.collect_num =[NSString stringWithFormat:@"%d",[self.model.collect_num intValue]-1];
            }
            self.model.collected =(btnselect)?@"N":@"Y";
            if ([self.model.collected isEqualToString:@"Y"]) {
                str = @"已收藏";
            }else{
                str = @"已取消收藏";

            }
            if(_topicTouchBlock){
                _topicTouchBlock(str,self.model);
            }
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        if ([self.model.collected isEqualToString:@"N"]) {
            str = @"收藏失败";
        }else{
            str = @"取消收藏失败";
            
        }
        if(_topicTouchBlock){
            _topicTouchBlock(str,self.model);
        }
    }];
    
    
}



@end
