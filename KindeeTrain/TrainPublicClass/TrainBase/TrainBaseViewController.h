//
//  TrainBaseViewController.h
//  SOHUEhr
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "UIViewController+TrainNavigationExtension.h"

@interface TrainBaseViewController : UIViewController

//@property(nonatomic, strong) TrainNavigationController      *navBar;
@property(nonatomic, strong) AppDelegate                    *appdelegate;


-(void)trainShowHUDOnlyActivity;
-(void)trainShowHUDOnlyText:(NSString  *)title;
-(void)trainShowHUDOnlyText:(NSString *)title andoff_y:(CGFloat )off_y;
-(void)trainShowHUDNetWorkError;
-(void)trainHideHUD;

-(void)creatLeftpopViewWithaction:(SEL)action;

@end
