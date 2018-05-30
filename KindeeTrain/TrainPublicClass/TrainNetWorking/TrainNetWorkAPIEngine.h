//
//  TrainNetWorkAPIEngine.h
//  SOHUTrain
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainMacroDefine.h"
#import "AFNetworking.h"


// 如果请求成功，resultObject 不为空，为返回对象
// 如果请求失败，resultObject 为空，error 为内置的错误信息
typedef void (^TrainAPIFinishedBlock) (id resultObject, NSError * error);

// 上传文件中的进度
typedef void (^TrainAFNProgressBlock) (NSProgress * progress);
// 上传文件中的进度
typedef void (^TrainProgressBlock) (CGFloat   progress);

typedef void (^TrainAFNUploadfileBlock) (id<AFMultipartFormData> formData);


@interface TrainNetWorkAPIEngine : NSObject




/**
 *  普通 HTTP GET 请求，没有进度回调
 *
 *  @param urlString URL
 *  @param finished  请求完成Block
 */
- (void)trainAFNGetRequest:(NSString *)urlString
              finished:(TrainAPIFinishedBlock)finished;

/**
 *  普通 HTTP POST 请求
 *
 *  @param urlString  URL
 *  @param parameters 参数
 *  @param finished   请求完成Block
 */
- (void)trainAFNPostRequest:(NSString *)urlString
             parameters:(id )parameters
               finished:(TrainAPIFinishedBlock)finished;

/**
 post上传文件

 @param urlString      URL
 @param paramesters    参数
 @param uploadData     上传文件data
 @param uploadProgress 上传进度
 @param finished       完成block
 */
- (void)trainAFNUploadRequest:(NSString *)urlString
                parameters:(id )paramesters
                uploadData:(TrainAFNUploadfileBlock)uploadData
            uploadProgress:(TrainAFNProgressBlock)uploadProgress
                  finished:(TrainAPIFinishedBlock)finished;



// 取消当前请求
- (void)trainAFNCancelRequest;



/**
 *  普通 HTTP GET 请求，没有进度回调
 *
 *  @param urlString URL
 *  @param finished  请求完成Block
 */
- (void)trainGetRequest:(NSString *)urlString
               finished:(TrainAPIFinishedBlock)finished;

/**
 *  普通 HTTP POST 请求
 *
 *  @param urlString  URL
 *  @param parameters 参数
 *  @param finished   请求完成Block
 */
- (void)trainPostRequest:(NSString *)urlString
              parameters:(id )parameters
                finished:(TrainAPIFinishedBlock)finished;


/**
 图片上传
 
 @param urlstring  URL
 @param parameters 参数
 @param imageArr   上传图片数组
 @param finished
 @param progress   上传进度
 */
- (void)trainUploadImageRequest:(NSString *)urlstring
                     parameters:(id )parameters
                       imageArr:(NSArray <NSData *> *)imageArr
                       finished:(TrainAPIFinishedBlock)finished
                       progress:(TrainProgressBlock)progress;



// 取消当前请求
- (void)trainCancelRequest;


@end
