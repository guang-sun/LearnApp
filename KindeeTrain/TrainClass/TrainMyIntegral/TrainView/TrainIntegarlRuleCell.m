//
//  TrainIntegarlRuleCell.m
//   KingnoTrain
//
//  Created by apple on 16/12/6.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainIntegarlRuleCell.h"


@interface TrainIntegarlRuleCell ()
{
    UILabel         *titleLab;
    UILabel         *dateLab;
    UILabel         *numLab;
}

@end

@implementation TrainIntegarlRuleCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


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
    titleLab.textAlignment =NSTextAlignmentCenter;
    
    dateLab =[[UILabel alloc]creatTitleLabel];
    dateLab.textAlignment =NSTextAlignmentCenter;
    
    numLab =[[UILabel alloc]creatTitleLabel];
    numLab.textAlignment =NSTextAlignmentCenter;
    
    UIView  *line =[[UIView alloc]initWithLine1View];
    
    [self.contentView sd_addSubviews:@[titleLab,dateLab,numLab,line]];
    
    self.contentView.sd_equalWidthSubviews = @[titleLab,dateLab,numLab];
    UIView   *supView =self.contentView;
    
    titleLab.sd_layout
    .leftSpaceToView(supView,15)
    //    .rightSpaceToView(supView,65)
    .topSpaceToView(supView,10)
    .heightIs(20);
    
    dateLab.sd_layout
    .leftSpaceToView(titleLab,5)
    //    .rightEqualToView(titleLab)
    .topSpaceToView(supView,10)
    .heightIs(20);
    
    numLab.sd_layout
    .leftSpaceToView(dateLab,5)
    .rightSpaceToView(supView,15)
    .topSpaceToView(supView,10)
    .heightIs(20);
    
    line.sd_layout
    .leftEqualToView(supView)
    .rightEqualToView(supView)
    .topSpaceToView(titleLab,9)
    .heightIs(0.7);
    
    
//    titleLab.text =@"1111sa";
//    dateLab.text =@"s1111a";
//    numLab.text =@"111111";
}

-(void)setRulemodel:(TrainIntegarlRuleModel *)rulemodel{
    titleLab.text =rulemodel.rule_name;
    NSString  *ruleString = @"" ;
    
    //规则： unlimited 不限制，limit限制， onlyonce 仅一次， everyday 每天， everyweek ， everymonth 每月， everyyear 每年
    
    if ([rulemodel.rule isEqualToString:@"unlimited"]) {
        ruleString  = @"不限制";
    }else if ([rulemodel.rule isEqualToString:@"onlyonce"]){
        ruleString  = @"仅一次";
    }else if ([rulemodel.rule isEqualToString:@"everyday"]){
        ruleString  =[NSString stringWithFormat:@"每天上限%@次",rulemodel.rule_frequency];
    }else if ([rulemodel.rule isEqualToString:@"limit"]){
        ruleString  =[NSString stringWithFormat:@"限制%@次",rulemodel.rule_frequency];
    }else if ([rulemodel.rule isEqualToString:@"everyweek"]){
        ruleString  =[NSString stringWithFormat:@"每周上限%@次",rulemodel.rule_frequency];
    }else if ([rulemodel.rule isEqualToString:@"everymonth"]){
        ruleString  =[NSString stringWithFormat:@"每月上限%@次",rulemodel.rule_frequency];
    }else if ([rulemodel.rule isEqualToString:@"everyyear"]){
        ruleString  =[NSString stringWithFormat:@"每年上限%@次",rulemodel.rule_frequency];
    }
    dateLab.text = ruleString;
    
    NSString  *scoreStr =@"";
    if ([rulemodel.rule_type isEqualToString:@"up"]) {
        scoreStr =[NSString stringWithFormat:@"每次加%@分",rulemodel.rule_score];
    }else if ([rulemodel.rule_type isEqualToString:@"down"]){
        scoreStr =[NSString stringWithFormat:@"每次减%@分",rulemodel.rule_score];
    }
    numLab.text = scoreStr;
}

-(void)setLevelmodel:(TrainIntegarlLevelModel *)levelmodel{
    
    titleLab.text =levelmodel.level_name;
    
    dateLab.text = levelmodel.level_num;
    numLab.text = levelmodel.level_score;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
