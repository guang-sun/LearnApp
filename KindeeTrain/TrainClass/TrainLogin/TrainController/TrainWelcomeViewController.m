//
//  TrainWelcomeViewController.m
//   KingnoTrain
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainWelcomeViewController.h"

#import "TrainWebViewController.h"
#import "TrainLoginViewController.h"

#define  ImageFilePath   [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"welcomeImage.jpg"]
#define  Iphone4ImagePath  [[NSBundle mainBundle]pathForResource:@"Welcom_White_4s" ofType:@"png"]
#define  Iphone5ImagePath  [[NSBundle mainBundle]pathForResource:@"Welcom_White_5" ofType:@"png"]
#define  Iphone6ImagePath  [[NSBundle mainBundle]pathForResource:@"Welcom_White_6" ofType:@"png"]
#define  Iphone6pImagePath  [[NSBundle mainBundle]pathForResource:@"Welcom_White_6p" ofType:@"png"]


@interface TrainWelcomeViewController ()
{
    int                 display_time;
    int                 allTime;
    NSTimer             *timer;
    UIButton            *passBtn;
    BOOL                isTouch;
    UIImageView         *defaultImageView;
    NSDictionary        *AdInfoDic;
    NSDictionary        *NewAdInfoDic;
}

@property(nonatomic,strong) UIScrollView      *scrollView;

@property(nonatomic,strong) NSArray           *adImageArr;
@end

@implementation TrainWelcomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.hidden =YES;
    
    self.navigationController.navigationBar.hidden =YES;
//    self.navBar.trainNavImage = [UIImage imageWithColor:[UIColor clearColor]];
    if (isTouch ) {
        [self passAd];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isTouch = NO;
    NSData *data =[TrainUserDefault objectForKey:TrainWelComeAD];
    if (data) {
        AdInfoDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
    _adImageArr = AdInfoDic[@"startPic"];
    display_time = 1 ;
    allTime = 1;
    if (_adImageArr.count > 0) {
        NSDictionary  *dic =_adImageArr[0];
        allTime = [dic[@"display_time"] intValue] * (int)_adImageArr.count;
        display_time = [dic[@"display_time"] intValue];
    }
    
    defaultImageView =[[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.view addSubview:defaultImageView];

    NSFileManager  *fileManager = [NSFileManager defaultManager];
    if ([fileManager isExecutableFileAtPath:ImageFilePath]) {
        defaultImageView.image = [UIImage imageWithContentsOfFile:ImageFilePath];
    }else{
        NSString  *imagePath = Iphone6ImagePath ;
        if (TrainiPhone5) {
            imagePath =Iphone6pImagePath;
        }else if(TrainiPhone6){
            imagePath =Iphone6ImagePath;
            
        }else if(TrainiPhone6Plus){
            imagePath =Iphone6pImagePath;
        }
        defaultImageView.image = [UIImage  imageWithContentsOfFile:imagePath];
    }
    
    [self creatDefultImageView];

    
    
}


-(void)creatDefultImageView{
    
    UIImageView  *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((TrainSCREENWIDTH-220)/2, 100, 220, 60)];
    logoImageView.image = [UIImage imageNamed:@"Welcome_Logo"];
    
    
    [self.view addSubview:logoImageView];
    
    UIImageView  *LabImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(logoImageView.frame)+20, 200, 200, 60)];
    LabImageView.image = [UIImage imageNamed:@"Welcome_Lab"];
    
    [self.view addSubview:LabImageView];
    
    UIView  *view  =[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(logoImageView.frame)+20, 200, 200, 60)];
    view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:view];
    
    
    [UIView  animateWithDuration:1.5 animations:^{
        
        CGRect  rect = view.frame;
        rect.origin.x += 200;
        view.frame = rect;
        
        
    } completion:^(BOOL finished) {
     
        if (AdInfoDic && _adImageArr.count > 0 ) {
            [self creatADScrollView];
        }else {
            [self passAd];
        }
        
        [self downloadWelcomAD];

    }];
    

}
-(void)downloadWelcomAD{

    if(TrainStringIsEmpty(TrainWelcomeURL)){
       
        return ;
    }
    NSString *url = [TrainStringUtil traindealSiteHttp:TrainWelcomeURL];
    
    [[TrainNetWorkAPIClient client] trainGetWelcomeWithBaseUrl:url Success:^(NSDictionary *dic) {
        if (dic && [dic[@"status"] boolValue]) {
            
            NewAdInfoDic =dic;
            
            if ([NewAdInfoDic[@"startPic"] count] > 0) {
                
                if(!AdInfoDic ||[AdInfoDic[@"version"] intValue] < [NewAdInfoDic[@"version"] intValue]){
                    [self downloadAdImageWithArr:NewAdInfoDic[@"startPic"]];
                }
            }else{
                [self downloadAdImageWithArr:[NSArray new]];
            }
        }

    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
    
}

-(void)creatADScrollView{
    
    defaultImageView.hidden = YES;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, TrainSCREENHEIGHT)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(TrainSCREENWIDTH * _adImageArr.count, 0);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.userInteractionEnabled = NO;
    [self.view addSubview:_scrollView];
    
    
    UIButton  *AllBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, TrainSCREENHEIGHT)];
    [AllBtn addTarget:self action:@selector(AdImagetap)];
    [self.view addSubview:AllBtn];
    
    passBtn = [[UIButton alloc]initCustomButton];
    NSString  *string = [NSString stringWithFormat:@"跳过(%ds)",allTime];
    
    [passBtn setTitle:string forState:UIControlStateNormal];
    [passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    passBtn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    passBtn.frame = CGRectMake(TrainSCREENWIDTH-100, 40, 70, 30);
    [passBtn addTarget:self action:@selector(passAd)];
    passBtn.layer.cornerRadius =15.0f;
    [self.view addSubview:passBtn];
    
    timer = [ NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
    
    if (_adImageArr.count > 0) {
        for (int i = 0; i < _adImageArr.count; i++) {
            UIImageView   *imageview = [[UIImageView alloc]init];
            imageview.frame = CGRectMake(TrainSCREENWIDTH * i, 0, TrainSCREENWIDTH, TrainSCREENHEIGHT);
            NSDictionary *dic =_adImageArr[i];
            imageview.image = [UIImage imageWithContentsOfFile:[self getFilePathWithImage:dic[@"pic"]]];
            [_scrollView addSubview:imageview];
        }
    }else{
        [self passAd];
    }
    
    
    
}
-(void)AdImagetap{
    
    NSInteger   index = _scrollView.contentOffset.x / TrainSCREENWIDTH;
    
    NSDictionary  *dic = _adImageArr[index];
    
    if (![dic[@"url"] isEqualToString:@""]) {
        [timer invalidate];
        timer = nil;
        isTouch = YES;
        TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
        webVC.webURL = dic[@"url"];
        webVC.hourtype = @"WelcomeAd";
        webVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webVC animated:NO];
        
    }
}

-(void)daojishi{
    allTime--;
    NSLog(@"----alltime===%d",allTime);
    
    if(allTime == display_time * 2){
        [_scrollView setContentOffset:CGPointMake(TrainSCREENWIDTH * 1, 0) animated:NO];
    }else if(allTime == display_time * 1){
        [_scrollView setContentOffset:CGPointMake(TrainSCREENWIDTH * (_adImageArr.count - 1), 0) animated:NO];
    }else if(allTime ==0){
        [self passAd];
    }
    NSString  *string = [NSString stringWithFormat:@"跳过(%ds)",allTime];
    [passBtn setTitle:string forState:UIControlStateNormal];
    
}

-(void)passAd{
    [timer invalidate];
    timer = nil;
    
    TrainLoginViewController *loginVC =[[TrainLoginViewController alloc]init];
    [self.navigationController pushViewController: loginVC animated:YES];
   
    
}

-(void)downloadAdImageWithArr:(NSArray *)arr{
    
    NSMutableArray  *muArr = [NSMutableArray arrayWithArray:arr];
    
    if(arr.count ==0){
        [self imageSaveSuccess:muArr];
        return;
    }
    
    for (int  i = 0 ; i < arr.count; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSDictionary  *dic =arr[i];
            
            NSString *filePath = [self getFilePathWithImage:dic[@"pic"]]; // 保存文件的名称
            NSLog(@"----%@",filePath);
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                
                NSString  *string = [NSString stringWithFormat:@"%@%@",TrainWelcomeURL,dic[@"pic"]];
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
                UIImage *image = [UIImage imageWithData:data];
                
                if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
                    NSLog(@"保存成功");
                    NSMutableDictionary  *muDic = [NSMutableDictionary  dictionaryWithDictionary:dic];
                    [muDic setObject:@"1" forKey:@"cache"];
                    [muArr replaceObjectAtIndex:i withObject:muDic];
                    [self imageSaveSuccess:muArr];
                    
                }else{
                    NSMutableDictionary  *muDic = [NSMutableDictionary  dictionaryWithDictionary:dic];
                    [muDic setObject:@"0" forKey:@"cache"];
                    [muArr replaceObjectAtIndex:i withObject:muDic];
                    [self imageSaveSuccess:muArr];
                    NSLog(@"保存失败");
                }
            }else{
                NSMutableDictionary  *muDic = [NSMutableDictionary  dictionaryWithDictionary:dic];
                [muDic setObject:@"1" forKey:@"cache"];
                [muArr replaceObjectAtIndex:i withObject:muDic];
                [self imageSaveSuccess:muArr];
                
            }
            
        });
        
    }
}

-(void)imageSaveSuccess:(NSMutableArray  *)muArr{
    __block  BOOL    isFinish = YES;
    [muArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary  *dic = obj;
        if (!dic[@"cache"] || ![dic[@"cache"] boolValue]) {
            isFinish = NO;
            *stop = YES;
        }
    }];
    if (isFinish) {
        
        [_adImageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary   *dic = obj;
            NSString *filePath = [self getFilePathWithImage:dic[@"pic"]]; // 保存文件的名称
            
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            
        }];
        
        NSArray  *arr = [NSArray  arrayWithArray:muArr];
        NSMutableDictionary  *muDic = [NSMutableDictionary dictionaryWithDictionary:NewAdInfoDic];
        [muDic setObject:arr forKey:@"startPic"];
        NSDictionary *saveDic = [NSDictionary dictionaryWithDictionary:muDic];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:saveDic];
        [TrainUserDefault setObject:data forKey:TrainWelComeAD];
        [TrainUserDefault synchronize];
    }
    
}


-(NSString *)getFilePathWithImage:(NSString  *)imageURL{
    NSString  *imageName = [NSString  stringWithFormat:@"%@.png",trainMd5String(imageURL)];
    NSString  *Path =[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"learnAdImage"];
    BOOL   isDir =NO;
    if (![[NSFileManager defaultManager ] fileExistsAtPath:Path isDirectory:&isDir]) {
        if (!isDir) {
            NSString  *Path =[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"learnAdImage"];
            
            [[NSFileManager defaultManager ] createDirectoryAtPath:Path withIntermediateDirectories:nil attributes:nil error:nil];
        }
    }
    
    return [Path stringByAppendingPathComponent:imageName];
    
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
