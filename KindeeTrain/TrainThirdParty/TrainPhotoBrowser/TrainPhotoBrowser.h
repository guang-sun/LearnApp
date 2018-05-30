//
//  TrainPhotoBrowser.h
//  SOHUEhr
//
//  Created by apple on 16/11/18.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrainButton, TrainPhotoBrowser;

@protocol TrainPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(TrainPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(TrainPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

@interface TrainPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView      *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<TrainPhotoBrowserDelegate> delegate;

- (void)show;


@end
