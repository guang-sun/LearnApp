//
//  AppDelegate.m
//   KingnoTrain
//
//  Created by apple on 16/12/2.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "AppDelegate.h"

#import "TrainLoginViewController.h"
#import "TrainWelcomeViewController.h"

#import "TrainHomeViewController.h"
#import "TrainCourseClassViewController.h"
#import "TrainGroupAndTopicListViewController.h"
#import "TrainDocumentListViewController.h"
#import "TrainMessageListViewController.h"

//#import <PgySDK/PgyManager.h>

@interface AppDelegate ()

@property (nonatomic,strong)UITabBarController *tabbar;
@property (nonatomic, assign) BOOL   isFirst;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window =[[UIWindow  alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor =[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.isFirst = YES ;

    //启动更新检查SDK
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGYAppKey];
//    [[PgyUpdateManager sharedPgyManager] checkUpdate];
//    [[PgyManager sharedPgyManager ]startManagerWithAppId:PGYAppKey];
    [TrainUserInfo getEncodeData] ;
    

    [TrainUserDefault setBool:NO forKey:TrainAllowRe];

    TrainNavigationController *nav =[[TrainNavigationController alloc]initWithRootViewController:[TrainWelcomeViewController new]];
    self.window.rootViewController = nav;


    // Override point for customization after application launch.
    return YES;
}
-(void)goLoginSuccessToHome{
    
    if (self.isFirst) {
        self.isFirst = NO ;
        [self getAppUpdate];

    }
    
    if (self.tabbar) {
        [self.tabbar.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromParentViewController];
        }];
        self.tabbar  = nil;
    }
    TrainNavigationController *mainNav =[[TrainNavigationController alloc]initWithRootViewController:[[TrainHomeViewController alloc]init]];
    mainNav.tabBarItem.title =@"首页";
    mainNav.tabBarItem.image =[UIImage imageNamed:@"Train_Tabbar_Unmain"];
    mainNav.tabBarItem.selectedImage =[UIImage imageNamed:@"Train_Tabbar_main"];
    
    TrainNavigationController  *couseNav =[[TrainNavigationController alloc]initWithRootViewController:[[TrainCourseClassViewController alloc]init]];
    couseNav.tabBarItem.title =@"课程";
    couseNav.tabBarItem.image =[UIImage imageNamed:@"Train_Tabbar_Uncouse"];
    couseNav.tabBarItem.selectedImage =[UIImage imageNamed:@"Train_Tabbar_couse"];
    
    TrainNavigationController  *groupNav =[[TrainNavigationController alloc]initWithRootViewController:[[TrainGroupAndTopicListViewController alloc]init]];
    groupNav.tabBarItem.title =@"圈子";
    groupNav.tabBarItem.image =[UIImage imageNamed:@"Train_Tabbar_Ungroup"];
    groupNav.tabBarItem.selectedImage =[UIImage imageNamed:@"Train_Tabbar_group"];
    
    TrainNavigationController  *docNav =[[TrainNavigationController alloc]initWithRootViewController:[[TrainDocumentListViewController alloc]init]];
    docNav.tabBarItem.title =@"文库";
    docNav.tabBarItem.image =[UIImage imageNamed:@"Train_Tabbar_Undocument"];
    docNav.tabBarItem.selectedImage =[UIImage imageNamed:@"Train_Tabbar_document"];
    
    TrainNavigationController  *mesNav =[[TrainNavigationController alloc]initWithRootViewController:[[TrainMessageListViewController alloc]init]];
    mesNav.tabBarItem.title =@"资讯";
    mesNav.tabBarItem.image =[UIImage imageNamed:@"Train_Tabbar_UnMessage"];
    mesNav.tabBarItem.selectedImage =[UIImage imageNamed:@"Train_Tabbar_Message"];
    
//    UITabBarController *tabbar =[[UITabBarController alloc]init];
    self.tabbar =[[UITabBarController alloc]init];
    self.tabbar.tabBar.tintColor =TrainNavColor;
    self.tabbar.viewControllers =@[mainNav,couseNav,groupNav,docNav,mesNav];
    
    self.window.rootViewController = self.tabbar;
    [self.window makeKeyAndVisible];

}



#pragma mark - ======  app 更新  =============
/*
 appUrl = "https:%2f%2fwww.baidu.com%2f";
 appVersion = "1.0";
 msg = "\U6709\U65b0\U7684\U66f4\U65b0\U7248\U672c";
 status = 1;
 success = 1;
 updateContent = "\U8fd9\U4e2a\U662f\U6d4b\U8bd5\U516c\U53f8\U76841.0\U7248\U672c";
 */
//   conple: 判断是否为强制更新  1 强制更新   version: App 版本;
- (void)getAppUpdate {
    
    if (TrainStringIsEmpty(TrainUser.site)) {
        return ;
    }
    
    [[TrainNetWorkAPIClient client] trainGetAPPUpdateWithSuccess:^(NSDictionary *dic) {
        NSDictionary  *objdic = dic;
        NSString  *appVersion = TrainAPPVersions ;;
        NSComparisonResult ss  = [objdic[@"appVersion"] compare:appVersion options:NSLiteralSearch] ;
        if(ss == NSOrderedDescending){
            
            [self rzCompareVersion:dic];
        }
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
    
}

//- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
//{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//    
//}


- (void)rzCompareVersion:(NSDictionary *)dic {
    
    
    TrainWeakSelf(self);
    
    if ([dic[@"conpel"] boolValue]) {
        
        [weakself rzStrongUpdate:dic];
        
    }else {
        
       [ TrainAlertTools showAlertWith:[TrainControllerUtil getTrainRootVC] title:@"更新提示" message:dic[@"updateContent"]  callbackBlock:^(NSInteger btnIndex) {
            if (btnIndex == 1) {
                
                [weakself openAppStore:dic];
                
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:@"更新" otherButtonTitles:nil, nil];
        
        
    }
}


- (void)rzStrongUpdate:(NSDictionary *)dic {
    
    TrainWeakSelf(self);
    
    [ TrainAlertTools showAlertWith:[TrainControllerUtil getTrainRootVC] title:@"更新提示" message:dic[@"updateContent"]  callbackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 0) {
            
            [weakself openAppStore:dic];
            [weakself rzStrongUpdate:dic[@"updateContent"] ] ;
        }
    } cancelButtonTitle:nil destructiveButtonTitle:@"更新" otherButtonTitles:nil, nil];
    
}

- (void)openAppStore:(NSDictionary *)dic {
    
    NSString  *appstoreUrlString = @"itms-apps://itunes.apple.com/cn/app/id1132953125?mt=8";
    
    NSURL* url = [NSURL URLWithString:appstoreUrlString];
    
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        
        [[UIApplication sharedApplication]openURL:url];
        
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
