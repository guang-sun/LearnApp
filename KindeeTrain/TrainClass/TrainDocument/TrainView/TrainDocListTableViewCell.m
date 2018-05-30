//
//  TrainDocListTableViewCell.m
//  SOHUEhr
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainDocListTableViewCell.h"
#import "TrainLocalData.h"
#import "TrainNetWorkAPIClient.h"
@interface TrainDocListTableViewCell ()
{
    UILabel         *titleLab, *contentLab ,*iconLab, *readNumLab, *sizeLab;
    UIImageView     *iconImageV;
    UIButton        *collectBtn;
    BOOL            isSearch;
}


@end


@implementation TrainDocListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        isSearch =NO;
        [self creatUI];
    }
    return  self;
}

-(void)creatUI{
    
    titleLab =[[UILabel alloc]creatTitleLabel];
    
    collectBtn =[[UIButton alloc]initCustomButton];
    collectBtn.image =[UIImage imageNamed:@"Train_Collect"];
    [collectBtn setImage:[UIImage imageNamed:@"Train_Group_collect"] forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(docCollect:)];
    
    contentLab =[[UILabel alloc]creatContentLabel];
    
    iconImageV =[[UIImageView alloc]init];
    
    iconLab =[[UILabel alloc]initCustomLabel];
    iconLab.cusFont =11.f;
    iconLab.textColor = TrainOrangeColor;
    
    readNumLab =[[UILabel alloc]creatContentLabel];
    readNumLab.cusFont =11.f;

    
    sizeLab =[[UILabel alloc]creatContentLabel];
    sizeLab.cusFont =11.f;

    
    UIView *lineV =[[UIView alloc]initWithLineView];
    
    [self.contentView sd_addSubviews:@[titleLab,collectBtn,contentLab,iconImageV,iconLab,readNumLab,sizeLab,lineV]];
    UIView *supView =self.contentView;
    
    titleLab.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,(40))
    .topSpaceToView(supView,10)
    .heightIs((20));
    
    collectBtn.sd_layout
    .rightSpaceToView(supView,TrainMarginWidth)
    .centerYEqualToView(supView)
    .widthIs((30))
    .heightEqualToWidth();
    
    contentLab.sd_layout
    .leftEqualToView(titleLab)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(titleLab,5)
    .autoHeightRatio(0)
    .maxHeightIs(contentLab.font.lineHeight * 3);
    
    iconImageV.sd_layout
    .leftEqualToView(contentLab)
    .topSpaceToView(contentLab,5)
    .widthIs((20))
    .heightEqualToWidth();
    
    iconLab.sd_layout
    .leftSpaceToView(iconImageV,5)
    .topEqualToView(iconImageV)
    .widthIs((50))
    .heightIs((20));
    
    readNumLab.sd_layout
    .leftSpaceToView(iconLab,5)
    .topEqualToView(iconImageV)
    .widthIs((80))
    .heightIs((20));
    
    sizeLab.sd_layout
    .leftSpaceToView(readNumLab,TrainMarginWidth)
    .topEqualToView(iconImageV)
    .widthIs((80))
    .heightIs((20));
    
    lineV.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(iconImageV,9)
    .heightIs(0.7);
    
}
-(void)setSearchStr:(NSString *)searchStr{
    _searchStr =searchStr;
    isSearch =  TrainStringIsEmpty(searchStr)?NO:YES;
}
-(void)setModel:(TrainDocListModel *)model{
    _model = model;
    if (isSearch) {
        _searchStr =(_searchStr)?_searchStr:@"";
        NSAttributedString  *attstr =[model.name dealwithstring:_searchStr andFont:14.0];
        titleLab.attributedText =attstr;
    }else{
        titleLab.text =model.name;
    }
    
    iconLab.text =[model.format uppercaseString];
    
    NSString  *Num =(model.read_count)?model.read_count:@"0";
    readNumLab.text =[Num stringByAppendingString:@" 人阅读"];
   
    iconImageV.image = [UIImage imageNamed:[TrainLocalData returnDocImage:model.format]];
    sizeLab.text =[TrainStringUtil trainGetFileSizeWithsize:[model.file_size floatValue]];
    collectBtn.selected =([model.is_collected  isEqualToString:@"N"])?NO:YES;
    
}

-(void)docCollect:(UIButton *)btn{
   __block NSString  *str =@"";
    [[TrainNetWorkAPIClient client]trainDocCollectWithIsCollect: !btn.selected doc_id:_model.doc_id Success:^(NSDictionary *dic) {
        
        if ([dic[@"status"] boolValue]) {
            
            str = (btn.selected )?@"已取消收藏":@"已收藏";
            btn.selected = !btn.selected;
            
            
        }else{
          str = dic[@"msg"];
        }
        if (_trainDocCollectStatus) {
            _trainDocCollectStatus(str);
        }
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        if (_trainDocCollectStatus) {
            _trainDocCollectStatus(TrainNetWorkError);
        }
    }];
   
    
    
}


@end
