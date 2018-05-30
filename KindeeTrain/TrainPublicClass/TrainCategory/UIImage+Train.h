//
//  UIImage+Train.h
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Train)

- (UIImage *)imageTintWithColor:(UIColor *)color;

+ (UIImage *)imageThemeColorWithName:(NSString *)imageName;

+ (UIImage *)imageSizeWithName:(NSString *)imageName;

+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image ;
+ (UIImage *)imageWithColor:(UIColor *)color;
//+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (NSData *)compressImageMaxFileSize:(NSInteger)maxFileSize;
+ (UIImage *)fixOrientation:(UIImage *)aImage ;
+ (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;

@end
