//
//  TrainClassExamCell.m
//  KindeeTrain
//
//  Created by admin on 2018/6/18.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainClassExamCell.h"

@interface TrainClassExamCell ()
@property (weak, nonatomic) IBOutlet UIImageView *examImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinNumButton;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;


@end

@implementation TrainClassExamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIImage *image = [UIImage imageNamed:@"1-2"];
    image = [image imageByScalingAndCroppingForSize:CGSizeMake(15, 15)];
    
    UIImage *finishimage = [UIImage imageNamed:@"all"];
    finishimage = [finishimage imageByScalingAndCroppingForSize:CGSizeMake(15, 15)];
    
    [self.statusButton setImage:image forState:UIControlStateNormal];
    [self.statusButton setImage:finishimage forState:UIControlStateSelected];
    [self.statusButton setTitle:@"未完成" forState:UIControlStateNormal];
    [self.statusButton setTitle:@"已完成" forState:UIControlStateSelected];

    self.selectionStyle = UITableViewCellSelectionStyleNone ;
}

- (void)rzUpdateClassResCellWithModel :(TrainClassResModel *)model  {

    [self.examImageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"train_course_default"] options:SDWebImageAllowInvalidSSLCertificates];

    self.titleLabel.text = model.obj_name ;
    
    NSString  *endDate ;
    if (TrainStringIsEmpty(model.end_date)) {
        endDate = @"不限" ;
    }else {
        endDate = model.end_date ;
    }
    self.startLabel.text = [NSString stringWithFormat:@"截止时间: %@",endDate];
    self.joinNumButton.cusTitle = [NSString stringWithFormat:@"参加次数: %@/%@", model.answer_num,model.allow_num];

    self.statusButton.selected = model.isStudy;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
