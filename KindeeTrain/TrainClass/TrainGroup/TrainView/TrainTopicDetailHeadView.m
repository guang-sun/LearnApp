//
//  TrainTopicDetailHeadView.m
//  KindeeTrain
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import "TrainTopicDetailHeadView.h"

#import "TrainPhotoBrowser.h"
#import "TrainShowImageView.h"


#define trainwebDefaultHeight   30

@interface TrainTopicDetailHeadView ()<UIWebViewDelegate, TrainPhotoBrowserDelegate>
{
//    UIView                      *headBgView;
    BOOL                        isHasKVO;
    float                       headwebHeight;
    UIImageView             *leftIconImageV, *rightAskImageV, *rightTopImageV,
    *rightPrefectImageV;
    
    UIView                  *lineV0 , *lineV1  ,*lineV2, *lineV3,  *lineV4 ;
    UILabel                 *titleLab, *writerLab, *originLab;
    UIButton                *eyeBtn, *replyBtn, *supportBtn, *collectBtn;
    
    NSMutableArray          *_imageArray;

    BOOL                    isMobile;
}
@property (nonatomic, strong) UIWebView     *headWebView;
@property (nonatomic, strong) UIView        *headTopView;
@property (nonatomic, strong) UIView        *headDownView;
@property (nonatomic, strong) UILabel       *contentLab;
@property (nonatomic, strong) TrainShowImageView      *showImageView;
@property (nonatomic, strong) TrainTopicModel     *topicInfo;
@property (nonatomic, copy)   trainGetHeightBlock   headHetghtBlock;

@end


@implementation TrainTopicDetailHeadView


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
      
        [self creatHeadViewUI];
        isMobile = NO;
    }
    
    return self;
}

-(void)creatHeadViewUI{
    
    headwebHeight = trainwebDefaultHeight;

    [self addSubview:self.headTopView];
    [self addSubview:self.headWebView];
    [self addSubview:self.contentLab];
    [self addSubview:self.showImageView];
    [self addSubview:self.headDownView];
    
    
    self.headTopView.sd_layout
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,0)
    .heightIs(trainAutoLoyoutImageSize(60));
    
    leftIconImageV.sd_layout
    .leftSpaceToView(self.headTopView,TrainMarginWidth)
    .topSpaceToView(self.headTopView,10)
    .widthIs(trainAutoLoyoutImageSize(trainIconWidth))
    .heightEqualToWidth();
    
//    leftIconImageV.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    titleLab.sd_layout
    .leftSpaceToView(leftIconImageV,10)
    .rightSpaceToView(self.headTopView,TrainMarginWidth)
    .topSpaceToView(self.headTopView,10)
    .heightIs(trainAutoLoyoutImageSize(20));
    
    originLab.sd_layout
    .leftSpaceToView(leftIconImageV,10)
    .rightSpaceToView(self.headTopView,TrainMarginWidth)
    .topSpaceToView(titleLab,5)
    .heightIs(trainAutoLoyoutImageSize(10));
    
    writerLab.sd_layout
    .leftSpaceToView(leftIconImageV,10)
    .rightSpaceToView(self.headTopView,TrainMarginWidth)
    .topSpaceToView(originLab,5)
    .heightIs(trainAutoLoyoutImageSize(10));
    
    
   
    
 
}


-(void)updateHeadDownView{
    
    CGFloat  width = (TrainSCREENWIDTH -2 * TrainMarginWidth - 6)/4;
    
    lineV0.sd_layout
    .leftSpaceToView(self.headDownView,TrainMarginWidth)
    .rightSpaceToView(self.headDownView,TrainMarginWidth)
    .topEqualToView(self.headDownView)
    .heightIs(1);
    
    
    
    eyeBtn.sd_layout
    .leftSpaceToView(self.headDownView,TrainMarginWidth)
    .topEqualToView(self.headDownView)
    .widthIs(width)
    .heightIs(TrainCLASSHEIGHT);
    
    
    replyBtn.sd_layout
    .leftSpaceToView(eyeBtn,2)
    .topEqualToView(eyeBtn)
    .widthIs(width)
    .heightIs(TrainCLASSHEIGHT);
    
    supportBtn.sd_layout
    .leftSpaceToView(replyBtn,2)
    .topEqualToView(replyBtn)
    .widthIs(width)
    .heightIs(TrainCLASSHEIGHT);
    
    collectBtn.sd_layout
    .leftSpaceToView(supportBtn,2)
    .widthIs(width)
    .topEqualToView(supportBtn)
    .heightIs(TrainCLASSHEIGHT);
    
    lineV2.sd_layout
    .leftSpaceToView(eyeBtn,0)
    .widthIs(1)
    .centerYEqualToView(self.headDownView)
    .heightIs(20);
    
    lineV3.sd_layout
    .leftSpaceToView(replyBtn,0)
    .widthIs(1)
    .centerYEqualToView(self.headDownView)
    .heightIs(20);
    
    lineV4.sd_layout
    .leftSpaceToView(supportBtn,0)
    .widthIs(1)
    .centerYEqualToView(self.headDownView)
    .heightIs(20);
    
    lineV1.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(eyeBtn,0)
    .heightIs(10);

}


-(void)updateViewHeightWith:(TrainTopicModel *)topicModel andGetHeight:(trainGetHeightBlock)getHeight{
    self.topicInfo = topicModel;
    
    
    NSString  *imageStr =(topicModel.sphoto)?topicModel.sphoto:@"";
    NSString  *image ;
    if ([imageStr hasPrefix:@"/upload/user/pic"]) {
        image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
    }else{
        image = [TrainIP stringByAppendingFormat:@"/upload/user/pic/%@",imageStr];
    }
    
    [leftIconImageV sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"user_avatar_default"] options:SDWebImageAllowInvalidSSLCertificates];
    
    isMobile = [topicModel.is_mobile isEqualToString:@"Y"];
    
    NSString  *oriStr =(topicModel.gg_title  && ![topicModel.gg_title isEqualToString:@""])?topicModel.gg_title:@"";
    originLab.text =[NSString  stringWithFormat:@"来源:%@",oriStr];
    NSString *formWhereStr =(isMobile)?@"移动端":@"PC端";

    NSString *writeStr = [NSString stringWithFormat:@"%@    %@   来自 %@",notEmptyStr(topicModel.full_name),notEmptyStr(topicModel.timeDifference) ,formWhereStr];
    
//    writerLab.attributedText = [ writeStr dealwithstring:notEmptyStr(topicModel.full_name) andFont:14.0f andColor:TrainColorFromRGB16(0xFF8A10)];
    writerLab.text = writeStr;
    
    titleLab.text = notEmptyStr(topicModel.title);
    
    [self updateThreeIcon:topicModel];
    
    if (isMobile) {
        
        
       NSArray  *arr =(topicModel.pics.count > 9)?[topicModel.pics subarrayWithRange:NSMakeRange(0, 9)]:topicModel.pics;
        _showImageView.picNetArr = arr;
    
        _contentLab.text = notEmptyStr(topicModel.content);
        
        self.showImageView.picNetArr = arr;
        [self.showImageView updateLayout];

    
    }else{
        
        [self.headWebView loadHTMLString:[topicModel.content dealWithHtmlImgTagAddWidthReturnStr] baseURL:nil];
//[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",TrainIP]]
    }
    [self updateHeadMilldeHeight];
    [self updateHeadDownView];
 
    
    eyeBtn.cusTitle =([topicModel.hit_num intValue]>0)?topicModel.hit_num:@"查看";
    replyBtn.cusTitle =([topicModel.post_num intValue]>0)?topicModel.post_num:@"回复";
    supportBtn.cusTitle =([topicModel.top_num intValue]>0)?topicModel.top_num:@"点赞";
    collectBtn.cusTitle =([topicModel.collect_num intValue]>0)?topicModel.collect_num:@"收藏";
    collectBtn.selected =([topicModel.collected isEqualToString:@"Y"])?YES:NO;
    
    supportBtn.selected =([topicModel.toped isEqualToString:@"Y"])?YES:NO;
//    supportBtn.userInteractionEnabled =!supportBtn.selected;
    
    float  height = 0.0f;
    if (isMobile ) {
        
        [self setupAutoHeightWithBottomView:self.headDownView bottomMargin:0];
        [self.headDownView updateLayout];
        [self updateLayout];

        height = self.frame.size.height;
    }else{
        
        if (headwebHeight > trainwebDefaultHeight ) {
            
            height = headwebHeight + trainAutoLoyoutImageSize(60) +40 + 2 *TrainMarginWidth;

        }else{
            
            height = trainwebDefaultHeight + trainAutoLoyoutImageSize(60) +40 + 2 *TrainMarginWidth;
  
        }
    }
    if ( getHeight) {
        getHeight(height);
    }
    _headHetghtBlock = getHeight;
    
}
-(void)updateThreeIcon:(TrainTopicModel *)model{
    
    BOOL  ispre =([model.is_elite intValue])?YES:NO;
    BOOL  istop =([model.is_stick intValue])?YES:NO;
    BOOL  isAsk =([model.type isEqualToString:@"Q"])?YES:NO;
    
    float  width = 0.0f;
    rightPrefectImageV.hidden   = !ispre;
    rightAskImageV.hidden       = !isAsk;
    rightTopImageV.hidden       = !istop;
    if (ispre) {
        
        rightPrefectImageV.sd_layout
        .rightSpaceToView(self.headTopView,TrainMarginWidth)
        .topEqualToView(titleLab)
        .widthIs(15)
        .heightEqualToWidth();
        width = width + 20.0f ;
        
    }
    
    if (istop) {
        
        rightTopImageV.sd_layout
        .rightSpaceToView(self.headTopView,width + TrainMarginWidth)
        .topEqualToView(titleLab)
        .widthIs(15)
        .heightEqualToWidth();
        width = width + 20.0f ;
        
    }
    
    if (isAsk) {
        rightAskImageV.sd_layout
        .rightSpaceToView(self.headTopView,width + TrainMarginWidth)
        .topEqualToView(titleLab)
        .widthIs(15)
        .heightEqualToWidth();
        width = width + 20.0f ;
        
    }
    titleLab.sd_layout.rightSpaceToView(self.headTopView, width +TrainMarginWidth);
    
}



-(void)updateHeadMilldeHeight{
    
    if (isMobile) {
        
        _contentLab.sd_layout
        .leftSpaceToView(self,TrainMarginWidth)
        .rightSpaceToView(self,TrainMarginWidth)
        .topSpaceToView(self.headTopView,5)
        .autoHeightRatio(0);
        
        self.showImageView.sd_layout
        .leftSpaceToView(self,TrainMarginWidth)
        .topSpaceToView(self.contentLab, 5);
        
        self.headDownView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(self.showImageView,10)
        .heightIs(TrainCLASSHEIGHT + 10);
        
    }else {
        
        self.headWebView.sd_layout
        .leftSpaceToView(self,TrainMarginWidth)
        .rightSpaceToView(self,TrainMarginWidth)
        .topSpaceToView(self.headTopView,5)
        .heightIs(headwebHeight);
        
        self.headDownView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(self.headTopView,10 + headwebHeight)
        .heightIs(TrainCLASSHEIGHT + 10);
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize WebViewSize = [self.headWebView sizeThatFits:CGSizeZero];
        float webViewHeight  = WebViewSize.height;
        if (webViewHeight > trainwebDefaultHeight) {
            headwebHeight = webViewHeight;
            [self updateHeadMilldeHeight];

            if(_headHetghtBlock){
                _headHetghtBlock(headwebHeight + trainAutoLoyoutImageSize(60) +40 + 2 *TrainMarginWidth);
            }
            
        }
    }
}

-(void)dealloc{
    if (isHasKVO) {
        [self.headWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
        
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'";
    [self.headWebView stringByEvaluatingJavaScriptFromString:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0; i < length;i++){img=imgs[i];if(\"ad\" ==img.getAttribute(\"flag\")){var parent = this.parentNode;if(parent.nodeName.toLowerCase() != \"a\")return;}img.onclick=function(){window.location.href='image-preview:'+this.src}}}"];
    [self.headWebView stringByEvaluatingJavaScriptFromString:@"assignImageClickAction();"];
    
    [self.headWebView stringByEvaluatingJavaScriptFromString:str];
    [self getImgs];
    /* 获取网页现有的frame*/
    [self.headWebView sizeToFit];
    
    if (isHasKVO) {
        [self.headWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
    isHasKVO = YES;

    [self.headWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

    
//    float  webViewHeight = [[self.headWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    
//    
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        float  webViewHeight = [[self.headWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//        
//        CGSize WebViewSize = [self.headWebView sizeThatFits:CGSizeZero];
//        float webViewHeight2  = WebViewSize.height;
//        
//        NSLog(@"11111");
//    });

    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];
    
    if ([requestString isEqual:@"about:blank"])
    {
        return true;
    }
    if ([request.URL.scheme isEqualToString: @"image-preview"])
    {
        
        NSString *url = [request.URL.absoluteString substringFromIndex:14];
        
        if ([_imageArray containsObject:url]) {
            if (_imageArray.count != 0) {
                
                TrainPhotoBrowser *browser = [[TrainPhotoBrowser alloc] init];
                browser.imageCount = _imageArray.count; // 图片总数
                browser.currentImageIndex = [_imageArray indexOfObject:url];
                browser.delegate = self;
                [browser show];
                
            }
        }
        return NO;
    }
    
    if (_topicContentTouchBlock) {
        _topicContentTouchBlock(requestString);
    }
    return NO;
    
}


#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(TrainPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"Train_default_image"];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(TrainPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = _imageArray[index];
    return [NSURL URLWithString:urlStr];
}
#pragma mark -- 获取文章中的图片个数
- (NSArray *)getImgs
{
    
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
        NSString *str = [self.headWebView stringByEvaluatingJavaScriptFromString:jsString];
        
        if (trainIsvalidString(str)) {
            NSString  *imageType= [[str componentsSeparatedByString:@"."] lastObject];
            if (![imageType isEqualToString:@"gif"]) {
                [arrImgURL addObject:str];
                
            }
        }
    }
    _imageArray = [NSMutableArray arrayWithArray:arrImgURL];
    
    
    return arrImgURL;
}
- (NSInteger)nodeCountOfTag:(NSString *)tag
{
    
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('%@').length", tag];
    
    int count =  [[self.headWebView stringByEvaluatingJavaScriptFromString:jsString] intValue];
    
    return count;
}

-(void)supportTouch:(UIButton *)btn{
    TrainWeakSelf(self);

    if(supportBtn.selected == NO){
        
        __block NSString  *str = @"";
        [[TrainNetWorkAPIClient client] trainTopicSupportWithtopic_id:self.topicInfo.topic_id Success:^(NSDictionary *dic) {
            
            if ([dic[@"status"] boolValue]) {
                weakself.topicInfo.toped =@"Y";
                btn.selected = YES;
                btn.userInteractionEnabled = NO;
                weakself.topicInfo.top_num =[NSString stringWithFormat:@"%d",[self.topicInfo.top_num intValue]+1];
                supportBtn.cusTitle =([self.topicInfo.top_num intValue]>0)?self.topicInfo.top_num:@"点赞";
                
                str = @"赞一个";
                
                if (weakself.topicTopandCollectBlock) {
                    weakself.topicTopandCollectBlock(str,self.topicInfo);
                }
            }
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            str =@"点赞失败";
            
            if (weakself.topicTopandCollectBlock) {
                weakself.topicTopandCollectBlock(str,nil);
            }
        }];
    }else{
        if(weakself.topicTopandCollectBlock){
            weakself.topicTopandCollectBlock(@"您已经赞过了",nil);
        }
    }
   
    
}
-(void)collectTouch:(UIButton *)btn{
    
    __block NSString  *str = @"";
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainTopicCollectWithtopic_id:self.topicInfo.topic_id Success:^(NSDictionary *dic) {
        
        if ([dic[@"status"] boolValue]) {
            BOOL  btnselect =([weakself.topicInfo.collected isEqualToString:@"Y"])?YES:NO;
            if (!btnselect) {
                weakself.topicInfo.collect_num =[NSString stringWithFormat:@"%d",[weakself.topicInfo.collect_num intValue]+1];
            }else{
                weakself.topicInfo.collect_num =[NSString stringWithFormat:@"%d",[weakself.topicInfo.collect_num intValue]-1];
            }
            weakself.topicInfo.collected =(btnselect)?@"N":@"Y";
            if ([weakself.topicInfo.collected isEqualToString:@"Y"]) {
                str = @"已收藏";
                btn.selected = YES;
                
            }else{
                str = @"已取消收藏";
                btn.selected = NO;
            }
            collectBtn.cusTitle =([self.topicInfo.collect_num intValue]>0)?weakself.topicInfo.collect_num:@"收藏";
            
            if (weakself.topicTopandCollectBlock) {
                weakself.topicTopandCollectBlock(str,weakself.topicInfo);
            }
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        if ([weakself.topicInfo.collected isEqualToString:@"N"]) {
            str = @"收藏失败";
        }else{
            str = @"取消收藏失败";
            
        }
        
        if (weakself.topicTopandCollectBlock) {
            weakself.topicTopandCollectBlock(str,nil);
        }
    }];
    
}

-(UIWebView *)headWebView{
    if (!_headWebView) {
        _headWebView  = [[UIWebView alloc]init];
        _headWebView.delegate  = self;
        _headWebView.scrollView.bounces = NO;
        _headWebView.scrollView.showsHorizontalScrollIndicator = NO;
        _headWebView.scrollView.scrollEnabled = NO;
        _headWebView.backgroundColor = [UIColor grayColor];
//        _headWebView = headWebView;

    }
    return _headWebView;
}

-(UIView *)headTopView{
    if (!_headTopView) {
        
        UIView  *headview = [[UIView alloc]init];
        
        leftIconImageV =[[UIImageView alloc]init];
        leftIconImageV.image =[UIImage imageNamed:@"user_avatar_default"];
        leftIconImageV.contentMode = UIViewContentModeScaleAspectFill;
        leftIconImageV.userInteractionEnabled = YES;
        [headview addSubview:leftIconImageV];
        
        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(topiciconTouch)];
        [leftIconImageV addGestureRecognizer:tap];
        
        
        rightAskImageV =[[UIImageView alloc]init];
        rightAskImageV.image =[UIImage imageNamed:@"Train_Topic_ask"];
        rightAskImageV.hidden =YES;
        [headview addSubview:rightAskImageV];
        
        rightTopImageV =[[UIImageView alloc]init];
        rightTopImageV.image =[UIImage imageNamed:@"Train_Topic_top"];
        rightTopImageV.hidden =YES;
        [headview addSubview:rightTopImageV];
        
        rightPrefectImageV =[[UIImageView alloc]init];
        rightPrefectImageV.image =[UIImage imageNamed:@"Train_Topic_pre"];
        rightPrefectImageV.hidden =YES;
        [headview addSubview:rightPrefectImageV];
        
        titleLab =[[UILabel alloc]creatTitleLabel];
        [headview addSubview:titleLab];
        
        
        writerLab =[[UILabel alloc]creatContentLabel];
//        writerLab.textColor =TrainColorFromRGB16(0xFF8A10);
        [headview addSubview:writerLab];
        
        originLab =[[UILabel alloc]creatContentLabel];
//        originLab.cusFont = 10.f;
//        originLab.textAlignment = NSTextAlignmentRight;
        originLab.textColor = TrainOrangeColor;
        [headview addSubview:originLab];
  
        _headTopView = headview;
        
    }
    return _headTopView;
}

-(UIView *)headDownView{
    if (!_headDownView) {
        
        UIView  *bgView =[[UIView alloc]init];
        
        lineV0 = [[UIView alloc]initWithLineView];
        [bgView addSubview:lineV0];

        
        lineV2 =[[UIView alloc]initWithLine1View];
        [bgView addSubview:lineV2];
        
        lineV3 =[[UIView alloc]initWithLine1View];
        [bgView addSubview:lineV3];
        
        lineV4 =[[UIView alloc]initWithLine1View];
        [bgView addSubview:lineV4];
        
        lineV1 =[[UIView alloc]initWithLine1View];
        lineV1.backgroundColor =[UIColor groupTableViewBackgroundColor];
        [bgView addSubview:lineV1];
        
        eyeBtn =[[UIButton alloc]initImageLeftCustomButton];
        eyeBtn.userInteractionEnabled =NO;
        eyeBtn.image = [UIImage imageSizeWithName:@"Train_Group_eye"];// [UIImage imageNamed:@"Train_Group_eye"];
        [bgView addSubview:eyeBtn];
        
        replyBtn =[[UIButton alloc]initImageLeftCustomButton];
        replyBtn.userInteractionEnabled =NO;
        replyBtn.image = [UIImage imageSizeWithName:@"Train_Group_reply"]; //[UIImage imageNamed:@"Train_Group_reply"];
        [bgView addSubview:replyBtn];
        
        supportBtn =[[UIButton alloc]initImageLeftCustomButton];
        supportBtn.image = [UIImage imageSizeWithName:@"Train_Group_support"];//[UIImage imageNamed:@"Train_Group_support"];
        UIImage *selectImage = [UIImage imageSizeWithName:@"Train_Group_support1"];
        [supportBtn setImage:[selectImage imageTintWithColor:TrainNavColor] forState:UIControlStateSelected];
        [supportBtn addTarget:self action:@selector(supportTouch:)];
        [bgView addSubview:supportBtn];
        
        collectBtn =[[UIButton alloc]initImageLeftCustomButton];
        collectBtn.image = [UIImage imageSizeWithName:@"Train_Collect"];//[UIImage imageNamed:@"Train_Group_Uncollect"];
        [collectBtn setImage: [UIImage imageSizeWithName:@"Train_Group_collect"]forState:UIControlStateSelected];
        [collectBtn addTarget:self action:@selector(collectTouch:)];
        [bgView addSubview:collectBtn];
        
       

        _headDownView = bgView;
        
    

    }
    return _headDownView;
}

-(void)topiciconTouch{
    
//    if (_topicIconTouchBlock) {
//        _topicIconTouchBlock(self.topicInfo.user_id);
//    }
    
}

-(UILabel *)contentLab{
    if (!_contentLab) {
        UILabel  *lable = [[UILabel alloc]creatContentLabel];
        lable.textColor = TrainContentColor;
        _contentLab  =lable;
    }
    return _contentLab;
}

-(TrainShowImageView *)showImageView{
    if (!_showImageView) {
        TrainShowImageView  *showImageView =[[TrainShowImageView alloc]init];
        showImageView.userInteractionEnabled = YES;
        _showImageView = showImageView;
    }
    return _showImageView;
}


@end
