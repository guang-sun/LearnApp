//
//  TrainClassCommendCell.m
//  KindeeTrain
//
//  Created by admin on 2018/6/10.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainClassCommendCell.h"

@interface TrainClassCommendCell ()
@property (weak, nonatomic) IBOutlet UIView *contentBgView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *comgradeView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@property (nonatomic, strong) UIView        *appreiseView ;

@end

@implementation TrainClassCommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone ;
    [self.contentView addSubview:self.appreiseView];
    
    self.appreiseView.hidden = YES ;
    [self.appreiseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(60).priorityMedium() ;
    }];
    
    self.appreiseView.userInteractionEnabled  = YES ;
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rzAddCommendApprese)];
    [self.appreiseView addGestureRecognizer:tap];
    
    // Initialization code
}

- (void)rzAddCommendApprese {
    if (self.rzAddComemdAppresiseBlock) {
        self.rzAddComemdAppresiseBlock() ;
    }
    
}

- (void)rzUpdateClassCommentWithModel:(TrainCourseAppraiseModel *)model  {
    
    
    if (model.ismy) {
        if (model.grade && model.grade.intValue > 0) {
            [self creatStarImage:[model.grade intValue]];
        }else{
            [self creatGroupAppraise];
            return;
        }
    }else{
        
        [self creatStarImage:[model.grade intValue]];
    }
    
    NSString  *imageStr =(model.mphoto)?model.mphoto:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:@"/upload/user/pic"]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"/upload/user/pic/%@",imageStr];
    }
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"user_avatar_default"] options:SDWebImageAllowInvalidSSLCertificates];
    
    self.contentLabel.text = (TrainStringIsEmpty( model.content))?@" ":model.content;
    
    self.nameLabel.text = model.create_name;
    self.dateLabel.text = model.create_date;
    
    
}

- (UIView *)appreiseView {
    if (!_appreiseView) {
        UIView *view = [[UIView alloc]init];
        
        
        _appreiseView =view ;
    }
    return _appreiseView;
}

-(void)creatGroupAppraise{
    
    _appreiseView.hidden = NO;
    _contentBgView.hidden = YES;
    [_appreiseView.subviews  makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    UIView  *lastView = [[UIView alloc]init];
    for (int i = 0; i < 5; i++) {
        UIImageView  *image =[[UIImageView alloc]init];
        NSString  *name = @"star_big";
        image.image =[UIImage imageNamed:name];
        [_appreiseView addSubview:image];
        
        CGFloat  off_x =  (TrainSCREENWIDTH - 5 *30 - 4 *15) / 2 ;
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0) {
                make.left.equalTo(self.appreiseView).offset(off_x);
            }else{
                make.left.equalTo(lastView.mas_right).offset(15);
            }
            make.centerY.equalTo(self.appreiseView);
            make.height.width.mas_equalTo(30);
        }];
        lastView = image ;
      
        
    }

  
}
-(void)creatStarImage:(int )grade{
    
    _appreiseView.hidden = YES;
    _contentBgView.hidden = NO;
    [self.comgradeView.subviews  makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    UIView  *lastView =nil;
    for (int i = 0; i < 5; i++) {
        UIImageView  *image =[[UIImageView alloc]init];
        NSString  *name =(i < grade)?@"star_big_selected":@"star_big.png";
        image.image =[UIImage imageNamed:name];
        [self.comgradeView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0) {
                make.left.equalTo(self.comgradeView).offset(5);
            }else{
                make.left.equalTo(lastView.mas_right).offset(3);
            }
            make.centerY.equalTo(self.comgradeView);
            make.height.width.mas_equalTo(13);
        }];
        lastView = image ;
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
