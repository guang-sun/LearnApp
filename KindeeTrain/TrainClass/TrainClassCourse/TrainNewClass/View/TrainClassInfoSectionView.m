//
//  TrainClassInfoSectionView.m
//  KindeeTrain
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainClassInfoSectionView.h"

@interface  TrainClassInfoSectionView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

@implementation TrainClassInfoSectionView


-(void)awakeFromNib {
    [super awakeFromNib];
    

}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title ;
    
}

- (void)setIsMore:(BOOL)isMore {
    _isMore = isMore;
    self.moreButton.hidden = !isMore ;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle ;
    self.moreButton.cusTitle = buttonTitle;
}




@end
