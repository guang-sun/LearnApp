//
//  TrainNetWorkClientBase.m
//  SOHUTrain
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainNetWorkClientBase.h"

@interface TrainNetWorkClientBase ()

// 处理 API 请求没有正常返回的错误
// 处理了返回 TRUE，未处理返回 FALSE
- (BOOL)handleNetworkError:(NSError *)error
               withFailure:(defaultFailureBlock)failure;

//// 处理 API 请求正常返回后内容本身的错误，例如 token 过期等公共错误
//// 处理了返回 TRUE，未处理返回 FALSE
//- (BOOL)handleCommonErrorFromResponse:(id)responseObject
//                          withFailure:(defaultFailureBlock)failure;

@end

@implementation TrainNetWorkClientBase


+ (instancetype )client {
    
      return  [[[self class] alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _trainAPIEngine = [[TrainNetWorkAPIEngine alloc] init];
    }
    return self;
}

//-(TrainUserInfo *)trainUserInfo{
//    if ( !_trainUserInfo) {
//        _trainUserInfo = [[TrainUserInfo alloc]init];
//
//    }
//    return _trainUserInfo;
//}




/**
 拼接 /appws/user/....
 
 @param url
 
 @return
 */
- (NSString *)trainCreatBaseURL:(NSString *)url{
    NSString * urlString =[TrainNetWorkConfiguration defaultConfiguration].hostString;
    
    if([urlString isEqualToString:[TrainStringUtil traindealSiteHttp:TrainIpText]] ){
        urlString = [TrainStringUtil traindealSiteHttp:TrainHostText];
    }
    
    if (![TrainStringUtil trainIsBlankString:url] ) {
        return [urlString stringByAppendingString:url];
    }
    return @""  ;
}



-(NSDictionary *)trainAddCommonParameters:(NSDictionary *)dic andUserName:(NSString *)userName{
    
    NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
    if (! TrainDictIsEmpty(dic)) {
        [mudic setDictionary:dic];
    }
    if (TrainStringIsEmpty(userName)) {
//        TrainUser.emp_id;
//        TrainNSLog(@"%@,%@",[TrainUser.emp_id class],TrainUser.emp_id);
        [mudic setObject:notEmptyStr(TrainUser.emp_id) forKey:@"user_id"];
    }else{
        
        [mudic setObject:notEmptyStr(TrainUser.emp_id) forKey:userName];
    }
    
    [mudic setObject:TrainAPPVersions forKey:@"appVersion"];
    [mudic setObject:(@"IOS") forKey:@"systemType"];
    
    return mudic;
    
}

/**
 获取完整url
 
 @param URL
 @param userinfo
 @param params
 
 @return
 */
- (NSString *)trainCreatURLStringWithbaseURL:(NSString *)URL userinfo:(NSString *)userinfo parameters:(NSDictionary  *)params  {
    
    NSMutableString  *baseURL  = [NSMutableString stringWithCapacity:10];
    BOOL  isprefix = NO;
    if (!TrainStringIsEmpty(URL)) {
        [baseURL appendString:URL];
        isprefix = YES;
    }
    
    NSMutableDictionary  *allParams = [NSMutableDictionary new];
    if (params) {
        allParams = [NSMutableDictionary dictionaryWithDictionary:params];
    }
//    if (userinfo && ![userinfo isEqualToString:@""]) {
//        [allParams setObject:notEmptyStr(TrainUser.emp_id) forKey:userinfo];
//    }else {
//        [allParams setObject:notEmptyStr(TrainUser.emp_id) forKey:@"user_id"];
//    }
//
//    [allParams setObject:TrainAPPVersions forKey:@"appVersion"];
//    [allParams setObject:(@"IOS") forKey:@"app"];
    
    NSString  *param = [self queryStringWithDic:allParams prefixed:isprefix];
    [baseURL appendString:param];
    return baseURL;
    
}
- (NSString *)webUrlAddInfoSession:(NSString *)baseUrl{
    NSMutableString  *muUrl  = [baseUrl mutableCopy];
   
    NSURL  *url = [NSURL URLWithString:baseUrl];
    if([url.host isEqualToString:TrainIpText]){
     
        NSArray  *arr = [baseUrl componentsSeparatedByString:url.host];
        if (arr.count > 1) {
            NSString *params  = arr[1];
            NSInteger  local = [params rangeOfString:@"/"].location;
            params = [params substringFromIndex:local];
            muUrl = [NSMutableString stringWithFormat:@"https://%@%@",TrainHostText,params];
        }
        
        
    }
    
    NSMutableDictionary  *allParams = [NSMutableDictionary new];
    [allParams setObject:notEmptyStr(TrainUser.user_id) forKey:@"user_id"];
    [allParams setObject:TrainAPPVersions forKey:@"appVersion"];
    [allParams setObject:(@"IOS") forKey:@"app"];
    NSString  *param = [self queryStringWithDic:allParams prefixed:NO];
    [muUrl appendString:@"&"];
    [muUrl appendString:param];
    return muUrl;
    
}

-(NSString  *)queryStringWithDic:(NSDictionary *)params prefixed:(BOOL)prefixed{
    
    NSMutableString*str=[NSMutableString stringWithCapacity:10];
    
    if(params){
        
        int i=0;
        NSArray*allkeys=[params allKeys];
        for (i=0; i<[allkeys count]; i++) {
            if(i==0 && prefixed){
                [str appendString:@"?"];
            }else if(i>0){
                [str appendString:@"&"];
            }
            NSString*key=[allkeys objectAtIndex:i];
            NSString*value=[params objectForKey:key];
//            [str appendFormat:@"%@=%@",key,trainIsvalidString(value)];
            [str appendFormat:@"%@=%@",key,(value)];
            
        }
        
    }
    return str;
}




#pragma  mark - 请求处理
#pragma  mark 请求的error

- (BOOL)handleNetworkError:(NSError *)error
               withFailure:(defaultFailureBlock)failure
{
    TRAIN_ERROR_CODE apiErrorCode = TRAIN_ERROR_UNKNOWN;

    if (!error)
        return NO;
    
    switch (error.code)
    {
        case -999:
            
            apiErrorCode = TRAIN_ERROR_USER_CANCELED;
            break;
        case -1009:
            
            apiErrorCode = TRAIN_ERROR_NO_NETWORK;
            break;
        case -1001:
            //请求超时
            apiErrorCode = TRAIN_ERROR_NET_TIMEOUT ;
            break;
        case -1004:
            //服务器不通
            apiErrorCode = TRAIN_ERROR_SERVER;
            break;
  
        default:
            break;
    }
    if (failure) {
        failure(apiErrorCode, error.domain);
    }
    return TRUE;
}
#pragma  mark 服务器上的error

- (BOOL)handleCommonErrorFromResponse:(id)responseObject
                          withFailure:(defaultFailureBlock)failure
{
    TRAIN_ERROR_CODE apiErrorCode = TRAIN_ERROR_UNKNOWN;
    
    if (!responseObject)
        return NO;
    
    if ([responseObject allKeys].count <= 1 && ![responseObject[@"status"] boolValue]) {
        
        apiErrorCode = TRAIN_ERROR_SERVER;
        failure(apiErrorCode, @"服务器错误");
        return YES;
    }
   

    return NO;
    
}
#pragma  mark 统一处理

- (TrainAPIFinishedBlock)customFinishedBlock:(BOOL (^)(id resultObject))customHandler
                                withFailure:(defaultFailureBlock)failure
{
    
    return ^void(id resultObject, NSError * error) {
        
      if ([self handleNetworkError:error withFailure:failure])
            return;
        
      if ([self handleCommonErrorFromResponse:resultObject withFailure:failure])
          return;
        
      if (customHandler(resultObject))return;
      failure(TRAIN_ERROR_SERVER, @"服务器错误");
        
    };
}


//检查url字符串是否为空 并进行转义
NSString* trainIsvalidString(NSString*astring){
    
    if (astring) {
        astring=[NSString stringWithFormat:@"%@",astring];
        return  [TrainStringUtil trainURLEscapes:astring];
    }
    return @"";
}


@end
