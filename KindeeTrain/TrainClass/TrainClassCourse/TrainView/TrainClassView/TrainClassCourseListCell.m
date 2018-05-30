//
//  TrainClassCourseListCell.m
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainClassCourseListCell.h"

@interface TrainClassCourseListCell ()
{
    UIImageView     *leftImageV;
    UILabel         *titleLab ,*detailLab, *courseNumLab;
    UIView          *progressBgView;
    UIView          *progressView;
}
@end


@implementation TrainClassCourseListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
    }
    return  self;
    
}


-(void)creatUI{
    
    leftImageV =[[UIImageView alloc]init];
    leftImageV.image =[UIImage imageNamed:@"train_course_default"];
    
    //    leftImageV.backgroundColor =[UIColor grayColor];
    
    titleLab =[[UILabel alloc]creatTitleLabel];

    
    courseNumLab =[[UILabel alloc]initCustomLabel];
    courseNumLab.cusFont =11;
    courseNumLab.textColor =TrainColorFromRGB16(0x6FAD47);
    
    
    progressBgView =[[UIView alloc]init];
    progressBgView.backgroundColor =TrainColorFromRGB16(0xFFE0C0);
    
    //    progressView =[[UIView alloc]init];
    //    progressView.backgroundColor =UIColorFromRGB16(0xFF9628);
    
    
    UIView  *lineV =[[UIView alloc]initWithLineView];
    
    [self.contentView sd_addSubviews:@[leftImageV,titleLab,courseNumLab,progressBgView,lineV]];
    
    
    UIView *supView =self.contentView;
    leftImageV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .widthIs(130)
    .heightIs(80);
    
    
    titleLab.sd_layout
    .leftSpaceToView(leftImageV,10)
    .topEqualToView(leftImageV)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(40);
    
    
    courseNumLab.sd_layout
    .leftEqualToView(titleLab)
    .rightEqualToView(titleLab)
    .topSpaceToView(titleLab,5)
    .heightIs(15);
    
    
    progressBgView.sd_layout
    .leftEqualToView(titleLab)
    .rightEqualToView(titleLab)
    .topSpaceToView(courseNumLab,5)
    .heightIs(15);
    
    
    
    lineV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(leftImageV,9)
    .heightIs(0.5);
    
    progressBgView.sd_cornerRadiusFromHeightRatio =@(0.5);
    
    
    [self setupAutoHeightWithBottomView:leftImageV bottomMargin:10];
    
    
}
-(void)setModel:(TrainClassCourseModel *)model{
    titleLab.text =[self deal:model.name];
    
    NSString  *imageStr =(model.picture)?model.picture:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:@"/upload/course/pic/"]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"/upload/course/pic/%@",imageStr];
    }

//    NSString  *imageUrl = [TrainIP stringByAppendingString:(model.picture)?model.picture:@""];
    [leftImageV sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"train_course_default"] options:SDWebImageAllowInvalidSSLCertificates];
    NSString  *string ;
//    if(model.completed_num.intValue ==0){
//        string =@"还没有开始学习";
//    }else{
        string =[NSString stringWithFormat:@"已学习%@/%@课时",model.completed_num,model.hour_count];
//    }
    courseNumLab.text =string;
    
    if (progressView) {
        [progressView removeFromSuperview];
        progressView =nil;
    }
    
    progressView =[[UIView alloc]init];
    progressView.backgroundColor =TrainColorFromRGB16(0xFF9628);
    [self.contentView addSubview:progressView];
    float  progress  ;
    if (model.hour_count.intValue == 0) {
        progress = 0.0f;
    }else{
        progress  = 1.0 * model.completed_num.intValue/model.hour_count.intValue;
        
    }
    progressView.sd_layout
    .leftEqualToView(progressBgView)
    .topEqualToView(progressBgView)
    .heightRatioToView(progressBgView,1)
    .widthRatioToView(progressBgView,progress);
    
    if (progress < 1) {
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:progressView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(7.5, 7.5)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = progressView.bounds;
        maskLayer1.path = maskPath1.CGPath;
        progressView.layer.mask = maskLayer1;
    }else{
        progressView.layer.masksToBounds =YES;
        progressView.layer.cornerRadius = 10;
    }
    
}

-(NSString *)deal:(NSString *)str{
    NSString  *string = (str)?str:@"";
    return string;
    
}

@end
