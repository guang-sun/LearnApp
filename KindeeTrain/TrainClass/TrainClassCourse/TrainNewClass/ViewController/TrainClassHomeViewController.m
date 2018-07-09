//
//  TrainClassHomeViewController.m
//  KindeeTrain
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainClassHomeViewController.h"
#import "TrainNewMovieViewController.h"
//#import "WMPanGestureRecognizer.h"
#import "TrainNewClassInfoViewController.h"
#import "TrainNewCouseHourViewController.h"
#import "TrainClassCommendViewController.h"
#import "TrainPlayerView.h"
#import "TrainMovieDetailDelegate.h"
#import "TrainImageButton.h"


static CGFloat const kWMHeaderViewHeight = 200;
static CGFloat const kWMMenuViewHeight = 44.0;

@interface TrainClassHomeViewController ()<UIGestureRecognizerDelegate,TrainPlayerDelegate,TrainMovieDetailDelegate>
{
    UIView          *headView;
    
    UIView                          *downView;
    UIImageView                     *movieDefaultView;
    UIView                          *movieBgView;
    UIButton                        *lastHourBtn;
    UILabel                         *lastHourLab;
    BOOL                            isRegister, isOnline;
    TrainClassRegisterStatus          Regstatus;
    
    TrainCourseDetailMode           courseMode;
    TrainImageButton              *signButton;

    NSDictionary                    *coursIntroDic;
    
    NSString                        *register_id;
    

    __block NSInteger               playercurrTime;
    __block NSInteger               learnTime;
    __block NSInteger               pausetime;;
    
    __block NSDate                  *startDate;
    
    NSString                        *studyCount; // 只有退出课程是 才为1 其他 0
    
    NSString                        *condition;
    NSString                        *course_object_id;
    
    TrainCourseDirectoryModel       *lasthourModel;
    TrainCourseDirectoryModel       *currenthourModel;
    
    BOOL                            isUpdate;

    
}
@property (nonatomic, assign) CGFloat viewTop;

@property(nonatomic,strong)    UIView                  *succesView;
@property(nonatomic,strong)    UIButton                *exitBtn;
@property(nonatomic,strong)    UIButton                *registBtn;

@property (nonatomic, strong) NSArray *musicCategories;

@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) WMPageScrollStatus     scrollStatus;
@property (nonatomic, assign) BOOL     isDrag;
@property (nonatomic, assign) BOOL     fixedHeadView;
@property (nonatomic, assign) BOOL     isPlaying;

@property (nonatomic, strong) TrainPlayerView       *playerView;
@property (nonatomic, strong) TrainPlayerModel      *playerModel;

@property(nonatomic,strong)    NSDictionary             *classInfo ;


@end

@implementation TrainClassHomeViewController

- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal   = 15;
        self.titleSizeSelected = 15;
        self.selectIndex       = 1;
        self.pageAnimatable    = NO;
        self.titles            = @[@"班级简介",@"班级课表",@"班级评价"];
        self.menuViewStyle     = WMMenuViewStyleLine;
        self.menuItemWidth      = [UIScreen mainScreen].bounds.size.width / 3;
        self.titleColorSelected = TrainMenuSelectColor;
        self.titleColorNormal = TrainTitleColor;
        self.menuViewHeight     = kWMMenuViewHeight;
        self.headerViewHeight   = TrainMovieHeight ;
        self.minimumTopInset    = 0;
        self.scrollEnable       = NO ;
        
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.Train_PopGestureEnabled  =  NO ;
    self.scrollStatus = WMPageScrollStatusNULL;
    self.isDrag = NO;
    self.fixedHeadView = NO;
    self.isPlaying = NO ;
    isRegister = NO ;
    isUpdate = NO ;
    Regstatus = TrainClassRegisterStatusNone;
    studyCount = @"0";
    [self creatLeftpopViewWithaction:@selector(popToView)];
    self.navigationItem.title = @"班级详情" ;
    courseMode = TrainCourseDetailModeIntroduction;
    self.automaticallyAdjustsScrollViewInsets = YES;

    [self creatHeaderMovieView];
    self.downInset = TrainTabbarHeight ;
//    self.panGesture = [[WMPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnView:)];
//    [self.view addGestureRecognizer:self.panGesture];
    
    [self downloadDate:1];
    [self creatDownUnregistView];

    //    [self registeNotifications];
    // Do any additional setup after loading the view.
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.view.frame =  CGRectMake(0, 0, TrainSCREENWIDTH, TrainSCREENHEIGHT - TrainNavHeight - TrainTabbarHeight);

}


-(void)dealloc{
    
    studyCount = @"1";
    if (self.playerView) {
        [self.playerView stopPlayer];
    }
    
    TrainNSLog(@"moviePlayer dealloc --->");
    
}
-(void)popToView{
    
    studyCount = @"1";
    if (self.playerView) {
        [self.playerView stopPlayer];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}


#pragma   mark   - 数据请求

/**
 *  downLoad 班级课程列表 和 详情
 *
 *  @param index index
 */
-(void)downloadDate:(int )index{
    
    [self trainShowHUDOnlyActivity];

    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainClassDetailWithClassMode:TrainClassModeCourse class_id:_class_id curPage:index Success:^(NSDictionary *dic) {

            NSDictionary  *infoDic = dic[@"class"];
            weakself.classInfo = infoDic ;
            register_id = [infoDic[@"register_id"] stringValue];

            if (self.status == RZClassStatusDafeult) {
                [weakself judgeStatus:dic[@"class"]];
                
            }else {
                
                [self  showClassStatus];
            }
            NSString  *imageStr =(infoDic[@"picture"]) ? infoDic[@"picture"]:@"";
            NSString  *image ;
            if ([imageStr hasPrefix:@"/upload/class/pic/"]) {
                image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
            }else{
                image = [TrainIP stringByAppendingFormat:@"/upload/class/pic/%@",imageStr];
            }
        [weakself trainHideHUD];

    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {

   
        [weakself trainShowHUDNetWorkError];
    }];
    
    
}


#pragma  mark  - 报名
#pragma  mark - 底部签到

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    if (scrollView == self.view) {
//     
//        downView.mj_y = scrollView.contentOffset.y + TrainSCREENHEIGHT - TrainNavHeight - TrainTabbarHeight  ;
//        
//    }
//}

- (void)wmpageScrollViewWithOff:(CGPoint)contentOff {
    NSLog(@"-1-1-%f",contentOff.y);
    
    downView.top_sd = contentOff.y + TrainSCREENHEIGHT - TrainNavHeight - TrainTabbarHeight  ;

}

-(void)creatDownUnregistView{
    
    
    downView =[[UIView alloc]init];
    downView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    downView.frame = CGRectMake(0, TrainSCREENHEIGHT - TrainNavHeight - TrainTabbarHeight , TrainSCREENWIDTH, TrainTabbarHeight);
    [self.view addSubview:downView];
  

    [downView addSubview:self.exitBtn];
    [downView addSubview:self.registBtn];
    [downView addSubview:self.succesView];
    self.exitBtn.hidden     = YES;
    self.succesView.hidden  = YES;
    self.registBtn.hidden   = YES;
}

-(void)updateDownUnRegistView{
    
    self.exitBtn.hidden     = YES;
    self.succesView.hidden  = YES;
    self.registBtn.hidden   = YES;
    
    if (Regstatus == TrainClassRegisterStatusNone ) {
        
        self.registBtn.frame =CGRectMake((TrainSCREENWIDTH - 160)/2, 5, 160, 40);
        _registBtn.cusTitle     = @"立即参加";
        self.registBtn.hidden = NO;
        isRegister  = NO ;

    } else if(Regstatus == TrainClassRegisterStatusWaiting || Regstatus == TrainClassRegisterStatusLining) {
        
        self.exitBtn.hidden   = NO;
        self.registBtn.hidden = NO;
        
        float  width =(TrainSCREENWIDTH - 60)/2;
        self.exitBtn.frame =CGRectMake(20, 5, width, 40);
        self.registBtn.frame =CGRectMake(40+width, 5, width, 40);
        
        _registBtn.cusTitle = (Regstatus == TrainClassRegisterStatusWaiting)?@"等待审核...":@"正在排队...";
        _registBtn.backgroundColor =[UIColor lightGrayColor];
        _registBtn.userInteractionEnabled =NO;
        isRegister  = NO ;

    }else if(Regstatus == TrainClassRegisterStatusFinish || Regstatus == TrainClassRegisterStatusFinishExit){
        float  width =(TrainSCREENWIDTH - 60)/2;
        self.exitBtn.hidden     = NO;
        self.succesView.hidden = NO;
        
        
        self.exitBtn.frame =CGRectMake(20, 5, width, 40);
        self.succesView.frame =CGRectMake(40+width, 5, width, 40);
        signButton.frame = CGRectMake(0, 0, width, 40);
        signButton.imageSize = CGSizeMake(20, 20);
        
        if (Regstatus == TrainClassRegisterStatusFinish) {
            _exitBtn.backgroundColor = [UIColor lightGrayColor];
            _exitBtn.userInteractionEnabled =NO;
        }
        isRegister  = YES ;

    }
    
    if([self.currentViewController isKindOfClass:[TrainNewCouseHourViewController class]]){
        TrainNewCouseHourViewController *hourVC = (TrainNewCouseHourViewController *)self.currentViewController;
        hourVC.isRegister = isRegister ;
        
    }else if([self.currentViewController isKindOfClass:[TrainClassCommendViewController class]]){
        
        TrainClassCommendViewController *commendVC = (TrainClassCommendViewController *)self.currentViewController;
        commendVC.isRegister = isRegister ;
    }

}
//
//    "ru_status": "Q", 若"S" 已报名  其他 未报名
//    "ru_wait_status": "N",  =W  等待审核 ==D 等待排队 其他则报名完成
//    "r_type": "2", "2"  buneng退出报名  其他则可以
-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn =[[UIButton alloc]initCustomButton];
        _exitBtn.cusFont =14.0f;
        _exitBtn.cusTitle =@"退出报名";
        _exitBtn.cusTitleColor =[UIColor whiteColor];
        _exitBtn.backgroundColor =TrainColorFromRGB16(0xFF9628);
        _exitBtn.layer.cornerRadius = 5;
        _exitBtn.layer.masksToBounds =YES;
        [_exitBtn addTarget:self action:@selector(exitButton)];
        
    }
    return _exitBtn;
}
-(UIButton *)registBtn{
    if (!_registBtn) {
        _registBtn =[[UIButton alloc]initCustomButton];
        _registBtn.cusFont =14.0f;
        _registBtn.cusTitleColor =[UIColor whiteColor];
        _registBtn.backgroundColor =TrainNavColor;
        _registBtn.layer.cornerRadius = 5;
        _registBtn.layer.masksToBounds =YES;
        [_registBtn addTarget:self action:@selector(buttonTouch)];
        
    }
    return _registBtn;
}
-(UIView *)succesView{
    
    
    if ( !_succesView) {
        _succesView =[[UIView alloc]init];
        _succesView.backgroundColor =TrainNavColor;
        _succesView.userInteractionEnabled =YES;
        _succesView.layer.cornerRadius = 5;
        _succesView.layer.masksToBounds =YES;
        
        UIImage  *image = [UIImage imageNamed:@"Train_Class_Detail_Rili"];
        NSString  *str = [TrainStringUtil trainGetNewTime];
        NSString  *signStr = [NSString stringWithFormat:@"%@   签到",str];
        
        
        signButton =[[TrainImageButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10) andImage:image andTitle:signStr];
        [signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        TrainWeakSelf(self);
        signButton.touchAction = ^(UIButton  *btn ){
            [weakself signBtn];
            
        };
        [_succesView addSubview:signButton];
        
        
    }
    return _succesView;
}



#pragma  mark  报名 退出

//e_not_in_time  当前时间不能退出报名
//e_require  你被指派报名，不允许退出

-(void)exitButton{
    [ self classRegisterStatus:NO];
}


//                r_has_reg  报名已经提交，不能重复报名
//                r_has_reg_wait  报名已经提交，在等待队列中
//                r_no_enable  报名还未开启
//                r_reg_end  报名已经结束

-(void)buttonTouch{
    
    [self classRegisterStatus:YES];
}

-(void)classRegisterStatus:(BOOL)isRegister{
    
    
    [self trainShowHUDOnlyActivity];
    TrainWeakSelf(self);
    
    [[TrainNetWorkAPIClient client] trainClassDetailRegisterWithisRegister:isRegister class_id:self.class_id regiter_id:register_id Success:^(NSDictionary *dic) {
        
        if([dic[@"key"] isEqualToString:@"success"]){
            if (!isRegister) {
                Regstatus = TrainClassRegisterStatusNone;
                [weakself updateDownUnRegistView];
            }else{
                [weakself judgeStatus:dic[@"class"]];
            }
            [weakself trainHideHUD];
        }else{
            [weakself trainShowHUDOnlyText:dic[@"msg"]];
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        [weakself trainShowHUDNetWorkError];
    }];
}
#pragma mark 判断报名状态
-(void)judgeStatus:(NSDictionary *)dic{
    if (![dic[@"ru_status"] isEqualToString:@"S"]) {
        if ([dic[@"ru_wait_status"] isEqualToString:@"W"]) {
            Regstatus =TrainClassRegisterStatusWaiting;
        }else if([dic[@"ru_wait_status"] isEqualToString:@"D"]){
            Regstatus = TrainClassRegisterStatusLining;
        }else{
            Regstatus =TrainClassRegisterStatusNone;
        }
    }else{
        
        if (![dic[@"r_type"] isEqualToString:@"2"]) {
            Regstatus = TrainClassRegisterStatusFinishExit;
        }else{
            Regstatus = TrainClassRegisterStatusFinish;
        }
    }
    
    [self   updateDownUnRegistView];

}

// 显示 未开始 或 已结束的状态
- (void)showClassStatus{
    
    self.exitBtn.hidden     = YES;
    self.succesView.hidden  = YES;
    self.registBtn.hidden   = YES;
    
    if (self.status == RZClassStatusNotStart ) {
        _registBtn.cusTitle     = @"未开始" ;
        
    }else if (self.status == RZClassStatusEnd ){
        _registBtn.cusTitle     = @"已结束";
    }
    _registBtn.backgroundColor = [UIColor lightGrayColor];
    _registBtn.userInteractionEnabled =NO;
    self.registBtn.frame =CGRectMake((TrainSCREENWIDTH - 160)/2, 5, 160, 40);
    self.registBtn.hidden = NO;
}


#pragma  mark  签到
-(void)signBtn{
    
    [self trainShowHUDOnlyActivity];
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainClassSignInWithregiter_id:register_id Success:^(NSDictionary *dic) {
        if([dic[@"key"] isEqualToString:@"success"]){
            NSString  *str = [TrainStringUtil trainGetNewTime];
            NSString  *signStr = [NSString stringWithFormat:@"%@   已签到",str];
            
            signButton.cusTitle = signStr;
            [weakself trainShowHUDOnlyText:@"签到成功"];
            
        }else{
            [weakself trainShowHUDOnlyText:dic[@"msg"]];
            
        }
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        [weakself trainShowHUDNetWorkError];
    }];
    
    
}



#pragma mark  创建视频播放View

-(void)creatHeaderMovieView{
    
    movieBgView = [[UIView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainMovieHeight)];
    [self.view addSubview:movieBgView];
    self.playerModel.fatherView = movieBgView;
    movieBgView.userInteractionEnabled = YES;

    movieDefaultView = [[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"bgimageView"]];
    movieDefaultView.frame =CGRectMake(0, 0, TrainSCREENWIDTH, TrainMovieHeight);
    movieDefaultView.userInteractionEnabled =YES;
    [movieBgView addSubview:movieDefaultView];
    
}

-(void)changMovieViewlocation:(BOOL)isUp{
    
    if (isUp) {
        [self.view bringSubviewToFront:movieBgView];
    }else{
        
        [self.view insertSubview:movieBgView belowSubview:self.navigationController.view];
    }
    
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    TrainNSLog(@"----index ---%zi",index);
    if (index == 0) {
        TrainNewClassInfoViewController  *introdVC =[[TrainNewClassInfoViewController alloc]init];
        introdVC.class_id = self.class_id ;
        

        return introdVC;
    }else if (index == 1){
        TrainNewCouseHourViewController *hourVC = [[TrainNewCouseHourViewController alloc]init];
        hourVC.class_id = self.class_id ;
        hourVC.delegate = self ;
        return hourVC ;
    }
    
    TrainClassCommendViewController *commendVC =[[TrainClassCommendViewController alloc]init];
    commendVC.class_id = self.class_id ;

    return commendVC;
}


-(void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    NSLog(@"didenter -- %@",info);
    

        if([self.currentViewController isKindOfClass:[TrainNewClassInfoViewController class]]){
            TrainNewClassInfoViewController *introdVC = (TrainNewClassInfoViewController *)self.currentViewController;
            introdVC.classInfo = self.classInfo ;
            
            [introdVC rzGetGradeInfo];
            
        }else
        if([self.currentViewController isKindOfClass:[TrainNewCouseHourViewController class]]){
            TrainNewCouseHourViewController *hourVC = (TrainNewCouseHourViewController *)self.currentViewController;
            hourVC.isRegister = isRegister ;
            hourVC.class_id = self.class_id ;

            
        }else if([self.currentViewController isKindOfClass:[TrainClassCommendViewController class]]){
            
            TrainClassCommendViewController *commendVC = (TrainClassCommendViewController *)self.currentViewController;
            commendVC.isRegister = isRegister ;

        }
}


-(void)WMTableviewSelect:(TrainCourseDirectoryModel *)hourModel {
    
    TrainCourseDirectoryModel  *listModel = hourModel;
    
    if ([listModel.h_type isEqualToString:@"H"] ||[listModel.h_type isEqualToString:@"E"] ) {
        
        [self playerHour:listModel];
    }
    
}

//#pragma mark - 播放视频

// 根据课时不同进行处理
-(void)playerHour:(TrainCourseDirectoryModel *)hourModel{

    TrainWeakSelf(self);

    /*
     V 视频 L 直播   D 文档  E 考试   p  课程包

     */

    //    if

    if ([hourModel.c_type isEqualToString:@"V"] || [hourModel.c_type isEqualToString:@"L"]) {

        if ( [currenthourModel isEqual:hourModel] && !movieDefaultView) {
            return;
        }
        lasthourModel = currenthourModel;
        currenthourModel = hourModel;

        if ( !_fixedHeadView) {
            _fixedHeadView = YES;
        }
      

        Reachability *reach = [Reachability reachabilityForInternetConnection];
        
        if ([reach isReachableViaWWAN]) {
            NSDictionary  *dic = [TrainUserDefault valueForKey:TrainAllowWWANPlayer];
            BOOL isok =(dic[TrainUser.user_id])?[dic[TrainUser.user_id] boolValue]:NO;
            if (isok == NO)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.playerView pause];
                    
                    [TrainAlertTools showAlertWith:self title:@"提示" message:TrainWWANPlayerText callbackBlock:^(NSInteger btnIndex) {
                        
                        if(btnIndex ==1){
                            [weakself getMovieURLWith:hourModel];
                        }
                        
                    } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
                });
                
            }else{
                [self getMovieURLWith:hourModel];
                
            }
        }else{
            
            [self getMovieURLWith:hourModel];
            
        }

    }else if([hourModel.c_type isEqualToString:@"D"] || [hourModel.c_type isEqualToString:@"E"]){

        currenthourModel = hourModel;
        lasthourModel = currenthourModel;

//        [self updateMovieHeadInfo];


    }else if([hourModel.c_type isEqualToString:@"O"]){

        currenthourModel = hourModel;
        lasthourModel = currenthourModel;

//        [self updateMovieHeadInfo];

    }else if ([hourModel.c_type isEqualToString:@"P"]){

        currenthourModel = hourModel;
        lasthourModel = currenthourModel;

//        [self updateMovieHeadInfo];

    }else {

        isUpdate = NO;
        [TrainAlertTools  showTipAlertViewWith:self title:@"提示" message:TrainHourNotSupportText buttonTitle:@"好的" buttonStyle:TrainAlertActionStyleCancel];
    }

}

// 在线课程 获取视频地址;
-(void)getMovieURLWith:(TrainCourseDirectoryModel *)hourModel{

    [[TrainNetWorkAPIClient client] trainGetMovieUrlWithobject_id:hourModel.object_id Success:^(NSDictionary *dic) {

        NSString  *url = @"" ;
        if ([dic[@"status"] boolValue] ) {

            if ( !TrainStringIsEmpty(dic[@"m3u8url"])) {

                url =dic[@"m3u8url"];
            }else if( !TrainStringIsEmpty(dic[@"url"])){

                url =dic[@"url"];
            }

        }
        NSString  *encode =[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.playerModel.title = hourModel.title;
        self.playerModel.videoURL = [NSURL  URLWithString:encode];

        [self playMovieWithModel:hourModel];


    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {

        [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:@"获取视频地址失败,请重试" buttonTitle:@"知道了" buttonStyle:TrainAlertActionStyleCancel];
    }];


}

// 播放视频
-(void)playMovieWithModel:(TrainCourseDirectoryModel *)hourModel{

    if (movieDefaultView ) {
        [movieDefaultView removeFromSuperview];
        movieDefaultView = nil;
        TrainPlayerControlView *controlView = [[TrainPlayerControlView alloc] init];
        [self.playerView playerControlView:controlView playerModel:self.playerModel];

    }
    self.playerModel.isFinish = ([hourModel.ua_status isEqualToString:@"C"]) ? YES : NO;

    if ([hourModel.c_type isEqualToString:@"V"]) {
        if ([hourModel.last_time integerValue] > 1) {
            self.playerModel.seekTime = [hourModel.last_time integerValue];
        }else{
            self.playerModel.seekTime = 0;

        }
        self.playerModel.title       = hourModel.title;

    }else{

    }
    self.isPlaying = YES ;
    [self.playerView resetToPlayNewVideo:self.playerModel];

}


#pragma  mark - 视频代理
-(void)Train_playerStartPlay{
    //    [self updateStudyTime];
    if ( !isUpdate) isUpdate = YES;
    self.isPlaying = YES ;

    startDate = [NSDate date];

}
-(void)Train_playerStopPauseTime:(NSInteger )pauseTime{
    pausetime = pauseTime;
    self.fixedHeadView = YES;

}
-(void)Train_playerStartPauseTime{
    self.isPlaying = NO ;
    self.fixedHeadView = NO;
}



-(void)Train_playerFinish:(NSInteger)lastTime
{
    self.isPlaying = NO ;
    if (startDate) {
        playercurrTime = lastTime;
        lasthourModel = currenthourModel;
        [self updateStudyTime];

    }
    _fixedHeadView = NO;

    if ([condition isEqualToString:@"O"]) {

        [self.playerView changeFullScreen];
        [self ordertoplaymovie];
    }
}


-(void)Train_playerChangeMovie:(NSInteger )lastTime{
    if (startDate) {
        playercurrTime = lastTime;
        [self updateStudyTime];


    }
}
-(void)Train_playerNotPan{

    [TrainProgressHUD showMessage:TrainMovieNoFinishText inView:self.playerView];

}


-(void)Train_playerBackAction:(NSInteger)lastTime{

    self.isPlaying = NO ;
    if (startDate) {
        playercurrTime = lastTime;

        lasthourModel = currenthourModel;
        [self updateStudyTime];

    }

    [TrainNotiCenter  removeObserver:self name:kReachabilityChangedNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];


}


- (void)ordertoplaymovie {

    if ([self.currentViewController isKindOfClass:[TrainNewCouseHourViewController class]]) {

        TrainNewCouseHourViewController *hourVC = (TrainNewCouseHourViewController *)self.currentViewController;
        [hourVC autoPlayHour];
    }
}



-(void)updateStudyTime{

    if (!isUpdate) {
        isUpdate = YES;
        return;
    }
    learnTime = [startDate timeIntervalSinceNow];
    startDate =nil;
    if (learnTime < 0) {
        learnTime = 0 - learnTime;
    }
    if (learnTime > pausetime) {
        learnTime = learnTime - pausetime;
    }

    NSMutableDictionary   *mudic = [NSMutableDictionary  dictionary];

    NSString  *lastTime =[NSString stringWithFormat:@"%zi",playercurrTime];
    NSString  *studytime =[NSString stringWithFormat:@"%zi",learnTime];
    BOOL   isCourse = NO;
    NSString *c_id = currenthourModel.c_id;
    
    [mudic setObject:notEmptyStr(self.class_id)             forKey:@"ccm.object_id"];
    [mudic setObject:notEmptyStr(self.lastHour_id)          forKey:@"ccm.lh_id"];
    [mudic setObject:notEmptyStr(self.lastcw_id)            forKey:@"ccm.cw_id"];
    [mudic setObject:notEmptyStr(c_id)                      forKey:@"ccm.c_id"];
    [mudic setObject:notEmptyStr(lastTime)                  forKey:@"ccm.last_time"];
    [mudic setObject:notEmptyStr(studytime)                 forKey:@"ccm.time"];
    [mudic setObject:studyCount                             forKey:@"go_num"];

    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainUpdateStudyTimeWithIsCourse:isCourse infoDic:mudic Success:^(NSDictionary *dic) {

        if ([dic[@"status"] boolValue]) {

            if ([self.currentViewController isKindOfClass:[TrainNewCouseHourViewController class]]) {

                TrainNewCouseHourViewController *movieVC = (TrainNewCouseHourViewController *)weakself.currentViewController;

                TrainCourseDirectoryModel  *model = lasthourModel;
                model.last_time = lastTime;

                if ([model.c_type isEqualToString:@"V"] && ![model.ua_status isEqualToString:@"C"]) {
                    if (![studyCount isEqualToString:@"1"]) {

                        [movieVC updateLearningRecord:nil andreload:NO] ;
                    }

                }else{
                    [movieVC updateLearningRecord:model andreload:NO] ;

                }

            }

        }
        pausetime =0;

    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {

    }];


}




-(void)setFixedHeadView:(BOOL)fixedHeadView{
    _fixedHeadView = fixedHeadView;
    self.disableSticky = fixedHeadView ;
//    if (_fixedHeadView) {
//        self.viewTop =  TrainNavorigin_y + TrainMovieHeight;
//    }
}


#pragma mark -- getter --



-(NSString *)lastHour_id{

    NSString  *last = @"0";
    if( !lasthourModel ){

    }else{
        last = lasthourModel.list_id;

    }

    return last;
}

- (NSString *)lastcw_id {

    NSString  *last = @"0";
    if( !lasthourModel ){

    }else{
        last = lasthourModel.object_id;

    }

    return last;
}

-(TrainPlayerView *)playerView{

    if (_playerView == nil) {

        TrainPlayerView  * playerViewC = [[TrainPlayerView alloc] init];
        // 设置代理
        //        playerViewC.delegate = self;
        // 打开预览图
        playerViewC.hasPreviewView = NO;
        // 是否自动播放，默认不自动播放
        [playerViewC autoPlayTheVideo];

        _playerView  = playerViewC;
        _playerView.delegate = self;

    }
    return _playerView;
}
-(TrainPlayerModel *)playerModel{
    if (!_playerModel ) {
        TrainPlayerModel      *newplayModel = [[TrainPlayerModel alloc]init];
        newplayModel.placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];

        _playerModel  = newplayModel;
    }
    return _playerModel;
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
