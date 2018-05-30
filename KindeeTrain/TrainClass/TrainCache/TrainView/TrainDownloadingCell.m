//
//  TrainDownloadingCell.m
//  SOHUEhr
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 com.sohu-inc. All rights reserved.
//

#import "TrainDownloadingCell.h"

@interface TrainDownloadingCell ()
{
    UILabel *titleLab, *statusLab, *sizeLab, *progressLab;
    UIImageView *selectImageView;
    NSString *urlstring;
    UIProgressView *progressindicator;
    UIButton *selectbutton;
}

@end

@implementation TrainDownloadingCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addCellView];
        self.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)addCellView{
    
    
   
    selectbutton =[[UIButton alloc]init];
    [selectbutton setImage:[UIImage imageNamed:@"train_checkbox_on"] forState:UIControlStateNormal];
    [selectbutton setImage:[UIImage imageThemeColorWithName:@"train_checkbox_off"]
                   forState:UIControlStateSelected];
    [selectbutton setImage:[UIImage imageThemeColorWithName:@"train_checkbox_off"]  forState:UIControlStateHighlighted | UIControlStateSelected];
    [selectbutton setImage:[UIImage imageThemeColorWithName:@"train_checkbox_off"]  forState:UIControlStateHighlighted ];
    
    [selectbutton addTarget:self
                      action:@selector(selectbuttontapped)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:selectbutton];
    
    titleLab =[[UILabel alloc]init];
    titleLab.font =[UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:titleLab];
    
    progressindicator =[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressindicator.trackTintColor =[UIColor lightGrayColor];
    [self.contentView addSubview:progressindicator];
    
    progressLab =[[UILabel alloc]init];
    progressLab.font =[UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:progressLab];
    
    statusLab =[[UILabel alloc]init];
    statusLab.textColor = [UIColor grayColor];
    statusLab.font =[UIFont systemFontOfSize:12];
    [self.contentView addSubview:statusLab];
    
    sizeLab = [[UILabel alloc]init];
    sizeLab.font =[UIFont systemFontOfSize:12];
    sizeLab.textAlignment =NSTextAlignmentRight;
    
    [self.contentView addSubview:sizeLab];
    
    UILabel *lable =[[UILabel alloc]init];
    lable.backgroundColor =[UIColor lightGrayColor];
    [self.contentView addSubview:lable];
    
    
    UIView  *lineView = [[UIView alloc]initWithLineView];
    
    [self.contentView addSubview:lineView];
    
    
    UIView    *supView = self.contentView;
    
    selectbutton.sd_layout
    .leftSpaceToView(supView ,10)
    .centerYEqualToView(supView)
    .widthIs(0)
    .heightIs(20);
    
    titleLab.sd_layout
    .leftSpaceToView(selectbutton,10)
    .topSpaceToView(supView,10)
    .rightSpaceToView(supView,50)
    .heightIs(20);
    
    progressindicator.sd_layout
    .leftEqualToView(titleLab)
    .rightEqualToView(titleLab)
    .topSpaceToView(titleLab,5)
    .heightIs(10);
    
    statusLab.sd_layout
    .leftEqualToView(progressindicator)
    .rightEqualToView(progressindicator)
    .topSpaceToView(progressindicator,10)
    .heightIs(15);
    
    progressLab.sd_layout
    .leftSpaceToView(titleLab,5)
    .rightSpaceToView(supView,10)
    .centerYEqualToView (supView)
    .heightIs(20);
    
    
    lineView.sd_layout
    .leftSpaceToView(supView,10)
    .rightSpaceToView(supView,10)
    .topSpaceToView(statusLab,5)
    .heightIs (0.5);
    
    
}

-(void)setShowSelectView:(BOOL)showSelectView{
    
    _showSelectView = showSelectView;
    if (showSelectView) {
        
        selectbutton.sd_layout.widthIs(20);
        
    }else{
        selectbutton.sd_layout.widthIs(0);

    }
    
    [selectbutton updateLayout];
}

-(void)setModel:(TrainDownloadModel *)model{
    _model =model;
    NSString    *status;
    switch (model.status) {
        case TrainFileDownloadStateFinish:{
            
            statusLab.textColor =[UIColor grayColor];
            status = @"下载完成";
        }
            break;
        case TrainFileDownloadStateSuspending:
            statusLab.textColor =[UIColor grayColor];
            
            status = @"下载暂停";
            break;
        case TrainFileDownloadStateDownloading:
            statusLab.textColor =[UIColor grayColor];
            
            status = @"下载中";
            break;
        case TrainFileDownloadStateFail:
            status = @"下载出错,请重试";
            statusLab.textColor =[UIColor redColor];
            break;
        case TrainFileDownloadStateWaiting:
            status = @"等待中";
            statusLab.textColor =[UIColor grayColor];
            break;
        default:
            status = @"等待中";
            statusLab.textColor =[UIColor grayColor];
            break;
    }
    statusLab.text = status;
    selectbutton.selected = model.isSelect;
    titleLab.text  = model.hourName;
    
    progressLab.text = [NSString stringWithFormat:@"%.0f%%",model.progress * 100];
    progressindicator.progress = model.progress;
    
}


-(void)selectbuttontapped{
    
    selectbutton.selected =!selectbutton.selected;
    if (_selectTouch) {
        _selectTouch(selectbutton.selected);
    }
}



@end
