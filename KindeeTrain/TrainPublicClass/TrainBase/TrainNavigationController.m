//
//  TrainNavigationController.m
//  KindeeTrain
//
//  Created by apple on 17/2/13.
//  Copyright © 2017年 Kindee. All rights reserved.
//


#import "TrainNavigationController.h"
//#import "TrainBaseViewController.h"
//#import "TrainNewMovieViewController.h"

#pragma mark - TrainWrapNavigationController

@interface TrainWrapNavigationController : UINavigationController

@end

@implementation TrainWrapNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    TrainNavigationController *Train_navigationController = viewController.Train_navigationController;
    NSInteger index = [Train_navigationController.Train_viewControllers indexOfObject:viewController];
    return [self.navigationController popToViewController:Train_navigationController.viewControllers[index] animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    viewController.Train_navigationController = (TrainNavigationController *)self.navigationController;
    viewController.Train_fullScreenPopGestureEnabled = viewController.Train_navigationController.fullScreenPopGestureEnabled;
    viewController.Train_PopGestureEnabled = viewController.Train_navigationController.popGestureEnabled;
    
    UIButton  *backBtn  = viewController.Train_navigationController.backButton;
    
    if (!backBtn) {
        
        backBtn  = [[UIButton alloc]init];
        backBtn.frame  = CGRectMake(0, 0, 30, 44);
        
        [backBtn setImage:[UIImage imageNamed:@"Train_back_default"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"Train_back_highlight"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(didTapBackButton) forControlEvents:UIControlEventTouchUpInside];
//        if(iOS_Version > 7){
//            
//            backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 13);
//        }
    }
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleDone target:self action:@selector(didTapBackButton)];
    
    [self.navigationController pushViewController:[TrainWrapViewController wrapViewControllerWithViewController:viewController] animated:animated];
}

- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    self.viewControllers.firstObject.Train_navigationController=nil;
}

@end

#pragma mark - TrainWrapViewController

static NSValue *Train_tabBarRectValue;

@implementation TrainWrapViewController

+ (TrainWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController {
    
    TrainWrapNavigationController *wrapNavController = [[TrainWrapNavigationController alloc] init];
    wrapNavController.viewControllers = @[viewController];
    
    TrainWrapViewController *wrapViewController = [[TrainWrapViewController alloc] init];
    [wrapViewController.view addSubview:wrapNavController.view];
    [wrapViewController addChildViewController:wrapNavController];
    
    return wrapViewController;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.tabBarController && !Train_tabBarRectValue) {
        Train_tabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tabBarController && [self rootViewController].hidesBottomBarWhenPushed) {
        self.tabBarController.tabBar.frame = CGRectZero;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.translucent = YES;
    if (self.tabBarController && !self.tabBarController.tabBar.hidden && Train_tabBarRectValue) {
        self.tabBarController.tabBar.frame = Train_tabBarRectValue.CGRectValue;
    }
}

- (BOOL)Train_fullScreenPopGestureEnabled {
    return [self rootViewController].Train_fullScreenPopGestureEnabled;
}
-(BOOL)Train_PopGestureEnabled{
    return [self rootViewController].Train_PopGestureEnabled;;
}

- (BOOL)hidesBottomBarWhenPushed {
    return [self rootViewController].hidesBottomBarWhenPushed;
}

- (UITabBarItem *)tabBarItem {
    return [self rootViewController].tabBarItem;
}

- (NSString *)title {
    return [self rootViewController].title;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return [self rootViewController];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return [self rootViewController];
}

- (UIViewController *)rootViewController {
    TrainWrapNavigationController *wrapNavController = self.childViewControllers.firstObject;
    return wrapNavController.viewControllers.firstObject;
}

@end

#pragma mark - TrainNavigationController

@interface TrainNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *popPanGesture;

@property (nonatomic, strong) id popGestureDelegate;

@end

@implementation TrainNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        rootViewController.Train_navigationController = self;
        self.viewControllers = @[[TrainWrapViewController wrapViewControllerWithViewController:rootViewController]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.viewControllers.firstObject.Train_navigationController = self;
        self.viewControllers = @[[TrainWrapViewController wrapViewControllerWithViewController:self.viewControllers.firstObject]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden:YES];
    self.delegate = self;
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.translucent =NO;
    
    [navigationBar setBackgroundImage:[UIImage imageWithColor:TrainNavColor] forBarMetrics: UIBarMetricsDefault];
    [navigationBar setTintColor:TrainColorFromRGB16(0xFFFFFF)];
    
    [navigationBar setShadowImage:[[UIImage alloc]init]];
    
    NSShadow *shadow = [[NSShadow alloc]init];
    [shadow setShadowOffset:CGSizeZero];
    NSDictionary *barDic =@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],NSForegroundColorAttributeName:TrainColorFromRGB16(0xFFFFFF)};

    [navigationBar setTitleTextAttributes:barDic];
    
    
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    NSDictionary *itemDic =@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:TrainColorFromRGB16(0xFFFFFF)};

    [barButtonItem setTitleTextAttributes:itemDic forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:itemDic forState:UIControlStateHighlighted];
    

    
    self.popGestureDelegate = self.interactivePopGestureRecognizer.delegate;
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    self.popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.popGestureDelegate action:action];
    self.popPanGesture.maximumNumberOfTouches = 1;
    
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    
    if (viewController.Train_fullScreenPopGestureEnabled) {
        if (isRootVC) {
            [self.view removeGestureRecognizer:self.popPanGesture];
        } else {
            [self.view addGestureRecognizer:self.popPanGesture];
        }
        self.interactivePopGestureRecognizer.delegate = self.popGestureDelegate;
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        
        
      BOOL  iii =   viewController.Train_PopGestureEnabled ;
        
        [self.view removeGestureRecognizer:self.popPanGesture];
        self.interactivePopGestureRecognizer.delegate = self;
    
        self.interactivePopGestureRecognizer.enabled = iii ;
    }
    
}

#pragma mark - UIGestureRecognizerDelegate

//修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

#pragma mark - Getter

- (NSArray *)Train_viewControllers {
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (TrainWrapViewController *wrapViewController in self.viewControllers) {
        [viewControllers addObject:wrapViewController.rootViewController];
    }
    return viewControllers.copy;
}
@end
