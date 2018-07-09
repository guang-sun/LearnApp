//
//  UIView+RZNib.h
//  YGProject
//
//  Created by admin on 2017/10/26.
//  Copyright © 2017年 YG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

@interface UIView (RZNib)

+ (UINib *)loadNib;

+ (UINib *)loadNibNamed:(NSString*)nibName;

+ (UINib *)loadNibNamed:(NSString*)nibName bundle:(NSBundle *)bundle;

+ (instancetype)loadInstanceFromNib;

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName;

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner;

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;


@end
