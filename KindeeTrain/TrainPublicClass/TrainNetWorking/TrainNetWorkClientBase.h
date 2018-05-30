//
//  TrainNetWorkClientBase.h
//  SOHUTrain
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainNetWorkAPI.h"
#import "TrainCommonMacro.h"

typedef NS_ENUM(NSInteger)
{
    TRAIN_ERROR_UNKNOWN       = 0,       //未知错误
    TRAIN_ERROR_NO_NETWORK    = 1,      //无网络
    TRAIN_ERROR_USER_CANCELED = 2,      //用户取消
    TRAIN_ERROR_NET_TIMEOUT   = 3,      //超时
    TRAIN_ERROR_SERVER        = 4       //服务器错误
}TRAIN_ERROR_CODE;

typedef void (^defaultFailureBlock)(NSInteger errorCode, NSString * errorMsg);
typedef void (^defaultSuccessBlock)(NSDictionary *dic);
typedef void (^defaultProgressBlock)(CGFloat progress);

@interface TrainNetWorkClientBase : NSObject

//@property (nonatomic, strong)  TrainUserInfo   *trainUserInfo;

@property (nonatomic, strong) TrainNetWorkAPIEngine * trainAPIEngine;

// 生成一个 client
+ (instancetype)client;



- (TrainAPIFinishedBlock)customFinishedBlock:(BOOL(^)(id resultObject))customBlock
                                 withFailure:(defaultFailureBlock)failure;

/**
 拼接/appws/user/....
 
 @param url
 
 @return
 */
- (NSString *)trainCreatBaseURL:(NSString *)url;

// afn  add 个人信息 session
-(NSDictionary *)trainAddCommonParameters:(NSDictionary *)dic andUserName:(NSString *)userName;

/**
 获取完整url
 
 @param URL
 @param userinfo
 @param params
 
 @return
 */
- (NSString *)trainCreatURLStringWithbaseURL:(NSString *)URL userinfo:(NSString *)userinfo parameters:(NSDictionary  *)params;
//

/**
 webUrl add 个人信息 session
 
 @param baseUrl
 
 @return
 */
- (NSString *)webUrlAddInfoSession:(NSString *)baseUrl;


// 字符转译
NSString* trainIsvalidString(NSString*astring);

@end
