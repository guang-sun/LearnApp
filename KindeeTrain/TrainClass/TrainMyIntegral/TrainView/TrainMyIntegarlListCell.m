//
//  TrainMyIntegarlListCell.m
//   KingnoTrain
//
//  Created by apple on 16/12/6.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainMyIntegarlListCell.h"


@interface TrainMyIntegarlListCell ()
{
    UILabel         *titleLab;
    UILabel         *dateLab;
    UILabel         *numLab;
}
@end

@implementation TrainMyIntegarlListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
    
}

-(void)creatUI{
    titleLab =[[UILabel alloc]creatTitleLabel];
    
    dateLab =[[UILabel alloc]creatContentLabel];
    
    numLab =[[UILabel alloc]initCustomLabel];
    numLab.textColor =TrainColorFromRGB16(0xFF0000);
    numLab.cusFont =15;
    numLab.textAlignment =NSTextAlignmentCenter;
    
    UIView  *line =[[UIView alloc]initWithLine1View];
    
    [self.contentView sd_addSubviews:@[titleLab,dateLab,numLab,line]];
    
    UIView   *supView =self.contentView;
    
    titleLab.sd_layout
    .leftSpaceToView(supView,15)
    .rightSpaceToView(supView,65)
    .topSpaceToView(supView,10)
    .autoHeightRatio(0);
    
    dateLab.sd_layout
    .leftEqualToView(titleLab)
    .rightEqualToView(titleLab)
    .topSpaceToView(titleLab,10)
    .heightIs(15);
    
    numLab.sd_layout
    .rightSpaceToView(supView,15)
    .widthIs(40)
    .centerYEqualToView(supView)
    .heightIs(20);
    
    
    line.sd_layout
    .leftEqualToView(supView)
    .rightEqualToView(supView)
    .topSpaceToView(dateLab,9)
    .heightIs(0.7);
    
    [self setupAutoHeightWithBottomView:dateLab bottomMargin:10];
    
    
}
-(void)setModel:(TrainIntegralMoel *)model{
   
    titleLab.text = model.rule_explain;
    dateLab.text =model.create_date;
    
    if (model.score && [model.score intValue] > 0 ) {
        numLab.text = [NSString stringWithFormat:@"+%@",model.score];
    }else{
        numLab.text = [NSString stringWithFormat:@"%@",model.score];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
