//
//  TrainClassExamRecordCell.m
//  KindeeTrain
//
//  Created by admin on 2018/6/19.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainClassExamRecordCell.h"
#import "TrainExamRecordView.h"

@interface TrainClassExamRecordCell  ()

@property (nonatomic, strong) UILabel         *dateLabel ;
@property (nonatomic, strong) UILabel         *gradeLabel ;
@property (nonatomic, strong) UILabel         *lastGradeLabel ;
@property (nonatomic, strong) UIButton        *joinButton ;
@property (nonatomic, strong) UIView            *recordView ;

@property (nonatomic, strong) NSMutableArray  *recordMuArr ;

@property (nonatomic, strong) TrainClassResModel  *resModel ;
@end

@implementation TrainClassExamRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        [self rzaddSubview];
    }
    return self;
}

- (void)rzaddSubview {
    
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.gradeLabel];
    [self.contentView addSubview:self.lastGradeLabel];
    [self.contentView addSubview:self.joinButton];
    [self.contentView addSubview:self.recordView];
    [self rzAddlayout];

}

- (void)rzAddlayout {
    
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.joinButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dateLabel);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    [self.gradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
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
    
    [self.recordView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self.gradeLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(0).priorityMedium();
        make.bottom.equalTo(self.contentView).offset(-10);

    }];
    
}

- (void)rzUpdateClassExamWithModel:(TrainClassResModel *)model  {
    
    self.resModel = model ;
    NSString *startDate = (TrainStringIsEmpty(model.start_date))?@"不限制" : model.start_date;
    NSString *endDate = (TrainStringIsEmpty(model.end_date))?@"不限制" : model.end_date;
    
    self.dateLabel.text = [NSString stringWithFormat:@"起止时间: %@ 至 %@" ,startDate ,endDate];
    NSString *gradeText = [NSString stringWithFormat:@"总分:%zi   及格分:%zi", [model.sum_score integerValue],[model.pass_line integerValue]];
    
    self.gradeLabel .text = gradeText ;
    
    [self.recordView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];

    if (model.attemptList.count > 0) {

        TrainClassExamModel *exam = [model.attemptList firstObject];

        NSString *lastText = [NSString stringWithFormat:@"最后总分:%zi ", [exam.score integerValue]];
        self.lastGradeLabel.text = lastText ;
        
        UIView  *lastRecord = nil ;

        for (NSInteger  i = 0; i< model.attemptList.count; i++) {

            TrainClassExamModel *exam = model.attemptList[i];
            TrainExamRecordView  *recordView = [[TrainExamRecordView alloc]init];
            [recordView rzUpdateExamRecordWithModel:exam index:i];

            TrainWeakSelf(self);
            recordView.trainExamRecordBlock = ^(NSInteger index) {
                [weakself rzrecordViewWithModel:exam];
            };

            [self.recordView addSubview: recordView ];

            [recordView mas_makeConstraints:^(MASConstraintMaker *make) {

                make.left.right.equalTo(self.recordView);
                make.height.mas_equalTo(30);
                if (!lastRecord) {
                    make.top.equalTo(self.recordView);
                }else {
                    make.top.equalTo(lastRecord.mas_bottom);
                }

            }];
            lastRecord = recordView ;
        }
        
        CGFloat  height = 30 * model.attemptList.count ;
        
        [self.recordView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.height.mas_equalTo( height).priorityHigh() ;

        }];
        [self.recordView layoutIfNeeded];
        [self.contentView layoutIfNeeded];
    
    }else {
        
        [self.recordView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo( 0).priorityHigh() ;
            
        }];
        [self.recordView layoutIfNeeded];
        [self.contentView layoutIfNeeded];
    }
}

- (void)rzrecordViewWithModel :(TrainClassExamModel *)model {
    
    [[TrainNetWorkAPIClient client] trainReviewExamWithAtmp_id:model.record_id Success:^(NSDictionary *dic) {
        
//        NSString  *webUrl = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"reviewExam" object_id:dic[@"object_id"] andtarget_id:self.model.type_id];
//        if (_returnWebUrlBlock) {
//            _returnWebUrlBlock(webUrl);
//        }
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
    }];
    
    
}

- (void)rzClassExamJoin {

    if (self.rzClassExamJoinBlock) {
        NSString * webUrl = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"onlineExam" object_id:self.resModel.res_id andtarget_id:self.resModel.obj_id];
        self.rzClassExamJoinBlock(webUrl);
    }
}



- (UILabel *)dateLabel {
    if (!_dateLabel) {
        UILabel *label  = [[UILabel alloc]initCustomLabel];
        label.text = @"" ;
        
        _dateLabel = label ;
    }
    return _dateLabel ;
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
        button.cusTitle = @"参加";
        button.cusTitleColor = TrainNavColor ;
        [button addTarget:self action:@selector(rzClassExamJoin)];
        _joinButton = button;
    }
    return _joinButton ;
}

- (UIView *)recordView {
    if (!_recordView) {
        UIView *view = [[UIView alloc]init];
    
        _recordView = view ;
    }
    return _recordView ;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
