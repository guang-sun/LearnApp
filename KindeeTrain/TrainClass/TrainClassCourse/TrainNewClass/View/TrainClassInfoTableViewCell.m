//
//  TrainClassInfoTableViewCell.m
//  KindeeTrain
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainClassInfoTableViewCell.h"

@interface TrainClassInfoTableViewCell ()

@property (nonatomic, strong) UILabel  *contentLabel ;

@property (nonatomic, strong) UIButton  *moreButton ;


@end

@implementation TrainClassInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self rzInitSubview];
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
    }
    return  self ;
}

- (void)rzInitSubview {
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.moreButton];
    self.isShowMore = NO ;
    self.isMore = YES ;
    
}

- (void)rzMoreAddLayout {
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).offset(TrainMarginWidth);
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-TrainMarginWidth);
        make.height.mas_lessThanOrEqualTo(50);
        
    }];
    [self.moreButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.contentView).offset(- 5);

    }];
}

- (void)rzGardeAddLayout {
    

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(TrainMarginWidth);
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-TrainMarginWidth);
        make.bottom.mas_equalTo(self.contentView).offset(- TrainMarginWidth);
    }];
    [self.moreButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(self.contentView).offset(- 5);

    }];
   
}

- (void)rzAllMore:(UIButton *)button {
    button.selected = !button.selected;
  
    if (self.rzMoreBlock) {
        self.rzMoreBlock(button.selected);
    }
    [self layoutIfNeeded];
    
}

- (void)setContentText:(NSString *)contentText {
    
    _contentText = contentText ;
    self.contentLabel.text  = contentText ;
}

- (void)setIsShowMore:(BOOL)isShowMore  {
    
    _isShowMore = isShowMore;
    self.moreButton.hidden = !isShowMore;
    if (isShowMore) {
        [self rzMoreAddLayout];

    }else {
        [self rzGardeAddLayout];
    }

}

- (void)setIsMore:(BOOL)isMore {
    
    _isMore = isMore ;
    if (isMore) {
        
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_lessThanOrEqualTo(MAXFLOAT);
            
        }];
    }else {
        
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_lessThanOrEqualTo(50);
            
        }];
    }
    
}


- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *label = [[UILabel alloc]init];
        label.textColor = TrainColorFromRGB16(0x101010);
        label.font = [UIFont systemFontOfSize:14.f];
        label.text =@"";
        label.numberOfLines = 0 ;
        _contentLabel = label ;
    }
    return _contentLabel ;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"更多" forState:UIControlStateNormal];
        [button setTitle:@"收起" forState:UIControlStateSelected];
        [button setTitleColor:TrainColorFromRGB16(0x259B24) forState:UIControlStateSelected];
        [button setTitleColor:TrainColorFromRGB16(0x259B24) forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(rzAllMore:)];
        button .titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        _moreButton = button ;
    }
    return _moreButton ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
