//
//  NSString+TrainStringColor.h
//  SOHUTrain
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TrainStringColor)

/*
 *字符串 中如果存在 str 则变成红色
 *
 */
- (NSMutableAttributedString *)dealwithstring:(NSString *)str andFont:(CGFloat )font;

/**
 *  处理字符串
 *
 *  @param str   需要处理的str
 *  @param font  处理后大小
 *  @param color 处理后颜色
 */
- (NSMutableAttributedString *)dealwithstring:(NSString *)str andFont:(CGFloat )font andColor:(UIColor *)color;

- (NSString *)trainReplaceHtmlCharacter;
/**
 *  处理字符串 将html中图片加入 width设置
 *
 *  @param str   需要处理的str
 
 */
-(NSMutableAttributedString *)dealWithHtmlImgTagAddWidth;
/**
 *  处理字符串 将html中图片加入 width设置
 *
 *  @param str   需要处理的str
 
 */
-(NSString *)dealWithHtmlImgTagAddWidthReturnStr;


@end
