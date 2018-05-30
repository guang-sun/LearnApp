//
//  TrainPhotoBrowserView.h
//  SOHUEhr
//
//  Created by apple on 16/11/18.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainPhotoBrowserView : UIView

@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) BOOL beginLoadingImage;
//@property (nonatomic, assign) BOOL beginLoadingImage;
//单击回调
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
