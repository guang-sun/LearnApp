//
//  TrainCenterCourseListCell.m
//  SOHUEhr
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCenterCourseListCell.h"

@interface TrainCenterCourseListCell (){
    
    UIImageView   *leftImageView;
    UILabel       *titleLab, *teacherLab, *numLab;
}

@end

@implementation TrainCenterCourseListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self creatView];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
    
}
-(void)creatView{
    
    leftImageView =[[UIImageView alloc]init];
    leftImageView.image = [UIImage imageNamed:@"train_course_default"];
    [self.contentView addSubview:leftImageView];
    
    titleLab = [[UILabel alloc]creatTitleLabel];
    
    [self.contentView addSubview:titleLab];
    
    teacherLab = [[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:teacherLab];
   
    numLab= [[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:numLab];

    UIImageView *teacherIcon = [[UIImageView alloc]init];
    teacherIcon.image = [UIImage imageNamed:@"Teacher"];
    [self.contentView addSubview:teacherIcon];
    UIImageView *numIcon = [[UIImageView alloc]init];
    numIcon.image = [UIImage imageNamed:@"train_number"];
    [self.contentView addSubview:numIcon];

  
    UIView  *supView =self.contentView;
    
    leftImageView.sd_layout
    .leftSpaceToView(supView, TrainMarginWidth)
    .topSpaceToView(supView,10)
    .widthIs(80)
    .heightIs(50);
    
    titleLab.sd_layout
    .leftSpaceToView(leftImageView,10)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .heightIs(30);
    
    teacherIcon.sd_layout
    .leftSpaceToView(leftImageView,10)
    .topSpaceToView(titleLab,5)
    .widthIs(20)
    .heightIs(15);
    
    teacherLab.sd_layout
    .leftSpaceToView(teacherIcon,5)
    .topEqualToView(teacherIcon)
    .widthIs(100)
    .heightIs(15);
    
    
    numIcon.sd_layout
    .leftSpaceToView(teacherLab,10)
    .topEqualToView(teacherLab)
    .widthIs(20)
    .heightIs(15);
    
    numLab.sd_layout
    .leftSpaceToView(numIcon,5)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topEqualToView(numIcon)
    .heightIs(15);
    
    
}

-(void)setModel:(TrainCourseAndClassModel *)model{
   
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",TrainIP, notEmptyStr(model.picture)];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"train_course_default"]options:SDWebImageAllowInvalidSSLCertificates];

 
    titleLab.text = notEmptyStr(model.name);
    
    teacherLab.text = [NSString stringWithFormat:@"讲师：%@",notEmptyStr(model.lecturer_name)];
    numLab.text = [NSString stringWithFormat:@"学习人数：%@",notEmptyStr(model.study_num)];
}

@end
