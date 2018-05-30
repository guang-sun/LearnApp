//
//  TrainNodataView.m
//  SOHUEhr
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainNodataView.h"

#define NO_WIFI_WORDS                   TrainNoNetWorkText
#define NO_DATA                         TrainNoDataText

float const width_displayNoWifiView  = 200.0 ;
float const height_displayNoWifiView = 100.0 ;

float const width_labelshow          = 300.0 ;
float const height_labelshow         = 35.0 ;
float const fontSize_labelshow       = 17.0 ;

float const flexY_lb_bt              = 10.0 ;

float const width_bt                 = 100.0 ;
float const height_bt                = 30.0 ;
float const fontSize_bt              = 15.0 ;


@interface   TrainNodataView ()
{
    trainStyle     mode;
}
@property (nonatomic, strong) UIImageView *nowifiImgView ;
@property (nonatomic, strong) UILabel *warmLab ;
@property (nonatomic, strong) UIButton *warmBtn ;
@property (nonatomic, copy)   ReloadButtonClickBlock reloadButtonClickBlock ;


@end
@implementation TrainNodataView

- (void)showInView:(UIView *)viewWillShow {
    [viewWillShow addSubview:self] ;
}

- (void)dismiss {
    [self removeFromSuperview] ;
}

- (instancetype)initWithFrame:(CGRect)frame trainStyle:(trainStyle)style
                  reloadBlock:(ReloadButtonClickBlock)reloadBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor] ;
        mode = style;
        self.reloadButtonClickBlock = reloadBlock ;
        if (style == trainStyleNoNet) {
            [self nowifiImgView] ;
            [self warmLab] ;
            _warmLab.text = NO_WIFI_WORDS ;

            [self warmBtn] ;
        }else{
            [self warmLab] ;
            _warmLab.text = NO_DATA ;
            
 
        }
        
      //  [self setup] ;
    }
    return self;
}


- (void)setup {
    [self nowifiImgView] ;
    [self warmLab] ;
    [self warmBtn] ;
}
- (void)layoutSubviews {
    [super layoutSubviews] ;
    if (mode == trainStyleNoNet) {
        CGRect rectWifi = CGRectZero ;
        rectWifi.size = CGSizeMake(width_displayNoWifiView, height_displayNoWifiView) ;
        rectWifi.origin.x = (self.frame.size.width - width_displayNoWifiView) / 2.0 ;
        rectWifi.origin.y = (self.frame.size.height - height_displayNoWifiView - height_labelshow - flexY_lb_bt - height_bt) / 2.0 ;
        self.nowifiImgView.frame = rectWifi ;
        
        CGRect rectLabel = CGRectZero ;
        rectLabel.origin.x = (self.frame.size.width - width_labelshow) / 2.0 ;
        rectLabel.origin.y = rectWifi.origin.y + rectWifi.size.height ;
        rectLabel.size = CGSizeMake(width_labelshow, height_labelshow) ;
        self.warmLab.frame = rectLabel ;
        
        CGRect rectButton = CGRectZero ;
        rectButton.origin.x = (self.frame.size.width - width_bt) / 2.0 ;
        rectButton.origin.y = rectLabel.origin.y + rectLabel.size.height + flexY_lb_bt ;
        rectButton.size = CGSizeMake(width_bt, height_bt) ;
        self.warmBtn.frame = rectButton ;
    }else{
        CGRect rectLabel = CGRectZero ;
        rectLabel.origin.x = (self.frame.size.width - width_labelshow) / 2.0 ;
        rectLabel.origin.y = (self.frame.size.height- height_labelshow)/2.0 ;
        rectLabel.size = CGSizeMake(width_labelshow, height_labelshow) ;
        self.warmLab.frame = rectLabel ;
        
    }
   
}

- (UIImageView *)nowifiImgView {
    if (!_nowifiImgView) {
        _nowifiImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Train_Error_data"]] ;
        
        _nowifiImgView.contentMode = UIViewContentModeScaleAspectFit ;
        if (![_nowifiImgView superview]) {
            [self addSubview:_nowifiImgView] ;
            
    
            
        }
    }
    return _nowifiImgView ;
}
- (UILabel *)warmLab {
    if (!_warmLab) {
        _warmLab = [[UILabel alloc] init] ;
        _warmLab.font = [UIFont boldSystemFontOfSize:16.0f] ;
        _warmLab.textAlignment = NSTextAlignmentCenter ;
        _warmLab.textColor = TrainContentColor ;
        if (![_warmLab superview]) {
            [self addSubview:_warmLab] ;
        }
    }
    return _warmLab ;
}

- (UIButton *)warmBtn {
    if (!_warmBtn) {
        _warmBtn = [[UIButton alloc] init] ;
        [_warmBtn setTitle:@"重新加载" forState:0] ;
        [_warmBtn setTitleColor:TrainContentColor forState:0] ;
        _warmBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f] ;
        _warmBtn.layer.cornerRadius = 5.0f ;
        _warmBtn.layer.borderWidth = 1.0f ;
        _warmBtn.layer.borderColor = TrainContentColor.CGColor ;
        [_warmBtn addTarget:self action:@selector(reloadButtonClicked) forControlEvents:UIControlEventTouchUpInside] ;
        if (![_warmBtn superview]) {
            [self addSubview:_warmBtn] ;
        }
    }
    return _warmBtn ;
}

- (void)reloadButtonClicked {
    self.reloadButtonClickBlock() ;
}


@end
