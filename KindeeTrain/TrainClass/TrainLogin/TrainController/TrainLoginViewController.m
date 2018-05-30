//
//  TrainLoginViewController.m
//   KingnoTrain
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainLoginViewController.h"
#import "TrainHomeViewController.h"
#import "TrainCourseClassViewController.h"
#import "TrainGroupAndTopicListViewController.h"
#import "TrainDocumentListViewController.h"
#import "TrainMessageListViewController.h"
#import "TrainUserInfo.h"
#define BGVIEWHEIGHT   250

@interface TrainLoginViewController ()<UITextFieldDelegate>
{
    UITextField *userNameTextField; //用户名输入框
    UITextField *passWordTextField; //密码输入框
    UITextField *siteTextField;     //站点输入框
    UIButton * loginButton;          //登陆按钮
    UIView * bgView;                 //背景View
    UIImageView * bgImageView;       //登陆页背景图
    UIImageView * bgLogoView;        //登陆页LOGO
    NSString *currentString;
    UIButton            *isrememberBtn;
    NSString            *needString;
    int                 count;
    UILabel             *promptLabel;
    UIView              *loginBgView;
}
//@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic,strong) NSString         *logintag;
@property (nonatomic,strong) TrainUserInfo    *userInfo;
@property (nonatomic,strong) NSTimer          *timer;

@property (nonatomic,strong) UIButton         *adminLogin;

@end

@implementation TrainLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    if(self.userInfo.isLogin){
        
        [self LoginSuccess];
    }else{
        [self setSubViews];
 
    }

}

-(TrainUserInfo *)userInfo{
    if (! _userInfo) {
        _userInfo = [TrainUserInfo getEncodeData];
    }
    return _userInfo;
}

- (void)setSubViews{
    //背景log

    NSString  *str = [TrainUserDefault objectForKey:@"LOGINSTATUS"];
    if ([str isEqualToString:@"2"]) {
        [self trainShowHUDOnlyText:@"已安全退出"];
        [TrainUserDefault setObject:@"1" forKey:@"LOGINSTATUS"];

    }
    
    bgImageView = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    bgImageView.userInteractionEnabled =YES;
    if (TrainiPhone5) {
        bgImageView.image = [UIImage imageNamed:@"Login_LoginBgImage"];
    }else{
        bgImageView.image = [UIImage imageNamed:@"Login_LoginBgImage"];
    }
    [self.view addSubview:bgImageView];
    
    bgLogoView = [[UIImageView alloc] init];
    bgLogoView.image =[UIImage imageNamed:@"Login_Logo"];
    [bgImageView addSubview:bgLogoView];
    
    bgLogoView.sd_layout
    .centerXEqualToView(bgImageView)
    .widthIs(200)
    .topSpaceToView(bgImageView,(100*TrainScale))
    .heightIs(70);
    
    //登陆页背景
    
    promptLabel=[[UILabel alloc]init];
    promptLabel.text =@"";
    promptLabel.textAlignment =NSTextAlignmentCenter;
    //    promptLabel.hidden =YES;
    promptLabel.numberOfLines =0;
    promptLabel.textColor =[UIColor redColor];
    [bgImageView addSubview:promptLabel];
    promptLabel.sd_layout
    .leftSpaceToView(bgImageView,30)
    .rightSpaceToView(bgImageView,30)
    .topSpaceToView(bgImageView,40)
    .heightIs(50);
    
    NSDate  *date =[TrainUserDefault objectForKey:TrainLoginErrorPass];
    if ([date timeIntervalSinceNow] >0) {
        promptLabel.hidden =NO;
        bgImageView.userInteractionEnabled =NO;
        NSString *time =[TrainStringUtil trainLoginPassDate:date];
        promptLabel.text =[NSString stringWithFormat:@"您已输错3次密码，请稍后再试\n%@",time];
        [self.timer setFireDate:[NSDate date]];
    }
    //输入框 密码框  按钮  背景view
    bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:bgView];
    bgView.sd_layout
    .leftSpaceToView(bgImageView,30)
    .rightSpaceToView(bgImageView,30)
    //    .centerXEqualToView(bgImageView)
    //    .widthIs(300)
    .topSpaceToView(bgLogoView,30)
    .heightIs(BGVIEWHEIGHT);
    
    siteTextField = [[UITextField alloc]init];
    siteTextField.backgroundColor =[UIColor whiteColor];
    siteTextField.layer.cornerRadius =3.0f;
    siteTextField.userInteractionEnabled = YES;
    siteTextField.placeholder = TrainHostText;
    [siteTextField setValue:TrainColorFromRGB16(0xCACACA)
                 forKeyPath:@"_placeholderLabel.textColor"]; //设置placeholder字体颜色
    [siteTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    siteTextField.font = [UIFont boldSystemFontOfSize:14];
    siteTextField.keyboardType = UIKeyboardTypeURL ;
    siteTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    //    siteTextField.autocorrectionType = UIKeyboardTypeASCIICapable;
    siteTextField.returnKeyType = UIReturnKeyNext;
    [siteTextField addTarget:self action:@selector(textfieldTouch) forControlEvents:UIControlEventAllEditingEvents];
    UILabel  *lable1 =[[UILabel alloc]initCustomLabel];
    lable1.frame =CGRectMake(0, 0, 40, 20);
    lable1.cusFont =13.0f;
    lable1.textAlignment=NSTextAlignmentCenter;
    lable1.textColor =TrainColorFromRGB16(0x9E9E9E);
    lable1.text =@"域名";
    siteTextField.leftView =lable1;
    siteTextField.leftViewMode =UITextFieldViewModeAlways;
    //    siteTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    siteTextField.delegate = self;
    [bgView addSubview:siteTextField];
    
    
    userNameTextField = [[UITextField alloc]init];
    
    userNameTextField.backgroundColor =[UIColor whiteColor];
    userNameTextField.layer.cornerRadius =3.0f;
    userNameTextField.userInteractionEnabled = YES;
    userNameTextField.placeholder = @"请输入账号";
    [userNameTextField setValue:TrainColorFromRGB16(0xCACACA)
                     forKeyPath:@"_placeholderLabel.textColor"]; //设置placeholder字体颜色
    [userNameTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    userNameTextField.font = [UIFont boldSystemFontOfSize:14];
    userNameTextField.keyboardType = UIKeyboardTypeAlphabet;
    userNameTextField.autocapitalizationType =UITextAutocapitalizationTypeNone;
    [userNameTextField addTarget:self action:@selector(textfieldTouch) forControlEvents:UIControlEventAllEditingEvents];
    
    userNameTextField.autocorrectionType = UIKeyboardTypeEmailAddress |UIKeyboardTypeNumberPad;
    //    userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameTextField.delegate = self;
    userNameTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    //    userNameTextField.clearsOnBeginEditing =YES;
    userNameTextField.returnKeyType = UIReturnKeyNext;
    UIView  *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_UserName"]];
    image.frame =CGRectMake(10, 0, 20, 20);
    [view addSubview:image];
    userNameTextField.leftView =view;
    userNameTextField.leftViewMode =UITextFieldViewModeAlways;
    
    [bgView addSubview:userNameTextField];
    
    
    //    密码
    passWordTextField = [[UITextField alloc]init];
    [passWordTextField addTarget:self action:@selector(textfieldTouch) forControlEvents:UIControlEventAllEditingEvents];
    
    passWordTextField.backgroundColor =[UIColor whiteColor];
    passWordTextField.layer.cornerRadius =3.0f;
    passWordTextField.userInteractionEnabled = YES;
    passWordTextField.placeholder = @"请输入密码";
    [passWordTextField setValue:TrainColorFromRGB16(0xCACACA)
                     forKeyPath:@"_placeholderLabel.textColor"];
    [passWordTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    passWordTextField.font = [UIFont boldSystemFontOfSize:14];
    passWordTextField.delegate = self;
    passWordTextField.keyboardType = UIKeyboardTypeAlphabet;
    passWordTextField.autocapitalizationType =UITextAutocapitalizationTypeNone;
    passWordTextField.returnKeyType = UIReturnKeyDone;
    UIView  *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    
    UIImageView *image1 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_PassWord"]];
    image1.frame =CGRectMake(10, 0, 20, 20);
    [view1 addSubview:image1];
    UIView  *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    
    UIButton   *button =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    button.image =[UIImage imageNamed:@"Train_Group_eye"];
    [button  setImage:[UIImage imageNamed:@"Login_PassWordeye"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(xianshiMiMa:)];
    button.selected =YES;
    
    [view2 addSubview:button];
    passWordTextField.leftView =view1;
    passWordTextField.leftViewMode =UITextFieldViewModeAlways;
    passWordTextField.rightView =view2;
    passWordTextField.rightViewMode =UITextFieldViewModeWhileEditing;
    
    
    passWordTextField.secureTextEntry = YES;
    [bgView addSubview:passWordTextField];
    
    siteTextField.sd_layout
    .leftSpaceToView(bgView,0)
    .rightSpaceToView(bgView,0)
    .topEqualToView(bgView)
    .heightIs(40);
    
    userNameTextField.sd_layout
    .leftEqualToView(siteTextField)
    .rightEqualToView(siteTextField)
    .topSpaceToView(siteTextField,15)
    .heightRatioToView(siteTextField,1);
    
    passWordTextField.sd_layout
    .leftEqualToView(siteTextField)
    .rightEqualToView(siteTextField)
    .topSpaceToView(userNameTextField,15)
    .heightRatioToView(siteTextField,1);
    
    
    UILabel  *remLab = [[UILabel alloc ]initCustomLabel];
    remLab.cusFont =12.0f;
    remLab.text =@"记住密码";
    remLab.textColor =TrainColorFromRGB16(0xFFFFFF);
    [bgView addSubview:remLab];
    
    
    isrememberBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [isrememberBtn setImage:[UIImage imageNamed:@"Login_UnRem"]
                   forState:UIControlStateNormal];
    [isrememberBtn setImage:[UIImage imageNamed:@"Login_rem"]
                   forState:UIControlStateSelected];

    [isrememberBtn addTarget:self action:@selector(updateIspublic:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:isrememberBtn];
    
    isrememberBtn.selected  = self.userInfo.isRemember ;
   
    if(self.userInfo.site && ![self.userInfo.site isEqualToString:@""])
    {
        siteTextField.text      = self.userInfo.site;

    }else {
        
        siteTextField.text = @"elearnplus.com";

    }
    userNameTextField.text  = self.userInfo.username;

    if (self.userInfo.isRemember ) {
        passWordTextField.text = self.userInfo.password;

    }
    
    
    remLab.sd_layout
    .rightEqualToView(passWordTextField)
    .topSpaceToView(passWordTextField,15)
    .widthIs(50)
    .heightIs(15);
    
    isrememberBtn.sd_layout
    .rightSpaceToView(remLab,10)
    .topEqualToView(remLab)
    .widthIs(15)
    .heightIs(15);
    //    63 117 32
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.userInteractionEnabled =self.userInfo.isRemember;
    loginButton.backgroundColor =(!self.userInfo.isRemember)?[UIColor lightGrayColor]:TrainNavColor;
    //    [loginButton setBackgroundImage:[UIImage imageNamed:@"Login_Login"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:63/255.0 green:117/255.0 blue:32/255.0 alpha:1]] forState:UIControlStateHighlighted];
    
    loginButton.layer.cornerRadius=3.0f;
    loginButton.cusTitle =@"登  录";
    //    loginButton.userInteractionEnabled =NO;
    [loginButton addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bgView addSubview:loginButton];
    
    loginButton.sd_layout
    .leftSpaceToView(bgView,0)
    .rightSpaceToView(bgView,0)
    .topSpaceToView(passWordTextField,50)
    .heightIs(40);
    
    
#ifdef DEBUG
    [bgImageView addSubview: self.adminLogin];


    self.adminLogin.sd_layout
    .leftSpaceToView(bgImageView,0)
    .rightSpaceToView(bgImageView,0)
    .topSpaceToView(bgView,50)
    .heightIs(40);
    
#else

#endif
    
    
    
    //    UIView  *line =[[UIView alloc]init];
    //    line.backgroundColor =[UIColor whiteColor];
    //    [bgImageView addSubview:line];
    //
    //    UILabel  *orLab =[[UILabel alloc]initCustomLabel];
    //    orLab.text =@"或";
    //
    //    orLab.textColor =[UIColor whiteColor];
    //    [bgImageView addSubview:orLab];
    //
    //    UIView  *line1 =[[UIView alloc]init];
    //    line1.backgroundColor =[UIColor whiteColor];
    //    [bgImageView addSubview:line1];
    //
    //
    //    orLab.sd_layout
    //    .centerXEqualToView(bgImageView)
    //    .topSpaceToView(bgView,30)
    //    .widthIs(15)
    //    .heightIs(15);
    //
    //    line.sd_layout
    //    .leftEqualToView(bgView)
    //    .rightSpaceToView(orLab,10)
    //    .centerYEqualToView(orLab)
    //    .heightIs(1);
    //
    //    line1.sd_layout
    //    .leftSpaceToView(orLab,10)
    //    .rightEqualToView(bgView)
    //    .centerYEqualToView(orLab)
    //    .heightIs(1);
    //
    //
    //    UIButton   *scanBtn =[[UIButton alloc]initCustomButton];
    //    scanBtn.layer.borderWidth =1.0f;
    //    scanBtn.layer.borderColor =[UIColor whiteColor].CGColor;
    //    scanBtn.layer.cornerRadius =3.0f;
    //    scanBtn.backgroundColor =[UIColor clearColor];
    //    scanBtn.cusTitle =@"扫描进入系统";
    //    scanBtn.cusTitleColor =[UIColor whiteColor];
    //    [scanBtn addTarget:self action:@selector(scanLogin)];
    //    [bgImageView addSubview:scanBtn];
    //
    //    scanBtn.sd_layout
    //    .centerXEqualToView(bgImageView)
    //    .topSpaceToView(orLab,20)
    //    .widthIs(185)
    //    .heightIs(40);
    
    
    
    
    
}
-(void)updateIspublic:(UIButton *)btn{
    btn.selected =!btn.selected;
    self.userInfo.isRemember = btn.selected;
}
-(void)xianshiMiMa:(UIButton *)btn{
    btn.selected =!btn.selected;
    passWordTextField.secureTextEntry = btn.selected;
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self tap];
    
}

-(void)tap{
    [userNameTextField resignFirstResponder];
    [passWordTextField resignFirstResponder];
    [siteTextField resignFirstResponder];
    
    
    [UIView animateWithDuration:0.5f animations:^{
        bgView.sd_layout.topSpaceToView(bgLogoView,30);
        [bgView updateLayout];
    } completion:^(BOOL finished) {
        bgLogoView.hidden = NO;
    }];
}

-(void)scanLogin{
    
}

#pragma mark textfeild delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    bgLogoView.hidden =YES;
    
    [UIView animateWithDuration:0.3f animations:^{
        bgView.sd_layout.topSpaceToView(bgImageView,50);
        [bgView updateLayout];
    }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == siteTextField) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [userNameTextField becomeFirstResponder];
        });
        
    }else if(textField == userNameTextField){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [passWordTextField becomeFirstResponder];
        });
    }else{
        [self goToLogin];
    }
    
    return YES;
}
-(void)textfieldTouch{
    
    
    
    if ( TrainStringIsEmpty(siteTextField.text )  || TrainStringIsEmpty(userNameTextField.text ) ||  TrainStringIsEmpty (passWordTextField.text )) {
        loginButton.userInteractionEnabled =NO;
        loginButton.backgroundColor =[UIColor grayColor];
    }else{
        loginButton.userInteractionEnabled =YES;
        loginButton.backgroundColor =TrainNavColor;
    }
    
}


-(void)goToLogin{
    [self tap];
    
    [self isUserNameAndPassWord];
    
}
-(void)isUserNameAndPassWord{
   
    
    [self trainShowHUDOnlyActivity];
    NSString *baseUrl ;
    if (notEmptyStr(siteTextField.text)) {
        baseUrl  = [TrainStringUtil getHostFrom:siteTextField.text];
        
    }else{
        baseUrl  = [TrainStringUtil traindealSiteHttp:TrainHostText];

    }
    
    
    
    [[TrainNetWorkAPIClient client] trainloginAppWithBaseUrl:baseUrl userName:notEmptyStr(userNameTextField.text) passWord: notEmptyStr(passWordTextField.text) Success:^(NSDictionary *dic) {
        
        if ([dic[@"status"] boolValue]) {
            
            self.userInfo.isLogin   = YES;
            self.userInfo.site      = baseUrl;
            self.userInfo.username  = userNameTextField.text;
            self.userInfo.password  = (self.userInfo.isRemember)?passWordTextField.text:@"";
            self.userInfo.emp_id    = [dic[@"user_id"] stringValue];
            self.userInfo.full_name = dic[@"full_name"];
            self.userInfo.msg       = dic[@"msg"];
            self.userInfo.photo     = dic[@"photo"];
            self.userInfo.user_id   = [dic[@"user_id"] stringValue];
           
            [TrainUserInfo archVierWithData:self.userInfo];
        
            [self LoginSuccess];
            [self trainHideHUD];
            
        }else {
            
            [self trainShowHUDOnlyText:dic[@"msg"] andoff_y:TrainAlertOff_y];
            
            count++;
            if (count > 2) {
                [self errormorethree];
            }
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        if (errorCode != -1001) {
           
            [self trainShowHUDOnlyText:TrainSiteIPNullText andoff_y:TrainAlertOff_y];
            
        }else{
            [self trainShowHUDOnlyText:TrainNoNetWorkText andoff_y:TrainAlertOff_y];
            
        }

    }];
    
   
}
-(void)passtime{
    NSDate  *date =[TrainUserDefault objectForKey:TrainLoginErrorPass];
    
    if ([date timeIntervalSinceNow] >0) {
        NSString *time =[TrainStringUtil trainLoginPassDate:date];
        promptLabel.text =[NSString stringWithFormat:@"%@\n%@",TrainLoginMoreErrorText,time];
    }else{
        bgImageView.userInteractionEnabled =YES;
        promptLabel.hidden =YES;
        count =0;
        [self.timer invalidate];
        self.timer =nil;
    }
    
}
-(void)errormorethree{
    promptLabel.hidden =NO;
    promptLabel.text =[NSString stringWithFormat:@"%@\n05:00",TrainLoginMoreErrorText];
    
    NSDate  *passdate  =[NSDate dateWithTimeIntervalSinceNow:5*60];
    [TrainUserDefault setObject:passdate forKey:TrainLoginErrorPass];
    [TrainUserDefault synchronize];
    bgImageView.userInteractionEnabled =NO;
    
    [self.timer setFireDate:[NSDate date]];
}
-(void)LoginSuccess{

    AppDelegate *app =[UIApplication sharedApplication].delegate;
    [app goLoginSuccessToHome];
  
    
//        TrainNavigationController *mainNav =[[TrainNavigationController alloc]initWithRootViewController:[[TrainHomeViewController alloc]init]];
//        mainNav.tabBarItem.title =@"首页";
//        mainNav.tabBarItem.image =[UIImage imageNamed:@"Train_Tabbar_Unmain"];
//        mainNav.tabBarItem.selectedImage =[UIImage imageNamed:@"Train_Tabbar_main"];
//        
//        TrainNavigationController  *couseNav =[[TrainNavigationController alloc]initWithRootViewController:[[TrainCourseClassViewController alloc]init]];
//        couseNav.tabBarItem.title =@"课程";
//        couseNav.tabBarItem.image =[UIImage imageNamed:@"Train_Tabbar_Uncouse"];
//        couseNav.tabBarItem.selectedImage =[UIImage imageNamed:@"Train_Tabbar_couse"];
//        
//        TrainNavigationController  *groupNav =[[TrainNavigationController alloc]initWithRootViewController:[[TrainGroupAndTopicListViewController alloc]init]];
//        groupNav.tabBarItem.title =@"圈子";
//        groupNav.tabBarItem.image =[UIImage imageNamed:@"Train_Tabbar_Ungroup"];
//        groupNav.tabBarItem.selectedImage =[UIImage imageNamed:@"Train_Tabbar_group"];
//        
//        TrainNavigationController  *docNav =[[TrainNavigationController alloc]initWithRootViewController:[[TrainDocumentListViewController alloc]init]];
//        docNav.tabBarItem.title =@"文库";
//        docNav.tabBarItem.image =[UIImage imageNamed:@"Train_Tabbar_Undocument"];
//        docNav.tabBarItem.selectedImage =[UIImage imageNamed:@"Train_Tabbar_document"];
//        
//        TrainNavigationController  *mesNav =[[TrainNavigationController alloc]initWithRootViewController:[[TrainMessageListViewController alloc]init]];
//        mesNav.tabBarItem.title =@"资讯";
//        mesNav.tabBarItem.image =[UIImage imageNamed:@"Train_Tabbar_UnMessage"];
//        mesNav.tabBarItem.selectedImage =[UIImage imageNamed:@"Train_Tabbar_Message"];
//        
//        UITabBarController *tabbar =[[UITabBarController alloc]init];
//        tabbar.tabBar.tintColor =TrainNavColor;
//        tabbar.viewControllers =@[mainNav,couseNav,groupNav,docNav,mesNav];
//    
//        AppDelegate *app =[UIApplication sharedApplication].delegate;
//
//        app.window.rootViewController = tabbar;
// 

}


-(NSTimer *)timer{
    if (!_timer) {
        _timer =[NSTimer  scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(passtime) userInfo:nil repeats:YES];
    }
    return _timer;
}


-(UIButton *)adminLogin{
    if (!_adminLogin) {
        _adminLogin = [[UIButton alloc]initCustomButton];
        _adminLogin.cusTitle = @"管理员";
        _adminLogin.backgroundColor = TrainNavColor;
        [_adminLogin addTarget:self action:@selector(adminGotoLogin)];
        _adminLogin.userInteractionEnabled = YES;
    }
    return _adminLogin;
}
-(void)adminGotoLogin{
//
    siteTextField.text = @"https://demo.elearnplus.com";
    userNameTextField.text = @"test_admin";
    passWordTextField.text = @"888888";
    
//    siteTextField.text = @"https://elearnplus.com";
//    userNameTextField.text = @"zd_admin";
//    passWordTextField.text = @"admin123";
//
//    siteTextField.text = @"https://elearning.cpgroup.cn";
//    userNameTextField.text = @"cpgroup_admin";
//    passWordTextField.text = @"888888";
    
//    userNameTextField.text = @"liuzhihui";
    [self goToLogin];
    
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
