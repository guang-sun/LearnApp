//
//  TrainClassResCourseCell.m
//  KindeeTrain
//
//  Created by admin on 2018/6/18.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainClassResCourseCell.h"

@interface  TrainClassResCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *compulsoryButton;

@property (weak, nonatomic) IBOutlet UIButton *hourButton;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

@implementation TrainClassResCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone ;

    UIImage *image = [UIImage imageNamed:@"1-2"];
    image = [image imageByScalingAndCroppingForSize:CGSizeMake(15, 15)];

    UIImage *finishimage = [UIImage imageNamed:@"all"];
    finishimage = [finishimage imageByScalingAndCroppingForSize:CGSizeMake(15, 15)];

    [self.statusButton setImage:image forState:UIControlStateNormal];
    [self.statusButton setImage:finishimage forState:UIControlStateSelected];
//    [self.statusButton setTitle:@"未完成" forState:UIControlStateNormal];
//    [self.statusButton setTitle:@"已完成" forState:UIControlStateSelected];

    
    // Initialization code
}

- (void)rzUpdateClassResCellWithModel :(TrainClassResModel *)model  {
    
    self.titleLabel.text = model.obj_name ;
    NSString  *imageStr =(model.picture)?model.picture:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:@"/upload/user/pic"]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"/upload/user/pic/%@",imageStr];
    }
    
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"train_course_default"] options:SDWebImageAllowInvalidSSLCertificates];
    
    NSString  *comText = (model.is_compulsory)? @"必修" :@"选修" ;
    self.compulsoryButton.cusTitle = comText ;
    NSString  *houre ;
    if ([model.hour_num integerValue] > 0) {
        houre = [NSString stringWithFormat:@"%zi课时", [model.hour_num integerValue]];
    }else {
        houre = [NSString stringWithFormat:@"暂无课时"];
    }
    self.hourButton.cusTitle = houre ;
    self.statusButton.selected = model.isStudy ;
    self.statusButton.cusTitle = model.isStudyMsg ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
