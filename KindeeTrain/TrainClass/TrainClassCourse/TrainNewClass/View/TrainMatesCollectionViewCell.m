//
//  TrainMatesCollectionViewCell.m
//  KindeeTrain
//
//  Created by admin on 2018/6/10.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainMatesCollectionViewCell.h"

@interface TrainMatesCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation TrainMatesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

    // Initialization code
}


- (void)rzUpdateMatesInfoWithmodel:(TrainClassUserModel *)model  {
    
//    self.headimageView sd_setImageWithURL:[] placeholderImage:<#(UIImage *)#>
    
    NSString  *imageStr =(model.photo)?model.photo:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:@"/upload/user/pic/"]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"/upload/user/pic/%@",imageStr];
    }
    [self.headimageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"user_avatar_default"] options:SDWebImageAllowInvalidSSLCertificates];
    self.nameLabel.text =notEmptyStr(model.full_name);
//    if (_status  == TrainClassDetailStatusTeacher) {
//        contentLab.text =notEmptyStr(model.l_level); ;
//    }else if(_status == TrainClassDetailStatusStudent){
//        contentLab.text = notEmptyStr(model.group_name);
//    }
    
}

@end
