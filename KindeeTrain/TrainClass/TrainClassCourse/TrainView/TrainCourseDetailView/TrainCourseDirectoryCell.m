//
//  TrainCourseDirectoryCell.m
//  SOHUEhr
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCourseDirectoryCell.h"
#import "TrainCircleView.h"

typedef NS_ENUM(NSInteger, TrainDownStyle){
   
    TrainDownStyleStartDown = 1, // 开始下载 (需要下载)
    TrainDownStyleDelete = 2     //   (删除)
    
};

@interface TrainCourseDirectoryCell ()
{
    UIView              *titleBgView;        //章节背景
    UIView              *classHourBgView;    //课时背景
    UILabel             *titleLab;
    UIImageView         *iconImageView;
    UILabel             *nameLab , *hourModeLab;
    UIView              *lineView;
    UIButton            *rightimageBtn;
    TrainCircleView     *downProgressView;
}

@end

@implementation TrainCourseDirectoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self creatUI];
        
    }
    return self;
}

-(void)creatUI{
    
    titleBgView =[[UIView alloc]init];
    titleBgView.backgroundColor =[UIColor colorWithRed:247/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    [self.contentView addSubview:titleBgView];
    
    
    classHourBgView =[[UIView alloc]init];
    classHourBgView.backgroundColor =[UIColor whiteColor];
    [self.contentView addSubview:classHourBgView];
    
    UIView  *selectView =[[UIView alloc]initWithLineView];
    selectView.frame = self.bounds;
    self.selectedBackgroundView = selectView ;

    
    lineView =[[UIView alloc]initWithLineView];
    [self.contentView addSubview:lineView];
    
    titleBgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 10, 0, 10));
    
    classHourBgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    titleLab =[[UILabel  alloc] initCustomLabel];
    titleLab.cusFont = 15;
    titleLab.textColor =[UIColor blackColor];
    [titleBgView addSubview:titleLab];
    
    titleLab.sd_layout
    .leftSpaceToView(titleBgView,10)
    .topSpaceToView(titleBgView,5)
    .rightSpaceToView(titleBgView,10)
    .heightIs(40);
    
    iconImageView =[[UIImageView  alloc]init];
    [classHourBgView addSubview:iconImageView];
    
    nameLab =[[UILabel  alloc] creatTitleLabel];
    nameLab.highlightedTextColor = TrainNavColor;
    [classHourBgView addSubview:nameLab];
    
    
    
    rightimageBtn =[[UIButton alloc]initCustomButton];
    rightimageBtn.userInteractionEnabled =YES;
    [rightimageBtn addTarget:self action:@selector(stateDownload:)];
    [classHourBgView addSubview:rightimageBtn];

    
    
    downProgressView =[[TrainCircleView alloc]initWithFrame:CGRectMake((TrainSCREENWIDTH-40), 10, 30   , 30) andcircleMode:TraincircleModeCircle];
    downProgressView.progressColor = TrainNavColor;
    downProgressView.circleBgLineColor = TrainColorFromRGB16(0xD9D9D9);
    downProgressView.tag = 1 ;
    //    circleView.percent =44;
    downProgressView.hidden = YES;
    downProgressView.bgImage = [UIImage imageThemeColorWithName:@"Train_Movie_DownloadStop"];
    downProgressView.userInteractionEnabled =YES;
    //    circleView.circleBgLineColor =[UIColor groupTableViewBackgroundColor];
    [classHourBgView addSubview:downProgressView];

    
    
    hourModeLab =[[UILabel  alloc]initCustomLabel];
    hourModeLab.textAlignment =NSTextAlignmentRight;
    [classHourBgView addSubview:hourModeLab];
    
    iconImageView.sd_layout
    .leftSpaceToView(classHourBgView,20)
    .centerYEqualToView(classHourBgView)
    .widthIs(15)
    .heightEqualToWidth();

//
    nameLab.sd_layout
    .leftSpaceToView(iconImageView,5)
    .centerYEqualToView(classHourBgView)
    .rightSpaceToView(classHourBgView,10)
    .heightIs(40);
    
   
  
    
    lineView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,1)
    .heightIs(0.5);
    
    
}


-(void)stateDownload:(UIButton *)btn{
    
    BOOL  isFinish = NO;
    if(btn.tag == TrainDownStyleStartDown){
        isFinish = NO;
    }else if(btn.tag == TrainDownStyleDelete){
        isFinish = YES;
    }
    
    if (_trainDownloadStatus) {
        _trainDownloadStatus(isFinish);
    }
}


-(void)updateCourseZhangJieLayout{
    
    self.selectionStyle =UITableViewCellSelectionStyleNone;
    titleBgView.hidden = NO;
    classHourBgView.hidden = YES;
    NSString  *string ;
    if([_model.h_type isEqualToString:@"C"]){
        string =@"";
    }else if([_model.h_type isEqualToString:@"U"]){
        string =@"";
    }else if([_model.h_type isEqualToString:@"D"]){
        string =@"";
    }
    
    titleLab.text =[NSString stringWithFormat:@"%@%@",string,_model.title];
}

-(void)updateCourseHourLayout{
    
    if([_model.c_type isEqualToString:@"V"] ){
        
        NSString *cho_id = [NSString stringWithFormat:@"%@%@%@",_model.c_id,_model.list_id,_model.object_id];
        
        TrainDownloadModel  *newDownModel = nil;
        
        if ([self.downModel.CHO_id  isEqualToString:cho_id]) {
          
            newDownModel = self.downModel;
        
        }else{
        
            NSArray  *arr = [TrainDownloadModel findWithFormat:@"CHO_id = %@",cho_id];
            if ( !TrainArrayIsEmpty(arr)) {
                newDownModel = [arr firstObject];
            }
        }
        if (newDownModel ) {
            
            if (newDownModel.status == TrainFileDownloadStateFinish || newDownModel.status == TrainFileDownloadStateFail) {
                rightimageBtn.hidden    = NO;
                hourModeLab.hidden      = NO;
                
                rightimageBtn.tag = TrainDownStyleDelete;
                rightimageBtn.image =[UIImage imageNamed:@"Train_MyNote_Detele"];

                NSString *totsize = @"";
                if (newDownModel.status == TrainFileDownloadStateFail) {
                    totsize = @"下载失败";
                    hourModeLab.textColor = [UIColor redColor];
                }else{
                    hourModeLab.textColor = [UIColor grayColor];

                    unsigned long  long  tot = newDownModel.totalSize ;
                    totsize = [NSString stringWithFormat:@"%.1f %@",
                                calculateFileSizeInUnit(tot),
                                calculateUnit(tot)];
                }
                
                hourModeLab.text = totsize;
                
                
                rightimageBtn.sd_layout
                .rightSpaceToView(classHourBgView,10)
                .centerYEqualToView(classHourBgView)
                .widthIs(30)
                .heightIs(30);
                
                
                hourModeLab.sd_layout
                .rightSpaceToView(rightimageBtn,5)
                .centerYEqualToView(classHourBgView)
                .heightIs(20)
                .widthIs(50);
                nameLab.sd_layout.rightSpaceToView(classHourBgView, 100);
                
            }else {
                
                downProgressView.hidden = NO;
                downProgressView.percent = newDownModel.progress * 100;
                
            }
            
        }else{
            rightimageBtn.hidden =NO;
            rightimageBtn.tag =1;
            rightimageBtn.image =[UIImage imageThemeColorWithName:@"Train_Course_Detaile_Down"];
            
            rightimageBtn.sd_layout
            .rightSpaceToView(classHourBgView,10)
            .centerYEqualToView(classHourBgView)
            .widthIs(30)
            .heightIs(30);
            
            nameLab.sd_layout.rightSpaceToView(classHourBgView, 50);


        }
        
    
    
    }
}


-(void)updateCourseDAndEHourLayout{
    
    
    hourModeLab.sd_layout
    .rightSpaceToView(classHourBgView,10)
    .centerYEqualToView(classHourBgView)
    .heightIs(20)
    .widthIs(0);
    if([_model.c_type isEqualToString:@"D"]){
        hourModeLab.hidden = NO ;
        hourModeLab.sd_layout.widthIs(50);
        nameLab.sd_layout.rightSpaceToView(classHourBgView, 70);
        if ([_model.ua_status isEqualToString:@"C"]) {
            hourModeLab.text = @"已学习" ;
            hourModeLab.textColor = TrainNavColor;
            
        }else {
            hourModeLab.text = @"未学习" ;
            hourModeLab.textColor = [UIColor grayColor];
            
        }
        
    }else if([_model.c_type isEqualToString:@"E"]){
        hourModeLab.hidden = NO ;

        hourModeLab.sd_layout.widthIs(50);
        nameLab.sd_layout.rightSpaceToView(classHourBgView, 70);

        if ([_model.ua_status isEqualToString:@"P"] ||[_model.ua_status isEqualToString:@"C"]) {
            hourModeLab.text = @"通过" ;
            hourModeLab.textColor = TrainNavColor;
            
        }else if([_model.ua_status isEqualToString:@"I"]){
            hourModeLab.text = @"进行中" ;
            hourModeLab.textColor = TrainOrangeColor;
            
        }else if([_model.ua_status isEqualToString:@"M"]){
            hourModeLab.text = @"待阅卷" ;
            hourModeLab.textColor = TrainOrangeColor;
            
        }else if([_model.ua_status isEqualToString:@"F"]){
            hourModeLab.text = @"未通过" ;
            hourModeLab.textColor = TrainOrangeColor;
            
        }else if([_model.ua_status isEqualToString:@"N"] || [_model.ua_status isEqualToString:@""] ){
            hourModeLab.text = @"未参加" ;
            hourModeLab.textColor = [UIColor grayColor];
            
        }
    }else{
        hourModeLab.hidden = YES ;

        hourModeLab.sd_layout.widthIs(0);

    }
    [hourModeLab updateLayout];


}

-(void)setModel:(TrainCourseDirectoryModel *)model{

    _model = model;
    if (![model.h_type isEqualToString:@"H"] && ![model.h_type isEqualToString:@"E"]) {
        
        [self updateCourseZhangJieLayout];
        
    }else {
       
        // 课时的整体 初始化
        self.selectionStyle =UITableViewCellSelectionStyleBlue;
        titleBgView.hidden = YES;
        classHourBgView.hidden = NO;
        
        rightimageBtn.hidden    = YES;
        downProgressView.hidden = YES;
        hourModeLab.hidden      = YES;
        nameLab.text            = model.title;
        nameLab.textColor       = TrainTitleColor;
        iconImageView.image     = [self getCourseHourStyleIconImage];

        if (_isRegister) {
            
            [self updateCourseHourLayout];
        }
        // 设置 D & E 是右侧提示语
        [self updateCourseDAndEHourLayout];
    }


}

-(UIImage *)getCourseHourStyleIconImage{
    
    UIImage *image;
    if ([_model.c_type isEqualToString:@"V"] || [_model.c_type isEqualToString:@"L"]) {
        if ([_model.ua_status isEqualToString:@"C"]) {
            image =[UIImage imageThemeColorWithName:@"Train_Movie_Finish"];
        }else if([_model.ua_status isEqualToString:@""]){
            image =[UIImage imageThemeColorWithName:@"Train_Movie_UnLearn"];
        }else if([_model.ua_status isEqualToString:@"I"]){
            image =[UIImage imageThemeColorWithName:@"Train_Movie_LearnHalf"];
        }
        
    }else{
        
        if([_model.c_type isEqualToString:@"D"]){
            image = [UIImage imageThemeColorWithName:@"Train_Movie_Doc"];
            
        }else if([_model.c_type isEqualToString:@"E"]){
            image = [UIImage imageThemeColorWithName:@"Train_Movie_Exam"];
            
        }else if([_model.c_type isEqualToString:@"P"]) {
            
            if ([_model.is_free isEqualToString:@"H"]) {
                
                image = [UIImage imageNamed:@"Train_Movie_h5_scrom"];
            }else{
                image = [UIImage imageNamed:@"Train_Movie_UnSupport"];
                nameLab.textColor =TrainColorFromRGB16(0xCBCBCB);
            }

        }else if([_model.c_type isEqualToString:@"O"]){
            
            image = [UIImage imageNamed:@"Train_Movie_Html"];

        }else {
            image = [UIImage imageNamed:@"Train_Movie_UnSupport"];
            nameLab.textColor =TrainColorFromRGB16(0xCBCBCB);
        }
    }
    return image;
    
}
@end
