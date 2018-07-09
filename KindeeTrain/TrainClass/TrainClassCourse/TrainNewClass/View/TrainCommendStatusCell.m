//
//  TrainCommendStatusCell.m
//  KindeeTrain
//
//  Created by admin on 2018/6/10.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainCommendStatusCell.h"

@interface TrainCommendStatusCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *conbgView;

@end

@implementation TrainCommendStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

    self.conbgView.layer.cornerRadius = 3.0f;
    self.conbgView.layer.borderWidth = 1.0f;
    self.conbgView.layer.borderColor = TrainColorFromRGB16(0xdedede).CGColor;
    self.conbgView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setContentText:(NSString *)contentText {
    
    _contentText = contentText ;
    self.titleLabel.text = contentText ;
}

- (void)setIsSelect:(BOOL)isSelect {
    if (isSelect) {
       
        self.conbgView.backgroundColor = [UIColor redColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    }else {
        
        self.conbgView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = TrainColorFromRGB16(0x4D4D4D);
    }
}




@end
