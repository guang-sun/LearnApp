//
//  TrainCourse_CommentListView.m
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCourse_CommentListView.h"

#import "MLLinkLabel.h"

@interface TrainCourse_CommentListView ()<MLLinkLabelDelegate,UIGestureRecognizerDelegate>


@property (nonatomic, strong) NSArray           *commentItemsArray;
@property (nonatomic, strong) NSMutableArray           *AllItemsArray;
@property (nonatomic, strong) UIImageView       *bgImageView;

@property (nonatomic, strong) NSMutableArray    *commentLabelsArray;


@end

@implementation TrainCourse_CommentListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];
    }
    return self;
}
- (void)setupViews
{
    _bgImageView = [UIImageView new];
    UIImage *bgImage = [[UIImage imageNamed:@"Train_LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
    _bgImageView.image = bgImage;
    [self addSubview:_bgImageView];
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(00, 0, 0, 0));
}

- (void)setCommentItemsArray:(NSArray *)commentItemsArray
{
    _commentItemsArray = commentItemsArray;
    
    _AllItemsArray =[NSMutableArray new];
    
    [_commentItemsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainCourseDiscussListModel  *listModel = obj;
        [_AllItemsArray addObject:listModel];
        if (listModel.child_post_list.count>0) {
            [_AllItemsArray  addObjectsFromArray:listModel.child_post_list];
        }
        
    }];
    
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = _AllItemsArray.count > originalLabelsCount ? (_AllItemsArray.count - originalLabelsCount) : 0;
    
    for (int i = 0; i < needsToAddCount; i++) {
        MLLinkLabel *label = [MLLinkLabel new];
        UIColor *highLightColor = TrainColorFromRGB16(0x8290AF);
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.tag = i + originalLabelsCount;
        label.font = [UIFont systemFontOfSize:14];
        label.delegate = self;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
        label.userInteractionEnabled =YES;
        UITapGestureRecognizer  *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lineTap:)];
        tap.delegate =self;
        [label addGestureRecognizer:tap];
        
        
    }
    
    for (int i = 0; i < _AllItemsArray.count; i++) {
        TrainCourseDiscussListModel *model = _AllItemsArray[i];
        MLLinkLabel *label = self.commentLabelsArray[i];
        label.attributedText = [self generateAttributedStringWithCommentItemModel:model ];
    }
}

-(void)lineTap:(UITapGestureRecognizer *)tap{

    MLLinkLabel *label = self.commentLabelsArray[tap.view.tag];
    label.backgroundColor =TrainLineColor1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label.backgroundColor =[UIColor clearColor];
    });
    
    if (_commentLine) {
        
        TrainCourseDiscussListModel *model = _AllItemsArray[tap.view.tag];
  
        _commentLine(model);
        
    }
    
}


- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}

- (void)setupWithcommentItemsArray:(NSArray *)commentItemsArray
{
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏所以评论label，然后根据评论个数显示label
        }];
    }
    
    UIView *lastTopView = [[UIView alloc]init];
    [self addSubview:lastTopView];
    lastTopView.sd_layout
    .leftSpaceToView(self, 8)
    .rightSpaceToView(self, 5)
    .topSpaceToView(self, 0)
    .heightIs(0);
    
    for (int i = 0; i < self.AllItemsArray.count; i++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        label.hidden = NO;
        
        label.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 5)
        .topSpaceToView(lastTopView, 010)
        .autoHeightRatio(0);
        
        label.isAttributedContent = YES;
        lastTopView = label;
    }
    
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

#pragma mark - private actions

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(TrainCourseDiscussListModel *)model
{
    NSString *text = model.full_name;
    if (model.super_id && ![model.super_id isEqualToString:@""]) {
        if (model.isFirst) {
            text = [text stringByAppendingString:[NSString stringWithFormat:@" : %@", model.content]];
        }else{
            text = [text stringByAppendingString:[NSString stringWithFormat:@" %@", model.content]];
            
        }
        
    }else{
        text = [text stringByAppendingString:[NSString stringWithFormat:@" : %@", model.content]];
        
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRange  range =[text rangeOfString:model.full_name];
    
    [attString setAttributes:@{NSLinkAttributeName : model.user_id} range:range];
    
    return attString;
}


#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"%@", link.linkValue);
    if (_commentName) {
        _commentName(link.linkValue);
    }
}


@end
