//
//  TrainHomeCollectionViewCell.m
//   KingnoTrain
//
//  Created by apple on 16/12/2.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainHomeCollectionViewCell.h"
#import "TrainLocalData.h"

@interface TrainHomeCollectionViewCell ()
{
    UIImageView    *mainImageView;
    UILabel        *mainLable;
}
@end

@implementation TrainHomeCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self creatUI];
    }
    return  self;
}


-(void)creatUI{
    mainImageView =[[UIImageView alloc]init];
    [self.contentView addSubview:mainImageView];
    
    mainLable =[[UILabel alloc] initCustomLabel];
    mainLable.textAlignment =NSTextAlignmentCenter;
    mainLable.cusFont = trainAutoLoyoutTitleSize(14.0f);
    mainLable.textColor =TrainColorFromRGB16(0x181818);
    [self.contentView addSubview:mainLable];
    
    self.contentView.layer.borderWidth =0.5f;
    self.contentView.layer.borderColor =TrainColorFromRGB16(0xE8E8E8).CGColor;
    
    mainImageView.sd_layout
    .centerXEqualToView(self.contentView)
    .widthIs( trainAutoLoyoutImageSize(30))
    .topSpaceToView(self.contentView, (self.frame.size.height - trainAutoLoyoutImageSize(30) * 2) / 2)
    .heightEqualToWidth();
    
    mainLable.sd_layout
    .centerXEqualToView(self.contentView)
    .widthRatioToView(self.contentView,0.9)
    .topSpaceToView(mainImageView,(10))
    .heightIs(trainAutoLoyoutTitleSize(20));
    
    
}
-(void)setTitle:(NSString *)title{
    mainLable.text =title;
    NSString  *string =[TrainLocalData returnMainDic][title];
    UIImage  *contentImage = [UIImage imageNamed:string];
    mainImageView.image = contentImage;
    
}
-(void)setImage:(NSString *)image{
    mainImageView.image =[UIImage imageNamed:image];
}

- (void)setModel:(TrainHomeModel *)model {
    mainLable.text =model.fn_name;
    NSString  *string =[TrainLocalData returnMainDic][model.fn_key];
    
    if (TrainStringIsEmpty(model.fn_pic)) {
        
        string = (TrainStringIsEmpty(string))?@"":string;
        [mainImageView sd_setImageWithURL:[NSURL URLWithString:model.fn_pic] placeholderImage:[UIImage imageNamed:string] options:SDWebImageAllowInvalidSSLCertificates];
    }else{
        string = (TrainStringIsEmpty(string))?@"":string;
        mainImageView.image = [UIImage imageNamed:string];
    }
}

@end
