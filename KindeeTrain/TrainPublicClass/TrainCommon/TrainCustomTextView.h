//
//  TrainCustomTextView.h
//  SOHUEhr
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainCustomTextView : UITextView

@property (nonatomic, copy) void (^textViewChangeBlock)(NSString  *text);
/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, strong) void(^trainTextHeightChangeBlock)(CGFloat textHeight);
/**
 *  是否自适应高度  默认 NO;
 */
@property (nonatomic, assign) BOOL       isAutolayoutHeight;

/**
 *  设置圆角
 */
@property (nonatomic, assign) NSUInteger cornerRadius;

/**
 *  占位文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;


@end
