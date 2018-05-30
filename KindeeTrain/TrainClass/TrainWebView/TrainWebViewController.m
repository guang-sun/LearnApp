//
//  TrainWebViewController.m
//   KingnoTrain
//
//  Created by apple on 16/12/2.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainWebViewController.h"
//#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
//#import "LoginViewController.h"
#import <IMYWebView.h>
#import <IMY_NJKWebViewProgress.h>
#import "TrainLoginViewController.h"

@interface TrainWebViewController ()<UIApplicationDelegate,IMYWebViewDelegate,NSURLConnectionDelegate,CAAnimationDelegate>
{
//    NJKWebViewProgress          *_webViewProgress;
//    UIWebView                   *NJwebView;
//    IMYWebView                  *imyWebView;
    //    NSMutableArray              *urlarray;
//    int                         urlindex;
    NSString                    *hourStatus;
    NSString                    *hourScore;
    NSString                    *hourExamTime;
    BOOL                        isAllowFull ;
    
   // https
    BOOL            _authenticated;
//    NSMutableURLRequest    *_currentRequest;
//    NSURLConnection *_currentConnection;
//    NSURLSession    *_currentsession;
    
}
@property (nonatomic, strong) NJKWebViewProgressView      *webViewProgressView;
@property (nonatomic, strong) IMYWebView                  *imyWebView;
@property (nonatomic, strong) NSURLSessionDataTask        *datatask;
@property (nonatomic, strong) NSURLSession                *currentsession;



@end

@implementation TrainWebViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(_isCourse){
        
        [TrainUserDefault setBool:YES forKey:TrainAllowRe];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_isCourse){
        [self saveH5Study];
    }

    [self.webViewProgressView removeFromSuperview];
    self.webViewProgressView = nil;
    [self removeCache];
    [self interfaceOrientation:UIInterfaceOrientationPortrait];

    [TrainUserDefault setBool:NO forKey:TrainAllowRe];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    isAllowFull = NO;

    if (self.navTitle && ![self.navTitle isEqualToString:@""]) {
        self.navigationItem.title = self.navTitle ;
    }
    
        UIButton  *backBtn   = [[UIButton alloc]init];
        backBtn.frame  = CGRectMake(0, 0, 30, 44);
        
        [backBtn setImage:[UIImage imageNamed:@"Train_back_default"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"Train_back_highlight"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(leftGoBack:) forControlEvents:UIControlEventTouchUpInside];
        if(iOS_Version > 7){
            
            backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 13);
        }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
//
    hourStatus =([_hourtype isEqualToString:@"E"])?@"I":@"";
    hourScore  = @"0";
    hourExamTime = @"0";
    
    BOOL  isUrl =  [self.webURL hasPrefix:@"http"];
    if (!TrainStringIsEmpty(self.webURL) && isUrl) {
        [self setUpWebView];

    }else{
        
        [self trainShowHUDOnlyText:@"网址有误,请检查后重试"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self webClose];
        });
    }
    
}


-(void)leftGoBack:(UIButton  *)btn{
    
    if (_hourtype  ) {
        if ([_hourtype isEqualToString:@"E"] || [_hourtype isEqualToString:@"D"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if (_updataHourStatus) {
                _updataHourStatus(hourStatus,hourScore,hourExamTime);
            }
            return;
        }else if([_hourtype isEqualToString:@"WelcomeAd"]){
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            transition.subtype = kCATransitionFromLeft;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
            TrainLoginViewController *loginVC =[[TrainLoginViewController alloc]init];
            [self.navigationController pushViewController: loginVC animated:YES];
            return;
        }
    }else {
        
        if (_isCourse) {
            
            [self webClose];
            
        }else if (self.imyWebView.canGoBack) {
            
            [self.imyWebView goBack];
        
        }else{
            
            [self webClose];
            
        }

    }
    
}

-(void)webClose{
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self saveH5Study];

}

// 调用h5 保存学习记录
- (void)saveH5Study {
    
    [self.imyWebView evaluateJavaScript:@"saveStudy()" completionHandler:^(id obj, NSError *error) {
        NSLog(@"-obj===%@,error==%@",obj,error);

    }];
    
}


-(void)setUpWebView{

 
    [self.view addSubview:self.imyWebView];
 
    [self.navigationController.view addSubview:self.webViewProgressView];

    [self loadWebData];

    [self.imyWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}


-(void)loadWebData{
    
    
    NSMutableURLRequest *request = [self getPostRequest:self.webURL];
    [self.imyWebView loadRequest:request];
}

- (void)viewDidLayoutSubviews {
    
     [UIApplication sharedApplication].statusBarHidden = NO;
    
    CGFloat  navheight ;
    if (TrainSCREENWIDTH > TrainSCREENHEIGHT) {
        navheight = 52.0f   ;
    }else {
        navheight = TrainNavHeight ;
    }
    self.imyWebView.frame  = CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-navheight);
    
}

//强制转屏
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
       
        CGFloat  newProgress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        CGFloat  oldProgress = [[change objectForKey:NSKeyValueChangeOldKey] floatValue];
        if (newProgress > oldProgress) {
            [self.webViewProgressView setProgress:newProgress animated:YES];
        }
    }
}

-(NSMutableURLRequest *)getPostRequest:(NSString *)urlStr{
    
    
    NSMutableURLRequest *request = nil;
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL  *URL = [NSURL URLWithString:encodedString];
    request =[NSMutableURLRequest requestWithURL:URL];

    return request;
    
}



#pragma mark - NSURLConnectionDataDelegate


//-(void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler{
//    _authenticated = YES;
//    [self loadWebData];
//    [session finishTasksAndInvalidate];
//    if (self.datatask) {
//        [self.datatask cancel];
//        self.datatask = nil;
//        [self.currentsession invalidateAndCancel];
//        self.currentsession = nil;
//    }
//}

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
//    [session finishTasksAndInvalidate];
//}

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
////            SecTrustResultType result = -1;
//            //通过本地导入的证书来验证服务器的证书是否可信
//            //            status = SecTrustEvaluate(serverTrust, &result);
//            //            if(!(errSecSuccess == status))
//            //                break; /* failed */
//            //            NSLog(@"stutas:%d",(int)status);
//            //            NSLog(@"Result: %d", result);
//            //
//            //            BOOL allowConnect = (result == kSecTrustResultUnspecified) || (result == kSecTrustResultProceed);
//            //            if (allowConnect) {
//            //                NSLog(@"success");
//            //            }else {
//            //                NSLog(@"error");
//            //            }
//            //
//            //            /* kSecTrustResultUnspecified and kSecTrustResultProceed are success */
//            //            if(! allowConnect)
//            //            {
//            //                break; /* failed */
//            //            }
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


//-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
//    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//    __block NSURLCredential *credential = nil;
//    //    challenge.protectionSpace.host ;
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        _authenticated = YES;
//
//        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        if (credential) {
//            disposition = NSURLSessionAuthChallengeUseCredential;
//        } else {
//            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//        }
//    } else {
//        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//    }
//    
//    if (completionHandler) {
//        completionHandler(disposition, credential);
//    }
//
//}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _authenticated = YES;
    [self loadWebData];
    [connection cancel];
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    //服务器自签名证书
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] && [challenge.protectionSpace.host hasSuffix:@"elearnplus.com"]) {
        _authenticated = YES;

        //基于原始网站的证书签名 建立一个新的凭证
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    }
    else {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    }
}



#pragma mark 网页代理
-(void)webViewDidStartLoad:(IMYWebView *)webView{
//    [self trainShowHUDOnlyActivity];
  
}
-(void)webViewDidFinishLoad:(IMYWebView *)webView{

//    [self trainHideHUD];
    TrainWeakSelf(self);
    [self.imyWebView evaluateJavaScript:@"document.title" completionHandler:^(id object, NSError * error) {
        if (!weakself.navTitle || [weakself.navTitle isEqualToString:@""]) {
            weakself.navigationItem.title =  object;
        }
        
    }];

}

-(void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error{
    //NSURLRequest *request=webView.originRequest;
//    TrainWeakSelf(self);
//    if (![webView canGoBack]) {
        [self trainShowHUDNetWorkError];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakself.navigationController popViewControllerAnimated:YES];
//        });
//    }
}

-(BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    

    self.imyWebView = webView;
    //需要进行登录操作的时候
    if (!_authenticated && [self.webURL hasPrefix:@"https"]) {
        
        
        _authenticated = NO;
//        NSMutableURLRequest *currentRequest = [NSMutableURLRequest requestWithURL:request.URL];

        NSURLConnection  *currCon = [NSURLConnection connectionWithRequest:request delegate:self];
        [currCon start];
//        NSURLSessionDataTask *da = [self.currentsession dataTaskWithRequest:request];
//        [da resume];
        
//        self.datatask =  [self.currentsession  dataTaskWithRequest:request];
//        [self.datatask resume];

        return NO;
    }
    
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@" 报名： %@",requestString);
//    if ([_hourtype isEqualToString:@"E"]) {
//        NSArray *components = [requestString componentsSeparatedByString:@"?"];
//        if (components.count > 1) {
//            NSString *dealStr1 = components[1];
//            NSArray *dealArr1 = [dealStr1 componentsSeparatedByString:@"&"];
//            [dealArr1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSString *dealStr2 = obj;
//                NSArray *dealArr2 = [dealStr2 componentsSeparatedByString:@"="];
//                if(dealArr2.count > 0 && [dealArr2[0] isEqualToString:@"complete_status"]){
//                    hourStatus = dealArr2[1];
//                }else if(dealArr2.count > 0 && [dealArr2[0] isEqualToString:@"score"]){
//                    hourScore = dealArr2[1];
//                }else if(dealArr2.count > 0 && [dealArr2[0] isEqualToString:@"exam_time"]){
//                    hourExamTime = dealArr2[1];
//                }
//
//            }];
//            NSLog(@"%@  %@   %@",hourStatus,hourScore,hourExamTime);
//
//        }
//
//    }
    return YES;
    
  }

- (NSURLSession *)currentsession{
    if (! _currentsession) {
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultConfigObject.timeoutIntervalForRequest  = 20;
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue:[NSOperationQueue mainQueue]];
        _currentsession = defaultSession;
    }
    return _currentsession;
}


-(void)removeCache{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSURLCache* cache = [NSURLCache sharedURLCache];
    
    [cache removeAllCachedResponses];
    
    [cache setDiskCapacity:0];
    
    [cache setMemoryCapacity:0];
    
   
}






-(void)dealloc{
    TrainNSLog(@"--KOV dealloc--")
    [self.imyWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
    
}

-(IMYWebView *)imyWebView{
    if (! _imyWebView) {
        
        IMYWebView *iimyWebView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight)];
        iimyWebView.delegate = self;
        iimyWebView.scalesPageToFit = NO;
//        iimyWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin);
        _imyWebView = iimyWebView;
    }
    return _imyWebView;
}

-(NJKWebViewProgressView *)webViewProgressView{
    if (!_webViewProgressView) {
        CGRect navBounds = self.navigationController.view.bounds;
        CGRect barFrame = CGRectMake(0,60,navBounds.size.width,4);
        _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [_webViewProgressView setProgress:0.01 animated:YES];
    }
    return _webViewProgressView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



//@interface NSURLRequest (NSURLRequestWithIgnoreSSL){
//    
//}
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
//@end
//
//@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host{
//    return YES;
//}
//@end

