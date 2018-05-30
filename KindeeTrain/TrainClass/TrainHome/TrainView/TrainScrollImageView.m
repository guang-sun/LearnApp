//
//  TrainScrollImageView.m
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainScrollImageView.h"


#define pageSize 30

/** 滚动宽度*/
#define ScrollWidth self.frame.size.width

/** 滚动高度*/
#define ScrollHeight self.frame.size.height

@interface TrainScrollImageView ()
<UIScrollViewDelegate>
{
    __weak  UIImageView *_leftImageView,*_centerImageView,*_rightImageView ,*scrollBigV;
    
    __weak  UIScrollView *_scrollView;
    
    __weak  UIPageControl *_PageControl;
    
    
    /** 当前显示的是第几个*/
    NSInteger _currentIndex;
    
    /** 图片个数*/
    NSInteger _MaxImageCount;
    
    /** 是否是网络图片*/
    BOOL _isNetworkImage;
    UILabel               *titleLab;
    
}
@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation TrainScrollImageView


-(instancetype)initWithFrame:(CGRect)frame WithDelay:(NSTimeInterval)delay{
    self =[super initWithFrame:frame];
    if (self) {
        if (delay >0) {
            _AutoScrollDelay =delay;
        }else{
            _AutoScrollDelay =0;
        }
        _imageArray =[NSArray new];
        [self createScrollView];
        _placeholderImage =[UIImage imageNamed:@"lunimageBg"];
        
        
    }
    return self;
}
- (void)createScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    
    /** 开始显示的是第一个   前一个是最后一个   后一个是第二张*/
    _currentIndex = 0;
    
    _scrollView = scrollView;
    
    scrollBigV =[[UIImageView alloc]initWithFrame:CGRectZero];
    scrollBigV.backgroundColor =[UIColor whiteColor];
    [self  addSubview:scrollBigV];
    scrollBigV.hidden =YES;
    
}
-(void)setLocalImageArr:(NSArray *)localImageArr{
    _isNetworkImage =NO;
    NSMutableArray *localimageArray = [NSMutableArray arrayWithCapacity:localImageArr.count];
    for (NSString *imageName in localImageArr) {
        [localimageArray addObject:[UIImage imageNamed:imageName]];
    }
    _imageArray = [localimageArray copy];
    [self setMaxImageCount:_imageArray.count];
    
    
}
-(void)setNetImageArr:(NSArray *)netImageArr{
    _isNetworkImage =YES;
    _imageArray = [netImageArr copy];
    [self setMaxImageCount:_imageArray.count];
}
-(void)setMaxImageCount:(NSInteger)MaxImageCount
{
    _MaxImageCount = MaxImageCount;
    if (_imageArray.count >= 2) {
        _scrollView.contentSize = CGSizeMake(ScrollWidth * 3, 0);
    }else{
        _scrollView.contentSize = CGSizeMake(ScrollWidth , 0);
    }
    [self initImageView];
    [self createPageControl];
    
    if (MaxImageCount>=2) {
        
        
        [self setUpTimer];
        
        [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
        
    }else{
        
        if (_imageArray.count>0) {
            NSString  *imageURL =[TrainIP stringByAppendingString:_imageArray[MaxImageCount-1][@"image"]];
            NSString *str =(_imageArray[MaxImageCount-1][@"title"])?_imageArray[MaxImageCount-1][@"title"]:@"";
            titleLab.text =str;
            [_centerImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:_placeholderImage options:SDWebImageAllowInvalidSSLCertificates];
        }else{
            _centerImageView.image = _placeholderImage;
        }
    }
}
- (void)initImageView {
//    if (_leftImageView || _centerImageView || _rightImageView) {
//        return;
//    }
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScrollWidth, ScrollHeight)];
    centerImageView.contentMode = UIViewContentModeScaleAspectFill;
    centerImageView.layer.masksToBounds = YES;
    
    UIImageView *leftImageView;
    UIImageView *rightImageView;
    if (_imageArray.count>1) {
        
        leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScrollWidth, ScrollHeight)];
        leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        leftImageView.layer.masksToBounds = YES;
        

        rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScrollWidth * 2, 0,ScrollWidth, ScrollHeight)];
        rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        rightImageView.layer.masksToBounds = YES;
        

        centerImageView.frame =CGRectMake(ScrollWidth, 0,ScrollWidth, ScrollHeight);
        
    }
    
    centerImageView.userInteractionEnabled = YES;
    [centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
    
    [_scrollView addSubview:leftImageView];
    [_scrollView addSubview:centerImageView];
    [_scrollView addSubview:rightImageView];
    
    _leftImageView = leftImageView;
    _centerImageView = centerImageView;
    _rightImageView = rightImageView;
}
-(void)imageViewDidTap{
    _tapimageAction(_currentIndex);
}
-(void)createPageControl
{
//    if (titleLab) {
//        return;
//    }
    UIView  *titleBgView =[[UIView alloc]initWithFrame:CGRectMake(0, ScrollHeight-pageSize, ScrollWidth, pageSize)];
    titleBgView.backgroundColor =[UIColor colorWithWhite:0.2 alpha:0.5];
    [self addSubview:titleBgView];
    
    titleLab =[[UILabel alloc]initCustomLabel];
    titleLab.textColor =[UIColor whiteColor];
    titleLab.frame =CGRectMake(10, ScrollHeight-pageSize, ScrollWidth-(_MaxImageCount+2)*15, pageSize);
    [self addSubview:titleLab];
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(ScrollWidth-_MaxImageCount*15,pageSize/3,_MaxImageCount*10, pageSize/3)];
    //设置页面指示器的颜色
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    //设置当前页面指示器的颜色
//    TrainColorFromRGB(100, 190, 244)
    pageControl.currentPageIndicatorTintColor = TrainMenuSelectColor;
    pageControl.numberOfPages = _MaxImageCount;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled =NO;
    [titleBgView addSubview:pageControl];
    
    _PageControl = pageControl;
}
#pragma mark - 定时器

- (void)setUpTimer
{
    if (_AutoScrollDelay < 0.5) return;//太快了
    if (_imageArray.count<2)return;
    if (_timer==nil) {
        _timer =[NSTimer scheduledTimerWithTimeInterval:_AutoScrollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
    }
}

- (void)scorll
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +ScrollWidth, 0) animated:YES];
}

#pragma mark - 给复用的imageView赋值

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex
{
    if (_isNetworkImage)
    {
        NSString  *leftStr =_imageArray[LeftIndex][@"image"]?_imageArray[LeftIndex][@"image"]:@"";
        NSString  *LeftimageURL =[TrainIP stringByAppendingString:leftStr];
        
        NSString  *centerStr =_imageArray[centerIndex][@"image"]?_imageArray[centerIndex][@"image"]:@"";
        NSString  *centerimageURL =[TrainIP stringByAppendingString:centerStr];
        
        NSString  *rightStr =_imageArray[rightIndex][@"image"]?_imageArray[rightIndex][@"image"]:@"";
        NSString  *rightimageURL =[TrainIP stringByAppendingString:rightStr];
        NSString *str =(_imageArray[centerIndex][@"title"])?_imageArray[centerIndex][@"title"]:@"";
        titleLab.text =str;
        
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:LeftimageURL] placeholderImage:_placeholderImage options:SDWebImageAllowInvalidSSLCertificates];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:centerimageURL] placeholderImage:_placeholderImage options:SDWebImageAllowInvalidSSLCertificates];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:rightimageURL] placeholderImage:_placeholderImage options:SDWebImageAllowInvalidSSLCertificates] ;
        
    }else
    {
        _leftImageView.image = _imageArray[LeftIndex];
        _centerImageView.image = _imageArray[centerIndex];
        _rightImageView.image = _imageArray[rightIndex];
    }
    
    [_scrollView setContentOffset:CGPointMake(ScrollWidth, 0)];
}

#pragma mark - 滚动代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_timer  resumeTimerAfterTimeInterval:_AutoScrollDelay];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer pauseTimer];
}

- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //开始滚动，判断位置，然后替换复用的三张图
    [self changeImageWithOffset:scrollView.contentOffset.x];
}

- (void)changeImageWithOffset:(CGFloat)offsetX
{
    if (offsetX >= ScrollWidth * 2)
    {
        _currentIndex++;
        
        if (_currentIndex == _MaxImageCount-1)
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else if (_currentIndex == _MaxImageCount)
        {
            
            _currentIndex = 0;
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        _PageControl.currentPage = _currentIndex;
        
    }
    
    if (offsetX <= 0)
    {
        _currentIndex--;
        
        if (_currentIndex == 0) {
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else if (_currentIndex == -1) {
            
            _currentIndex = _MaxImageCount-1;
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        
        _PageControl.currentPage = _currentIndex;
    }
}
#pragma mark - set方法，设置间隔时间

- (void)setAutoScrollDelay:(NSTimeInterval)AutoScrollDelay
{
    _AutoScrollDelay =AutoScrollDelay;
    [self setUpTimer];
    
}
#pragma mark - 图片拉伸问题
- (void)cycleScrollViewStretchingWithOffset:(CGFloat)offset
{
    
    CGFloat whpercent = ScrollWidth/ScrollHeight;
    CGFloat height = ScrollHeight - offset;
    CGFloat width = ScrollWidth - offset * whpercent;
    if (offset < 0) {
        [_timer pauseTimer];
        scrollBigV.hidden = NO;
        scrollBigV.image =_centerImageView.image;
        scrollBigV.frame = CGRectMake(offset, offset, width, height);
    } else {
        [_timer resumeTimerAfterTimeInterval:_AutoScrollDelay];
        scrollBigV.hidden = YES;
        
        
    }
}
-(void)dealloc{
    [self removeTimer];
}



@end
