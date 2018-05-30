//
//  TrainNewsListCell.m
//   KingnoTrain
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import "TrainNewsListCell.h"

@interface TrainNewsListCell ()
{
    UILabel         *titleLab, *dateLab , *contentLab;
    UIImageView     *rightIconImageV;
}
@end

@implementation TrainNewsListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return  self;
}
-(void)creatUI{
    
    titleLab =[[UILabel alloc]creatTitleLabel];

    
    dateLab =[[UILabel alloc]creatContentLabel];

    
    contentLab =[[UILabel alloc]creatContentLabel];
    contentLab.isAttributedContent = YES;
    
    rightIconImageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Train_Cell_right"]];
    
    UIView  *view =[[UIView alloc]initWithLineView];
    
    [self.contentView sd_addSubviews:@[titleLab,dateLab,contentLab,rightIconImageV,view]];
    
    titleLab.sd_layout
    .leftSpaceToView(self.contentView,TrainMarginWidth)
    .topSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,25)
    .heightIs(20);
    
    dateLab.sd_layout
    .leftEqualToView(titleLab)
    .widthRatioToView(titleLab,1)
    .topSpaceToView(titleLab,5)
    .heightIs(15);
    
    contentLab.sd_layout
    .leftEqualToView(titleLab)
    .widthRatioToView(titleLab,1)
    .topSpaceToView(dateLab,5)
    .autoHeightRatio(0);
//    .maxHeightIs(contentLab.font.lineHeight*3);
    
    rightIconImageV.sd_layout
    .rightSpaceToView(self.contentView,10)
    .widthIs(10)
    .centerYEqualToView(self.contentView)
    .heightIs(16);
    
    view.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(contentLab,9)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:contentLab bottomMargin:10];
    
}
-(void)setIsRead:(BOOL)isRead{
//    if (isRead) {
//        titleLab.textColor =UIColorFromRGB16(0x9D9D9D);
//        dateLab.textColor =UIColorFromRGB16(0x9D9D9D);
//        contentLab.textColor =UIColorFromRGB16(0x9D9D9D);
//    }else{
//        titleLab.textColor =UIColorFromRGB16(0x2F2F2F);
//        dateLab.textColor =UIColorFromRGB16(0x9C9C9C);
//        contentLab.textColor =UIColorFromRGB16(0x9D9D9D);
//    }
}
-(void)setModel:(TrainNewsModel *)model{
    titleLab.text =model.title;
    dateLab.text =model.send_time;
//    NSString  *newsStr =[model.content trainReplaceHtmlCharacter];
//    contentLab.text =newsStr;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    contentLab.attributedText = attrStr;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
