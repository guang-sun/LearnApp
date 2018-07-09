//
//  TrainExamRecordView.m
//  KindeeTrain
//
//  Created by admin on 2018/6/20.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainExamRecordView.h"

@interface TrainExamRecordView  ()

@property (nonatomic, strong) UILabel         *gradeLabel ;
@property (nonatomic, strong) UILabel         *lastGradeLabel ;
@property (nonatomic, strong) UIButton        *joinButton ;

@property (nonatomic, assign) NSInteger        selectIndex ;

@end

@implementation TrainExamRecordView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.selectIndex = 0 ;
        [self rzAddSubview];
    }
    return  self ;
}
- (void)rzAddSubview {
    
    [self addSubview:self.gradeLabel];
    [self addSubview:self.lastGradeLabel];
    [self addSubview:self.joinButton];
    [self rzAddlayout];
    
}

- (void)rzAddlayout {
    
   
    [self.gradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(5);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self).offset(-5);
    }];
    [self.joinButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).offset(5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    [self.lastGradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.joinButton.mas_left).offset(-5);
        make.top.height.equalTo(self.joinButton);
        make.left.equalTo(self.gradeLabel.mas_right).offset(010);
    }];
    [self.gradeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.lastGradeLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.gradeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
    [self.lastGradeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)rzClassExamJoin {

    if (self.trainExamRecordBlock) {
        self.trainExamRecordBlock(_selectIndex);
    }
    
}

- (void)rzUpdateExamRecordWithModel:(TrainClassExamModel *)model  index:(NSInteger)index{
    
    self.selectIndex = index ;
    NSString  *examdate = [NSString stringWithFormat:@"第%zi次: %@",index + 1 ,model.create_date ];
    self.gradeLabel.text = examdate ;
   
    NSString  *gradeText = [NSString stringWithFormat:@"得分: %@" ,model.score];
    self.lastGradeLabel.text = gradeText;
}


- (UILabel *)gradeLabel {
    if (!_gradeLabel) {
        UILabel *label  = [[UILabel alloc]initCustomLabel];
        label.text = @"" ;
        
        _gradeLabel = label ;
    }
    return _gradeLabel ;
}

- (UILabel *)lastGradeLabel {
    if (!_lastGradeLabel) {
        UILabel *label  = [[UILabel alloc]initCustomLabel];
        label.text = @"" ;
        
        _lastGradeLabel = label ;
    }
    return _lastGradeLabel ;
}

-(UIButton *)joinButton {
    
    if (!_joinButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.cusFont = 13.0f;
        button.cusTitle = @"回顾";
        button.cusTitleColor = TrainNavColor ;
        [button addTarget:self action:@selector(rzClassExamJoin)];
        _joinButton = button;
    }
    return _joinButton ;
}


@end
