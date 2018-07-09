//
//  TrainBaseViewController.m
//  SOHUEhr
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseViewController.h"
//#import "TrainHomeViewController.h"
//#import "TrainSearchResultViewController.h"

@interface TrainBaseViewController ()<MBProgressHUDDelegate>

{
    
    
}
@end

@implementation TrainBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageWithColor:TrainNavColor] forBarMetrics:UIBarMetricsDefault];
    
    self.Train_PopGestureEnabled = YES;
    self.appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    self.view.opaque = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden: NO withAnimation:UIStatusBarAnimationNone];
//    if (!self.appdelegate.navigationC.navigationBgView.hidden) {
//        self.appdelegate.navigationC.navigationBgView.hidden = YES;
//
//    }
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self trainHideHUD];

//    if (self.appdelegate.navigationC.navigationBgView.hidden) {
//        self.appdelegate.navigationC.navigationBgView.hidden = NO;
//    }
    
}


-(void)trainShowHUDOnlyActivity{
    
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [TrainProgressHUD showCustomAnimation:@"加载中……" withImgArry:@[] inview:view];
}
-(void)trainShowHUDOnlyText:(NSString *)title {
    [TrainProgressHUD showMsgWithoutView:title];
    
}
-(void)trainShowHUDOnlyText:(NSString *)title andoff_y:(CGFloat )off_y{
    
    [TrainProgressHUD showMsgWithoutView:title];
    [TrainProgressHUD shareinstance].hud.offset = CGPointMake(0, off_y);
    
}

-(void)trainShowHUDNetWorkError{
    
    
    [TrainProgressHUD showMsgWithoutView:TrainNetWorkError];
    [TrainProgressHUD shareinstance].hud.offset = CGPointMake(0, 150.f);
    
}

-(void)trainHideHUD{
    
    [TrainProgressHUD hide];
    
}
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [TrainProgressHUD hide];
    
}


-(void)creatLeftpopViewWithaction:(SEL)action{
    
    UIButton  *backBtn  =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
    
    [backBtn setImage:[UIImage imageNamed:@"Train_back_default"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"Train_back_highlight"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    if(iOS_Version > 7){
//
//        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 13);
//    }
//
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}


-(void)dealloc{
    TrainNSLog(@"---dealloc ---%@----",[self class]);
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
