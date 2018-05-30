//
//  UIButton+Train.h
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainMacroDefine.h"

@interface UIButton (Train)
@property(nonatomic,copy)   NSString *cusTitle;
@property(nonatomic,copy)   NSString *cusSelectTitle;
@property(nonatomic,strong) UIColor  *cusTitleColor;
@property(nonatomic,strong) UIImage  *image;
@property(nonatomic,assign) CGFloat  cusFont;
-(id)initCustomButton;
-(id)initWithImageButton;
-(id)initImageLeftCustomButton;

-(void)addTarget:(id)sup action:(SEL)selector;
@end
