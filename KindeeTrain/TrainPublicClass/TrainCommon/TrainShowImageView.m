//
//  TrainShowImageView.m
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainShowImageView.h"
#import "TrainPhotoBrowser.h"
#import "TrainMacroDefine.h"

@interface TrainShowImageView ()<TrainPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray   *imageViewsArray;
@property (nonatomic, assign) BOOL      isNet;
@property (nonatomic, strong) NSArray   *imageArr;
@property (nonatomic, strong) UILabel   *picLable;

@end
@implementation TrainShowImageView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self cleanCacheImage];
        
    }
    return self;
}

- (void)cleanCacheImage
{
    
    for(UIView *view  in self.subviews){
        [view removeFromSuperview];
    }
    self.imageViewsArray =[NSArray  array];
    
    [self.picLable removeFromSuperview];
    self.picLable = nil;
    
    [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];

    
}
-(void)dealloc{
    TrainNSLog(@"showimage---dealloc===");
}
-(NSArray *)imageViewsArray{
    if ( !_imageViewsArray || _imageViewsArray.count < self.imageArr.count) {
        
        NSMutableArray *temp = [NSMutableArray new];
        
        for (int i = 0; i < self.imageArr.count; i++) {
            UIImageView *imageView = [UIImageView new];
            [self addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];
            [temp addObject:imageView];
        }
        
        _imageViewsArray = [temp copy];
        
    }
    return _imageViewsArray;
}


-(void)setPicNetArr:(NSArray *)picNetArr{
    _imageArr =picNetArr;
    _isNet =YES;
    [self cleanCacheImage];
    [self creatImageView];
}
-(void)setPicLocalArr:(NSArray *)picLocalArr{
    _imageArr =picLocalArr;
    _isNet =NO;
    [self cleanCacheImage];
    [self creatImageView];
    
    
}
-(void)creatImageView{
    
    int  count  = (int)_imageArr.count;
    
    for (long i = count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    
    if (count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_imageArr];
    CGFloat itemH = 0;
    if (count == 1) {
        UIImage *image;
        if(_isNet){
            UIImageView  *imageView1 =[[UIImageView alloc]init];
            imageView1.contentMode = UIViewContentModeScaleAspectFill;
            imageView1.layer.masksToBounds = YES;
            
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]] placeholderImage:[UIImage imageNamed:@"Train_default_image"] options:SDWebImageAllowInvalidSSLCertificates];
            image = imageView1.image;
        }else{
            image =[UIImage imageNamed:_imageArr[0]];
        }
        
        if (image.size.width) {
            itemH =   itemW;
        }
    } else {
        itemH = itemW;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_imageArr];
    CGFloat margin = 5;
    
    [_imageArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;

        if(_isNet){
            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"Train_default_image"] options:SDWebImageAllowInvalidSSLCertificates];
            
        }else{
            imageView.image = [UIImage  imageNamed:obj];
        }
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
        
        if (_imageArr.count == 3 && self.picCount > 3) {
            
            NSString *lanCount =[NSString stringWithFormat:@"共%zi张",self.picCount];
            self.picLable.text = lanCount;
            self.picLable.frame = CGRectMake( itemW - 50, itemW - 20, 48, 18);
            [imageView addSubview:self.picLable];
            
        }
        
        
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}
#pragma mark - private actions

-(UILabel *)picLable{
    if (!_picLable ) {
        UILabel  *lable = [[UILabel alloc]creatContentLabel];
        lable.backgroundColor = [UIColor grayColor];
        lable.textColor = [UIColor whiteColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.adjustsFontSizeToFitWidth = YES;
        _picLable = lable;
        
    }
    return _picLable;
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    return (TrainSCREENWIDTH-30-20)/3;
    //    if (array.count == 1) {
    //        return 160;
    //    } else {
    //        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 100*Scale: 70;
    //        return w;
    //    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count <= 3) {
        return array.count;
    } else if (array.count <= 4) {
        return 2;
    } else {
        return 3;
    }
    
}


- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    //启动图片浏览器
    TrainPhotoBrowser *browser = [[TrainPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.imageArr.count; // 图片总数
    browser.currentImageIndex = imageView.tag;
    browser.delegate = self;
    [browser show];
    
}


#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(TrainPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(TrainPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.imageArr[index];
    return [NSURL URLWithString:imageName];
}



@end
