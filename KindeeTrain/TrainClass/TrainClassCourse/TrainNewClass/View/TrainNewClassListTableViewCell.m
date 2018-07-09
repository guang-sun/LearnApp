//
//  TrainNewClassListTableViewCell.m
//  KindeeTrain
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainNewClassListTableViewCell.h"

@interface  TrainNewClassListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *couseImageView;

@property (weak, nonatomic) IBOutlet UILabel *classtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTeacherLabel;

@property (weak, nonatomic) IBOutlet UILabel *classTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *classMatesButton;

@property (weak, nonatomic) IBOutlet UIButton *courseNumButton;
@property (weak, nonatomic) IBOutlet UIButton *classTopicButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@end

@implementation TrainNewClassListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone ;
    [self.classMatesButton addTarget:self action:@selector(rzClassMates)];
    [self.classTopicButton addTarget:self action:@selector(rzClassTopic)];
    [self.collectButton addTarget:self action:@selector(rzClassCollect)];
    // Initialization code
}

- (void)setModel:(TrainNewClassModel *)model {
    
    _model = model ;
    
    UIImage    *defaultImage = [UIImage imageNamed:@"train_class_default"];
    NSString  *preFixStr = @"/upload/class/pic/";
    
    NSString  *imageStr =(model.picture)?model.picture:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:preFixStr]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"%@%@",preFixStr,imageStr];
    }
    [_couseImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:defaultImage options:SDWebImageAllowInvalidSSLCertificates];
    
    
    self.classtitleLabel.text = notEmptyStr(model.name);
    
    NSString  *teacher = [NSString stringWithFormat:@"班主任: %@",notEmptyStr(model.object_name)];
    
    self.classTeacherLabel.text = teacher;

    NSString *time = [NSString stringWithFormat:@"时间: %@/%@",model.start_date ,model.end_date];
    
    self.classTimeLabel .text = time ;
    
    self.classMatesButton.cusTitle = model.studentNum ;
    self.courseNumButton.cusTitle = model.cnum ;
    self.classTopicButton.cusTitle = model.commentNum ;
    self.collectButton.cusTitle = model.favNum ;
    self.collectButton.selected = model.is_fav ;

}

- (void)rzClassMates {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rzClassListMates:)]) {
        [self.delegate rzClassListMates:self.model];
    }
    
}

- (void)rzClassTopic {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rzClassListTopicGroup:)]) {
        [self.delegate rzClassListTopicGroup:self.model];
    }
    
}
- (void)rzClassCollect {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rzClassListCollect:)]) {
        [self.delegate rzClassListCollect:self.model];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
