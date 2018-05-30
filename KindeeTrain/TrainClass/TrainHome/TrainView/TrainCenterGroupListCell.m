//
//  TrainCenterGroupListCell.m
//  SOHUEhr
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCenterGroupListCell.h"

@interface TrainCenterGroupListCell (){
    
    UIImageView   *leftImageView;
    UILabel       *titleLab, *peopleNumLab, *topicNumLab;
}

@end

@implementation TrainCenterGroupListCell


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
    leftImageView.image = [UIImage imageNamed:@"GROUP"];
    [self.contentView addSubview:leftImageView];
    
    titleLab = [[UILabel alloc]creatTitleLabel];
    
    [self.contentView addSubview:titleLab];
    
    peopleNumLab = [[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:peopleNumLab];
    
    topicNumLab= [[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:topicNumLab];
    
    UIImageView *peopleNumIcon = [[UIImageView alloc]init];
    peopleNumIcon.image = [UIImage imageNamed:@"train_number.png"];
    [self.contentView addSubview:peopleNumIcon];
    
    UIImageView *topicNumIcon = [[UIImageView alloc]init];
    topicNumIcon.image = [UIImage imageNamed:@"train_posting_number"];
    [self.contentView addSubview:topicNumIcon];
    
    UIImageView *rightIcon = [[UIImageView alloc]init];
    rightIcon.image = [UIImage imageNamed:@"train_right_arrow"];
    [self.contentView addSubview:rightIcon];
    
    
    UIView  *supView =self.contentView;
    
    leftImageView.sd_layout
    .leftSpaceToView(supView, TrainMarginWidth)
    .topSpaceToView(supView,10)
    .widthIs(50)
    .heightIs(50);
    
    titleLab.sd_layout
    .leftSpaceToView(leftImageView,10)
    .rightSpaceToView(supView,40)
    .topSpaceToView(supView,10)
    .heightIs(30);
    
    peopleNumIcon.sd_layout
    .leftSpaceToView(leftImageView,10)
    .topSpaceToView(titleLab,5)
    .widthIs(20)
    .heightIs(15);
    
    peopleNumLab.sd_layout
    .leftSpaceToView(peopleNumIcon,5)
    .topEqualToView(peopleNumIcon)
    .widthIs(100)
    .heightIs(15);
    
    
    topicNumIcon.sd_layout
    .leftSpaceToView(peopleNumLab,10)
    .topEqualToView(peopleNumLab)
    .widthIs(20)
    .heightIs(15);
    
    topicNumLab.sd_layout
    .leftSpaceToView(topicNumIcon,5)
    .topEqualToView(topicNumIcon)
    .widthIs(100)
    .heightIs(15);
    
    rightIcon.sd_layout
    .centerYEqualToView(supView)
    .rightSpaceToView(supView,10)
    .widthIs(15)
    .heightIs(15);
    
}

-(void)setModel:(TrainGroupModel *)model{
    
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",TrainIP, notEmptyStr(model.logo)];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"GROUP.png"] options:SDWebImageAllowInvalidSSLCertificates];

    
    titleLab.text = notEmptyStr(model.title);
    
    peopleNumLab.text =notEmptyStr(model.member_num);
    topicNumLab.text = notEmptyStr(model.topic_num);
}

@end
