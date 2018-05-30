//
//  TrainCourseClassListCell.m
//   KingnoTrain
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainCourseClassListCell.h"
#import "TrainCustomLable.h"

@interface TrainCourseClassListCell ()
{
    UIImageView     *leftImageV;
    TrainCustomLable         *titleLab;
    UILabel          *peopleNumLab ,  *classNumLab , *learnTimeLab, *iconLab, *progressLabel , * dateLabel;
}
@end

@implementation TrainCourseClassListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _isClass  = NO;

    [self creatUI];

    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _isClass  = NO;
        [self creatUI];
    }
    return  self;
    
}
-(void)creatUI{
    
    
    leftImageV = [[UIImageView alloc]init];
//    leftImageV.image =[UIImage imageNamed:@"train_course_default"];
    
    dateLabel = [[UILabel alloc]initCustomLabel];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    dateLabel.textAlignment = NSTextAlignmentCenter ;
    dateLabel.font = [UIFont systemFontOfSize:12.0f];

    dateLabel.hidden = YES ;

    
    titleLab =[[TrainCustomLable alloc]initWithFrame:CGRectZero];
    titleLab.font = [UIFont systemFontOfSize:trainAutoLoyoutTitleSize(TrainTitleFont)];
    titleLab.numberOfLines = 0;
    titleLab.verticalAlignment = TrainVerticalAlignmentTop;
    titleLab.textColor = TrainTitleColor;
    
    UIView *view =[[UIView alloc]init];
    
    iconLab = [[UILabel alloc]creatTitleLabel];
    iconLab.cusFont = (12.0f);
    iconLab.layer.cornerRadius = 3.0f;
    iconLab.layer.masksToBounds = YES;
    iconLab.textAlignment = NSTextAlignmentCenter;
    iconLab.textColor = [UIColor whiteColor];
    
    progressLabel = [[UILabel alloc] creatContentLabel];
    progressLabel.cusFont = (14.0f);
    progressLabel.textColor = TrainNavColor ;
    progressLabel.textAlignment = NSTextAlignmentRight;
    
    peopleNumLab =[[UILabel alloc]creatContentLabel];
    
    classNumLab=[[UILabel alloc]creatContentLabel];
    
    classNumLab.textAlignment =NSTextAlignmentCenter;
    
    learnTimeLab=[[UILabel alloc]creatContentLabel];
    learnTimeLab.textAlignment =NSTextAlignmentRight;
    
    UIView  *lineV =[[UIView alloc]initWithLineView];
    
    [self.contentView sd_addSubviews:@[leftImageV,titleLab,progressLabel,view,lineV]];
    
    [leftImageV addSubview:dateLabel];
    
    [titleLab addSubview:iconLab];
    
    [view sd_addSubviews:@[peopleNumLab,classNumLab,learnTimeLab]];
    
    UIView *supView =self.contentView;
    
    leftImageV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,trainAutoLoyoutImageSize(10))
    .widthIs(trainAutoLoyoutImageSize(130))
    .heightIs(trainAutoLoyoutImageSize(80));
    
    dateLabel.sd_layout
    .rightEqualToView(leftImageV)
    .bottomEqualToView(leftImageV)
    .widthIs(50)
    .heightIs(25);
    
    
    titleLab.sd_layout
    .leftSpaceToView(leftImageV,10)
    .topEqualToView(leftImageV)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(trainAutoLoyoutImageSize(80) - 40);
    
    progressLabel.sd_layout
    .rightEqualToView(titleLab)
    .leftEqualToView(titleLab)
    .topSpaceToView(titleLab, 3)
    .heightIs(15);
    
    
    iconLab.sd_layout
    .leftEqualToView(titleLab)
    .topEqualToView (titleLab)
    .widthIs(trainAutoLoyoutImageSize(30))
    .heightIs(iconLab.font.lineHeight + 2);
    
    
    view.sd_layout
    .leftEqualToView(titleLab)
    .rightEqualToView(titleLab)
    .topSpaceToView(progressLabel,2)
    .heightIs((20));
    
    view.sd_equalWidthSubviews = @[peopleNumLab, classNumLab, learnTimeLab];
    
    peopleNumLab.sd_layout
    .leftEqualToView(view)
    .topSpaceToView(view,0)
    .heightIs(20);
    
    classNumLab.sd_layout
    .leftSpaceToView(peopleNumLab,0)
    .topEqualToView(peopleNumLab)
    .heightRatioToView(peopleNumLab,1);
    
    learnTimeLab.sd_layout
    .leftSpaceToView(classNumLab,5)
    .topSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .heightRatioToView(view,1);
    
    lineV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(leftImageV,9)
    .heightIs(0.5);
    
    // [self setupAutoHeightWithBottomView:leftImageV bottomMargin:10];
    
}
-(void)setIsClass:(BOOL)isClass{
    _isClass =isClass;
}

-(void)setSearchStr:(NSString *)searchStr{
    _searchStr=searchStr;
}

-(void)setIsMyCourse:(BOOL)isMyCourse {
    _isMyCourse = isMyCourse ;
}


-(void)setModel:(TrainCourseAndClassModel *)model{
    
    NSString  *preFixStr =@"";
    
    UIImage    *defaultImage = nil;
    if (_isClass) {
        preFixStr = @"/upload/class/pic/";
        defaultImage = [UIImage imageNamed:@"train_class_default"];
    }else{
        preFixStr = @"/upload/course/pic/";
        defaultImage = [UIImage imageNamed:@"train_course_default"];

    }
    
    NSString  *imageStr =(model.picture)?model.picture:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:preFixStr]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"%@%@",preFixStr,imageStr];
    }
    [leftImageV sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:defaultImage options:SDWebImageAllowInvalidSSLCertificates];
    
    NSString  *courseName =@"";
    if (_isClass) {
        
        iconLab.hidden = YES;
        courseName = model.name;
        progressLabel.text = @"" ;
        dateLabel.hidden = NO ;
        if ([model.is_start integerValue] > 0 && [model.is_end integerValue] > 0)  {
            
            dateLabel.hidden = YES ;
            
        }else {
            dateLabel.hidden = NO ;
            
            NSString *msgText;
            if ([model.is_start integerValue] <= 0) {
                
                msgText = @"未开始";
                
            }else {
                msgText = @"已结束";
            }
            
            dateLabel.text = msgText ;
            
        }
        
    }else{
        
        dateLabel.hidden = NO ;
        
        if (_isMyCourse) {
            progressLabel.textAlignment = NSTextAlignmentLeft ;
            NSString *progressStr  ;
            if (model.completed_percent > 0) {
                progressStr = [NSString stringWithFormat:@"已学习%zi%%",model.completed_percent];
                
            }else if (model.completed_percent == 0){
                progressStr = @"开始学习";
                
            }
            progressLabel.text = progressStr ;
        }else {
           
            progressLabel.textAlignment = NSTextAlignmentRight;

            if([model.c_status isEqualToString:@"S"]) {
                progressLabel.text = @"已报名";
                
            }else {
                progressLabel.text = @"";
                
            }
        }
        
        if ([model.is_start integerValue] > 0 && [model.is_end integerValue] > 0)  {
            
            dateLabel.hidden = YES ;
            
        }else {
            dateLabel.hidden = NO ;
            
            NSString *msgText;
            if ([model.is_start integerValue] <= 0) {
                
                msgText = @"未开始";
                
            }else {
                msgText = @"已结束";
            }
            
            dateLabel.text = msgText ;
            
        }
        
        iconLab.hidden =(model.c_type)? NO: YES;
        // 前面icon宽度为30  9个空格
        NSString  *iconNull ;
        NSString *deviceName = [TrainStringUtil getCurrentDeviceModel];
        if([deviceName rangeOfString:@"iPad"].location != NSNotFound) {
            iconNull = @"              ";
        }else {
            iconNull = @"         ";
        }
        iconNull = (model.c_type)?iconNull:@"";
        
        courseName = [NSString stringWithFormat:@"%@%@",iconNull,model.name];
        if ([model.c_type isEqualToString:@"O"]) {
            iconLab.backgroundColor = TrainColorFromRGB16(0x3CA5F7);
            iconLab.text = @"在线";
            
        }else if ([model.c_type isEqualToString:@"C"]){
            
            iconLab.backgroundColor = TrainColorFromRGB16(0xF9A700);
            iconLab.text = @"面授";
        }else if ([model.c_type isEqualToString:@"L"]){
            
            iconLab.backgroundColor = TrainColorFromRGB16(0x3A773A);
            iconLab.text = @"直播";
        }
    }
    
    if (!TrainStringIsEmpty(_searchStr)) {
        _searchStr =(_searchStr)?_searchStr:@"";
        
        NSAttributedString  *attstr =[courseName dealwithstring:_searchStr andFont:TrainTitleFont];
        titleLab.attributedText =attstr;
    }else{
        
        titleLab.text = courseName;
    }
    
    NSString *peoNum;
    NSString *claNum;
    NSString *leaTime =(model.totTime && ![model.totTime isEqualToString:@"null"])?model.totTime:@"0分钟";
    NSString *peo =(_isClass)?@"人在学":@"人学过";
    
    if (_isClass) {
        peoNum =(model.pnum)?model.pnum:@"0";
        claNum =(model.cnum)?model.cnum:@"0";
    }else{
        peoNum =(model.study_num)?model.study_num:@"0";
        claNum =(model.hours)?model.hours:@"0";
    }
    peopleNumLab.text =[peoNum stringByAppendingString:peo];
    
    NSString *cla =(_isClass)?@"个课程":@"个章节";
    classNumLab.text =[claNum stringByAppendingString:cla];
    
    learnTimeLab.text =leaTime;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
