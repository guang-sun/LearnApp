//
//  TrainCourseNoteCell.m
//  SOHUEhr
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCourseNoteCell.h"

@interface TrainCourseNoteCell ()
{
    UILabel         *contentLab, *dateLab;
    UIButton        *openButton;
    
}

@end

CGFloat maxCourseNoteHei = 0; // 根据具体font而定

@implementation TrainCourseNoteCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)creatUI{
    
    contentLab =[[UILabel alloc]initCustomLabel];
    contentLab.cusFont =14;
    contentLab.textColor =TrainColorFromRGB16(0x9D9D9D);
    [self.contentView addSubview:contentLab];
    
    if (maxCourseNoteHei == 0) {
        maxCourseNoteHei = contentLab.font.lineHeight * 4;
    }
    
    openButton =[[UIButton  alloc]initCustomButton];
    openButton.cusFont =12.0f;
    openButton.cusTitleColor =TrainNavColor;
    openButton.cusTitle=@"更多";
    openButton.cusSelectTitle =@"收起";
    [openButton addTarget:self action:@selector(UnfoldTouch:)];
    
    [self.contentView addSubview:openButton];
    
    
    dateLab =[[UILabel alloc]initCustomLabel];
    dateLab.cusFont =11;
    dateLab.textColor =TrainColorFromRGB16(0x9C9C9C);
    [self.contentView addSubview:dateLab];
    
    UIView  *line =[[UIView alloc]init];
    line.backgroundColor =TrainColorFromRGB16(0xececec);
    [self.contentView addSubview:line];
    
    UIView  *supView =self.contentView;
    
    contentLab.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .autoHeightRatio(0);
    
    
    openButton.sd_layout
    .rightEqualToView(contentLab)
    .topSpaceToView(contentLab,0)
    .widthIs(50);
    
    
    dateLab.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(20);
    
    line.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(dateLab,5)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:dateLab bottomMargin:6];
    
}

-(void)UnfoldTouch:(UIButton *)btn{
    if (_unfoldBlock) {
        _unfoldBlock();
    }
}
-(void)setModel:(TrainCourseNoteModel *)model{
    contentLab.text =model.content;
    
    if (model.isShowButton) { // 如果文字高度超过60
        openButton.sd_layout.heightIs(20);
        openButton.hidden = NO;
        dateLab.sd_layout.topSpaceToView(openButton,0);
        if (model.isOpen) { // 如果需要展开
            contentLab.sd_layout.maxHeightIs(MAXFLOAT);
            openButton.selected =YES;
        } else {
            contentLab.sd_layout.maxHeightIs(maxCourseNoteHei);
            openButton.selected=NO;
        }
    } else {
        openButton.sd_layout.heightIs(0);
        openButton.hidden = YES;
        dateLab.sd_layout.topSpaceToView(contentLab,5);
        
    }
    
    
    dateLab.text =model.create_date;
}


@end
