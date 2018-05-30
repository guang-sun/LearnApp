//
//  TrainScanViewController.m
//  SOHUEhr
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainScanViewController.h"
#import "TrainAlertTools.h"
#import "TrainWebViewController.h"

@interface TrainScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    CALayer *capturelayer;
    CALayer *raylayer;
//    NSTimer *timer;

    AVCaptureVideoPreviewLayer * previewlayer;
    UILabel *infotext;
    UIButton *readerbackbutton;
    UIAlertView *scanalert;
    UIAlertView * authoralert;
    UIAlertView * nilalert;
    UILabel *warningString;

}
@property (strong,nonatomic) AVCaptureSession   *session;
@property (strong,nonatomic) NSDictionary       *noteInfo;
@property (strong,nonatomic) NSTimer            *timer;


@end

@implementation TrainScanViewController


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self stop];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫一扫" ;
    [self warningAuthorizationStatus];

    // Do any additional setup after loading the view.
}

- (void)createWarningLabel
{
    warningString = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, TrainSCREENWIDTH)];
    warningString.center = self.view.center;
    warningString.text = TrainScanPermissionText;
    warningString.lineBreakMode = NSLineBreakByCharWrapping;
    warningString.numberOfLines = 0;
    warningString.font = [UIFont systemFontOfSize:13];
    //            warningString.backgroundColor = [UIColor redColor];
    warningString.textColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    warningString.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:warningString];
}
- (void)warningAuthorizationStatus {
    
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied)
    {
        if (!warningString) {
            [self createWarningLabel];
        }
        
        TrainWeakSelf(self);
        [TrainAlertTools showAlertWith:self title:TrainNotCameraText message:TrainScanPermissionText callbackBlock:^(NSInteger btnIndex) {
            if (btnIndex == 0) {
                //跳转到设置-隐私-相机    跳转到设置-隐私：@"prefs:root=Privacy"
                //还没有找到直接跳转到设置-隐私-相机 页面
                
                //系统设置页面
                NSURL *setting = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:setting]) {
                    [[UIApplication sharedApplication]openURL:setting];
                }
                
                //跳转到app相应的设置页面（如果没有系统设置页面没有已经打开，此时在跳转时，则只会进入系统设置页面而不是app相应的设置页面）
                NSString *bundleIdentify = [[NSBundle mainBundle]bundleIdentifier];
                NSString *urlstring = [@"Prefs:root=" stringByAppendingString:bundleIdentify];
                
                NSURL *jumpToUrl = [NSURL URLWithString:urlstring];
                if ([[UIApplication sharedApplication] canOpenURL:jumpToUrl]) {
                    [[UIApplication sharedApplication]openURL:jumpToUrl];
                }
            }else if(btnIndex ==1){
                
                [weakself.navigationController popViewControllerAnimated:YES];

            }
        } cancelButtonTitle:@"设置" destructiveButtonTitle:nil otherButtonTitles:@"取消",nil];
        
        
    }else
    {
        if (warningString) {
            warningString.hidden = YES;
        }
        
        [self startScan];
    }
    
}


-(void)start{
    if (!self.session.isRunning) {
        [self.session startRunning];
        [self.timer fire];
    }
}


-(void)stop{
    if (self.session.isRunning || self.timer.isValid) {
        [self.session stopRunning];
        [self.timer invalidate];
        self.timer=nil;
    }
}


-(void)initSession
{
    // Do any additional setup after loading the view, typically from a nib.
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (input)
    {
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        _session = [[AVCaptureSession alloc]init];
        
        NSString *captureset=AVCaptureSessionPresetHigh;
        if (TrainiPhone5 || TrainiPhone6||TrainiPhone6Plus)
        {
            captureset=AVCaptureSessionPreset1920x1080;
        }
//
        //高质量采集率 AVCaptureSessionPreset1920x1080  AVCaptureSessionPresetHigh
        [_session setSessionPreset:captureset];
        
        [_session addInput:input];
        [_session addOutput:output];
        
        //设置扫码的范围
        [output setRectOfInterest:CGRectMake(0.15,0.15,TrainSCREENWIDTH*0.7/TrainSCREENHEIGHT,0.7)];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
    }
    else
    {
        [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:@"没有发现摄像头" buttonTitle:@"确定" buttonStyle:TrainAlertActionStyleCancel];
       
    }
    
    
    
}

-(void)startScan
{
    if (self.session==nil)
    {
        [self initSession];
    }
    previewlayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    previewlayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    //    previewlayer.frame=self.view.layer.frame;
    previewlayer.frame=CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT - TrainNavHeight);
    //    previewlayer.position=CGPointMake(ScreenWidth/2, ScreenHeight/2);
    [self.view.layer addSublayer:previewlayer];
    
    [self.view addSubview:readerbackbutton];
    
    
    float fx=TrainSCREENWIDTH * 0.15f;
    float fy=TrainSCREENHEIGHT *0.2;
    float fw=TrainSCREENWIDTH *0.7;
    float fh=TrainSCREENWIDTH *0.7;
    capturelayer=[CALayer layer];
    capturelayer.frame=CGRectMake(fx,fy, fw, fh);
    capturelayer.masksToBounds=YES;
    capturelayer.contents=(id)[UIImage imageNamed:@"capture.png"].CGImage;
    [self.view.layer addSublayer:capturelayer];
    
    raylayer=[CALayer layer];
    raylayer.frame=capturelayer.frame;
    raylayer.position=CGPointMake(fw/2, fw/2);
    raylayer.contents=(id)[UIImage imageNamed:@"scan_ray.png"].CGImage;
    [capturelayer addSublayer:raylayer];
    [self.timer fire];
    
    //开始捕获
    [_session startRunning];
    
}

- ( void )captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
         fromConnection:(AVCaptureConnection *)connection
{
    
    if (metadataObjects.count>0)
    {
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex: 0 ];
        [self stop];

        //输出扫描字符串
        NSString *urlstring=metadataObject.stringValue;
        urlstring=[[urlstring componentsSeparatedByString:@"\n"]objectAtIndex:0];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scanDidEnd:) object:urlstring];
        [self performSelector:@selector(scanDidEnd:) withObject:urlstring afterDelay:0.2];
    }
}


-(void)scanDidEnd:(NSString *)urlstring{
    NSURL  *url = [NSURL URLWithString:urlstring];
    
    NSString  *hostURL = [TrainIP lowercaseString];
    
    if ([url.host isEqualToString:TrainIpText] || [url.host isEqualToString:TrainHostText] || [urlstring hasPrefix:hostURL])
    {

        NSString  *strURL  = [[TrainNetWorkAPIClient  alloc] trainWebViewAddEmpidWithBaseURL:urlstring];
        TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
        webVC.webURL = strURL;
        [self.navigationController pushViewController:webVC animated:YES];

    }

    else
    {
        NSString *string = [NSString stringWithFormat:@"你当前访问的不是 学佳 提供的二维码，当前扫描内容为：\n%@,\n是否继续访问",urlstring];
        [TrainAlertTools showAlertWith:self title:@"提示" message:string callbackBlock:^(NSInteger btnIndex) {
            if (btnIndex == 1) {
                NSURL *url=[NSURL URLWithString:urlstring];
                if ( url.host ) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstring]];
                [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
                
            }else{
                [self start];
   
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        }
}

-(void)gotoWebView:(NSString *)urlString{
    [self.session stopRunning];
    [self.timer invalidate];
    self.timer = nil;
//    NSDLog(@"打开二维码详情");
//    @synchronized (_webView) {
//        if (_webView)return;
//        NewsDetailViewController *webView=[[NewsDetailViewController alloc]init];
//        webView.newsDic=[NSMutableDictionary dictionaryWithDictionary: @{@"redirectType":@(1),@"url":urlString}];
//        _webView=webView;
//        [self.navigationController pushViewController:webView animated:YES];
//    }
    
}
-(void)removeScanlayer
{
    [previewlayer removeFromSuperlayer];
    [capturelayer removeFromSuperlayer];
    [infotext removeFromSuperview];
    [readerbackbutton removeFromSuperview];
    
    
}
-(void)removeOutScan
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)moveScanLayer:(NSTimer *)timer
{
    float fw  = TrainSCREENWIDTH * 0.7;
    CGPoint p = raylayer.position;
    raylayer.position=CGPointMake(fw/2, fw/2);
    if (fw/2< p.y )
    {
        p.y = -(fw/2 +30);
        raylayer.position=p;
        
    }else{
        
        p.y += 5;
        [UIView animateWithDuration:0.02 animations:^{
            raylayer.position=p;
        }];
    }
}

-(NSTimer *)timer{
    
    if ( !_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                 target:self
                                               selector:@selector(moveScanLayer:)
                                               userInfo:nil
                                                repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//        [timer fire];
    }
    return _timer;
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
