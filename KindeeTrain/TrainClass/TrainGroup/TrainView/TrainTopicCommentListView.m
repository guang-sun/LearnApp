//
//  TrainTopicCommentListView.m
//  SOHUEhr
//
//  Created by apple on 16/11/1.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainTopicCommentListView.h"
#import "TrainMacroDefine.h"
#import "TrainGroupAndTopicModel.h"
#import "MLLinkLabel.h"



@interface TrainTopicCommentListView ()<MLLinkLabelDelegate,UIGestureRecognizerDelegate>


@property (nonatomic, strong) NSArray *commentItemsArray;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) NSMutableArray *commentLabelsArray;
//@property (nonatomic, strong) NSMutableArray *commentRemoveBtnArray;



@end


@implementation TrainTopicCommentListView


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
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemsArray.count > originalLabelsCount ? (commentItemsArray.count - originalLabelsCount) : 0;
    
    for (int i = 0; i < needsToAddCount; i++) {
        
        MLLinkLabel *label = [MLLinkLabel new];
        UIColor *highLightColor = TrainColorFromRGB16(0x8290AF);
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.tag =i +originalLabelsCount;
        label.font = [UIFont systemFontOfSize:14];
        label.delegate = self;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
        label.userInteractionEnabled =YES;
        UITapGestureRecognizer  *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lineTap:)];
        tap.delegate =self;
        [label addGestureRecognizer:tap];
        
        
//        UIButton  *button = [self getRemoveBtn];
//        button.tag = i;
//        [self addSubview:button];
//        [self.commentRemoveBtnArray addObject:button];
        
        
    }
    
    for (int i = 0; i < commentItemsArray.count; i++) {
        TrainTopicCommentModel *model = commentItemsArray[i];
        MLLinkLabel *label = self.commentLabelsArray[i];
        label.attributedText = [self generateAttributedStringWithCommentItemModel:model andIndex:i];
    }
}

-(void)lineTap:(UITapGestureRecognizer *)tap{
    
    MLLinkLabel *label = self.commentLabelsArray[tap.view.tag];
    label.backgroundColor = TrainLineColor1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label.backgroundColor =[UIColor clearColor];
    });
    
    if (_topicComLine) {
        TrainTopicCommentModel *model = _commentItemsArray[tap.view.tag];
        _topicComLine(model,tap.view.tag);
    }
    
}


- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}

//- (NSMutableArray *)commentRemoveBtnArray
//{
//    if (!_commentRemoveBtnArray) {
//        _commentRemoveBtnArray = [NSMutableArray new];
//    }
//    return _commentRemoveBtnArray;
//}

- (void)setupWithcommentItemsArray:(NSArray *)commentItemsArray
{
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏所以评论label，然后根据评论个数显示label
        }];
    }
//    if (self.commentRemoveBtnArray.count) {
//        [self.commentRemoveBtnArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
//            [button sd_clearAutoLayoutSettings];
//            button.hidden = YES;
//        }];
//    }
    UIView *lastTopView = [[UIView alloc]init];
    [self addSubview:lastTopView];
    lastTopView.sd_layout
    .leftSpaceToView(self, 8)
    .rightSpaceToView(self, 5)
    .topSpaceToView(self, 0)
    .heightIs(0);
    
    for (int i = 0; i < self.commentItemsArray.count; i++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        label.hidden = NO;
        label.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 5)
        .topSpaceToView(lastTopView, 10)
        .minHeightIs(20)
        .autoHeightRatio(0);
        
        label.isAttributedContent = YES;
//        TrainTopicCommentModel *model = _commentItemsArray[i];
//        BOOL  isManager =(self.pv_flag ==1 || [model.user_id isEqualToString:TrainUser.user_id]);
//        if (isManager) {
//            UIButton *button = (UIButton *)self.commentRemoveBtnArray[i];
//            button.hidden = NO;
//            button.sd_layout
//            .rightSpaceToView(self, 2)
//            .topSpaceToView(lastTopView, 10)
//            .widthIs(20)
//            .heightEqualToWidth();
//            
//            label.sd_layout.rightSpaceToView(self,25);
//        }
        
        lastTopView = label;

    }
    
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
}

//-(UIButton *)getRemoveBtn{
//    
//    UIButton *removeBtn1 = [[UIButton alloc]initCustomButton];
//    removeBtn1.image = TrainscaleImage(@"Train_MyNote_Detele");
//    
//    [removeBtn1 addTarget:self action:@selector(removeTopicPost:)];
//    return removeBtn1;
//}
//
//- (void)removeTopicPost:(UIButton *)btn{
//    
//    if (_topicComRemovePost) {
//        _topicComRemovePost(btn.tag);
//    }
//    
//}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

#pragma mark - private actions

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(TrainTopicCommentModel *)model andIndex:(int)index
{
    NSString *text = model.full_name;
    if (index == 0) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@" :%@", model.content]];
    }else{
        text = [text stringByAppendingString:[NSString stringWithFormat:@" %@", model.content]];
        
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
    if (_topicComName) {
        _topicComName(link.linkValue);
    }
}

@end
