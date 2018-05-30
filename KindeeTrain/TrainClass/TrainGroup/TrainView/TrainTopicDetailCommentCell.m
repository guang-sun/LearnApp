//
//  TrainTopicDetailCommentCell.m
//  SOHUEhr
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainTopicDetailCommentCell.h"
#import "TrainTopicCommentListView.h"

@interface TrainTopicDetailCommentCell ()
{
    UIImageView                 *iconImageView;
    UILabel                     *nameLab, *numLab, *dateLab, *contentLab;
    TrainTopicCommentListView   *listView;
    
}
@property (nonatomic, strong) UIButton       *removeBtn;


@end

@implementation TrainTopicDetailCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)creatUI{
    
    iconImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_avatar_default"]];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    iconImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:iconImageView];
     UITapGestureRecognizer   *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTouch)];
    [iconImageView addGestureRecognizer:tap];

    
    nameLab =[[UILabel alloc]creatContentLabel];
    nameLab.textColor = TrainNavColor;
    nameLab.userInteractionEnabled =YES;
    [self.contentView addSubview:nameLab];
    
    UITapGestureRecognizer   *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTouch)];
    [nameLab addGestureRecognizer:tap1];
    
    numLab =[[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:numLab];
    
    
    dateLab =[[UILabel alloc]creatContentLabel];
    dateLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:dateLab];
    
    contentLab  = [[UILabel alloc]initCustomLabel];
    contentLab.textColor =TrainColorFromRGB16(0x565656);
    contentLab.cusFont =14.0f;
    [self.contentView addSubview:contentLab];
    
    listView = [[TrainTopicCommentListView alloc]init];
    listView.userInteractionEnabled = YES;
    [self.contentView addSubview:listView];
    

    
    __weak  typeof(self)weakSelf  =self;
    listView.topicComLine = ^(TrainTopicCommentModel  *model,NSInteger  selectIndex){
        
        [weakSelf commentLineTouch:model andSelectIndex:selectIndex];
    };
    
    listView.topicComName =^(NSString  *user_id){
        [weakSelf commentNameTouch:user_id];
        
    };
//    listView.topicComRemovePost = ^(NSInteger selectIndex){
//        [weakSelf commentremovePostWithIndex:selectIndex];
//    };
    
    UIView  *line =[[UIView alloc]initWithLine1View];
    [self.contentView addSubview:line];
    
    UIView  *supView =self.contentView;
    
    iconImageView.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .widthIs(trainAutoLoyoutImageSize(30))
    .heightIs(trainAutoLoyoutImageSize(30));
    
//    iconImageView.sd_cornerRadiusFromWidthRatio =@(0.5);
    
    
    nameLab.sd_layout
    .leftSpaceToView(iconImageView,10)
    .topEqualToView(iconImageView)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(trainAutoLoyoutImageSize(15));
    
    
    numLab.sd_layout
    .leftSpaceToView(iconImageView,10)
    .topSpaceToView(nameLab,5)
    .widthIs(50)
    .heightIs(trainAutoLoyoutImageSize(10));
    
    dateLab.sd_layout
    .leftSpaceToView(numLab,10)
    .topSpaceToView(nameLab,5)
    .rightSpaceToView(supView,TrainMarginWidth )
    .heightIs(trainAutoLoyoutImageSize(10));
    
    contentLab.sd_layout
    .leftEqualToView(numLab)
    .topSpaceToView(numLab,10)
    .rightSpaceToView(supView,TrainMarginWidth)
    .autoHeightRatio(0);
    
    listView.sd_layout
    .leftEqualToView(numLab)
    .rightSpaceToView(supView, TrainMarginWidth)
    .topSpaceToView(contentLab, 10); // 已经在内部实现高度自适应所以不需要再设置高度
    
    
    line.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .bottomSpaceToView(supView,1)
    .heightIs(0.7);
}

-(void)setModel:(TrainTopicCommentModel *)model
{
    _model = model;
    
    listView.frame = CGRectZero;
    
    
    [listView setupWithcommentItemsArray:model.child_post_list];
    
    NSString  *imageStr =(model.sphoto)?model.sphoto:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:@"/upload/user/pic"]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"/upload/user/pic/%@",imageStr];
    }
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"user_avatar_default"] options:SDWebImageAllowInvalidSSLCertificates];
    
    nameLab.text = model.full_name;
    
    NSString  *string =[NSString stringWithFormat:@"%zi楼",[model.totCount intValue] - _index];
    
    numLab.text = string;
    
    dateLab.text =(model.create_date)?model.create_date:@"";
    
//    [self updateRemoveBtn];
    
    contentLab.text = model.content;
    UIView *bottomView;
    if (!model.child_post_list.count ) {
        listView.fixedWidth  = @0;
        listView.fixedHeight = @0;
        listView.sd_layout.topSpaceToView(contentLab, 0);
        bottomView = contentLab;
    } else {
        listView.fixedHeight = nil; // 取消固定宽度约束
        listView.fixedWidth = nil; // 取消固定高度约束
        listView.sd_layout.topSpaceToView(contentLab, 10);
        bottomView = listView;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];
    
}
//-(void)updateRemoveBtn{
//    
//    if (self.pv_flag!= -1) {
//        if (self.pv_flag ==1 || [self.model.user_id isEqualToString:TrainUser.user_id]) {
//            
//            [self.contentView addSubview:self.removeBtn];
//            
//            nameLab.sd_layout.rightSpaceToView(self.contentView,TrainMarginWidth + 30);
//            dateLab.sd_layout.rightSpaceToView(self.contentView,TrainMarginWidth + 30 );
//            
//            self.removeBtn.sd_layout
//            .rightSpaceToView(self.contentView ,TrainMarginWidth)
//            .topEqualToView(iconImageView)
//            .widthIs(30)
//            .heightEqualToWidth();
//            
//        }
//    }
//}
//

-(void)titleTouch{
    if (_topicLine) {
        _topicLine(_model,nil,-1);
    }
}

-(void)commentLineTouch:(TrainTopicCommentModel *)model andSelectIndex:(NSInteger)index{
    if (_topicLine) {
        
        model.comment_id = _model.comment_id;
        _topicLine(model,model.full_name,index);
    }
    
}

-(void)commentNameTouch:(NSString *)user_id{
    if (_topicName) {
        _topicName(user_id);
    }
}

//-(void)firstPostRemoveBtnTouch{
//    [self commentremovePostWithIndex:-1];
//}
//-(void)commentremovePostWithIndex:(NSInteger )index{
//    
//    TrainTopicCommentModel *comModel = nil;
//    if (index == -1) {
//        comModel = self.model;
//    }else{
//        if (index < self.model.child_post_list.count) {
//            comModel = self.model.child_post_list[index];
//        }
//    }
//
//    [[TrainNetWorkAPIClient client] trainRemoveTopicPostWithTopic_id:comModel.topic_id post_id:comModel.comment_id Success:^(NSDictionary *dic) {
//        
//        NSString  *str = @"";
//        if ([dic[@"success"] isEqualToString:@"S"]) {
//            str = @"删除成功";
//        }else{
//            str = dic[@"msg"];
//        }
//        if (_topicRemove) {
//            _topicRemove(index,str);
//        }
//        
//    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
//        if (_topicRemove) {
//            _topicRemove(index,@"删除失败,请重试");
//        }
//
//    }];
//
//}
//


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



//-(UIButton *)removeBtn{
//    if (!_removeBtn) {
//       UIButton *removeBtn1 = [[UIButton alloc]initCustomButton];
//        removeBtn1.image = TrainscaleImage(@"Train_MyNote_Detele");
//        
//        [removeBtn1 addTarget:self action:@selector(firstPostRemoveBtnTouch)];
//        _removeBtn = removeBtn1;
//
//    }
//    return _removeBtn;
//}
//

@end
