//
//  TrainCourseDiscussCell.m
//  SOHUEhr
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCourseDiscussCell.h"
#import "TrainCourse_CommentListView.h"

@interface TrainCourseDiscussCell ()
{
    UIImageView                     *iconImageView, *rightIconImageView;
    UILabel                         *nameLab ,*numLab ,*dateLab , *contentLab ;

    TrainCourse_CommentListView     *listView;
}
@property(nonatomic, strong) UIButton   *removeBtn;
@end

@implementation TrainCourseDiscussCell

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
    [self.contentView addSubview:iconImageView];
    iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer   *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTouch)];
    [iconImageView addGestureRecognizer:tap];
    
    nameLab =[[UILabel alloc]initCustomLabel];
    nameLab.cusFont =12.0f;
    nameLab.textColor =TrainNavColor;
    nameLab.userInteractionEnabled =YES;
    [self.contentView addSubview:nameLab];
    
    UITapGestureRecognizer   *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTouch)];
    [nameLab addGestureRecognizer:tap1];
    
    
    rightIconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Train_topic_ask"]];
    rightIconImageView.hidden = YES;
    [self.contentView addSubview:rightIconImageView];
    
    numLab =[[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:numLab];
    
    dateLab =[[UILabel alloc]creatContentLabel];
    [self.contentView addSubview:dateLab];
    
    contentLab  = [[UILabel alloc]creatTitleLabel];
//    contentLab.textColor =TrainColorFromRGB16(0x565656);
//    contentLab.cusFont =14.0f;
    [self.contentView addSubview:contentLab];
    
    listView = [[TrainCourse_CommentListView alloc]init];
    [self.contentView addSubview:listView];
    
    __weak  typeof(self)weakSelf  =self;
    listView.commentLine =^(TrainCourseDiscussListModel  *model){
        
        [weakSelf commentLineTouch:model];
    };
    
    listView.commentName =^(NSString  *user_id){
        [weakSelf commentNameTouch:user_id];
        
    };
    
    UIView  *line =[[UIView alloc]initWithLineView];
    [self.contentView addSubview:line];
    
    UIView  *supView =self.contentView;
    
    iconImageView.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .topSpaceToView(supView,10)
    .widthIs(30)
    .heightIs(30);
//    iconImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    nameLab.sd_layout
    .leftSpaceToView(iconImageView,10)
    .topEqualToView(iconImageView)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(15);
    
    numLab.sd_layout
    .leftSpaceToView(iconImageView,10)
    .topSpaceToView(nameLab,5)
    .rightSpaceToView(supView,TrainMarginWidth)
    .heightIs(10);
    
//    dateLab.sd_layout
//    .leftSpaceToView(numLab,10)
//    .topSpaceToView(nameLab,5)
//    .rightSpaceToView(supView,TrainMarginWidth)
//    .heightIs(10);
    
    contentLab.sd_layout
    .leftEqualToView(nameLab)
    .topSpaceToView(numLab,10)
    .rightSpaceToView(supView,TrainMarginWidth)
    .autoHeightRatio(0);
    
    listView.sd_layout
    .leftEqualToView(nameLab)
    .rightSpaceToView(supView, TrainMarginWidth)
    .topSpaceToView(contentLab, 10); // 已经在内部实现高度自适应所以不需要再设置高度
    
    
    line.sd_layout
    .leftSpaceToView(supView,TrainMarginWidth)
    .rightSpaceToView(supView,TrainMarginWidth)
    .bottomSpaceToView(supView,1)
    .heightIs(0.7);
}
-(void)titleTouch{
    if (_topicLine) {
        _model.mypost_id = _model.discuss_id;
        _model.myuser_id = _model.user_id;
        
        _topicLine(_model,nil);
    }
}

-(void)commentLineTouch:(TrainCourseDiscussListModel *)model{
    if (_topicLine) {
        
        TrainCourseDiscussListModel *sendModel =model;
        if (model.super_id  && ![model.super_id isEqualToString:@""]) {
            
            sendModel = _model.posts[[model.super_id intValue]];
            
        }
        TrainCourseDiscussModel *mod =[[TrainCourseDiscussModel alloc]init];
        mod.object_id   = sendModel.topic_id;
        mod.user_id     = sendModel.user_id;
        mod.discuss_id  = sendModel.discuss_id;
        mod.isFirst     = sendModel.isFirst;
        mod.myuser_id   = model.user_id;
        mod.mypost_id   = model.discuss_id;
        
        _topicLine(mod,model.full_name);
        
    }
    
}

-(void)commentNameTouch:(NSString *)user_id{
    if (_topicName) {
        _topicName(user_id);
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setModel:(TrainCourseDiscussModel *)model
{
    _model = model;
    
    listView.frame = CGRectZero;
    
    
    [listView setupWithcommentItemsArray:model.posts];
    
    NSString  *imageStr =(model.sphoto)?model.sphoto:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:@"/upload/user/pic"]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"/upload/user/pic/%@",imageStr];
    }
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"user_avatar_default"] options:SDWebImageAllowInvalidSSLCertificates] ;
    
    nameLab.text = model.full_name;
    
    
    if ([model.type isEqualToString:@"Q"]) {
        nameLab.sd_layout.rightSpaceToView(self.contentView,TrainMarginWidth*3);
        rightIconImageView.hidden = NO;
        rightIconImageView.sd_layout
        .rightSpaceToView(self.contentView,TrainMarginWidth)
        .topEqualToView(nameLab)
        .widthIs(15)
        .heightEqualToWidth();

    }else{
        rightIconImageView.hidden = YES;
        nameLab.sd_layout.rightSpaceToView(self.contentView,TrainMarginWidth);
    }
    
    NSString  *string =[NSString stringWithFormat:@"%zi楼     %@",[model.totCount intValue]-_index , model.timeDifference];
    
    numLab.text = string;
    
//    dateLab.text =(model.create_date)?model.create_date:@"";
    contentLab.text = model.content;
    UIView *bottomView;
    if (!model.posts.count ) {
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


@end
