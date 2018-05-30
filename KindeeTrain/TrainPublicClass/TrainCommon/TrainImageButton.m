//
//  TrainLeftImageButton.m
//   KingnoTrain
//
//  Created by apple on 16/12/7.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainImageButton.h"

#define margin 5 //偏移量

@interface TrainImageButton (){
    
}

@end

@implementation TrainImageButton



-(instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image andTitle:(NSString *)title {
   
    if (self = [super initWithFrame:frame]) {
        self.cusimage  = image;
        self.textTitle = title;
        [self creatButtonUI];
    }
    return self;
}

-(void)creatButtonUI{
    
//    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //文字居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //文字大小
    self.titleLabel.font = [UIFont systemFontOfSize:TrainTitleFont];
    //文字颜色
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //button的title
    [self setTitle:self.textTitle forState:UIControlStateNormal];
    [self setImage:self.cusimage forState:UIControlStateNormal];
    self.titleLabel.numberOfLines = 0 ;
    self.imageSize = CGSizeMake(20, 20);
    ;    //button的点击事件
    [self addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)handleButton:(UIButton *)sender{
    if (_touchAction) {
        _touchAction(sender);
    }
}

-(void)setCusimage:(UIImage *)cusimage{
    _cusimage = cusimage;
    [self setImage:_cusimage forState:UIControlStateNormal];

}

-(void)setImageSize:(CGSize)imageSize{
    _imageSize = imageSize;
    [self layoutIfNeeded];
}

-(void)setImageLocation:(TrainImageLocation)imageLocation{
    _imageLocation = imageLocation;
    [self layoutIfNeeded];
}

//-(void)setTextTitleColor:(UIColor *)textTitleColor{
//    self sett
//}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    if (! self.cusimage ) {
        return CGRectZero;
    }
    if (TrainStringIsEmpty(self.textTitle)) {
        return contentRect;
    }
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    
    CGFloat imageWidth = (contentRect.size.width > self.imageSize.width) ?  self.imageSize.width : contentRect.size.width;
    CGFloat imageHeight = (contentRect.size.height > self.imageSize.height) ?  self.imageSize.height : contentRect.size.height;
    
    if (imageWidth > imageHeight) {
        imageWidth = imageHeight;
    }else{
        imageHeight = imageWidth;

    }
    self.imageSize = CGSizeMake(imageWidth, imageHeight);

    if (self.imageLocation == TrainImageLocationRight) {
        
        imageX = contentRect.size.width - imageWidth - margin;
        imageY = (contentRect.size.height - self.imageSize.height) / 2.0;
       
    }else{
        imageX =  margin;
        imageY = (contentRect.size.height - self.imageSize.height) / 2.0;
      
    }
    
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
   
    if ( TrainStringIsEmpty(self.textTitle) ) {
        return CGRectZero;
    }
    if (! self.cusimage ) {
        return contentRect;
    }

    CGFloat titleX = margin;
    CGFloat titleY = margin;
    CGFloat titleWidth = 0;
    CGFloat titleHeight = 0;
    
    if (self.imageLocation == TrainImageLocationRight) {

        titleWidth = contentRect.size.width - self.imageSize.width - 3 * margin;
        titleHeight = contentRect.size.height - 2 * margin;
      
        
    }else{
        
        titleX = 2 *margin +self.imageSize.width;
        titleWidth = contentRect.size.width - self.imageSize.width - 3 * margin;
        titleHeight = contentRect.size.height - 2 * margin;
    }
    
    if ((titleHeight < 10)) {
        titleY = 0;
        titleHeight = contentRect.size.height;
    }
    
    return CGRectMake(titleX,titleY, titleWidth, titleHeight);

}

@end
