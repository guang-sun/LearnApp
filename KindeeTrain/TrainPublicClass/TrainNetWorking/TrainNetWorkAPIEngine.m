//
//  TrainNetWorkAPIEngine.m
//  SOHUTrain
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainNetWorkAPIEngine.h"


#define KBoundary  @"TrainKBoundary"
typedef void (^trainEngineBlock)(CGFloat progress);

@interface TrainNetWorkAPIEngine ()<NSURLSessionDelegate>

@property (nonatomic, strong) AFHTTPSessionManager      *manager;
//@property(nonatomic, strong) NSURLSessionDataTask     *dataTask;
@property(nonatomic, strong) NSURLSessionDataTask       *dataTask;
@property(nonatomic, strong) NSURLSession               *requstSession;

@property(nonatomic, strong) NSURLSessionUploadTask     *uploadTask;

@property(nonatomic, copy) __block  trainEngineBlock    progressBlock;

@end

@implementation TrainNetWorkAPIEngine




- (void)trainAFNGetRequest:(NSString *)urlString finished:(TrainAPIFinishedBlock)finished{
    TrainNSLog(@"path == %@ ==GET",urlString);

    [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        TrainNSLog(@"dic==>>%@",responseObject);

        finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        TrainNSLog(@"error==>>%@",error);

        finished(nil,error);
        
    }];
    
   
   
}

- (void)trainAFNPostRequest:(NSString *)urlString parameters:(id )parameters finished:(TrainAPIFinishedBlock)finished{
    TrainNSLog(@"path == %@?%@ ===POST",urlString,parameters);

    [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        TrainNSLog(@"dic==>>%@",responseObject);
        finished(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TrainNSLog(@"error==>>%@",error);
        finished(nil,error);
        
    }];

}

- (void)trainAFNUploadRequest:(NSString *)urlString
                parameters:(id )paramesters
                uploadData:(TrainAFNUploadfileBlock)uploadData
            uploadProgress:(TrainAFNProgressBlock)uploadProgress
                  finished:(TrainAPIFinishedBlock)finished{

    [self.manager POST:urlString parameters:paramesters constructingBodyWithBlock:uploadData progress:^(NSProgress * _Nonnull uploadProgress1) {
        
        uploadProgress(uploadProgress1);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
    }];
    
}

- (void)trainAFNCancelRequest{
  
    [self.manager.operationQueue cancelAllOperations];

    
//    if (self.dataTask) {
//        [self.dataTask cancel];
//        self.dataTask = nil;
//    }
    
    
}
-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        AFHTTPSessionManager  *afManager = [AFHTTPSessionManager manager];
//        afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置服务器允许的请求内容
        afManager.requestSerializer.timeoutInterval = 15;
        afManager.requestSerializer.allowsCellularAccess = YES;
        afManager.requestSerializer.HTTPShouldHandleCookies = YES;
        afManager.requestSerializer.HTTPShouldUsePipelining = NO;
        afManager.requestSerializer.cachePolicy         = NSURLRequestUseProtocolCachePolicy;

        
        afManager.responseSerializer = [AFJSONResponseSerializer serializer];
        afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        

        _manager = afManager;
        
    }
    return _manager;
}

// 系统 nsurlsession
- (void)trainBaseRequestMethod:(NSString *)httpMethod andUrl:(NSString *)url andParameters:(id )parameters andFinish:(TrainAPIFinishedBlock )finished{
    

    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    if ([httpMethod isEqualToString:@"GET"]) {
        request.HTTPMethod = @"GET";
    }else if([httpMethod isEqualToString:@"POST"]){
        request.HTTPMethod = @"POST";
        if ([parameters isKindOfClass:[NSString class]]) {
            request.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    TrainWeakSelf(self);
    
    self.dataTask =[self.requstSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:nil];
            if (!result) {
                result = [TrainStringUtil  trainDicWithData:data];
            }
            TrainNSLog(@"Train: dic = %@\n error =%@",result,error);
          
            if(TrainDictIsEmpty(result)){
                finished(nil,error);
                
            }else{
                if (finished) {
                    finished(result,error);
                }
            }
            
        }else {
            if (finished) {
                finished(nil,error);
            }
        }
        
        [weakself deleteCookie];
        
    }];
    [self.dataTask resume];
    
    
}
-(void)deleteCookie{
    NSHTTPCookieStorage * storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie * cookie in storage.cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//        NSLog(@"dddd-==%@",cookie.properties);
    }
  
   
}
//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
// completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
//    NSLog(@"证书认证");
//    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString: NSURLAuthenticationMethodServerTrust]  ) {
//    
//        do
//        {
//            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
//            NSCAssert(serverTrust != nil, @"serverTrust is nil");
//            if(nil == serverTrust)
//                break; /* failed */
//            /**
//             *  导入多张CA证书（Certification Authority，支持SSL证书以及自签名的CA），请替换掉你的证书名称
//             */
//            NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"kindee" ofType:@"cer"];//自签名证书
//            NSData* caCert = [NSData dataWithContentsOfFile:cerPath];
//            
//            NSCAssert(caCert != nil, @"caCert is nil");
//            if(nil == caCert)
//                break; /* failed */
//            
//            SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCert);
//            NSCAssert(caRef != nil, @"caRef is nil");
//            if(nil == caRef)
//                break; /* failed */
//            
//            //可以添加多张证书
//            NSArray *caArray = @[(__bridge id)(caRef)];
//            
//            NSCAssert(caArray != nil, @"caArray is nil");
//            if(nil == caArray)
//                break; /* failed */
//            
//            //将读取的证书设置为服务端帧数的根证书
//            OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
//            NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
//            if(!(errSecSuccess == status))
//                break; /* failed */
//            
//            SecTrustResultType result = -1;
//            //通过本地导入的证书来验证服务器的证书是否可信
////            status = SecTrustEvaluate(serverTrust, &result);
////            if(!(errSecSuccess == status))
////                break; /* failed */
////            NSLog(@"stutas:%d",(int)status);
////            NSLog(@"Result: %d", result);
////            
////            BOOL allowConnect = (result == kSecTrustResultUnspecified) || (result == kSecTrustResultProceed);
////            if (allowConnect) {
////                NSLog(@"success");
////            }else {
////                NSLog(@"error");
////            }
////            
////            /* kSecTrustResultUnspecified and kSecTrustResultProceed are success */
////            if(! allowConnect)
////            {
////                break; /* failed */
////            }
//            
//#if 0
//            /* Treat kSecTrustResultConfirm and kSecTrustResultRecoverableTrustFailure as success */
//            /*   since the user will likely tap-through to see the dancing bunnies */
//            if(result == kSecTrustResultDeny || result == kSecTrustResultFatalTrustFailure || result == kSecTrustResultOtherError)
//                break; /* failed to trust cert (good in this case) */
//#endif
//            
//            // The only good exit point
//            NSLog(@"信任该证书");
//            
//            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
//            return [[challenge sender] useCredential: credential
//                          forAuthenticationChallenge: challenge];
//            
//        }
//        while(0);
//
//    }
//
//    // Bad dog
//    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//    completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,credential);
//    return [[challenge sender] cancelAuthenticationChallenge: challenge];
//}
//

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
//    challenge.protectionSpace.host ;
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust ];
      
//        credential = [NSURLCredential credentialWithUser:TrainUser.user_id password:TrainUser.password persistence:NSURLCredentialPersistenceNone];
        
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}


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
                       progress:(TrainProgressBlock)progress{
    
       NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
    NSString * type=[NSString stringWithFormat:@"multipart/form-data; boundary=%@",KBoundary];
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 20;
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    
    NSData  *data = [self getHttpBodyWithimageArr:imageArr andParams:parameters];
    
    self.uploadTask = [self.requstSession uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        if (data) {
            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:nil];
            if (!result) {
                result = [TrainStringUtil  trainDicWithData:data];
            }
            TrainNSLog(@"Train: dic = %@\n error =%@",result,error);
            
            
            
            if(TrainDictIsEmpty(result)){
                finished(nil,error);
                
            }else{
                if (finished) {
                    finished(result,error);
                }
            }
            
        }else {
            if (finished) {
                finished(nil,error);
            }
        }
    }];
    
    _progressBlock = ^(CGFloat pro){
        if (progress) {
            progress(pro);
        }
    };
    
    [self.uploadTask resume];
    
    
}

- (void)trainGetRequest:(NSString *)urlString finished:(TrainAPIFinishedBlock)finished{
    TrainNSLog(@"path == %@ ==GET",urlString);
    
    [self trainBaseRequestMethod:@"GET" andUrl:urlString andParameters:nil andFinish:finished];
    
}




- (void)trainPostRequest:(NSString *)urlString parameters:(NSString *)parameters finished:(TrainAPIFinishedBlock)finished{
    TrainNSLog(@"path == %@?%@ ===POST",urlString,parameters);
    
    [self trainBaseRequestMethod:@"POST" andUrl:urlString andParameters:parameters andFinish:finished];
}


- (void)trainCancelRequest{
    
    if (self.dataTask) {
        [self.dataTask cancel];
        self.dataTask = nil;
    }
    
    
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
    CGFloat  progress = 0.0f;
    if (totalBytesExpectedToSend > 0) {
        progress = bytesSent * 1.0 / totalBytesSent;
    }
    
    if (_progressBlock) {
        _progressBlock(progress);
    }
    
}

-(NSData *)getHttpBodyWithimageArr:(NSArray *)imageArr andParams:(NSDictionary *)params{
    
    //循环头部信息
    //        -----------------------------2079310075963042894277672019
    //        Content-Disposition: form-data; name="userfile[]"; filename="test.rtf"
    //        Content-Type: application/octet-stream 通用类型
    
    NSMutableData * data=[NSMutableData data];
    
    [imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //获得后缀名..
        //fileName = [NSString stringWithFormat:@"%@.%@",fileName,[filePath lastPathComponent]];
        
        NSMutableString * headerString=[NSMutableString stringWithFormat:@"\r\n--%@\r\n",KBoundary];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@%zi.png", str,idx];
        
        NSString * type=[NSString stringWithFormat:@"Content-Disposition: form-data;name=img; filename=%@\r\n",fileName];
        
        [headerString appendString:type];
        
        //使用通用类型的方法 application/octet-stream  image/png
        [headerString appendFormat:@"Content-Type:application/octet-stream\r\n\r\n"];
        
        
        [data appendData:[headerString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //创建文件内容
        //        NSData * fileData=[NSData dataWithContentsOfFile:filePath];
        
        [data appendData:obj];
        
    }];
    
    
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //文件格式
        
        NSString * parmaterKey=key;
        NSString * parmaterValue=obj;
        NSMutableString * textStr=[NSMutableString stringWithFormat:@"\r\n--%@\r\n",KBoundary];
        
        [textStr appendFormat:@"Content-Disposition: form-data;name=%@\r\n\r\n",parmaterKey];
        
        [data appendData:[textStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //文本内容
        NSData * msgData=[parmaterValue dataUsingEncoding:NSUTF8StringEncoding];
        
        [data appendData:msgData];
        
        
        
    }];
    
    //加入尾部
    NSMutableString * footerString=[NSMutableString stringWithFormat:@"\r\n--%@--",KBoundary];
    
    [data appendData:[footerString dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
    
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [session finishTasksAndInvalidate];
}

- (void)dealloc {
    [self.requstSession invalidateAndCancel];
    
}


-(NSURLSession *)requstSession{
    if (_requstSession == nil) {
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.timeoutIntervalForRequest  = 20;
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue:[NSOperationQueue mainQueue]];
        _requstSession = defaultSession;

    }
    return _requstSession;
}


@end
