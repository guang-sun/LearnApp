//
//  TrainStringUtil.h
//  SOHUTrain
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TrainStringUtil : NSObject


// 适配iphone 和ipad  
CGFloat trainAutoLoyoutImageSize(CGFloat size);
CGFloat trainAutoLoyoutTitleSize(CGFloat size);


void trainAllowFullScreen(bool full);
NSString * getCacheSize();
void cleanCacheSize();
NSString * trainMd5String(NSString * str);
NSString  *notEmptyStr(NSString  *str);
NSString *trainCenterWithUser_id(NSString  *userId);
bool comparisonStr(NSString *str1 , NSString *str2);


float  calculateFileSizeInUnit( unsigned long long contentLength);

NSString * calculateUnit( unsigned long long contentLength);


/**
 *  字符串是否为空
 */
+ (BOOL)trainIsBlankString:(NSString *)string;

/**
 *  获取字符串的尺寸
 */
+ (CGSize)trainGetStringSize:(NSString *)namestr andMaxSize:(CGSize)maxSize AndLabelFountSize:(CGFloat)fontSize;

/**
 *  后台data 没有中文转码的时候 (直播视频详情  获取直播 hls  处理 )
 */
+ (NSDictionary *)trainDicWithData:(NSData *)data;


/**
 *  处理 html 标签去除  消息  字符串  <p>。。。
 *
 */
+ (NSString *)trainReplaceHtmlCharacter:(NSString *)html;

/**
 *  string  转译
 *
 */
+ (NSString*)trainURLEscapes:(NSString*)urlparameter;

/**
 *  根据日期 获取星座
 *
 *  @param date 格式 @"2012-10-10"
 *
 */
+ (NSString *)trainConstellationFromDate:(NSString *)date;

/**
 *  根据日期 获取距现在多少天
 *
 *  @param date 格式 @"2012-10-10"
 *
 */
+ (NSString *)trainLongTimeBetweenNowWithDate:(NSString *)date;

/**
 *
 * 根据大小 返回字符串
 */
+ (NSString *)trainGetFileSizeWithsize:(float )size;

/**
 获取 手机剩余大下

 */
+ (NSString *)trainGetFreeSize;


/**
 url 拼接上http

 */
+ (NSString  *)traindealSiteHttp:(NSString *)url;
+ (NSString *)getHostFrom:(NSString *)url;

/**
 登陆 失败后 等待时间

 */
+ (NSString *)trainLoginPassDate:(NSDate  *)date;

+ (NSString *)trainGetNewTime;
+ (NSString *)getCurrentDeviceModel;

@end
