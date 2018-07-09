//
//  TrainNewMovieViewController.m
//  KindeeTrain
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import "TrainNewMovieViewController.h"

#import "TrainIntroductionViewController.h"
#import "TrainMovieDetailTableViewController.h"
//#import "WMPanGestureRecognizer.h"

#import "TrainCourseDetailModel.h"
#import "TrainClassMenuView.h"
#import "TrainUnfoldView.h"
#import "TrainCustomTextView.h"
#import "TrainCourseDirectoryCell.h"
#import "TrainCourseNoteCell.h"
#import "TrainCourseDiscussCell.h"
#import "TrainCourseAppraiseCell.h"
#import "TrainAddNoteViewController.h"
#import "TrainAddAppraiseViewController.h"
#import "TrainWebViewController.h"
#import "TrainPlayerView.h"
#import "TrainCacheListViewController.h"
#import "TrainDownloadManager.h"
#import "TrainImageButton.h"

#define  TRAINDOWNHEIGHT   50

static CGFloat const kWMMovieHeaderViewHeight = 200;
static CGFloat const kWMMovieMenuViewHeight = 44.0;



@interface TrainNewMovieViewController ()<UIGestureRecognizerDelegate,TrainPlayerDelegate,TrainMovieDetailDelegate>
{
    UIView          *headView;
    
    
    UIImageView                     *movieDefaultView;
    UIView                          *movieBgView;
    UIButton                        *lastHourBtn;
    UILabel                         *lastHourLab;
    BOOL                            isRegister, isOnline;

    TrainCourseDetailMode           courseMode;
    
    NSDictionary                    *coursIntroDic;
    

    
    CGFloat                         footViewHeight;

    NSString                        *register_id;

    
    //笔记
    UIView                          *noteDownView;
    
    // 讨论
    UIView                          *commentView;
    TrainCustomTextView             *commentTextView;
    
    
    __block NSInteger               playercurrTime;
    __block NSInteger               learnTime;
    __block NSInteger               pausetime;;
    
    __block NSDate                  *startDate;
    
    NSString                        *studyCount; // 只有退出课程是 才为1 其他 0
    BOOL                            isUpdate;
    NSInteger                       lastHourRow;  //记录上次点击Row;
    NSInteger                       currentRow;   //记录本次点击Row 负责给lastHourRow 赋值;
    TrainCourseDirectoryModel       *lasthourModel;
    TrainCourseDirectoryModel       *currenthourModel;
    
    NSString                        *condition;
    NSString                        *course_object_id;

}
@property (nonatomic, assign) CGFloat viewTop;

@property (nonatomic, strong) NSArray *musicCategories;
//@property (nonatomic, strong) WMPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) WMPageScrollStatus     scrollStatus;
@property (nonatomic, assign) BOOL     isDrag;
@property (nonatomic, assign) BOOL     fixedHeadView;
@property (nonatomic, assign) BOOL     isPlaying;
@property (nonatomic, strong) NSString              *lastHour_id;
@property (nonatomic, strong) NSString              *lastcw_id;
@property (nonatomic, strong) TrainPlayerView       *playerView;
@property (nonatomic, strong) TrainPlayerModel      *playerModel;
@property (nonatomic, strong) NSMutableArray        *downLoadMuArr;


@end

@implementation TrainNewMovieViewController



- (NSArray *)musicCategories {
    if (!_musicCategories) {
        NSArray *array = [TrainLocalData returnCourseDetailMenu];

        _musicCategories = array;
    }
    return _musicCategories;
}

- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal   = 15;
        self.titleSizeSelected = 15;
        self.selectIndex       = 1;
        self.pageAnimatable    = NO;
        self.menuViewStyle     = WMMenuViewStyleLine;
        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.musicCategories.count;
//        self.menuHeight = TrainCLASSHEIGHT;
        self.viewTop = TrainNavorigin_y + TrainMovieHeight;
        self.titleColorSelected = TrainMenuSelectColor;
        self.titleColorNormal = TrainTitleColor;
//        self.scrollEnable = NO;
        self.menuViewHeight     = kWMMovieMenuViewHeight;
        self.headerViewHeight   = TrainMovieHeight ;
        self.minimumTopInset    = 0;
        self.scrollEnable       = NO ;
        
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self removeNotifications ];
    
    if (! movieDefaultView && self.isPlaying) {
        [self.playerView pause];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!movieDefaultView && self.isPlaying) {
        [self.playerView play];
    }

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.Train_PopGestureEnabled  =  NO ;

    self.scrollStatus = WMPageScrollStatusNULL;
    self.isDrag = NO;
    self.fixedHeadView = NO;
    self.isPlaying = NO ;
    //
    studyCount = @"0";
    isUpdate = NO;
    lastHourRow = 0;
    currentRow  = 0;
    footViewHeight = 0;

    [self creatLeftpopViewWithaction:@selector(popToView)];
    self.navigationItem.title = self.courseModel.name;
    courseMode = TrainCourseDetailModeIntroduction;
   
    if (![self.courseModel.type isEqualToString:@"CLASS"]) {
        //        [self getCourseRegisterStatus];
        [self downloadCourseInfo:1];
        
    }else{
        isRegister = YES;
        [self downloadCourseInfo:1];
        
    }
    [self creatHeaderMovieView];
    
    [TrainNotiCenter addObserver:self selector:@selector(networkStatusChange:) name:kReachabilityChangedNotification object:nil];
    
//    [self registeNotifications];
    // Do any additional setup after loading the view.
}


// 检测网络变化
-(void)networkStatusChange:(NSNotification *)noti{
    Reachability  * curReach = [noti object];
    
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    [self changeNetWorkStatus:curReach];
    
    
}

-(void)changeNetWorkStatus:(Reachability *)curReach{
    
    NetworkStatus status=[curReach currentReachabilityStatus];
    
    NSDictionary  *dic = [TrainUserDefault valueForKey:TrainAllowWWANPlayer];
    BOOL isok =(dic[TrainUser.user_id])?[dic[TrainUser.user_id] boolValue]:NO;
    
    if(status == ReachableViaWWAN &&  self.playerView.state == TrainPlayerStatePlaying && !isok){
        
        [self.playerView pause];
        [TrainAlertTools showAlertWith:self title:@"提示" message:TrainWWANPlayerText callbackBlock:^(NSInteger btnIndex) {
            
            if (btnIndex == 1) {
                
                
                [self.playerView play];
                
            }else{
                [self.playerView  pause];
            }
            
        } cancelButtonTitle:@"停止播放" destructiveButtonTitle:nil otherButtonTitles:@"继续播放", nil];
        
    }
    
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
#pragma  mark - download DATA

- (void)getCourseRegisterStatus{
    
    [self trainShowHUDOnlyActivity];
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainCourseRegisterStatusWithCourseID:self.courseModel.object_id Success:^(NSDictionary *dic) {
        
        if ([dic[@"status"] boolValue]) {
            isRegister =YES;
        }else{
            isRegister = NO;
            register_id = [dic[@"RegId"] stringValue];
        }
        [weakself downloadCourseInfo:1];
        
        
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        [weakself creatHeaderMovieView];
        [weakself trainHideHUD];
    }];
}

- (void)downloadCourseInfo:(int )index{
    
    [self trainShowHUDOnlyActivity];
    
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:notEmptyStr(self.courseModel.object_id) forKey:@"object_id"];
    
    [dic setObject:notEmptyStr(self.courseModel.type) forKey:@"type"];
    [dic setObject:notEmptyStr(self.courseModel.c_id) forKey:@"c_id"];
    [dic setObject:notEmptyStr(self.courseModel.class_id) forKey:@"class_id"];
    [dic setObject:notEmptyStr(self.courseModel.room_id) forKey:@"room_id"];
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client ]trainCourseDetailInfoWithMode:courseMode infoDic:dic
                                                          Success:^(NSDictionary *dic)
    {
        if(courseMode == TrainCourseDetailModeIntroduction){
            
                
                NSArray  *arr  = [TrainCourseDirectoryModel mj_objectArrayWithKeyValuesArray:dic[@"hour"]];
                if (arr.count > 0) {
                    lasthourModel = arr[0];
                    currenthourModel = lasthourModel;
                }
                coursIntroDic = [NSDictionary dictionaryWithDictionary:dic];
                condition = coursIntroDic[@"course"][@"condition"];
                course_object_id = coursIntroDic[@"course"][@"object_id"];

                [weakself panduan_CourseRegisteStatus:coursIntroDic[@"course"]];
                [weakself updateMovieHeadInfo];
                [weakself updateMovieInfo];

        }
            [self trainHideHUD];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
       
        [weakself panduan_CourseRegisteStatus:coursIntroDic[@"course"]];
        [weakself updateMovieHeadInfo];
        [weakself trainHideHUD];
        
    }];
    
}


-(void)panduan_CourseRegisteStatus:(NSDictionary *)couseDic{
    
    if (couseDic[@"serialized_state"] && [couseDic[@"serialized_state"] isEqualToString:@"U"]) {
        isOnline = NO;
    }else{
        isOnline = YES;
        if (couseDic[@"order_status"] ) {
            if ([couseDic[@"order_status"] isEqualToString:@"FINISH_PAID"] || [couseDic[@"order_status"] isEqualToString:@"FINISH_APPROVED"]) {
                isRegister = YES;
            }else if([couseDic[@"order_status"] isEqualToString:@""]) {
                if ([couseDic[@"c_status"] isEqualToString:@"X"]) {
                    isRegister = NO;
                }else if ([couseDic[@"c_status"] isEqualToString:@"S"]) {
                    isRegister = YES;
                }
            }else{
                isRegister =NO;
            }
        }
    }
    register_id = [couseDic[@"register_id"] stringValue];
    
    
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
    
    lastHourLab = [[UILabel alloc]initCustomLabel];
    lastHourLab.textColor = [UIColor whiteColor];
    lastHourLab.textAlignment =NSTextAlignmentCenter;
    [movieDefaultView addSubview:lastHourLab];
    
    
    lastHourBtn = [[UIButton alloc]initCustomButton];
    lastHourBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    lastHourBtn.layer.borderWidth =1.0f;
    lastHourBtn.layer.cornerRadius =8;
    lastHourBtn.layer.masksToBounds =YES;
    [lastHourBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [movieDefaultView addSubview:lastHourBtn];
    [lastHourBtn addTarget:self action:@selector(learnHour:)];
    
    lastHourBtn.sd_layout
    .centerXEqualToView(movieDefaultView)
    .centerYEqualToView(movieDefaultView)
    .widthIs(150)
    .heightIs(40);
    
    lastHourLab.sd_layout
    .centerXEqualToView(movieDefaultView)
    .bottomSpaceToView(lastHourBtn,5)
    .widthIs(trainAutoLoyoutImageSize(250))
    .heightIs(40);

//    [self changMovieViewlocation:YES];

}

-(void)changMovieViewlocation:(BOOL)isUp{
    
    if (isUp) {
        [self.view bringSubviewToFront:movieBgView];
    }else{
        
        [self.view insertSubview:movieBgView belowSubview:self.navigationController.view];
    }
    
}

-(void)learnHour:(UIButton *)btn{
    NSString  *string = [btn titleForState:UIControlStateNormal];
    if ([string  isEqualToString:@"立即报名"]) {
        [self joinTouch];
    }else {
        
        if (currenthourModel) {

            if ([self.currentViewController isKindOfClass:[TrainMovieDetailTableViewController class]]) {
                TrainMovieDetailTableViewController *movieVC =(TrainMovieDetailTableViewController *)self.currentViewController;
                [movieVC updateCurrentHourDataWithVC:currenthourModel];
            }
            
           
        }else{
            
            if ([self.currentViewController isKindOfClass:[TrainMovieDetailTableViewController class]]) {
              
                TrainMovieDetailTableViewController *movieVC =(TrainMovieDetailTableViewController *)self.currentViewController;
                [movieVC startLearnHour];
            }
            

        }
    }
    
}

#pragma  mark  - 报名
//                r_has_reg  报名已经提交，不能重复报名
//                r_has_reg_wait  报名已经提交，在等待队列中
//                r_no_enable  报名还未开启
//                r_reg_end  报名已经结束

-(void)joinTouch{
    
    
    [self trainShowHUDOnlyActivity];
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] traincourseRegisterWithCourseId:self.courseModel.object_id register_id:register_id name:self.courseModel.name Success:^(NSDictionary *dic) {
        
        
        [self trainHideHUD];
        
        if([dic[@"success"] boolValue]){
            
            isRegister = YES;
            lastHourLab.text  = @"你还没有学习该课程";
            lastHourBtn.cusTitle =@"立即学习";
            
            [self updateMovieInfo];
            
        }else{
            [weakself trainShowHUDOnlyText:dic[@"msg"]];
            
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        [weakself trainShowHUDNetWorkError];
        
    }];
    
}

-(void)updateMovieInfo{
    
    if ([self.currentViewController isKindOfClass:[TrainMovieDetailTableViewController class]]) {
     
        TrainMovieDetailTableViewController *movieVC = (TrainMovieDetailTableViewController *)self.currentViewController;
        movieVC.isRegister = isRegister;
        movieVC.condition = condition;
        movieVC.object_id = course_object_id ;
        [movieVC updateDataWithVC];
    }
  
}

-(void)updateMovieHeadInfo{
    
    
    if (isOnline && isRegister) {
        
        if (currenthourModel) {
            lastHourLab.text  = [NSString  stringWithFormat:@"上次学到: %@" ,currenthourModel.title];
            lastHourBtn.cusTitle =@"继续学习";
            
        }else{
            lastHourLab.text  = @"你还没有学习该课程";
            lastHourBtn.cusTitle =@"立即学习";
            
        }
    }else  if (isOnline && !isRegister){
        lastHourBtn.cusTitle =@"立即报名";
        lastHourLab.text = @"";
        
    }else if (! isOnline ){
        lastHourBtn.cusTitle =@"即将上线";
        lastHourLab.text = @"";
        lastHourLab.userInteractionEnabled = NO;
    }
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.musicCategories.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    if (index == 0) {
        TrainIntroductionViewController  *introdVC =[[TrainIntroductionViewController alloc]init];
        introdVC.delegate = self;
        
        return introdVC;
    }
    
    TrainMovieDetailTableViewController *movieVC =[[TrainMovieDetailTableViewController alloc]init];
    movieVC.courseDetailModel = self.courseModel;
    movieVC.courseMode  = index;
    movieVC.delegate    = self;

    return movieVC;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.musicCategories[index];
}

-(void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{

    NSInteger  index = [info[@"index"] integerValue];
    
    BOOL  aa = (index == 2 || index == 3 );
    footViewHeight = ( aa  && isRegister)?50:0;

    self.downInset = footViewHeight ;
    if (index == 0) {
        TrainIntroductionViewController  *introdVC = (TrainIntroductionViewController *)viewController;
        [introdVC updateDataWith: coursIntroDic[@"course"]];
    }else{
        
        TrainMovieDetailTableViewController *movieVC = (TrainMovieDetailTableViewController *)viewController;
        movieVC.isRegister = isRegister;
        movieVC.delegate    = self;
        movieVC.courseDetailModel = self.courseModel ;
        [movieVC updateDataWithVC];
        if (index == 1) {
            movieVC.defaultImageURL = coursIntroDic[@"course"][@"picture"];
            [movieVC updateLearningRecord:currenthourModel andreload:YES];

        }
    }

}

-(void)WMTableviewSelect:(TrainCourseDirectoryModel *)hourModel {
    
    TrainCourseDirectoryModel  *listModel = hourModel;
    
    if ([listModel.h_type isEqualToString:@"H"] ||[listModel.h_type isEqualToString:@"E"] ) {
        
        [self playerHour:listModel];
    }
    
}

#pragma mark - 播放视频

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
        
        __block TrainDownloadModel  *downModel = nil;
        [self.downLoadMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainDownloadModel  *downM = obj;
            if ([downM.hour_id isEqualToString:hourModel.list_id] && downM.status == TrainFileDownloadStateFinish) {
                downModel = downM;
                *stop = YES;
            }
        }];
        
        
        if (downModel ) {
            
            NSString  *localMovieURL = [NSString stringWithFormat:@"%@/%@",learnCachesDirectory,downModel.saveFileName];
            
            self.playerModel.videoURL = [NSURL  fileURLWithPath:localMovieURL];
            
            [self playMovieWithModel:hourModel];
            
        }else{
            
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
        }
        
    }else if([hourModel.c_type isEqualToString:@"D"] || [hourModel.c_type isEqualToString:@"E"]){
        
        currenthourModel = hourModel;
        lasthourModel = currenthourModel;

        [self updateMovieHeadInfo];
    
        
    }else if([hourModel.c_type isEqualToString:@"O"]){
        
        currenthourModel = hourModel;
        lasthourModel = currenthourModel;

        [self updateMovieHeadInfo];
    
    }else if ([hourModel.c_type isEqualToString:@"P"]){
        
        currenthourModel = hourModel;
        lasthourModel = currenthourModel;

        [self updateMovieHeadInfo];
        
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
 
//    [self trainShowHUDOnlyText:TrainMovieNoFinishText andoff_y:150.f];
//    +(void)showMessage:(NSString *)msg inView:(UIView *)view;

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
    
    if ([self.currentViewController isKindOfClass:[TrainMovieDetailTableViewController class]]) {
        
        TrainMovieDetailTableViewController *movieVC = (TrainMovieDetailTableViewController *)self.currentViewController;
        [movieVC autoPlayHour];
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
    BOOL      isCourse = YES;
    if ([self.courseModel.type isEqualToString:@"TRAIN"]) {
        isCourse  =YES;
        [mudic setObject:notEmptyStr(self.courseModel.object_id) forKey:@"ccm.object_id"];
        [mudic setObject:notEmptyStr(self.lastHour_id)          forKey:@"ccm.lh_id"];
        [mudic setObject:notEmptyStr(self.lastcw_id)            forKey:@"ccm.cw_id"];
        [mudic setObject:notEmptyStr(lastTime)                  forKey:@"ccm.last_time"];
        [mudic setObject:notEmptyStr(studytime)                 forKey:@"ccm.time"];
        [mudic setObject:studyCount                             forKey:@"go_num"];
        
    }else if([self.courseModel.type isEqualToString:@"CLASS"]){
        isCourse = NO;
        [mudic setObject:notEmptyStr(self.courseModel.class_id) forKey:@"ccm.object_id"];
        [mudic setObject:notEmptyStr(self.lastHour_id)          forKey:@"ccm.lh_id"];
        [mudic setObject:notEmptyStr(self.lastcw_id)            forKey:@"ccm.cw_id"];
        [mudic setObject:notEmptyStr(self.courseModel.c_id)     forKey:@"ccm.c_id"];
        [mudic setObject:notEmptyStr(lastTime)                  forKey:@"ccm.last_time"];
        [mudic setObject:notEmptyStr(studytime)                 forKey:@"ccm.time"];
        [mudic setObject:studyCount                             forKey:@"go_num"];
    }
        
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainUpdateStudyTimeWithIsCourse:isCourse infoDic:mudic Success:^(NSDictionary *dic) {
        
        if ([dic[@"status"] boolValue]) {
            
            if ([self.currentViewController isKindOfClass:[TrainMovieDetailTableViewController class]]) {
                
                TrainMovieDetailTableViewController *movieVC = (TrainMovieDetailTableViewController *)weakself.currentViewController;
                
                TrainCourseDirectoryModel  *model = lasthourModel;
                model.last_time = lastTime;
                
                if ([model.c_type isEqualToString:@"V"] && ![model.ua_status isEqualToString:@"C"]) {
                    if (![studyCount isEqualToString:@"1"]) {
                        
                        [movieVC updateLearningRecord:nil andreload:NO] ;
                    }
                    
                }else{
                    [movieVC updateLearningRecord:model andreload:NO] ;
                    
                }
                [self updateLocalRecordWith:model];
                
            }
            
        }
        pausetime =0;
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
    
    
}

-(void)updateLocalRecordWith:(TrainCourseDirectoryModel *)hourModel{
    
    [self.downLoadMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        TrainDownloadModel  *arrModel = obj ;

        if ([arrModel.hour_id isEqualToString:hourModel.list_id]) {
            arrModel.last_time = [hourModel.last_time integerValue];
            [arrModel updateObjectsByColumnName:@[@"CHO_id"]];
            *stop = YES;
        }
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

-(TrainCourseAndClassModel *)courseModel{
    
    if (!_courseModel  && !TrainDictIsEmpty(_courseDic)) {
        TrainCourseAndClassModel *trainModel = [[TrainCourseAndClassModel alloc]init];
        
        trainModel.class_id = (TrainStringIsEmpty(_courseDic[@"class_id"] ))?@"0":_courseDic[@"class_id"] ;
        trainModel.object_id = (TrainStringIsEmpty(_courseDic[@"id"] ))?@"0":_courseDic[@"id"] ;
        
        NSString  *typeStr = (TrainStringIsEmpty(_courseDic[@"type"]))?@"TRAIN":_courseDic[@"type"];
        
        trainModel.type = typeStr;
        trainModel.room_id = (TrainStringIsEmpty(_courseDic[@"room_id"]))?@"0":_courseDic[@"room_id"];
        trainModel.c_id = _courseDic[@"c_id"] ;
        trainModel.name = _courseDic[@"name"];
        
        
        _courseModel = trainModel;
        
    }
    return _courseModel;
}


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
        //        newplayModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        newplayModel.placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
        
        _playerModel  = newplayModel;
    }
    return _playerModel;
}


//-(TrainDownloadManager *)downManager{
//    if (!_downManager) {
//        _downManager = [TrainDownloadManager sharedFileDownloadManager];
//        _downManager.delegate = self;
//    }
//    return _downManager;
//}

-(NSMutableArray *)downLoadMuArr{
    if (! _downLoadMuArr) {
        NSArray  *arr =[ TrainDownloadModel findWithFormat:@"c_id = %@",self.courseModel.c_id];
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:arr];
        _downLoadMuArr = muArr;
    }
    return _downLoadMuArr;
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
