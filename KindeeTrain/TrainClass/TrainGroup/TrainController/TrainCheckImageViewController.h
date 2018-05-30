//
//  TrainCheckImageViewController.h
//  SOHUEhr
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseViewController.h"

@interface TrainCheckImageViewController : TrainBaseViewController

@property (nonatomic, strong) NSArray<NSData *> *photoArr;     ///< All photos / 所有图片流的数组
@property (nonatomic, assign) NSInteger currentIndex;           ///< Index of the photo user click / 用户点击的图片的索引

/// Return the new selected photos / 返回最新的选中图片数组
@property (nonatomic, copy) void (^returnNewPhotoArrBlock)(NSMutableArray *newSeletedPhotoArr);


@end
