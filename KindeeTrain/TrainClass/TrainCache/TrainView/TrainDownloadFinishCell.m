//
//  TrainDownloadFinishCell.m
//  SOHUEhr
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 com.sohu-inc. All rights reserved.
//

#import "TrainDownloadFinishCell.h"

@interface TrainDownloadFinishCell ()
{
    UIImageView     *leftImageV;
    UILabel         *titleLab;
    UILabel         *numLab;
    UILabel         *sizeLab;
    
    
}
@end

@implementation TrainDownloadFinishCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    leftImageV =[[UIImageView alloc]init];
    leftImageV.image =[UIImage imageNamed:@"train_course_default"];
    
    titleLab =[[UILabel alloc]creatTitleLabel];
    
    
    numLab =[[UILabel alloc]creatContentLabel];
  
    sizeLab=[[UILabel alloc]creatContentLabel];
    sizeLab.textAlignment =NSTextAlignmentRight;
    
    
    UIView  *lineV =[[UIView alloc]initWithLineView];
    
    [self.contentView sd_addSubviews:@[leftImageV,titleLab,numLab,sizeLab,lineV]];
    
    
    UIView *supView =self.contentView;
    
    leftImageV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .widthIs(80)
    .heightIs(50);
    
    
    titleLab.sd_layout
    .leftSpaceToView(leftImageV,10)
    .topEqualToView(leftImageV)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(30);
    
    
    numLab.sd_layout
    .leftSpaceToView(leftImageV,5)
    .bottomEqualToView(leftImageV)
    .widthIs(100)
    .heightIs(15);
    
    sizeLab.sd_layout
    .rightSpaceToView(supView,TrainMarginWidth)
    .topEqualToView(numLab)
    .leftSpaceToView(numLab,10)
    .heightIs(15);
    
    lineV.sd_layout
    .leftEqualToView(supView)
    .rightEqualToView(supView)
    .topSpaceToView(leftImageV,9)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:leftImageV bottomMargin:10];
    
}
-(void)setDownloadArr:(NSArray *)downloadArr{
    
    _downloadArr = downloadArr;
    TrainDownloadModel   *model ;
    if (!TrainArrayIsEmpty(downloadArr)) {
        model =[downloadArr firstObject];
    }
    numLab.text = [NSString stringWithFormat:@"已缓存%zi个视频",downloadArr.count];
    
//    NSString *path = [TrainDownloadBasePath stringByAppendingPathComponent:model.courseName];
//    CGFloat  size = [TrainStringUtil trainGetFileSizeWithPath:path];
//    numLab.text = [NSString stringWithFormat:@"共占用 %@",    [TrainStringUtil trainGetFileSizeWithsize:size]];

    if (!TrainStringIsEmpty(model.imageUrl)) {
        
        NSString  *iamgeStr =(model.imageUrl)?model.imageUrl:@"";
        if ([iamgeStr hasPrefix:@"/upload/course/pic/"]) {
            iamgeStr = [TrainIP stringByAppendingFormat:@"%@",iamgeStr];
        }else{
            iamgeStr = [TrainIP stringByAppendingFormat:@"/upload/course/pic/%@",iamgeStr];
        }
        NSLog(@"%@",iamgeStr);
        [leftImageV sd_setImageWithURL:[NSURL URLWithString:iamgeStr] placeholderImage:[UIImage imageNamed:@"train_course_default"] options:SDWebImageAllowInvalidSSLCertificates];
        
        
    }
    titleLab.text = model.courseName ;
}


@end
