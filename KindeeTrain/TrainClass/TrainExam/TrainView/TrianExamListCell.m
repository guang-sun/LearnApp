//
//  TrianExamListCell.m
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrianExamListCell.h"

#import "TrainNetWorkAPIClient.h"

@interface TrianExamListCell ()
{
    UIImageView             *iconImageView , *logoView;
    UILabel                 *titleLab, *originLab, *joinNumLab;

    UIButton                *joinBtn;
    UIButton                *readBtn;
    UILabel                 *starttimeLab, *endtimeLab ,*testNumLab, *testTimeLab;
    UILabel                 *testFenLab, *testpassLab, *testGradeLab, *testStatusLab;
    UILabel                 *contentLab;

    UIView                  *finishView;
}
@property(nonatomic ,assign)    BOOL   isFinish;
@property(nonatomic ,assign)    BOOL   isExam;

@end

@implementation TrianExamListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    return self;
    
}

-(void)creatUI{
    
    self.isCanLearn = YES ;
    iconImageView =[[UIImageView alloc]init];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconImageView];
    
    logoView =[[UIImageView alloc]init];
    
    
    [iconImageView addSubview:logoView];
    
    titleLab   = [[UILabel alloc]creatTitleLabel];
    [self.contentView addSubview:titleLab];
    
    originLab  = [[UILabel alloc]initCustomLabel];
    originLab.textColor = TrainOrangeColor;
    originLab.cusFont =12.0f;
    [self.contentView addSubview:originLab];
    
    joinNumLab = [[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:joinNumLab];
    
    
    joinBtn = [[UIButton alloc]initCustomButton];
    joinBtn.layer.cornerRadius =5.0f;
    joinBtn.cusFont =12;
    joinBtn.cusTitleColor =[UIColor whiteColor];
    [joinBtn addTarget:self action:@selector(join)];
    joinBtn.backgroundColor = TrainOrangeColor;
    
    [self.contentView addSubview:joinBtn];
    
    readBtn = [[UIButton alloc]initCustomButton];
    readBtn.layer.cornerRadius =5.0f;
    readBtn.cusFont =12;
    readBtn.cusTitleColor =[UIColor whiteColor];
    [readBtn addTarget:self action:@selector(read)];
    readBtn.backgroundColor = TrainNavColor;
    
    [self.contentView addSubview:readBtn];
    
    
    UIView  *line1 =[[UIView alloc]initWithLine1View];
//    line1.backgroundColor =TrainColorFromRGB16(0xD9D9D9);
    [self.contentView addSubview:line1];
    
    UILabel  *canyutimeLab =[[UILabel alloc]creatTitleLabel];
    canyutimeLab.cusFont =12.0f;
    canyutimeLab.text = @"参与时间 :";
    [self.contentView addSubview:canyutimeLab];
    
    
    starttimeLab =[[UILabel alloc]initCustomLabel];
    starttimeLab.textColor = TrainThemeTitleColor;
    starttimeLab.cusFont =12.0f;
    [self.contentView addSubview:starttimeLab];
    
    
    UILabel  *zhitimeLab =[[UILabel alloc]creatTitleLabel];
    zhitimeLab.cusFont =12.0f;
    zhitimeLab.text = @"           至 :";
    [self.contentView addSubview:zhitimeLab];
    
    
    endtimeLab =[[UILabel alloc]initCustomLabel];
    endtimeLab.textColor =TrainThemeTitleColor;
    endtimeLab.cusFont =12.0f;
    [self.contentView addSubview:endtimeLab];
    
    UIView  *view =[[UIView alloc]init];
    [self.contentView addSubview:view];
    
    testNumLab =[[UILabel alloc]initCustomLabel];
    testNumLab.cusFont =12.0f;
    
    [view addSubview:testNumLab];
    
    testTimeLab =[[UILabel alloc]initCustomLabel];
    testTimeLab.cusFont =12.0f;
    
    [view addSubview:testTimeLab];
    
    testFenLab =[[UILabel alloc]initCustomLabel];
    testFenLab.cusFont =12.0f;
    
    [view addSubview:testFenLab];
    
    testpassLab =[[UILabel alloc]initCustomLabel];
    testpassLab.cusFont =12.0f;
    
    [view addSubview:testpassLab];
    
    UIView  *line2 =[[UIView alloc]initWithLine1View];
//    line2.backgroundColor =TrainColorFromRGB16(0xD9D9D9);
    [self.contentView addSubview:line2];
    
    contentLab =[[UILabel alloc]creatTitleLabel];
//    contentLab.textColor = TrainColorFromRGB16(0x565656);
    contentLab.cusFont =13.0f;
    [self.contentView addSubview:contentLab];
    
    finishView =[[UIView alloc]init];
    [self.contentView addSubview:finishView];
    
    
    UIView  *line3 =[[UIView alloc]initWithLine1View];
//    line3.backgroundColor =TrainColorFromRGB16(0xD9D9D9);
    [finishView addSubview:line3];
    
    
    testGradeLab =[[UILabel alloc]creatTitleLabel];
//    testGradeLab.textColor =TrainColorFromRGB16(0x565656);
    [testGradeLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    testGradeLab.textAlignment =NSTextAlignmentCenter;
    [finishView addSubview:testGradeLab];
    
    testStatusLab =[[UILabel alloc]initCustomLabel];
    testStatusLab.textColor = TrainNavColor;
    [testStatusLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    testStatusLab.textAlignment =NSTextAlignmentCenter;
    [finishView addSubview:testStatusLab];
    
    UIView  *line4 =[[UIView alloc]initWithLine1View];
//    line4.backgroundColor =TrainColorFromRGB16(0xD9D9D9);
    [finishView addSubview:line4];
    
    
    UIView  *line5 =[[UIView alloc]init];
    line5.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line5];
    

    UIView   *supView =self.contentView;
    
    iconImageView.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .widthIs(60)
    .heightEqualToWidth();
    
    logoView.sd_layout
    .leftEqualToView(iconImageView)
    .topEqualToView(iconImageView)
    .widthIs(40)
    .heightEqualToWidth();
    
    titleLab.sd_layout
    .leftSpaceToView(iconImageView,10)
    .topEqualToView(iconImageView)
    .rightSpaceToView(supView,90)
    .heightIs(20);
    
    originLab.sd_layout
    .leftEqualToView(titleLab)
    .rightEqualToView(titleLab)
    .topSpaceToView(titleLab,5)
    .heightIs(15);
    
    joinNumLab.sd_layout
    .leftEqualToView(originLab)
    .rightEqualToView(originLab)
    .topSpaceToView(originLab,5)
    .heightIs(15);
    
    
    
    line1.sd_layout
    .leftEqualToView(iconImageView)
    .rightEqualToView(supView)
    .topSpaceToView(iconImageView,10)
    .heightIs(0.7);
    
    canyutimeLab.sd_layout
    .leftEqualToView(iconImageView)
    .topSpaceToView(line1,5)
    .widthIs(60)
    .heightIs(20);
    
    starttimeLab.sd_layout
    .leftSpaceToView(canyutimeLab,5)
    .topSpaceToView(line1,5)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(20);
    
    zhitimeLab.sd_layout
    .leftEqualToView(iconImageView)
    .topSpaceToView(canyutimeLab,5)
    .widthIs(60)
    .heightIs(20);
    
    endtimeLab.sd_layout
    .leftSpaceToView(zhitimeLab,5)
    .topSpaceToView(starttimeLab,5)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(20);
    
    
    view.sd_layout
    .leftEqualToView(zhitimeLab)
    .rightEqualToView(endtimeLab)
    .topSpaceToView(zhitimeLab,5)
    .heightIs(20);
    
    view.sd_equalWidthSubviews = @[testNumLab,testTimeLab,testFenLab,testpassLab];
    
    testNumLab.sd_layout
    .leftEqualToView(view)
    .topEqualToView(view)
    .heightIs(20);
    
    testTimeLab.sd_layout
    .leftSpaceToView(testNumLab,5)
    .topEqualToView(testNumLab)
    .heightRatioToView(testNumLab,1);
    
    testFenLab.sd_layout
    .leftSpaceToView(testTimeLab,5)
    .topEqualToView(testTimeLab)
    .heightRatioToView(testTimeLab,1);
    
    testpassLab.sd_layout
    .leftSpaceToView(testFenLab,5)
    .rightEqualToView(view)
    .topEqualToView(testFenLab)
    .heightRatioToView(testFenLab,1);
    
    line2.sd_layout
    .leftEqualToView(iconImageView)
    .rightEqualToView(supView)
    .topSpaceToView(view,10)
    .heightIs(0.5);
    
    
    contentLab.sd_layout
    .leftEqualToView(line2)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(line2,10)
    .autoHeightRatio(0)
    .maxHeightIs(contentLab.font.lineHeight*2);
    
    finishView.hidden =YES;
    finishView.sd_layout
    .leftEqualToView(supView)
    .rightEqualToView(supView)
    .topSpaceToView(contentLab,10)
    .heightIs(0);
    
    line3.sd_layout
    .leftEqualToView(finishView)
    .rightEqualToView(finishView)
    .topEqualToView(finishView)
    .heightIs(0.7);
    
    testGradeLab.sd_layout
    .leftSpaceToView(finishView,TrainMarginWidth)
    .topSpaceToView(line3,0)
    .widthIs((TrainSCREENWIDTH-30)/2-1)
    .heightIs(40);
    
    testStatusLab.sd_layout
    .leftSpaceToView(testGradeLab,1)
    .rightSpaceToView(finishView,TrainMarginWidth)
    .topEqualToView(testGradeLab)
    .heightIs(40);
    
    line4.sd_layout
    .leftSpaceToView(testGradeLab,0)
    .topEqualToView(testGradeLab)
    .widthIs(0.7)
    .heightRatioToView(testGradeLab,1);
    
    line5.sd_layout
    .leftEqualToView(supView)
    .rightEqualToView(supView)
    .topSpaceToView(finishView,0)
    .heightIs(10);
    
    
    [self setupAutoHeightWithBottomView:line5 bottomMargin:0];
    
    
}

-(void)setIsHasLogo:(BOOL)isHasLogo{
    _isHasLogo = isHasLogo;
    logoView.hidden = !isHasLogo;
}

- (void)setIsCanLearn:(BOOL)isCanLearn {
    _isCanLearn = isCanLearn ;
    
}

-(void)setModel:(TrainExamModel *)model{
    
    _model = model;
    UIImage  *image ;
    if ([model.object_type isEqualToString:@"CTRAIN"]) {
        image =[UIImage imageNamed:@"Train_MyExam_Course"];
    }else if ([model.object_type isEqualToString:@"Independent"]) {
        image =[UIImage imageNamed:@"Train_MyExam_Only"];
    }else if ([model.object_type isEqualToString:@"CLASS"] ||[model.object_type isEqualToString:@"CROOM"]  ) {
        image =[UIImage imageNamed:@"Train_MyExam_Class"];
    }
    logoView.image =image;
    NSString  *str =(model.photo)?model.photo:@"";
    NSString  *imageUrl =[TrainIP stringByAppendingString:str];
    
    UIImage  *placeHolerImage ;
    
    if (self.examStyle == TrainExamStyleExam) {
 
        placeHolerImage = [UIImage imageNamed:@"Train_Main_exam"];
        self.isExam = YES;
    }else if (self.examStyle == TrainExamStyleSurvey || self.examStyle == TrainExamStyleEvaluate){
    
        placeHolerImage = [UIImage imageNamed:@"Train_Main_question"];
        self.isExam = NO;

    }else if(self.examStyle == TrainExamStyleHomeWork){
        
        placeHolerImage = [UIImage imageNamed:@"Train_Main_myWork"];
        self.isExam = YES;

    }    
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeHolerImage options:SDWebImageAllowInvalidSSLCertificates];
    
    titleLab.text =[self deal:model.name];
    originLab.text =[@"来源 :" stringByAppendingString:[self deal:model.object_name]];
    BOOL  isJoin;
    NSString *joinStr ;
    if ( !model.answer_number_count || [model.answer_number_count isEqualToString:@"0"]|| [model.answer_number_count isEqualToString:@""]) {
        isJoin =YES;
        joinStr =@"参加次数: 不限";
    }else{
        int    zong =model.answer_number_count.intValue;
        int    num =model.answer_number.intValue;
        isJoin =(zong > num)?YES:NO;
        joinStr =[NSString stringWithFormat:@"允许参加:%@次",model.answer_number_count];
    }
    if (model.answer_number.intValue == 0) {
        joinStr =[NSString stringWithFormat:@"%@ 未参加",joinStr];
    }else{
        joinStr =[NSString stringWithFormat:@"%@ 已参加%@次",joinStr,model.answer_number];
    }
    joinNumLab.text = joinStr;

    starttimeLab.text = ([model.start_date  isEqualToString:@""])?@"不限制" : model.start_date;
    endtimeLab.text = ([model.end_date  isEqualToString:@""])?@"不限制" : model.end_date;
    //    timeLab .text = [@"参与时间: " stringByAppendingString:dataStr];
    NSString  *testNum = [NSString stringWithFormat:@"试题数:%@",model.que_count];
    testNumLab.attributedText =[testNum  dealwithstring:model.que_count andFont:13.0f andColor:TrainOrangeColor];
    
    NSString  *timestr;
    if (!model.answer_time || model.answer_time.intValue == 0) {
        timestr =@"不限制";
    }else{
        timestr =[NSString stringWithFormat:@"%@",model.answer_time];
    }
    NSString  *testtime = [NSString stringWithFormat:@"时长:%@",timestr];
    testTimeLab.attributedText =[testtime  dealwithstring:timestr andFont:13.0f andColor:TrainOrangeColor];
    
    NSString  *testFen =[NSString stringWithFormat:@"总分:%@",model.score];
    testFenLab.attributedText = [testFen dealwithstring: model.score andFont:13.0f andColor:TrainOrangeColor];
    NSString  *testPass =[NSString stringWithFormat:@"及格线:%@",model.pass_line];
    testpassLab.attributedText =[testPass dealwithstring:model.pass_line andFont:13.0f andColor:TrainOrangeColor];
    
//    @"暂无说明"
    contentLab.text = TrainStringIsEmpty(model.content) ? TrainNULLdescribeText :model.content ;
    NSString  *testGrade;
    NSString *status ;
    testGradeLab.textColor  = TrainTitleColor ;
    testStatusLab.textColor = TrainThemeTitleColor;
    if (![model.is_view_score isEqualToString:@"N"]) {
        testGrade =[NSString stringWithFormat:@"得分：%@",model.pfm_score];
        
        if ([model.complete_status isEqualToString:@"P"]) {
            status  = @"状态： 通过";
        }else if ([model.complete_status isEqualToString:@"F"]) {
            status  = @"状态： 失败";
            testGradeLab.textColor =[UIColor redColor];
            testStatusLab.textColor =[UIColor redColor];
        }else if ([model.complete_status isEqualToString:@"M"]) {
            status  = @"状态： 待阅卷";
        }else if ([model.complete_status isEqualToString:@"I"]) {
            status  = @"状态： 考试进行中";
        }else if ([model.complete_status isEqualToString:@"N"]) {
            status  = @"状态： 考试未开始";
        }
    }else{
        testGrade = @"得分: 未公开";
        status =@"状态：未公开";
    }
    testGradeLab.text =testGrade;
    testStatusLab.text = status;
    
    if (![model.is_Expired isEqualToString:@"Y"] || !isJoin) {
        joinBtn.cusTitle = @"已过期";
        joinBtn.userInteractionEnabled =NO;
        joinBtn.backgroundColor =TrainColorFromRGB16(0xBDBDBD);
        
    }else{
        joinBtn.cusTitle = @"继续参加";
        joinBtn.userInteractionEnabled =YES;
        joinBtn.backgroundColor = TrainOrangeColor;
    }
   
    if ( !model.complete_status  || [model.complete_status isEqualToString:@"N"] ||[model.complete_status isEqualToString:@"I"]) {
        self.isFinish =NO;
    }else{
        self.isFinish =YES;
    }
    
    if (!_isFinish) {
        
        joinBtn.sd_layout.heightIs(0);

        readBtn.sd_layout
        .rightSpaceToView(self.contentView,TrainMarginWidth)
        .leftSpaceToView(titleLab,10)
        .topSpaceToView(self.contentView,27.5)
        .heightIs(25);
       
        finishView.hidden =YES;
        finishView.sd_layout.heightIs(0);
        
        if (model.end_date && ![model.end_date isEqualToString:@""]) {
            NSDateFormatter  *dateFormatter =[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate   *date1 =[dateFormatter dateFromString:model.end_date];
            NSTimeInterval  time =[ date1 timeIntervalSinceNow];
            if (time > 0) {
                readBtn.cusTitle =@"立即参加";
                readBtn.backgroundColor =TrainNavColor;
                readBtn.userInteractionEnabled =YES;
            }else{
                readBtn.cusTitle =@"已过期";
                readBtn.backgroundColor =TrainColorFromRGB16(0xBDBDBD);;
                readBtn.userInteractionEnabled =NO;
            }
        }else{
            readBtn.cusTitle =@"立即参加";
            readBtn.backgroundColor =TrainNavColor;
            readBtn.userInteractionEnabled =YES;
            
        }
        
    }else{

        joinBtn.sd_layout
        .rightSpaceToView(self.contentView,TrainMarginWidth)
        .leftSpaceToView(titleLab,10)
        .topSpaceToView(self.contentView,10)
        .heightIs(25);
        
        readBtn.sd_layout
        .rightSpaceToView(self.contentView,TrainMarginWidth)
        .leftSpaceToView(titleLab,10)
        .topSpaceToView(self.contentView,45)
        .heightIs(25);
        
        if (_isExam) {
            finishView.hidden =NO;
            finishView.sd_layout.heightIs(40);
        }else{
            finishView.hidden =YES;
            finishView.sd_layout.heightIs(0);
        }
        readBtn.cusTitle =@"回顾";
        
        if (! [model.is_review isEqualToString:@"Y"]) {
            readBtn.backgroundColor =TrainColorFromRGB16(0xBDBDBD);
            readBtn.userInteractionEnabled =NO;
        }else{
            readBtn.backgroundColor = TrainNavColor;
            readBtn.userInteractionEnabled =YES;
            
        }
    }
    [joinBtn updateLayout];
    [readBtn updateLayout];
    
}
-(NSString *)deal:(NSString *)str{
    if (!str || [str isEqualToString:@"NULL"]) {
        return @"";
    }
    return str;
}
-(void)join{
    NSString  *webUrl ;
    if (_isCanLearn) {
        webUrl = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"onlineExam" object_id:self.model.exam_id andtarget_id:self.model.type_id];
    }else {
        webUrl = @"" ;
    }
    
    if (_returnWebUrlBlock) {
        _returnWebUrlBlock(webUrl);
    }
    
}
-(void)read{
    
    if (_isCanLearn) {
        if (self.isFinish) {
            
            [[TrainNetWorkAPIClient client] trainReviewExamWithAtmp_id:self.model.p_id Success:^(NSDictionary *dic) {
                
                NSString  *webUrl = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"reviewExam" object_id:dic[@"object_id"] andtarget_id:self.model.type_id];
                if (_returnWebUrlBlock) {
                    _returnWebUrlBlock(webUrl);
                }
            } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            }];
            
        }else{
            [self join];
            
        }
    }else {
        if (_returnWebUrlBlock) {
            _returnWebUrlBlock(@"");
        }
    }
    
   

}


@end
