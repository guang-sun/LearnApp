//
//  TrainMessageListCell.m
//   KingnoTrain
//
//  Created by apple on 17/1/4.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import "TrainMessageListCell.h"

@interface TrainMessageListCell (){
    UILabel                *titleLab, *contentLab, *categoryNameLab, *autorNameLab ;
    UILabel                *dateLab;
    //    UILabel                 *numLab;
    UIImageView            *leftImageView;
}

@end

@implementation TrainMessageListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    titleLab  =[[UILabel alloc]creatTitleLabel];
    titleLab.cusFont = 16.0f;
    [self.contentView addSubview:titleLab];
    
    leftImageView = [[UIImageView alloc]init];
    leftImageView.image = [UIImage imageNamed:@"lunImageBg"];
    leftImageView.hidden = YES;
    [self.contentView addSubview:leftImageView];
    
    contentLab = [[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:contentLab];
    
    
    categoryNameLab = [[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:categoryNameLab];
    
    autorNameLab = [[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:autorNameLab];
    
    dateLab = [[UILabel alloc]creatContentLabel];
    dateLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:dateLab];
    
    UIView  *line =[[UIView alloc]initWithLineView];
    [self.contentView addSubview:line];
    
    UIView  *supView =self.contentView;
    
    titleLab.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .autoHeightRatio(0)
    .maxHeightIs(2 * titleLab.font.lineHeight);
    
    leftImageView.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(titleLab,5)
    .widthIs(trainAutoLoyoutImageSize(120))
    .heightIs(trainAutoLoyoutImageSize(70));
    
    
    contentLab.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(titleLab,5)
    .autoHeightRatio(0)
    .maxHeightIs(4 * contentLab.font.lineHeight);
    
    categoryNameLab.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    //.topSpaceToView(contentLab,10)
    .widthIs(100)
    .heightIs(20);
    
    dateLab.sd_layout
    .rightSpaceToView(supView,TrainMarginWidth)
    .widthIs(60)
    .topEqualToView(categoryNameLab)
    .heightIs(20);
    
    
    
    line.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(categoryNameLab,9)
    .heightIs(0.8);
    
    
    
}

-(void)setModel:(TrainMessageModel *)model{
    
    titleLab.text = model.title;
    contentLab.text =model.content;
    if (!model.thumb ||[model.thumb isEqualToString:@"null"] ||[model.thumb isEqualToString:@""] ) {
        leftImageView.hidden = YES;
        contentLab.sd_layout.leftSpaceToView(self.contentView,TrainMarginWidth);
        categoryNameLab.sd_layout.topSpaceToView(contentLab,5);
        
    }else{
        leftImageView.hidden = NO;
        leftImageView.image = [UIImage imageWithColor:[UIColor grayColor]];
        contentLab.sd_layout
        .leftSpaceToView(leftImageView,10)
        .heightRatioToView(leftImageView,1);
        categoryNameLab.sd_layout.topSpaceToView(leftImageView,5);
        
        NSString  *imageStr =(model.thumb)?model.thumb:@"";
        NSString  *imageURl ;
        if ([imageStr hasPrefix:@"/upload/news/pic"]) {
            imageURl = [TrainIP stringByAppendingFormat:@"%@",imageStr];
        }else{
            imageURl = [TrainIP stringByAppendingFormat:@"/upload/news/pic/%@",imageStr];
        }
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:imageURl ] placeholderImage:[UIImage imageNamed:@"lunImageBg"] options:SDWebImageAllowInvalidSSLCertificates];
    }
    [contentLab updateLayout];
    [categoryNameLab updateLayout];
    [self setupAutoHeightWithBottomView:categoryNameLab bottomMargin:10];
    
    categoryNameLab.text = model.category_name;
    dateLab.text = model.create_date;
    
    
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
