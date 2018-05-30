//
//  TrainImageButton.h
//   KingnoTrain
//
//  Created by apple on 16/12/7.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){

    TrainImageLocationLeft =0,
    TrainImageLocationRight  ,
    
}TrainImageLocation;

typedef void (^buttonTapBlock)( UIButton *sender);

@interface TrainImageButton : UIButton
@property(nonatomic ,strong) UIImage             *cusimage;
@property(nonatomic ,strong) NSString            *textTitle;
@property(nonatomic ,copy)   buttonTapBlock      touchAction;

/** image的布局位置*/
@property(nonatomic ,assign) TrainImageLocation  imageLocation;
/** image的大小 默认 20 * 20*/
@property(nonatomic ,assign) CGSize              imageSize;

-(instancetype)initWithFrame:(CGRect)frame andImage:(UIImage  *)image andTitle:(NSString *)title;

@end
