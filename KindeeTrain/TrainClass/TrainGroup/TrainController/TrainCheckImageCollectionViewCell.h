//
//  TrainCheckImageCollectionViewCell.h
//  SOHUEhr
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainCheckImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString  *netImageURL;
@property (nonatomic, strong) UIImage   *locImage;
@property (nonatomic, copy) void (^singleTapGestureBlock)();

@end
