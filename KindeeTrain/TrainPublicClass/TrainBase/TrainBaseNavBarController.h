//
//  TrainBaseNavBarController.h
//   KingnoTrain
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainBaseNavBarController : UINavigationController

@property (strong, nonatomic)UIView *trainLeftBtnItem;

@property (strong, nonatomic)UIView *trainRightBtnItem;

@property (strong, nonatomic)UIView *trainCenterView;

@property (strong, nonatomic)UIView *trainNavigationBgView;

@property (strong, nonatomic)UIImage  *trainNavImage;



-(void)creatCenterView:(UIView *)centerView;

-(void)creatCenterTitle:(NSString *)title;

-(void)creatLeftBarItem:(UIView  *)leftView;
-(void)creatwebLeftTwoBarItem:(id)target backaction:(SEL)action closeAction:(SEL)closeAction;
-(void)creatLeftpopViewtarget:(id)target action:(SEL)action;

-(void)creatRightBarItem:(UIView  *)RightView;


-(void)removeLeftBtnItem;
-(void)removeRightBtnItem;



@end
