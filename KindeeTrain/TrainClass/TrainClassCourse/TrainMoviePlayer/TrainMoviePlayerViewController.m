//
//  TrainMoviePlayerViewController.m
//  SOHUEhr
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainMoviePlayerViewController.h"
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


@interface TrainMoviePlayerViewController ()<TrainClassMenuDelegate,UITableViewDelegate,UITableViewDataSource,TrainPlayerDelegate,UITextViewDelegate,TrainFileDownloadManagerDelegate>
{
    UIImageView                     *movieDefaultView;
    UIView                          *movieBgView;
    UIButton                        *lastHourBtn;
    UILabel                         *lastHourLab;
    BOOL                            isRegister, isOnline;
    TrainCourseDirectoryModel       *lasthourModel;
    TrainBaseTableView              *courseTableView;
    TrainCourseDetailMode           courseMode;
    
    NSDictionary                    *coursIntroDic;
    NSMutableArray                  *hourMuArr, *noteMuArr, *discussMuArr, *AppraiseMuArr;
    UIView                          *fiveBgView, *downView, *freeSizeView;
    TrainImageButton                *deleteBtn;
    
    UILabel                         *courseTitleLab, *learnNumLab, *courseGradeLab,
                                    *peopleContentLab, *tagertContentLab;
    TrainUnfoldView                 *courseGaiContentLab;
    
    
    
    NSString                        *register_id;
    TrainCustomTextView             *commentTextView;
    NSString                        *huiFuName;
    NSString                        *topicType;  // T 话题  Q问答
    TrainCourseDiscussModel         *commentInfo;
    
    __block NSString                *selectObject_id;
    __block NSInteger               playercurrTime;
    __block NSInteger               learnTime;
    __block NSInteger               pausetime;;
    
    __block NSDate                  *startDate;
    
    NSString                        *studyCount; // 只有退出课程是 才为1 其他 0
    BOOL                            isUpdate;
    NSInteger                       lastHourRow;  //记录上次点击Row;
    NSInteger                       currentRow;   //记录本次点击Row 负责给lastHourRow 赋值;
    NSIndexPath                     *commentSelect;
    
}
@property(nonatomic,strong) TrainClassMenuView    *courseMenuView;
@property(nonatomic,strong) NSString              *lastHour_id;
@property (nonatomic, strong) NSString              *lastCw_id;
@property(nonatomic,strong) TrainPlayerView       *playerView;
@property(nonatomic,strong) TrainPlayerModel      *playerModel;
@property(nonatomic,strong) TrainDownloadManager  *downManager;
@property(nonatomic,strong) NSMutableArray        *downLoadMuArr;
@property(nonatomic,strong) NSTimer               *downReloadCellTimer;

@end

@implementation TrainMoviePlayerViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(courseMode == TrainCourseDetailModeDiscuss){
        [self removeNotifications];
    }
    if (self.downManager) {
        self.downManager.delegate = nil;
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(courseMode == TrainCourseDetailModeDiscuss){
        [self registeNotifications];
    }
    if (self.downManager) {
        self.downManager.delegate = self;
    }
//    if (  ![self.playerView.SHvid isEqualToString:@""]) {
//        [self.playerView play];
//    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    [self resetStartDownload];
}

-(void)resetStartDownload{
    [self.downManager suspendAllFilesDownload];
    NSArray *arr = [TrainDownloadModel findWithFormat:@"status != 4"];
    [arr  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.downManager addDownloadWithDownLoadModel:obj];
        
    }];
    
    [self.downReloadCellTimer setFireDate:[NSDate date]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    studyCount = @"0";
    topicType = @"";
    isUpdate = NO;
    lastHourRow = 0;
    currentRow  = 0;
//    [self.navBar creatLeftpopViewtarget:self action:@selector(popToView)];
    self.navigationItem.title =  self.courseModel.name;
    
    courseMode = TrainCourseDetailModeIntroduction;
    
    if (![self.courseModel.type isEqualToString:@"CLASS"]) {
//        [self getCourseRegisterStatus];
        [self downloadCourseInfo:1];

    }else{
        isRegister = YES;
        [self downloadCourseInfo:1];

    }

    [TrainNotiCenter addObserver:self selector:@selector(networkStatusChange:) name:kReachabilityChangedNotification object:nil];

    
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
    
    if(courseMode  == TrainCourseDetailModeNote|| courseMode  == TrainCourseDetailModeDiscuss || courseMode  == TrainCourseDetailModeAppraise){
        [dic setObject:[NSString stringWithFormat:@"%d",index]forKey:@"curPage"];
        [dic setObject:@"0" forKey:@"classhour_id"];
//        [dic setObject:notEmptyStr(self.lastHour_id) forKey:@"classhour_id"];

    }
  
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client ]trainCourseDetailInfoWithMode:courseMode infoDic:dic
        Success:^(NSDictionary *dic) {
            switch (courseMode) {
                case TrainCourseDetailModeIntroduction:
                {
                   
                    
                    NSArray  *arr  = [TrainCourseDirectoryModel mj_objectArrayWithKeyValuesArray:dic[@"hour"]];
                    if (arr.count > 0) {
                            lasthourModel = arr[0];
                    }
                    coursIntroDic = [NSDictionary dictionaryWithDictionary:dic];
                    if (!TrainDictIsEmpty(coursIntroDic)  ) {
                        [weakself creatHeaderMovieView];
                    }
                    [weakself panduan_CourseRegisteStatus:coursIntroDic[@"course"]];
                }
                    break;
                case TrainCourseDetailModeDirectory:
                {
                     hourMuArr = [NSMutableArray array];
                     hourMuArr = [TrainCourseDirectoryModel mj_objectArrayWithKeyValuesArray:dic[@"hour"]];
                    courseTableView.trainMode = trainStyleNoData;

                    if (movieDefaultView ) {
                        [weakself updateMovieHeadInfo];
                    }else{
                        NSIndexPath *selectRow = [NSIndexPath indexPathForRow:currentRow inSection:0];
                        [courseTableView selectRowAtIndexPath:selectRow animated:NO scrollPosition:UITableViewScrollPositionNone];
                    }
                }
                    break;
                case TrainCourseDetailModeNote:
                {
                    if (index == 1) {
                        noteMuArr =[NSMutableArray new];
                    }
                    NSArray   *dataArr ;
                    if ([self.courseModel.type isEqualToString:@"TRAIN"]) {
                         dataArr = [TrainCourseNoteModel  mj_objectArrayWithKeyValuesArray:dic[@"courseNotes"]];
                    }else {
                        dataArr = [TrainCourseNoteModel  mj_objectArrayWithKeyValuesArray:dic[@"notes"]];
                    }
                    [noteMuArr addObjectsFromArray:dataArr];
                    if (noteMuArr.count>0) {
                        TrainCourseNoteModel *model = [noteMuArr firstObject];
                        courseTableView.totalpages =[model.totPage intValue];
                    }
                    [courseTableView EndRefresh];
                    courseTableView.trainMode = trainStyleNoData;
                }
                    break;
                case TrainCourseDetailModeDiscuss:
                {
                    if (index == 1) {
                        discussMuArr =[NSMutableArray new];
                    }
                    
                    NSArray   *dataArr  = [TrainCourseDiscussModel mj_objectArrayWithKeyValuesArray:dic[@"discussions"]];
                 
                    dataArr = [weakself dealWithCourseCommentData:dataArr];
                    [discussMuArr addObjectsFromArray:dataArr];
                    
                    if (discussMuArr.count>0) {
                        TrainCourseDiscussModel *model = discussMuArr[0];
                        courseTableView.totalpages =[model.totPage intValue];
                    }
                    [courseTableView EndRefresh];
                    courseTableView.trainMode = trainStyleNoData;
                }
                    break;
                case TrainCourseDetailModeAppraise:
                {
                    if (index == 1) {
                        AppraiseMuArr =[NSMutableArray new];
                        TrainCourseAppraiseModel *myAppraise = [TrainCourseAppraiseModel  mj_objectWithKeyValues:dic[@"comment"]];
                        [AppraiseMuArr addObject:myAppraise];
                    }
                    
                    NSArray   *dataArr = [TrainCourseAppraiseModel  mj_objectArrayWithKeyValuesArray:dic[@"comments"]];
                    NSLog(@"---%@",dataArr);
                    [AppraiseMuArr addObjectsFromArray:dataArr];
                    if (AppraiseMuArr.count>1) {
                        TrainCourseAppraiseModel *model = AppraiseMuArr[1];
                        courseTableView.totalpages =[model.totPage intValue];
                    }

                    [courseTableView EndRefresh];
                    courseTableView.trainMode = trainStyleNoData;

                }
                    break;
                    
                default:
                    break;
            }

            [self trainHideHUD];
            
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        [courseTableView train_reloadData];
        [courseTableView EndRefresh];
        [weakself trainHideHUD];

    }];
    
}


-(NSArray *)dealWithCourseCommentData:(NSArray *)dataArr{
    
    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainCourseDiscussModel *mod =obj;
        NSArray  *arr =[TrainCourseDiscussListModel  mj_objectArrayWithKeyValuesArray:mod.posts];
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainCourseDiscussListModel *mod1 =obj;
            NSArray  *arr1 =[TrainCourseDiscussListModel  mj_objectArrayWithKeyValuesArray:mod1.child_post_list];
            int   super_id =(int)idx;
            [arr1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TrainCourseDiscussListModel *mod2 =obj;
                NSArray  *arr2 =[TrainCourseDiscussListModel  mj_objectArrayWithKeyValuesArray:mod2.child_post_list];
                mod2.child_post_list =arr2;
                mod2.super_id =[NSString stringWithFormat:@"%d",super_id];
                if (idx == 0) {
                    mod2.isFirst =YES;
                }else{
                    mod2.isFirst =NO;
                }
            }];
            
            mod1.child_post_list =arr1;
            
        }];
        
        mod.posts = arr;
        
    }];

    return dataArr;
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
    
    if (_playerView) {
        return;
    }
    
    movieBgView = [[UIView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainMovieHeight)];
    [self.view addSubview:movieBgView];
    self.playerModel.fatherView = movieBgView;
    
    
    movieDefaultView = [[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"bgimageView"]];
    movieDefaultView.frame =CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainMovieHeight);
    movieDefaultView.userInteractionEnabled =YES;
    [self.view addSubview:movieDefaultView];
    
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
    .widthIs(250)
    .heightIs(40);
    
    [self.view addSubview: self.courseMenuView];
    
    
    self.courseMenuView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(movieBgView,0)
    .heightIs(TrainCLASSHEIGHT);
    
    if (TrainArrayIsEmpty(hourMuArr)) {
        courseMode = TrainCourseDetailModeDirectory;
        self.courseMenuView.selectIndex = 1;
        [self  TrainClassMenuSelectIndex:1];
    }
    

    
}
-(void)updateMovieHeadInfo{
   
    
    if (isOnline && isRegister) {
        
        if (lasthourModel) {
            lastHourLab.text  = [NSString  stringWithFormat:@"上次学到: %@" ,lasthourModel.title];
            lastHourBtn.cusTitle =@"继续学习";
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hourMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TrainCourseDirectoryModel  *model = obj;
                    if ([model.list_id isEqualToString: lasthourModel.list_id]) {
                        lastHourRow = idx;
                        currentRow  = idx;
                        lasthourModel = model;
                        NSIndexPath *selectRow = [NSIndexPath indexPathForRow:idx inSection:0];
                        [courseTableView selectRowAtIndexPath:selectRow animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                        *stop  = YES;
                    }
                }];
                
                
            });
            
            
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

-(void)learnHour:(UIButton *)btn{
    NSString  *string = [btn titleForState:UIControlStateNormal];
    if ([string  isEqualToString:@"立即报名"]) {
        [self joinTouch];
    }else {
        
        if (lasthourModel) {
            [self playerHour:lasthourModel];
        }else{
            
            __block BOOL  isHasHour = NO;
            TrainWeakSelf(self);
            [hourMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TrainCourseDirectoryModel  *listModel =obj;
                if ([listModel.h_type isEqualToString:@"H"] ||[listModel.h_type isEqualToString:@"E"] ) {
                    if ([listModel.c_type isEqualToString:@"V"] || [listModel.c_type isEqualToString:@"D"] || [listModel.c_type isEqualToString:@"E"]) {
                        isHasHour = YES;
                        [weakself playerHour:listModel];
                        *stop =YES;
                    }
                }
            }];
            if(! isHasHour){
                NSString *str = (hourMuArr.count) ? TrainHourNotSupportText : @"抱歉,该课程暂时没有课时,尽请期待";
                
                [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:str buttonTitle:@"好的" buttonStyle:TrainAlertActionStyleCancel];
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
            
            isRegister =YES;
            lastHourLab.text  = @"你还没有学习该课程";
            lastHourBtn.cusTitle =@"立即学习";
            
        }else{
            [weakself trainShowHUDOnlyText:dic[@"msg"]];
        
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        [weakself trainShowHUDNetWorkError];

    }];

}




#pragma  mark - 视频代理
-(void)Train_playerStartPlay{
    [self updateStudyTime];

    startDate = [NSDate date];

}
-(void)Train_playerPauseTime:(NSInteger )pauseTime{
    pausetime = pauseTime;

}
-(void)Train_playerFinish:(NSInteger)lastTime
{
    if (startDate) {
        playercurrTime = lastTime;
        [self updateStudyTime];
        startDate = nil;

    }

}
-(void)Train_playerChangeMovie:(NSInteger )lastTime{
    if (startDate) {
        playercurrTime = lastTime;
        lasthourModel = hourMuArr[currentRow];
        [self updateStudyTime];
        startDate = nil;
        
    }
}
-(void)Train_playerNotPan{
    
}


-(void)Train_playerBackAction:(NSInteger)lastTime{
   
    
    if (startDate) {
        playercurrTime = lastTime;
        lasthourModel = hourMuArr[currentRow];
        [self updateStudyTime];
        startDate = nil;

    }
    [TrainNotiCenter  removeObserver:self name:kReachabilityChangedNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)SHMoviePlayerStartDownload:(NSString *)downUrl{


}



#pragma  mark  - 中间 菜单的点击 delegate
-(void)TrainClassMenuSelectIndex:(int)index{
    
    courseMode = index;
    [self removeNotifications];
    [self resetCommentView];

    if (index ==0) {
        [self addintroductionView];
        [self updateCourseInfo:coursIntroDic];

    }else{
        [self addcatalogueView:index];
    }
    if (!movieDefaultView) {
        [self.view bringSubviewToFront:self.playerView];
    }
    
    switch (index) {
        
        case 1:{
            if (TrainArrayIsEmpty(hourMuArr)) {
                [self downloadCourseInfo:1];
            }
        }
            break;
        case 2:{
            if (TrainArrayIsEmpty(noteMuArr)) {
                [self downloadCourseInfo:1];
            }
        }
            break;
        case 3:{
                [self downloadCourseInfo:1];
            
        }
            break;
        case 4:{
            if (TrainArrayIsEmpty(AppraiseMuArr)) {
                [self downloadCourseInfo:1];
            }
        }
            break;
            
        default:
            break;
    }
    if (index ==0) {
        if (TrainDictIsEmpty(coursIntroDic) ) {
            [self downloadCourseInfo:1];
        }else{
            [self updateCourseInfo:coursIntroDic];
        }
    }else {
        
        [courseTableView train_reloadData];
        if (index == 1 &&hourMuArr.count > 1) {
            
            NSIndexPath *selectRow = [NSIndexPath indexPathForRow:currentRow inSection:0];
            [courseTableView selectRowAtIndexPath:selectRow animated:NO scrollPosition:UITableViewScrollPositionTop];
            

        }
    }
    
}

#pragma  mark - 简介

-(void)addintroductionView{
    if (fiveBgView) {
        [fiveBgView removeFromSuperview];
        fiveBgView =nil;
    }
    if (downView) {
        [downView removeFromSuperview];
        downView =nil;
    }
    
    fiveBgView =[[UIView alloc]initWithFrame:CGRectZero];
    fiveBgView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:fiveBgView];
    
    UIScrollView  *scrollView =[[UIScrollView alloc]initWithFrame:CGRectZero];
    scrollView.showsVerticalScrollIndicator =NO;
    //    scrollView.bounces =NO;
    [fiveBgView addSubview:scrollView];
    
    fiveBgView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.courseMenuView,0)
    .bottomEqualToView(self.view);
    
    scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
 
    
    learnNumLab =[[UILabel alloc]creatContentLabel];
//    learnNumLab.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:learnNumLab];
    
    courseGradeLab =[[UILabel alloc]creatContentLabel];
    courseGradeLab.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:courseGradeLab];
    
    
    UIView   *line1 =[[UIView alloc]init];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [scrollView addSubview:line1];
    
    UILabel  *courseGailanLab = [[UILabel alloc]creatTitleLabel];
    courseGailanLab.text = @"课程概述";
    [scrollView addSubview:courseGailanLab];
    
    courseGaiContentLab =[[TrainUnfoldView alloc]initWithMaxHeight:3];
    [scrollView addSubview:courseGaiContentLab];
    
    UILabel  *peopleLab = [[UILabel alloc]creatTitleLabel];
    peopleLab.text = @"适用人群";
    [scrollView addSubview:peopleLab];
    
    peopleContentLab =[[UILabel alloc]creatContentLabel];
    [scrollView addSubview:peopleContentLab];
    
    UIView   *line2 =[[UIView alloc]init];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [scrollView addSubview:line2];
    
    UILabel  *tagertLab = [[UILabel alloc]creatTitleLabel];
    tagertLab.text = @"学习目标";
    [scrollView addSubview:tagertLab];
    
    tagertContentLab =[[UILabel alloc]creatContentLabel];
    [scrollView addSubview:tagertContentLab];
    
  
    
    learnNumLab.sd_layout
    .leftSpaceToView(scrollView,TrainMarginWidth)
    .topSpaceToView(scrollView,10)
    .widthIs(100)
    .heightIs(15);
    
    
    courseGradeLab.sd_layout
    .leftSpaceToView(learnNumLab,10)
    .topEqualToView(learnNumLab)
    .widthIs(100)
    .heightRatioToView(learnNumLab,1);
    
    line1.sd_layout
    .leftSpaceToView(scrollView,0)
    .rightSpaceToView(scrollView,0)
    .topSpaceToView(learnNumLab,10)
    .heightIs(10);
    
    courseGailanLab.sd_layout
    .leftSpaceToView(scrollView ,TrainMarginWidth)
    .topSpaceToView(line1,TrainMarginWidth)
    .widthIs(100)
    .heightIs(20);
    
    courseGaiContentLab.sd_layout
    .leftSpaceToView(scrollView,0)
    .topSpaceToView(courseGailanLab,10)
    .rightSpaceToView(scrollView,0);
    
    peopleLab.sd_layout
    .leftSpaceToView(scrollView ,TrainMarginWidth)
    .topSpaceToView(courseGaiContentLab,10)
    .widthIs(100)
    .heightIs(20);
    
    peopleContentLab.sd_layout
    .leftSpaceToView(scrollView ,TrainMarginWidth)
    .rightSpaceToView(scrollView,TrainMarginWidth)
    .topSpaceToView(peopleLab,10)
    .autoHeightRatio(0);
    
    line2.sd_layout
    .leftSpaceToView(scrollView,TrainMarginWidth)
    .rightSpaceToView(scrollView,TrainMarginWidth)
    .topSpaceToView(peopleContentLab,10)
    .heightIs(0.7);
    
    tagertLab.sd_layout
    .leftSpaceToView(scrollView ,TrainMarginWidth)
    .topSpaceToView(line2,10)
    .widthIs(100)
    .heightIs(20);
    
    tagertContentLab.sd_layout
    .leftSpaceToView(scrollView ,TrainMarginWidth)
    .rightSpaceToView(scrollView,TrainMarginWidth)
    .topSpaceToView(tagertLab,10)
    .autoHeightRatio(0);
//    [self updateCourseInfo:coursIntroDic];
    [scrollView setupAutoContentSizeWithBottomView:tagertContentLab bottomMargin:10];
}

-(void)updateCourseInfo:(NSDictionary *)dic{
    
    NSDictionary  *introDic =dic[@"course"];
    learnNumLab.text = [NSString stringWithFormat:@"%d 人学过",[introDic[@"study_num"] intValue]];
    courseGradeLab.text = [NSString stringWithFormat:@"%d 星评价",[introDic[@"grade"] intValue]];
    courseGaiContentLab.text = [TrainStringUtil trainReplaceHtmlCharacter:introDic[@"introduction"]];
    peopleContentLab.text = [TrainStringUtil trainReplaceHtmlCharacter:introDic[@"forPerson"]];
    tagertContentLab.text = [TrainStringUtil trainReplaceHtmlCharacter:introDic[@"studyTarget"]];

}


-(void)addcatalogueView:(int)index{
    
    if (fiveBgView) {
        [fiveBgView removeFromSuperview];
        fiveBgView =nil;
    }
    if (downView) {
        [downView removeFromSuperview];
        downView =nil;
    }
    
    
    fiveBgView =[[UIView alloc]init];
    
    fiveBgView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:fiveBgView];
   
    
    fiveBgView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.courseMenuView,0)
    .bottomSpaceToView(self.view,0);
    
    
//    UIView   *freeSizeView;
    
    if (index ==1) {
        
        freeSizeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, 50)];;
        freeSizeView.userInteractionEnabled  = YES;
        
        UILabel *sizeLab = [[UILabel alloc] initCustomLabel];
        sizeLab.text = [TrainStringUtil trainGetFreeSize];
        sizeLab.textColor =TrainColorFromRGB16(0xAFAFAF);
        [freeSizeView addSubview:sizeLab];

        UIView  *line =[[UIView alloc]init];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [freeSizeView addSubview:line];

        NSString *str = @"删除已下载";
        deleteBtn = [[TrainImageButton alloc]initWithFrame:CGRectMake(TrainSCREENWIDTH -  TrainMarginWidth - 100, 5, 100, 30) andImage:nil andTitle:str];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:TrainContentFont];
        deleteBtn.cusimage = [UIImage imageNamed:@"Train_MyNote_Detele"];
        deleteBtn.imageLocation = TrainImageLocationLeft;
        deleteBtn.imageSize = CGSizeMake(15, 15);
        [deleteBtn setTitleColor:TrainContentColor forState:UIControlStateNormal];
        [freeSizeView addSubview:deleteBtn];
        
        [deleteBtn addTarget:self action:@selector(deleteAllDownMovie)];
        
        sizeLab.sd_layout
        .leftSpaceToView(freeSizeView,10)
        .topSpaceToView(freeSizeView,10)
        .widthIs(150)
        .heightIs(20);
        
        line.sd_layout
        .leftEqualToView(freeSizeView)
        .rightEqualToView(freeSizeView)
        .topSpaceToView(sizeLab,10)
        .heightIs(10);
        
        UITapGestureRecognizer   *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoCacheVC)];
        [freeSizeView addGestureRecognizer:tap];
        
        [self updateDownloadSize];
        
    }else if (index ==2) {
        
        
        if (isRegister) {
            downView  =[[UIView alloc]init];
            downView.backgroundColor =[UIColor groupTableViewBackgroundColor];
            [fiveBgView addSubview:downView];
            downView.sd_layout
            .leftEqualToView(fiveBgView)
            .rightEqualToView(fiveBgView)
            .bottomSpaceToView(fiveBgView,0)
            .heightIs(50);
  
        }
        
        downView.hidden = !isRegister;
        
        
        UIButton  *addnote =[[UIButton alloc]initCustomButton];
        addnote.backgroundColor = TrainNavColor ;
        addnote.layer.cornerRadius = 8;
        addnote.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [addnote setTitle:@"添加笔记" forState:UIControlStateNormal];
        [addnote setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addnote addTarget:self action:@selector(addnote) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:addnote];
        addnote.sd_layout
        .centerXEqualToView(downView)
        .centerYEqualToView(downView)
        .widthIs(150)
        .heightIs(40);
        
        
    }else if(index ==3){
        
        if (isRegister) {
            downView  =[[UIView alloc]init];
            downView.backgroundColor =[UIColor groupTableViewBackgroundColor];
            [self.view addSubview:downView];
            
            downView.sd_layout
            .leftEqualToView(self.view)
            .rightEqualToView(self.view)
            .bottomSpaceToView(self.view,0)
            .heightIs(50);
            
        }
    
        commentTextView = [[TrainCustomTextView alloc]init];
        commentTextView.font = [UIFont systemFontOfSize:14.0f];
        commentTextView.isAutolayoutHeight = YES;
        commentTextView.maxNumberOfLines = 4;
        commentTextView.placeholder = TrainCommentText;
        commentTextView.placeholderColor = TrainContentColor;
        commentTextView.backgroundColor = [UIColor whiteColor];
        commentTextView.delegate = self;
        [downView addSubview:commentTextView];

        __weak  typeof(downView)weakView = downView;
        commentTextView.trainTextHeightChangeBlock =^(CGFloat height){
            
            [UIView animateWithDuration:0.3 animations:^{
                
                weakView.sd_layout.heightIs(height+20);
                [weakView updateLayout];
            }];
            
        };
        
        UIButton  *button = [[UIButton alloc]initCustomButton];
        button.layer.cornerRadius = 3.0f;
        
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:TrainNavColor];
        [button addTarget:self action:@selector(sendComment:)];
        [downView addSubview:button];
        
        button.sd_layout
        .rightSpaceToView(downView,TrainMarginWidth)
        .bottomSpaceToView(downView,10)
        .widthIs(50)
        .heightIs(30);
        
        commentTextView.sd_layout
        .leftSpaceToView(downView,TrainMarginWidth)
        .rightSpaceToView(button,10)
        .topSpaceToView(downView,10)
        .bottomSpaceToView(downView,10);
        

//        注册通知
        [self registeNotifications];
        
        
    }
    if (index ==1) {
         courseTableView =[[TrainBaseTableView alloc]initWithFrame:CGRectZero andTableStatus:tableViewRefreshNone];
        courseTableView.tableHeaderView =freeSizeView;
    }else{
         courseTableView =[[TrainBaseTableView alloc]initWithFrame:CGRectZero andTableStatus:tableViewRefreshFooter];
    }
    courseTableView.currentpage = 1;
    courseTableView.dataSource =self;
    courseTableView.delegate=self;
    courseTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    courseTableView.tableFooterView =[[UIView alloc]init];
    
    [courseTableView registerClass:[TrainCourseDirectoryCell  class] forCellReuseIdentifier:@"cellList"];
    [courseTableView registerClass:[TrainCourseNoteCell  class] forCellReuseIdentifier:@"cellNote"];
    [courseTableView registerClass:[TrainCourseDiscussCell  class] forCellReuseIdentifier:@"cellComment"];
    [courseTableView registerClass:[TrainCourseAppraiseCell  class] forCellReuseIdentifier:@"cellAppresise"];
    
    [fiveBgView addSubview:courseTableView];
    
    float   bottomhei;
    bottomhei = (downView)?50:0;
    courseTableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, bottomhei, 0));
 
    TrainWeakSelf(self);
    courseTableView.footBlock = ^(int index){
      
        [weakself downloadCourseInfo:index];
    };

    [fiveBgView updateLayout];
    [courseTableView updateLayout];
    
}
// 去缓存页面
-(void)gotoCacheVC{
   
    TrainCacheListViewController  *cacheVC = [[TrainCacheListViewController alloc]init];
    cacheVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cacheVC animated:YES];
    
}

-(void)updateDownloadSize{
    
    
    NSArray  *arr = self.downLoadMuArr.copy;
    
    __block   unsigned long  long  tot =0;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainDownloadModel *model = obj;
        if (model.status == TrainFileDownloadStateFinish) {
            tot += model.totalSize;
        }
    }];

    NSString *str ;
    NSString *totsize =@" ";
    if(tot > 0){
        totsize = [NSString stringWithFormat:@"(%.1f%@)",
                   calculateFileSizeInUnit(tot),
                   calculateUnit(tot)];
        str = [NSString stringWithFormat:@"删除已下载 %@",totsize];
    }else{
        str =@"删除已下载";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        float   width = 30 +5 * 12 + totsize.length * 8;
        deleteBtn.frame  = CGRectMake(TrainSCREENWIDTH - TrainMarginWidth -width , 5, width, 30);
        [deleteBtn setTitle:str forState:UIControlStateNormal];
//        deleteBtn.textTitle = str;
    });

}

-(void)deleteAllDownMovie{
    
    NSArray  *arr = self.downLoadMuArr.copy;

    if (arr.count >0) {
        
        [TrainAlertTools showAlertWith:self title:@"提示" message:@"是否删除该课程的所有缓存的视频" callbackBlock:^(NSInteger btnIndex) {
            
            if(btnIndex == 1){
                
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  
                    TrainDownloadModel *downloadModel = obj;
                    if (downloadModel.status == TrainFileDownloadStateFinish) {
                        [self.downManager deleteDownloadWithFileId:downloadModel];
                    }else{
                        [self.downManager cancelDownloadWithFileId:downloadModel];
                    }
                }];
                
                self.downLoadMuArr =[NSMutableArray array];
                if (courseMode == TrainCourseDetailModeDirectory) {
                    [courseTableView reloadData];
                    [self updateDownloadSize];
                }
                
            }
            
        } cancelButtonTitle:@"否" destructiveButtonTitle:@"是" otherButtonTitles:nil, nil];
        
        
    }
    
 
    
    
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (courseMode == TrainCourseDetailModeDiscuss) {
        [commentTextView resignFirstResponder];
    }
    
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (!commentInfo && TrainStringIsEmpty(topicType)) {
       
        [TrainAlertTools showActionSheetWith:self title:@"" message:@"" callbackBlock:^(NSInteger btnIndex) {
            
            if (btnIndex == 1) {
                topicType = @"T";
                [commentTextView becomeFirstResponder];
            }else if (btnIndex == 2) {
                topicType = @"Q";
                [commentTextView becomeFirstResponder];

            }
        } destructiveButtonTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发话题",@"发问答", nil];
        return NO;
        
    }else{
        return YES;
    }
    
    return YES;
    
}
#pragma  mark -发表讨论
-(void)sendComment:(UIButton *)btn
{
    if ([TrainStringUtil trainIsBlankString:commentTextView.text]) {
        [self trainShowHUDOnlyText:@"输入为空"];
        return;
    }
    [self trainShowHUDOnlyActivity];
    TrainWeakSelf(self);
    if ( !commentInfo) {
        NSMutableDictionary *mudic = [NSMutableDictionary dictionary];

        [mudic setObject:commentTextView.text                    forKey:@"content"];
        [mudic setObject:notEmptyStr(self.courseModel.object_id) forKey:@"object_id"];
        [mudic setObject:notEmptyStr(self.lastHour_id)           forKey:@"classHour_id"];
        [mudic setObject:notEmptyStr(self.courseModel.type)      forKey:@"type"];
        [mudic setObject:notEmptyStr(self.courseModel.room_id)   forKey:@"room_id"];
        [mudic setObject:notEmptyStr(self.courseModel.c_id)      forKey:@"c_id"];
        [mudic setObject:topicType                              forKey:@"topic_type"];
        
        [[TrainNetWorkAPIClient client] trainCourseAddNewDiscussWithinfoDic:mudic Success:^(NSDictionary *dic) {
            
            NSString *str = @"";
            if ([dic[@"success"] isEqualToString:@"S"]) {
//                NSArray   *dataArr  = [TrainCourseDiscussModel mj_objectArrayWithKeyValuesArray:dic[@"discussions"]];
//                
//                dataArr = [self dealWithCourseCommentData:dataArr];
//                
//                discussMuArr = [NSMutableArray arrayWithArray:dataArr];
//                [self resetCommentView];
//                
//                
//                str = @"发表新讨论成功";
//                [courseTableView reloadData];
                [weakself downloadCourseInfo:1];
                [weakself resetCommentView];

            }else{
                str = dic[@"msg"];
                [weakself trainShowHUDOnlyText:str];

            }
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            [weakself trainShowHUDNetWorkError];
        }];
    }else{
        
        NSMutableDictionary *mudic = [NSMutableDictionary dictionary];

        NSString *sendStr  = commentTextView.text;
        if ( !TrainStringIsEmpty(huiFuName) ) {
            if (commentInfo.isFirst ) {
                sendStr = commentTextView.text;
            }else{
                sendStr =[NSString  stringWithFormat:@"回复 %@:%@",huiFuName,commentTextView.text];
            }
            
            [mudic setObject:sendStr forKey:@"content"];
            [mudic setObject:notEmptyStr(commentInfo.object_id) forKey:@"topic_id"];
            [mudic setObject:notEmptyStr(commentInfo.user_id) forKey:@"from_user_id"];
            [mudic setObject:notEmptyStr(commentInfo.discuss_id) forKey:@"from_post_id"];
            
        }else{
            
            [mudic setObject:sendStr forKey:@"content"];
            [mudic setObject:notEmptyStr(commentInfo.discuss_id) forKey:@"topic_id"];
            [mudic setObject:@"0" forKey:@"from_user_id"];
            [mudic setObject:@"0" forKey:@"from_post_id"];
        }
        
        [[TrainNetWorkAPIClient client] trainPostTopicWithinfoDic:mudic postType:YES Success:^(NSDictionary *dic) {
            
            if ([dic[@"success"] isEqualToString:@"S"]) {
                
                if ( commentInfo && !TrainStringIsEmpty(huiFuName) ) {
                
                    NSArray  *arr = [TrainCourseDiscussListModel mj_objectArrayWithKeyValuesArray:dic[@"post"]];
                
                    [weakself updateUIAfterSendCommentSuccess:arr];
                    
                    [courseTableView reloadRowsAtIndexPaths:@[commentSelect] withRowAnimation:UITableViewRowAnimationNone];
                    [weakself resetCommentView];

                    
                }else{
                   
                    courseTableView.currentpage = 1;
                    [weakself downloadCourseInfo:1];
                    [weakself resetCommentView];
                }
                
            }else{

                [self trainShowHUDOnlyText:dic[@"msg"]];
            }

        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            
            [weakself trainShowHUDNetWorkError];
        }];
        
    
    }
    
 }

-(void)updateUIAfterSendCommentSuccess:(NSArray *)arr{
  
    TrainCourseDiscussModel *mod = discussMuArr[commentSelect.row];

    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainCourseDiscussListModel *mod1 =obj;
        NSArray  *arr1 =[TrainCourseDiscussListModel  mj_objectArrayWithKeyValuesArray:mod1.child_post_list];
        int   super_id =(int)idx;
        [arr1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainCourseDiscussListModel *mod2 =obj;
            NSArray  *arr2 =[TrainCourseDiscussListModel  mj_objectArrayWithKeyValuesArray:mod2.child_post_list];
            mod2.child_post_list =arr2;
            mod2.super_id =[NSString stringWithFormat:@"%d",super_id];
            if (idx == 0) {
                mod2.isFirst =YES;
            }else{
                mod2.isFirst =NO;
            }
        }];
        
        mod1.child_post_list =arr1;
        
    }];
    
    mod.posts = arr;
    

}


-(void)registeNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardFram:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)removeNotifications{
    [TrainNotiCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [TrainNotiCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}


-(void)changeKeyboardFram:(NSNotification *)noti{
    NSDictionary  *info =[noti userInfo];
    CGSize  keyHeight =[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        downView.sd_layout.bottomSpaceToView(self.view ,keyHeight.height);
        [downView updateLayout];

    }];

}
-(void)KeyboardHide:(NSNotification *)noti{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        downView.sd_layout.bottomSpaceToView(self.view , 0);
        [downView updateLayout];
        
    }];
}

-(void)resetCommentView{
    
    commentInfo   = nil;
    huiFuName     = nil;
    commentSelect = nil;
    topicType     =  @"";
    if (courseMode != TrainCourseDetailModeDiscuss ) {
        return;
    }
    if(downView){
        [UIView animateWithDuration:0.25 animations:^{
            
            downView.sd_layout.heightIs(50);
            [downView updateLayout];
            
        }];
    }
    commentTextView.text = @"";
    commentTextView.placeholder = TrainCommentText;
    [commentTextView resignFirstResponder];

}
#pragma mark - 加笔记
-(void)addnote{
    
 
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    
    [mudic setObject:notEmptyStr(self.courseModel.type) forKey:@"type"];
    [mudic setObject:notEmptyStr(self.courseModel.c_id) forKey:@"c_id"];
    [mudic setObject:notEmptyStr(self.courseModel.object_id) forKey:@"object_id"];
    [mudic setObject:notEmptyStr(self.lastHour_id) forKey:@"hour_id"];
    [mudic setObject:notEmptyStr(self.courseModel.room_id) forKey:@"room_id"];
    
    TrainAddNoteViewController   *noteVC =[[TrainAddNoteViewController alloc]init];

    noteVC.infoDic = mudic;
    noteVC.isEditNote = NO;
    noteVC.delegate = self;
    [self.navigationController pushViewController:noteVC animated:YES];
    
    
}

-(void)saveNoteSuccess:(NSDictionary *)dic{
    if (!TrainDictIsEmpty(dic)) {
        if ([self.courseModel.type isEqualToString:@"TRAIN"]) {
            noteMuArr =[TrainCourseNoteModel  mj_objectArrayWithKeyValuesArray:dic[@"courseNotes"]];
        }else {
            noteMuArr = [TrainCourseNoteModel  mj_objectArrayWithKeyValuesArray:dic[@"notes"]];
        }
        [courseTableView train_reloadData];
    }else{
        [self downloadCourseInfo:1];
    }
}

#pragma mark - 评价  delegate

-(void)saveAppraiseSuccess:(NSDictionary *)dic{
    TrainCourseAppraiseModel *mo = [TrainCourseAppraiseModel  mj_objectWithKeyValues:dic];
    
    if (AppraiseMuArr.count > 0) {
        [AppraiseMuArr replaceObjectAtIndex:0 withObject:mo];
        NSIndexPath  *index =[NSIndexPath indexPathForRow:0 inSection:0];
        [courseTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    }
}



#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (courseMode)
    {
        case TrainCourseDetailModeDirectory:
            return 50;
            break;
        case TrainCourseDetailModeNote:
            return [tableView cellHeightForIndexPath:indexPath model:noteMuArr[indexPath.row] keyPath:@"model" cellClass:[TrainCourseNoteCell class ] contentViewWidth:TrainSCREENWIDTH];
            break;
        case TrainCourseDetailModeDiscuss:
            return [tableView cellHeightForIndexPath:indexPath model:discussMuArr[indexPath.row] keyPath:@"model" cellClass:[TrainCourseDiscussCell class ] contentViewWidth:TrainSCREENWIDTH];
            break;
        case TrainCourseDetailModeAppraise:
            return [tableView cellHeightForIndexPath:indexPath model:AppraiseMuArr[indexPath.row] keyPath:@"model" cellClass:[TrainCourseAppraiseCell class ] contentViewWidth:TrainSCREENWIDTH];
            break;
            
        default:
            break;
    }
    return 0 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (courseMode)
    {
        case TrainCourseDetailModeDirectory:
            return (hourMuArr)?hourMuArr.count:0;
            break;
        case TrainCourseDetailModeNote:
            return (noteMuArr)?noteMuArr.count:0;
            break;
        case TrainCourseDetailModeDiscuss:
            return (discussMuArr)?discussMuArr.count:0;
            break;
        case TrainCourseDetailModeAppraise:
            return (AppraiseMuArr)?AppraiseMuArr.count:0;
            break;
            
        default:
            break;
    }
    return 0;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainWeakSelf(self);
    switch (courseMode)
    {
        case TrainCourseDetailModeDirectory:
        {
            
            TrainCourseDirectoryCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"cellList"];
            TrainCourseDirectoryModel   *listModel =  hourMuArr[indexPath.row];
            __block TrainDownloadModel  *downModel = nil;
            [self.downLoadMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TrainDownloadModel  *downM = obj;
                if (downM.selectIndex == indexPath.row ) {
                    downModel = downM;
                    *stop = YES;
                }
            }];
            
            listCell.isRegister = isRegister;
            listCell.downModel  = downModel;
            listCell.model      = listModel;
            listCell.trainDownloadStatus = ^(BOOL isFinish){
              
                if (isFinish) {
                    [weakself deleteMovieWithModel:indexPath];
                }else{
                    [weakself startDownloadMovieWithmodel:indexPath];
                }
            };
            
            return listCell;
        }
            break;
        case TrainCourseDetailModeNote:
        {
            TrainCourseNoteCell  *noteCell = [tableView dequeueReusableCellWithIdentifier:@"cellNote"];
            TrainCourseNoteModel *noteModel = noteMuArr[indexPath.row];
            noteCell.model = noteModel;
            noteCell.unfoldBlock =^(){
                noteModel.isOpen =!noteModel.isOpen;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return noteCell;
        }
            break;
        case TrainCourseDetailModeDiscuss:
        {
             TrainCourseDiscussCell  *discussCell = [tableView dequeueReusableCellWithIdentifier:@"cellComment"];
            TrainCourseDiscussModel *model = discussMuArr[indexPath.row];
            discussCell.index = indexPath.row;
            discussCell.model =model;
            
            TrainWeakSelf(self);
            discussCell.topicLine =^(TrainCourseDiscussModel *mod, NSString *userName){
                if ([mod.myuser_id isEqualToString:TrainUser.user_id] ) {
                
                    commentInfo     = mod;
                    commentSelect   = indexPath;
                    huiFuName       = userName;
                    
                    [weakself removeOnlyTopicPostWith:mod];
                    
                }else{
                    BOOL  qqq = [commentInfo isEqual:mod];
                    if (commentInfo && qqq ) {
                        [weakself resetCommentView];

                    }else{
                        commentInfo     = mod;
                        commentSelect   = indexPath;
                        huiFuName       = userName;
                        [weakself commentHuiFu];
                    }
                }
            };
            discussCell.topicName =^(NSString *user_id){
                NSLog(@"%@",user_id);
            };

            return discussCell;
        }
            break;
        case TrainCourseDetailModeAppraise:
        {
             TrainCourseAppraiseCell  *appraiseCell = [tableView dequeueReusableCellWithIdentifier:@"cellAppresise"];
            appraiseCell.isFirst = (indexPath.row == 0);
            TrainCourseAppraiseModel *appModel =AppraiseMuArr[indexPath.row];
            appraiseCell.model = appModel;
            appraiseCell.unfoldBlock =^(){
                appModel.isOpen =!appModel.isOpen;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return appraiseCell;
        }
            break;
            
        default:
            break;
    }

    UITableViewCell   *cell =[[UITableViewCell alloc]init];
    
    return cell;
}

#pragma mark - 下载 download


-(void)startDownloadMovieWithmodel:(NSIndexPath *)index{
    
    TrainCourseDirectoryModel   *listModel =  hourMuArr[index.row];
    
    [[TrainNetWorkAPIClient client] trainGetMovieUrlWithobject_id:listModel.object_id Success:^(NSDictionary *dic) {
        
        NSString  *url = @"" ;
        if ([dic[@"status"] boolValue] ) {
            
           if(!TrainStringIsEmpty(dic[@"url"])){
                
                url =dic[@"url"];
               
               NSString  *encode =[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
               TrainDownloadModel  *model =[[TrainDownloadModel alloc]init];
               model.url           = encode;
               model.c_id          = listModel.c_id;
               model.hour_id       = listModel.list_id;
               model.object_id     = listModel.object_id;
               NSString  *cho_id   = [NSString stringWithFormat:@"%@%@%@",listModel.c_id,listModel.list_id,listModel.object_id];
               model.CHO_id        = cho_id;
               model.courseName    = self.courseModel.name;
               model.hourName      = listModel.title;
               model.selectIndex   = index.row;
               model.imageUrl      = coursIntroDic[@"course"][@"picture"];
               model.last_time      = [listModel.last_time integerValue];
               
               if ([listModel.c_type isEqualToString:@"V"]) {
                   [self.downManager addDownloadWithDownLoadModel:model];
                   [self.downLoadMuArr addObject:model];
                   [self.downReloadCellTimer setFireDate:[NSDate date]];
               }
           }else{
               [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:@"获取视频地址失败,请重试" buttonTitle:@"知道了" buttonStyle:TrainAlertActionStyleCancel];

           }
           
        }else{
            [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:@"获取视频地址失败,请重试" buttonTitle:@"知道了" buttonStyle:TrainAlertActionStyleCancel];

        }
       
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:@"获取视频地址失败,请重试" buttonTitle:@"知道了" buttonStyle:TrainAlertActionStyleCancel];
    }];
    
}
#pragma mark - 删除已下载   download

-(void)deleteMovieWithModel:(NSIndexPath *)index{
    TrainCourseDirectoryModel   *downModel =  hourMuArr[index.row];

    NSString  *cho_id   = [NSString stringWithFormat:@"%@%@%@",downModel.c_id,downModel.list_id,downModel.object_id];

    __block TrainDownloadModel  *dddModel  = nil;
    
    [self.downLoadMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainDownloadModel  *downM   = obj;

        if ([downM.CHO_id isEqualToString:cho_id]) {
            dddModel = downM;
            *stop = YES;
        }
    }];
    
    if ( dddModel) {
        
        [TrainAlertTools showAlertWith:self title:@"提示" message:@"是否删除该视频" callbackBlock:^(NSInteger btnIndex) {
            
            if(btnIndex == 1){
                
                [self.downManager  deleteDownloadWithFileId:dddModel];
                [dddModel deleteObjectsByColumnName:@[@"CHO_id"]];
                [self.downLoadMuArr removeObject:dddModel];
                [self updateDownloadSize];

                [courseTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            
        } cancelButtonTitle:@"否" destructiveButtonTitle:@"是" otherButtonTitles:nil, nil];

        
        
        
    }
    
    
}


#pragma mark - 下载 delegate


-(void)fileDownloadManagerStartDownload:(TrainDownloadModel *)download{
    
}

-(void)fileDownloadManagerReceiveResponse:(TrainDownloadModel *)download FileSize:(uint64_t)totalLength{
    NSArray   *arr = self.downLoadMuArr.copy;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainDownloadModel  *downM = obj;
        
        if ([downM.CHO_id isEqualToString:download.CHO_id]) {
            [self.downLoadMuArr replaceObjectAtIndex:idx withObject:download];
            *stop = YES;
        }
    }];

}

-(void)fileDownloadManagerFinishDownload:(TrainDownloadModel *)download success:(BOOL)downloadSuccess error:(NSError *)error{
    
    if (downloadSuccess) {
        NSArray   *arr = self.downLoadMuArr.copy;
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainDownloadModel  *downM = obj;
            
            if ([downM.CHO_id isEqualToString:download.CHO_id]) {
                [self.downLoadMuArr replaceObjectAtIndex:idx withObject:download];
                *stop = YES;
            }
        }];
        if (arr.count > 0) {
            [courseTableView reloadData];
            [self updateDownloadSize];
//            NSIndexPath  *index = [NSIndexPath indexPathForRow:download.selectIndex inSection:0];
//            if (courseMode == TrainCourseDetailModeDirectory) {
//                [courseTableView  reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
//            }

        }
    }else{
        
    }
    
}

-(void)fileDownloadManagerUpdateProgress:(TrainDownloadModel *)download didReceiveData:(uint64_t)receiveLength downloadSpeed:(NSString *)downloadSpeed{

    NSArray   *arr = self.downLoadMuArr.copy;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainDownloadModel  *downM = obj;
        
        if ([downM.CHO_id isEqualToString:download.CHO_id]) {
            [self.downLoadMuArr replaceObjectAtIndex:idx withObject:download];

            *stop = YES;
        }
    }];
    
}


-(void)reloadCell{
    if (courseMode == TrainCourseDetailModeDirectory && hourMuArr.count >0  ) {
        
        __block BOOL    isscfinish = YES;

        [self.downLoadMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainDownloadModel *dddModel = obj;
            if (dddModel.status != TrainFileDownloadStateFinish) {
                isscfinish = NO;
                *stop =YES;
            }
        }];

        if (isscfinish && self.downReloadCellTimer.isValid) {
            [self.downReloadCellTimer invalidate];
            self.downReloadCellTimer = nil;
        }
        
        [courseTableView reloadData];

    }
    
}


-(void)removeOnlyTopicPostWith:(TrainCourseDiscussModel *)model{
    
    TrainWeakSelf(self);
    [TrainAlertTools showActionSheetWith:self title:@"" message:@"" callbackBlock:^(NSInteger btnIndex) {
        
        if(btnIndex == 0){
            [self trainShowHUDOnlyActivity];
            
            if (huiFuName ) {
                [[TrainNetWorkAPIClient client] trainRemoveTopicPostWithTopic_id:model.object_id post_id:model.mypost_id Success:^(NSDictionary *dic) {
                    
                    NSString  *str = @"";
                    if ([dic[@"success"] isEqualToString:@"S"]) {
                        str = @"删除成功";
                        [self updateAfterRemovePost:model];
                  
                    }else{
                        str = dic[@"msg"];
                    }
                    [weakself resetCommentView];

                    [weakself trainShowHUDOnlyText:str];
                    
                } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
                    [weakself trainShowHUDNetWorkError];
                    
                }];
 
            }else{
               
                
                NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
                [mudic setObject:self.courseModel.object_id forKey:@"object_id"];
                [mudic setObject:model.discuss_id forKey:@"id"];
                NSArray  *arr = @[mudic];
                
                NSString *strObj = [arr mj_JSONString];
                
                [[TrainNetWorkAPIClient client] trainRemoveTopicWithtopicInfo:strObj Success:^(NSDictionary *dic) {
                    
                    NSString *str = @"";
                    if ([dic[@"success"] isEqualToString:@"S"]) {
                        str = @"删除成功";
                      
                        [discussMuArr removeObjectAtIndex:commentSelect.row];
                        [discussMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            TrainCourseDiscussModel *disModel = obj;
                            disModel.totCount = [NSString stringWithFormat:@"%zi",discussMuArr.count ];
                        }];
                        [courseTableView train_reloadData];
                        
                    }else{
                        str = dic[@"msg"];
                    }
                    [weakself resetCommentView];
                    [weakself trainShowHUDOnlyText:str];
                    
                } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
                    [weakself trainShowHUDNetWorkError];
                    
                }];
                
            }
            
            
        }else if(btnIndex ==2){
           
            [self commentHuiFu];

        }
    
    } destructiveButtonTitle:@"删除" cancelButtonTitle:@"取消" otherButtonTitles:@"回复", nil];
}

-(void)updateAfterRemovePost:(TrainCourseDiscussModel *)model{
    
    TrainCourseDiscussModel *disModel = discussMuArr[commentSelect.row];
    NSMutableArray  *muArr = [NSMutableArray  arrayWithArray:disModel.posts];
    
    [disModel.posts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      
        TrainCourseDiscussListModel  *listModel = obj;
        if ([listModel.discuss_id isEqualToString:model.mypost_id]) {
            [muArr removeObject:listModel];
            *stop  = YES;
        }else{
    
            NSMutableArray  *postMuArr = [NSMutableArray arrayWithArray:listModel.child_post_list];
            [listModel.child_post_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TrainCourseDiscussListModel  *postModel = obj;
                if ([postModel.discuss_id isEqualToString:model.mypost_id]) {
                    [postMuArr removeObject:postModel];
                    *stop  = YES;
                }
            }];
            listModel.child_post_list = postMuArr;
        }
    }];
    disModel.posts = muArr;
    
    [courseTableView reloadRowsAtIndexPaths:@[commentSelect] withRowAnimation:UITableViewRowAnimationNone];
    
}


-(void)commentHuiFu{

    [commentTextView becomeFirstResponder];
    
    NSString  *placeholderStr;
    if (huiFuName) {
        placeholderStr =[NSString  stringWithFormat:@"@%@",huiFuName];
    }else{
        placeholderStr =[NSString  stringWithFormat:@"@%@",commentInfo.full_name];
    }
    commentTextView.placeholder =placeholderStr;

    
}
#pragma  mark 删除自己的评价

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (courseMode == TrainCourseDetailModeAppraise) {
        TrainCourseAppraiseModel  *myAppraise = [AppraiseMuArr firstObject];
        
        int  group = [myAppraise.grade intValue];
        if (indexPath.row == 0 && group > 0 ) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete && courseMode == TrainCourseDetailModeAppraise) {
        
        [self trainShowHUDOnlyActivity];
        
        BOOL   isclass = NO;
        TrainCourseAppraiseModel  *appModel = [AppraiseMuArr firstObject];

        NSString * appraise_id = appModel.app_id;
        
        [[TrainNetWorkAPIClient client] trainCourseDeleteAppraiseWithIsClass:isclass Appraise_id:appraise_id Success:^(NSDictionary *dic) {
            
            
            [self trainShowHUDOnlyText:TrainDeleteSuccess andoff_y:150.0f];

            TrainCourseAppraiseModel  *newApp = [[TrainCourseAppraiseModel alloc]init];
            newApp.create_by = @"0";
            newApp.grade = @"0";
            newApp.totPage = @"0";
            [AppraiseMuArr replaceObjectAtIndex:0 withObject:newApp];
            
            [courseTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            [self trainShowHUDOnlyText:TrainDeleteFail];

        }];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (!isRegister) {
        NSString   *str;
        if (courseMode == TrainCourseDetailModeDirectory) {
            str =@"该课程您还没有参加，所以不能在手机上学习，请到电脑端进行参加";
        }else if (courseMode == TrainCourseDetailModeAppraise) {
            str =@"亲,您先参加课程才能评价哦!";
        }else{
            return;
        }
        [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:str buttonTitle:@"确定" buttonStyle:TrainAlertActionStyleCancel];
        
    }else{
        
        
        
        if (courseMode == TrainCourseDetailModeDirectory ) {
            
            TrainCourseDirectoryModel  *listModel = hourMuArr[indexPath.row];
          
            if ([listModel.h_type isEqualToString:@"H"] ||[listModel.h_type isEqualToString:@"E"] ) {
               
                lastHourRow = currentRow;
                currentRow =indexPath.row;
                
                if (!movieDefaultView ) {
                    
                    if ([listModel.c_type isEqualToString:@"V"] || [listModel.c_type isEqualToString:@"L"]) {
                        
                       
                        if(lastHourRow == currentRow){
                            return ;
                        }
                    }

                }
                [self playerHour:listModel];

            }
        }
        else if (courseMode == TrainCourseDetailModeAppraise && indexPath.row == 0) {
          
            TrainCourseAppraiseModel  *appModel = [AppraiseMuArr firstObject];
            if (appModel.grade && [appModel.grade intValue] == 0) {
                
                NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
                
                [mudic setObject:notEmptyStr(self.courseModel.type )     forKey:@"type"];
                [mudic setObject:notEmptyStr(self.courseModel.c_id)      forKey:@"c_id"];
                [mudic setObject:notEmptyStr(self.courseModel.object_id) forKey:@"object_id"];
                [mudic setObject:notEmptyStr(self.lastHour_id)           forKey:@"hour_id"];
                [mudic setObject:notEmptyStr(self.courseModel.room_id)   forKey:@"room_id"];
                
                TrainAddAppraiseViewController *appraiseVC =[[TrainAddAppraiseViewController alloc]init];
                
                appraiseVC.delegate =self;
                appraiseVC.infoDic = mudic;

                [self.navigationController pushViewController:appraiseVC animated:YES];
            }
            
        }else if (courseMode == TrainCourseDetailModeDiscuss){

            [commentTextView resignFirstResponder];
        
        }

    }
    
    
}

-(void)playerHour:(TrainCourseDirectoryModel *)hourModel{
    
    TrainWeakSelf(self);
    if ([hourModel.c_type isEqualToString:@"V"] || [hourModel.c_type isEqualToString:@"L"]) {
                
        lasthourModel = hourMuArr[lastHourRow];
        
        __block TrainDownloadModel  *downModel = nil;
        [self.downLoadMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainDownloadModel  *downM = obj;
            if ([downM.hour_id isEqualToString:hourModel.list_id] && downM.status == TrainFileDownloadStateFinish) {
                downModel = downM;
                *stop = YES;
            }
        }];
        
        if (downModel ) {
            if (movieDefaultView ) {
                [movieDefaultView removeFromSuperview];
                movieDefaultView = nil;
                TrainPlayerControlView *controlView = [[TrainPlayerControlView alloc] init];
                [self.playerView playerControlView:controlView playerModel:self.playerModel];
                

            }
            
            if ([hourModel.last_time integerValue] > 1) {
                self.playerModel.seekTime = [hourModel.last_time integerValue];
            }else{
                self.playerModel.seekTime = 0;
                
            }
            self.playerModel.title       = hourModel.title;
            
            NSString  *localMovieURL = [NSString stringWithFormat:@"%@/%@",learnCachesDirectory,downModel.saveFileName];
            
            self.playerModel.videoURL = [NSURL  fileURLWithPath:localMovieURL];
        
            [self.playerView resetToPlayNewVideo:self.playerModel];

            
        }else{

            Reachability *reach = [Reachability reachabilityForInternetConnection];
            
            if ([reach isReachableViaWWAN]) {
                NSDictionary  *dic = [TrainUserDefault valueForKey:TrainAllowWWANPlayer];
                BOOL isok =(dic[TrainUser.user_id])?[dic[TrainUser.user_id] boolValue]:NO;

                if (isok==NO)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.playerView pause];
                        
                        [TrainAlertTools showAlertWith:self title:@"提示" message:TrainWWANPlayerText callbackBlock:^(NSInteger btnIndex) {
                            
                            if(btnIndex ==1){
                                [weakself playMovieWithModel:hourModel];
                            }
                            
                        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
                    });
                    
                }
            }else{
                
                [self playMovieWithModel:hourModel];
                
            }
        }
        
    }else if([hourModel.c_type isEqualToString:@"D"] || [hourModel.c_type isEqualToString:@"E"]){
        isUpdate = YES;
        NSString *urlString = @"";
        if ([hourModel.c_type isEqualToString:@"D"]) {
            
            urlString = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"viewcoursedoc" object_id:hourModel.list_init_file andtarget_id:nil];
            
        }else if([hourModel.c_type isEqualToString:@"E"]){
            urlString = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"onlineExam" object_id:hourModel.object_id andtarget_id:@"0"];
        }
        TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
        webVC.webURL = urlString;
        webVC.navTitle = hourModel.title;
        
        [self.navigationController pushViewController:webVC animated:YES];
        
        
    }else{
        
        isUpdate = NO;
        [TrainAlertTools  showTipAlertViewWith:self title:@"提示" message:TrainHourNotSupportText buttonTitle:@"好的" buttonStyle:TrainAlertActionStyleCancel];
    }
    
}

-(void)playMovieWithModel:(TrainCourseDirectoryModel *)hourModel{
    
    if (movieDefaultView ) {
        [movieDefaultView removeFromSuperview];
        movieDefaultView = nil;
        TrainPlayerControlView *controlView = [[TrainPlayerControlView alloc] init];
        [self.playerView playerControlView:controlView playerModel:self.playerModel];
        

        
    }
    if ([hourModel.c_type isEqualToString:@"V"]) {
        if ([hourModel.last_time integerValue] > 1) {
            self.playerModel.seekTime = [hourModel.last_time integerValue];
        }else{
            self.playerModel.seekTime = 0;
            
        }
        self.playerModel.title       = hourModel.title;

    }else{
        

    }

    
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
        
        [self.playerView resetToPlayNewVideo:self.playerModel];
        

        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:@"获取视频地址失败,请重试" buttonTitle:@"知道了" buttonStyle:TrainAlertActionStyleCancel];
    }];
    
    
}

//-(BOOL )isDownloadFinish:(TrainCourseDirectoryModel *)hourModel{
// 
//    NSArray  *arr = [TrainDownloadModel findWithFormat:@"hour_id=%@ and object_id =%@ AND status = 4",hourModel.list_id, self.courseModel.object_id];
//    
//    return !TrainArrayIsEmpty(arr);
//}

-(void)updateStudyTime{
    
    if (!isUpdate) {
        isUpdate = YES;
        return;
    }
    learnTime = [startDate timeIntervalSinceNow];
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
        [mudic setObject:notEmptyStr(lastTime)                  forKey:@"ccm.last_time"];
        [mudic setObject:notEmptyStr(studytime)                 forKey:@"ccm.time"];
        [mudic setObject:notEmptyStr(self.lastCw_id)          forKey:@"ccm.cw_id"];
        [mudic setObject:studyCount                             forKey:@"go_num"];
        
    }else if([self.courseModel.type isEqualToString:@"CLASS"]){
        isCourse = NO;
        [mudic setObject:notEmptyStr(self.courseModel.class_id) forKey:@"ccm.object_id"];
        [mudic setObject:notEmptyStr(self.lastHour_id)          forKey:@"ccm.lh_id"];
        [mudic setObject:notEmptyStr(self.courseModel.c_id)     forKey:@"ccm.c_id"];
        [mudic setObject:notEmptyStr(self.lastCw_id)          forKey:@"ccm.cw_id"];
        [mudic setObject:notEmptyStr(lastTime)                  forKey:@"ccm.last_time"];
        [mudic setObject:notEmptyStr(studytime)                 forKey:@"ccm.time"];
        [mudic setObject:studyCount                             forKey:@"go_num"];
        

    }

    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainUpdateStudyTimeWithIsCourse:isCourse infoDic:mudic Success:^(NSDictionary *dic) {
        
        if ([dic[@"status"] boolValue]) {
            startDate =nil;
            
            TrainCourseDirectoryModel  *model = hourMuArr[lastHourRow];
            if ([model.c_type isEqualToString:@"V"] && ![model.ua_status isEqualToString:@"C"]) {
                if (![studyCount isEqualToString:@"1"]) {
                    [weakself updateHourInfo];

                }
               
            }else{
                model.last_time =lastTime;
                if (courseMode == TrainCourseDetailModeDirectory) {
                    NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:lastHourRow inSection:0];
                    [courseTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
        pausetime =0;
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
    
    
}

-(void)updateHourInfo{
    
    
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
   
    [dic setObject:notEmptyStr(self.courseModel.object_id) forKey:@"object_id"];
    
    [dic setObject:notEmptyStr(self.courseModel.type) forKey:@"type"];
    [dic setObject:notEmptyStr(self.courseModel.c_id) forKey:@"c_id"];
    
    if ([self.courseModel.type isEqualToString:@"TRAIN"]) {
        [dic setObject:@"0" forKey:@"room_id"];
        [dic setObject:@"0" forKey:@"class_id"];
    }else{
        [dic setObject:notEmptyStr(self.courseModel.class_id) forKey:@"class_id"];
        [dic setObject:notEmptyStr(self.courseModel.room_id) forKey:@"room_id"];
        
    }
    [[TrainNetWorkAPIClient client] trainCourseDetailInfoWithMode:courseMode infoDic:dic Success:^(NSDictionary *dic) {
        
        if (courseMode == TrainCourseDetailModeDirectory) {
            hourMuArr = [NSMutableArray array];
            hourMuArr = [TrainCourseDirectoryModel mj_objectArrayWithKeyValuesArray:dic[@"hour"]];
            
           
            NSIndexPath *lastRow = [NSIndexPath indexPathForRow:lastHourRow inSection:0];
            [courseTableView reloadRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationNone];
            
        }
     
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
}


-(TrainCourseAndClassModel *)courseModel{
    
    if (!_courseModel  && !TrainDictIsEmpty(_courseDic)) {
        TrainCourseAndClassModel *trainModel = [[TrainCourseAndClassModel alloc]init];
       
            trainModel.class_id = (TrainStringIsEmpty(_courseDic[@"class_id"] ))?@"0":_courseDic[@"class_id"] ;
            trainModel.object_id = _courseDic[@"id"] ;
            
            NSString  *typeStr = (TrainStringIsEmpty(_courseDic[@"type"]))?@"TRAIN":_courseDic[@"type"];
            
            trainModel.type = typeStr;
            trainModel.room_id = (TrainStringIsEmpty(_courseDic[@"room_id"]))?@"0":_courseDic[@"room_id"];
            trainModel.c_id = _courseDic[@"c_id"] ;
            trainModel.name = _courseDic[@"name"];
        
        
        _courseModel = trainModel;
       
    }
    return _courseModel;
}


-(TrainClassMenuView *)courseMenuView{
    
    if (_courseMenuView == nil) {
        NSArray *array = [TrainLocalData returnCourseDetailMenu];
        
        TrainClassMenuView *courseMenuView =[[TrainClassMenuView alloc]initWithFrame:CGRectZero andArr:array];
        courseMenuView.delegate =self;
        _courseMenuView = courseMenuView;

    }
    return _courseMenuView;
}

-(NSString *)lastHour_id{
    
    NSString  *last = @"0";
    if( !lasthourModel ){
            if (hourMuArr.count > 0) {
                TrainCourseDirectoryModel*course = hourMuArr[0];
                last = course.list_id;
            }
    }else{
            last = lasthourModel.list_id;
            
    }

    return last;
}

-(NSString *)lastCw_id{
    
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

-(TrainDownloadManager *)downManager{
    if (!_downManager) {
        _downManager = [TrainDownloadManager sharedFileDownloadManager];
        _downManager.delegate = self;
    }
    return _downManager;
}

-(NSMutableArray *)downLoadMuArr{
    if (! _downLoadMuArr) {
        NSArray  *arr =[ TrainDownloadModel findWithFormat:@"c_id = %@",self.courseModel.c_id];
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:arr];
        _downLoadMuArr = muArr;
    }
    return _downLoadMuArr;
}

-(NSTimer *)downReloadCellTimer{
    if (! _downReloadCellTimer) {
        _downReloadCellTimer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(reloadCell) userInfo:nil repeats:YES];

    }
    return _downReloadCellTimer;
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
