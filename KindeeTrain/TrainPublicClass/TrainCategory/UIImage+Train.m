//
//  UIImage+Train.m
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import "UIImage+Train.h"

@implementation UIImage (Train)

- (UIImage *)imageTintWithColor:(UIColor *)color;
{
    

    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageThemeColorWithName:(NSString *)imageName;
{
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageTintWithColor:TrainNavColor];
}

+ (UIImage *)imageSizeWithName:(NSString *)imageName{
   return  [UIImage OriginImage:[UIImage imageNamed:imageName] scaleToSize:CGSizeMake((20), (20))];
}


//-(void)downloadAdImageWithArr:(NSArray *)arr{
//    
//    NSMutableArray  *muArr = [NSMutableArray arrayWithArray:arr];
//    
//    if(arr.count ==0){
//        [self imageSaveSuccess:muArr];
//        return;
//    }
//    
//    for (int  i = 0 ; i < arr.count; i++) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            NSDictionary  *dic =arr[i];
//            
//            NSString *filePath = [self getFilePathWithImage:dic[@"pic"]]; // 保存文件的名称
//            NSLog(@"----%@",filePath);
//            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//                
//                NSString  *string = [NSString stringWithFormat:@"%@%@",TrainWelcomeURL,dic[@"pic"]];
//                
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
//                UIImage *image = [UIImage imageWithData:data];
//                
//                if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
//                    NSLog(@"保存成功");
//                    NSMutableDictionary  *muDic = [NSMutableDictionary  dictionaryWithDictionary:dic];
//                    [muDic setObject:@"1" forKey:@"cache"];
//                    [muArr replaceObjectAtIndex:i withObject:muDic];
//                    [self imageSaveSuccess:muArr];
//                    
//                }else{
//                    NSMutableDictionary  *muDic = [NSMutableDictionary  dictionaryWithDictionary:dic];
//                    [muDic setObject:@"0" forKey:@"cache"];
//                    [muArr replaceObjectAtIndex:i withObject:muDic];
//                    [self imageSaveSuccess:muArr];
//                    NSLog(@"保存失败");
//                }
//            }else{
//                NSMutableDictionary  *muDic = [NSMutableDictionary  dictionaryWithDictionary:dic];
//                [muDic setObject:@"1" forKey:@"cache"];
//                [muArr replaceObjectAtIndex:i withObject:muDic];
//                [self imageSaveSuccess:muArr];
//                
//            }
//            
//        });
//        
//    }
//}
//
//
//
//-(NSString *)getFilePathWithImage:(NSString  *)imageURL{
//    NSString  *imageName = [NSString  stringWithFormat:@"%@.png",trainMd5String(imageURL)];
//    NSString  *Path =[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"learnAdImage"];
//    BOOL   isDir =NO;
//    if (![[NSFileManager defaultManager ] fileExistsAtPath:Path isDirectory:&isDir]) {
//        if (!isDir) {
//            NSString  *Path =[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"learnAdImage"];
//            
//            [[NSFileManager defaultManager ] createDirectoryAtPath:Path withIntermediateDirectories:nil attributes:nil error:nil];
//        }
//    }
//    
//    return [Path stringByAppendingPathComponent:imageName];
//    
//}
//
//
//




//设置图片透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    //    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    CGImageRelease(image.CGImage);
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}


- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    //    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if(width < targetSize.width || height < targetSize.height){
        
        return self;
    }
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width * 1.0;
        CGFloat heightFactor = targetHeight / height * 1.0;
        
        if (widthFactor > heightFactor)
            scaleFactor = heightFactor; // scale to fit height
        else
            scaleFactor = widthFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        //        // center the image
        //        if (widthFactor < heightFactor)
        //        {
        //            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        //        }
        //        else if (widthFactor >= heightFactor)
        //        {
        //            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        //        }
    }
    
    //    UIGraphicsBeginImageContext(targetSize); // this will crop
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(scaledWidth, scaledHeight), NO, [UIScreen mainScreen].scale);
    
    CGRect thumbnailRect = CGRectZero;
    //    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
- (NSData *)compressImageMaxFileSize:(NSInteger)maxFileSize {
    
    NSData *orightData = UIImageJPEGRepresentation(self, 1);
    
    if (orightData.length / 1024.0 < maxFileSize) {
        return orightData;
    }
    
    UIImage  *newSizeImage = [self imageByScalingAndCroppingForSize:[UIScreen mainScreen].bounds.size];
    
    CGFloat compression = 0.9f;
    CGFloat minCompression = 0.2f;
    NSData *imageData = UIImageJPEGRepresentation(newSizeImage, compression);
    while ([imageData length] / 1024.0 > maxFileSize && compression > minCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(newSizeImage, compression);
    }
    
    printf("==> %.2f",imageData.length/1024.0);
    //    UIImage *compressedImage = [UIImage imageWithData:imageData];
    
    return imageData;
}



+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



+ (UIImage *)imageWithlocalName:(NSString *)imageName{
    
    UIImage  *image ;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [UIScreen mainScreen].scale == 2.0) {
        CGImageRef  cgimage = [[UIImage imageWithData:[NSData dataWithContentsOfFile:imageName]] CGImage] ;
       image =  [[UIImage alloc]initWithCGImage:cgimage scale:2.0 orientation:UIImageOrientationUp];
    }else{
       image =  [UIImage imageWithContentsOfFile:imageName];
    }
    return image;
}

@end
