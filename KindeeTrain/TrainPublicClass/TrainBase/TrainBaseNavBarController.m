//
//  TrainBaseNavBarController.m
//   KingnoTrain
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainBaseNavBarController.h"
#import "TrainBaseViewController.h"
@interface TrainBaseNavBarController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate> 
{
    UIView          *_textView;

}
@property (strong, nonatomic)UIImageView *trainNavBgImageView;

@end

@implementation TrainBaseNavBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.delegate = self;
    [self setNavigationBarHidden:NO];
    [self initViews];
    // Do any additional setup after loading the view.
}



- (void)initViews
{
    //背景
    
    self.interactivePopGestureRecognizer.enabled = YES;
    
//    self.navigationBar.hidden = YES;
    [ self.view addSubview:self.trainNavBgImageView];
    self.trainNavBgImageView.image  = [UIImage imageWithColor:TrainNavColor];


    _trainNavigationBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, TrainSCREENWIDTH, 44)];
    _trainNavigationBgView.userInteractionEnabled = YES;
    [self.view addSubview:_trainNavigationBgView];

}


-(void)creatCenterView:(UIView *)centerView{
    
    if (_trainCenterView) {
        [_trainCenterView removeFromSuperview];
    }
    
    _trainCenterView =[[UIView alloc]initWithFrame:centerView.frame];
    _trainCenterView.backgroundColor = [UIColor clearColor];
    centerView.frame = centerView.bounds;
    [_trainCenterView addSubview:centerView];
    [ self.trainNavigationBgView  addSubview:_trainCenterView];
    
}

-(void)creatCenterTitle:(NSString *)title{
    
    CGRect  frame = CGRectZero;
    if (_trainLeftBtnItem) {
        frame = CGRectMake(CGRectGetMaxX(_trainLeftBtnItem.frame)+10, 0, (TrainSCREENWIDTH - (CGRectGetMaxX(_trainLeftBtnItem.frame)+10)*2), 44);
    }else{
        frame = CGRectMake(40, 0, TrainSCREENWIDTH -80, 44);
        
    }
    UILabel  *titleLab = [[UILabel alloc]initWithFrame:frame];
    titleLab.text = title;
    
    titleLab.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
//    titleLab.adjustsFontSizeToFitWidth = YES;
//    titleLab.minimumScaleFactor = 12.0f;
    [self creatCenterView:titleLab];
    
}

-(void)creatLeftBarItem:(UIView *)leftView{
    
    if (_trainLeftBtnItem) {
        [_trainLeftBtnItem removeFromSuperview];
    }
    
    _trainLeftBtnItem =[[UIView alloc]initWithFrame:leftView.frame];
    //    trainLeftBtnItem.backgroundColor = [UIColor clearColor];
    [_trainLeftBtnItem addSubview:leftView];
    leftView.frame = leftView.bounds;
    [ self.trainNavigationBgView addSubview: _trainLeftBtnItem];
    
    
}
-(void)creatLeftpopViewtarget:(id)target action:(SEL)action{
    
    UIButton  *leftBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"Train_back_default"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"Train_back_highlight"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self creatLeftBarItem:leftBtn];
    
}
-(void)creatwebLeftTwoBarItem:(id)target backaction:(SEL)action closeAction:(SEL)closeAction{
    
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    UIButton  *leftBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"Train_back_default"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"Train_back_highlight"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];
    
    UIButton  *leftTwoBtn =[[UIButton alloc]initWithFrame:CGRectMake(30, 0, 30, 44)];
    [leftTwoBtn setImage:[UIImage imageNamed:@"Train_webClose"] forState:UIControlStateNormal];
    //    [leftTwoBtn setImage:[UIImage imageNamed:@"Train_webClose"] forState:UIControlStateHighlighted];
    [leftTwoBtn addTarget:target action:closeAction forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftTwoBtn];
    
    [self creatLeftBarItem:view];
    
    
}


-(void)creatRightBarItem:(UIView *)RightView{
    if (_trainRightBtnItem) {
        [_trainRightBtnItem removeFromSuperview];
    }
    
    _trainRightBtnItem =[[UIView alloc]initWithFrame:RightView.frame];
    _trainRightBtnItem.backgroundColor = [UIColor clearColor];
    RightView.frame = RightView.bounds;
    [_trainRightBtnItem addSubview:RightView];
    [ self.trainNavigationBgView addSubview: _trainRightBtnItem];
    
}

-(void)setTrainNavImage:(UIImage *)trainNavImage{
    _trainNavImage= trainNavImage;
    
    self.trainNavBgImageView.image = trainNavImage;
}
-(UIImageView *)trainNavBgImageView{
    
    if (!_trainNavBgImageView) {
        
        _trainNavBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, 64)];
        _trainNavBgImageView.userInteractionEnabled = YES;
        _trainNavBgImageView.image = [UIImage imageNamed:@"Train_Navbg"];

    }
    return _trainNavBgImageView;
}

-(void)removeLeftBtnItem{
    if (_trainLeftBtnItem) {
        [_trainLeftBtnItem removeFromSuperview];
        _trainLeftBtnItem= nil;
    }
    
}

-(void)removeRightBtnItem{
    if (_trainRightBtnItem) {
        [_trainRightBtnItem removeFromSuperview];
        _trainRightBtnItem = nil;
    }
}

//#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if([viewController isKindOfClass:[TrainBaseViewController class]]){
        
        TrainBaseViewController * trainVC = (TrainBaseViewController*)viewController;
        
                
    }else{
        self.interactivePopGestureRecognizer.enabled = YES;
 
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.trainLeftBtnItem.userInteractionEnabled = NO;
    self.trainRightBtnItem.userInteractionEnabled = NO;
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
