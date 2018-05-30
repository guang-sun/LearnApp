//
//  TrainMyNoteCell.m
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainMyNoteCell.h"

@interface TrainMyNoteCell ()
{
    UILabel         *contentLab;
    UIButton        *openButton;
    
    UILabel         *originLab;
    UILabel         *dateLab;
    UIButton        *editBtn;
    UIButton        *deleteBtn;
}
@end

@implementation TrainMyNoteCell
CGFloat maxMyNoteHeight = 0; // 根据具体font而定

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
    
}
-(void)creatUI{
    
    contentLab =[[UILabel  alloc]creatTitleLabel];
    if (maxMyNoteHeight == 0) {
        maxMyNoteHeight = contentLab.font.lineHeight * 4;
    }
    
    openButton =[[UIButton  alloc]initCustomButton];
    openButton.cusFont =12.0f;
    openButton.cusTitleColor = TrainNavColor;
    openButton.cusTitle=@"更多";
    openButton.cusSelectTitle =@"收起";
    [openButton addTarget:self action:@selector(UnfoldTouch:)];
    
    originLab =[[UILabel alloc]initCustomLabel];
    originLab.cusFont =12.0f;
    originLab.textColor = TrainOrangeColor;
    
    dateLab =[[UILabel  alloc]initCustomLabel];
    dateLab.cusFont =11.0f;
    dateLab.textColor = TrainTitleColor;
    
    editBtn =[[UIButton  alloc]initCustomButton];
    editBtn.tag=1;
    [editBtn addTarget:self action:@selector(editTouch:)];
    editBtn.image =[UIImage imageNamed:@"Train_MyNote_Edit"];
    
    deleteBtn =[[UIButton  alloc]initCustomButton];
    deleteBtn.tag=2;
    [deleteBtn addTarget:self action:@selector(editTouch:)];
    deleteBtn.image =[UIImage imageNamed:@"Train_MyNote_Detele"];
    UIView  *line =[[UIView alloc]init];
    line.backgroundColor =[UIColor groupTableViewBackgroundColor];
    
    [self.contentView sd_addSubviews:@[contentLab,openButton,originLab,dateLab,editBtn,deleteBtn,line]];
    
    UIView   *supView =self.contentView;
    contentLab.sd_layout
    .leftSpaceToView(supView,15)
    .rightSpaceToView(supView,15)
    .topSpaceToView(supView,15)
    .autoHeightRatio(0);
    
    openButton.sd_layout
    .rightEqualToView(contentLab)
    .topSpaceToView(contentLab,0)
    .widthIs(50);
    
    originLab.sd_layout
    .leftEqualToView(contentLab)
    .rightEqualToView(contentLab)
    .heightIs(15);
    
    dateLab.sd_layout
    .leftEqualToView(contentLab)
    .topSpaceToView(originLab,5)
    .widthIs(130)
    .heightIs(20);
    
    
    deleteBtn.sd_layout
    .rightSpaceToView(supView,20)
    .topEqualToView(dateLab)
    .widthIs(20)
    .heightIs(20);
    
    editBtn.sd_layout
    .rightSpaceToView(deleteBtn,30)
    .topEqualToView(dateLab)
    .widthIs(20)
    .heightIs(20);
    
    line.sd_layout
    .leftEqualToView(supView)
    .rightEqualToView(supView)
    .topSpaceToView(dateLab,10)
    .heightIs(10);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:0];
    
    
}
-(void)UnfoldTouch:(UIButton *)btn{
    if (_unfoldBlock) {
        _unfoldBlock();
    }
}
-(void)editTouch:(UIButton *)btn{
    if (_editDeleteBlock) {
        
        _editDeleteBlock(btn.tag);
    }
}

-(void)setModel:(TrainMyNoteModel *)model{
    contentLab.text =model.content;
    
    if (model.isShowButton) { // 如果文字高度超过60
        openButton.sd_layout.heightIs(20);
        openButton.hidden = NO;
        originLab.sd_layout.topSpaceToView(openButton,0);
        if (model.isOpen) { // 如果需要展开
            contentLab.sd_layout.maxHeightIs(MAXFLOAT);
            openButton.selected =YES;
        } else {
            contentLab.sd_layout.maxHeightIs(maxMyNoteHeight);
            openButton.selected=NO;
        }
    } else {
        openButton.sd_layout.heightIs(0);
        openButton.hidden = YES;
        originLab.sd_layout.topSpaceToView(contentLab,5);
        
    }
    NSString  *string =( model.ct_name)?model.ct_name:@"";
    
    originLab.text =[@"来源: " stringByAppendingString:string];
    dateLab.text = (model.create_date)?model.create_date:@"";
   
}
@end
