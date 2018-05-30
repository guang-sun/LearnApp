//
//  TrainMovieDetailTableViewController.m
//  KindeeTrain
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import "TrainMovieDetailTableViewController.h"
#import "TrainImageButton.h"

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
#import "TrainCustomTextView.h"

#import "TrainNodataView.h"
#import "UITableView+TrainTableViewPlaceHolder.h"

static NSString *const kDirectoryIdentifier = @"kDirectoryIdentifier";
static NSString *const kNoteIdentifier      = @"kNoteIdentifier";
static NSString *const kDiscussIdentifier   = @"kDiscussIdentifier";
static NSString *const kAppraiseIdentifier  = @"kAppraiseIdentifier";

#define TRAINDOWNHEIGHT  50.0f

@interface TrainMovieDetailTableViewController ()<TrainFileDownloadManagerDelegate,trainAppraiseDelegate,trainNoteDelegate,UITextViewDelegate>
{
    // shuju
    NSMutableArray             *hourMuArr, *noteMuArr, *discussMuArr, *AppraiseMuArr;
    
    // 目录的头视图
    UIView            *freeSizeView;
    TrainImageButton  *deleteBtn;
    
    //笔记
    UIView                          *noteDownView;

    // 讨论
    UIView                          *commentView;
    TrainCustomTextView             *commentTextView;
    NSString                        *huiFuName;
    NSString                        *topicType;  // T 话题  Q问答
    TrainCourseDiscussModel         *commentInfo;
    
    
    
    int                             currIndex; // 刷新的当前页数
    __block TrainNodataView *netReloader ;
    NSIndexPath                     *commentSelect;
    NSInteger                       currHourIndex; // 当前课时的
    NSInteger                       selectIndex; // 当前选中课时的

}

//@property(nonatomic,strong) TrainPlayerView       *playerView;
//@property(nonatomic,strong) TrainPlayerModel      *playerModel;
@property(nonatomic,strong) TrainDownloadManager  *downManager;
@property(nonatomic,strong) NSMutableArray        *downLoadMuArr;
@property (nonatomic, strong) NSString              *lastHour_id;

@property(nonatomic,strong) NSTimer               *downReloadCellTimer;

@end

@implementation TrainMovieDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currIndex       = 1 ;
    currHourIndex   = -1 ;
    selectIndex     = -1 ;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
//    self.tableView.backgroundColor = [UIColor brownColor];
    
    [self.tableView registerClass:[TrainCourseAppraiseCell class] forCellReuseIdentifier:kAppraiseIdentifier];
    [self.tableView registerClass:[TrainCourseDiscussCell class] forCellReuseIdentifier:kDiscussIdentifier];
    [self.tableView registerClass:[TrainCourseNoteCell class] forCellReuseIdentifier:kNoteIdentifier];
    [self.tableView registerClass:[TrainCourseDirectoryCell class] forCellReuseIdentifier:kDirectoryIdentifier];
//    [self creatDifferentCourseDetailView];

    if (self.courseMode == TrainCourseDetailModeNote || self.courseMode == TrainCourseDetailModeDiscuss || self.courseMode == TrainCourseDetailModeAppraise){
        
        TrainWeakSelf(self);
        self.tableView.mj_header  =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            currIndex  = 1 ;
            [weakself downloadCourseInfo:1];
        }];
        //        [self.tableView.mj_header beginRefreshing];
        MJRefreshBackNormalFooter  *footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            currIndex ++;
            [weakself downloadCourseInfo:currIndex];
        }];
        
        self.tableView.mj_footer  = footer;
        
        [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
        
    }
    if (self.courseMode == TrainCourseDetailModeDiscuss) {
     
        [self registeNotifications];

    }else if (self.courseMode == TrainCourseDetailModeDirectory){
        self.downManager.delegate = self;

    }

    
//    [self resetStartDownload];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNoteOrCommentDownView];
    if (self.downManager) {
        self.downManager.delegate = nil;
    }
    if (self.courseMode == TrainCourseDetailModeDiscuss) {
        [self resetCommentView];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    
    self.downManager.delegate = self;
    if (self.downManager) {
        NSArray  *arr =[ TrainDownloadModel findWithFormat:@"c_id = %@",self.courseDetailModel.c_id];
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:arr];
        self.downLoadMuArr = muArr;
    }
}

-(void)resetStartDownload{
    [self.downManager suspendAllFilesDownload];
    NSArray *arr = [TrainDownloadModel findWithFormat:@"status != 4"];
    [arr  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.downManager addDownloadWithDownLoadModel:obj];
        
    }];
    
    [self.downReloadCellTimer setFireDate:[NSDate date]];
    
}

-(void)dealloc{
    
    NSLog(@"+++movieDown+++ dealloc ");
    if ( self.downReloadCellTimer.isValid) {
        [self.downReloadCellTimer invalidate];
        self.downReloadCellTimer = nil;
    }
}
-(void)setIsRegister:(BOOL)isRegister{
    _isRegister  = isRegister;
}


- (void)removeNoteOrCommentDownView{
    
    UIWindow  *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *down = [keyWindow viewWithTag:10001];
    if (down) {
        [down removeFromSuperview];
    }
    down = [keyWindow viewWithTag:10002];
    if (down) {
        [down removeFromSuperview];
    }

}
-(void)updateDataWithVC{
    
    
    switch (self.courseMode) {
        case TrainCourseDetailModeDirectory:
        {
            if (TrainArrayIsEmpty(hourMuArr)) {
                [self downloadCourseInfo:1];
            }else{
                [self.tableView  train_reloadData];
            }
            
            if (self.downManager) {
                self.downManager.delegate = self;
                [self resetStartDownload];

            }
        }
            break;
        case TrainCourseDetailModeNote:
        {
            if (TrainArrayIsEmpty(noteMuArr)) {
                [self downloadCourseInfo:1];
            }
        }
            break;
        case TrainCourseDetailModeAppraise:
        {
            if (TrainArrayIsEmpty(AppraiseMuArr)) {
                [self downloadCourseInfo:1];
            }
        }
            break;
        case TrainCourseDetailModeDiscuss:
        {
            [self downloadCourseInfo:1];
        }
            break;
       
            
        default:
            break;
    }
    
    
    [self removeNoteOrCommentDownView];
    [self creatDifferentCourseDetailView];
}
-(void)updateLearningRecord:(TrainCourseDirectoryModel *)hourModel andreload:(BOOL)isReload{
    
    
    if ( !hourModel) {
        
        [self updateHourInfo];
        
    }else{
        
        [hourMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainCourseDirectoryModel  *model = obj;
            if ([model.list_id isEqualToString: hourModel.list_id]) {
                
                model.last_time = hourModel.last_time;
                
                if (isReload) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSIndexPath *selectRow = [NSIndexPath indexPathForRow:idx inSection:0];
                        [self.tableView selectRowAtIndexPath:selectRow animated:NO scrollPosition:UITableViewScrollPositionNone];
                    });
                }               
                *stop  = YES;
            }
        }];
   
 
    }
}
-(void)updateHourInfo{
    
    
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:notEmptyStr(self.courseDetailModel.object_id) forKey:@"object_id"];
    
    [dic setObject:notEmptyStr(self.courseDetailModel.type) forKey:@"type"];
    [dic setObject:notEmptyStr(self.courseDetailModel.c_id) forKey:@"c_id"];
    
    if ([self.courseDetailModel.type isEqualToString:@"TRAIN"]) {
        [dic setObject:@"0" forKey:@"room_id"];
        [dic setObject:@"0" forKey:@"class_id"];
    }else{
        [dic setObject:notEmptyStr(self.courseDetailModel.class_id) forKey:@"class_id"];
        [dic setObject:notEmptyStr(self.courseDetailModel.room_id) forKey:@"room_id"];
        
    }
    [[TrainNetWorkAPIClient client] trainCourseDetailInfoWithMode:TrainCourseDetailModeDirectory infoDic:dic Success:^(NSDictionary *dic) {
        
        if (_courseMode == TrainCourseDetailModeDirectory) {
            hourMuArr = [NSMutableArray array];
            hourMuArr = [TrainCourseDirectoryModel mj_objectArrayWithKeyValuesArray:dic[@"hour"]];
            
            [self.tableView reloadData];
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
}


-(void)startLearnHour{
    
 
        __block BOOL  isHasHour = NO;
        TrainWeakSelf(self);
        [hourMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainCourseDirectoryModel  *listModel =obj;
            if ([listModel.h_type isEqualToString:@"H"] ||[listModel.h_type isEqualToString:@"E"] ) {
//                if ([listModel.c_type isEqualToString:@"V"] || [listModel.c_type isEqualToString:@"D"] || [listModel.c_type isEqualToString:@"E"]) {
                
                    isHasHour = YES;
                    
                    NSIndexPath *selectRow = [NSIndexPath indexPathForRow:idx inSection:0];
                    [weakself.tableView selectRowAtIndexPath:selectRow animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                    [weakself tableView:weakself.tableView didSelectRowAtIndexPath:selectRow];
                    
                    *stop =YES;
//                }
            }
        }];
        if(! isHasHour){
            NSString *str = (hourMuArr.count) ? TrainHourNotSupportText : @"抱歉,该课程暂时没有课时,尽请期待";
            
            [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:str buttonTitle:@"好的" buttonStyle:TrainAlertActionStyleCancel];
        }
 
    
}

- (void)downloadCourseInfo:(int )index{
    
    [TrainProgressHUD showCustomAnimation:@"加载中……" withImgArry:@[] inview:nil];
    
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:notEmptyStr(self.courseDetailModel.object_id) forKey:@"object_id"];
    
    [dic setObject:notEmptyStr(self.courseDetailModel.type) forKey:@"type"];
    [dic setObject:notEmptyStr(self.courseDetailModel.c_id) forKey:@"c_id"];
    [dic setObject:notEmptyStr(self.courseDetailModel.class_id) forKey:@"class_id"];
    [dic setObject:notEmptyStr(self.courseDetailModel.room_id) forKey:@"room_id"];
    
    if(self.courseMode  == TrainCourseDetailModeNote|| self.courseMode  == TrainCourseDetailModeDiscuss || self.courseMode  == TrainCourseDetailModeAppraise){
        [dic setObject:[NSString stringWithFormat:@"%d",index]forKey:@"curPage"];
        [dic setObject:@"0" forKey:@"classhour_id"];
        
    }
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client ]trainCourseDetailInfoWithMode:self.courseMode infoDic:dic
                                                          Success:^(NSDictionary *dic)
     {
         switch (self.courseMode) {
      
             case TrainCourseDetailModeDirectory:
             {
                 hourMuArr = [NSMutableArray array];
                 hourMuArr = [TrainCourseDirectoryModel mj_objectArrayWithKeyValuesArray:dic[@"hour"]];
                 [hourMuArr  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     TrainCourseDirectoryModel   *mod = obj;
                     mod.course_objectid = self.object_id;
                     mod.condition = self.condition;
                     [mod saveOrUpdateByColumnName:@[@"c_id",@"list_id"]];
                 }];
                 
             }
                 break;
        case TrainCourseDetailModeNote:
        {
            if (index == 1) {
                noteMuArr =[NSMutableArray new];
            }
            NSArray   *dataArr ;
            if ([self.courseDetailModel.type isEqualToString:@"TRAIN"]) {
                dataArr = [TrainCourseNoteModel  mj_objectArrayWithKeyValuesArray:dic[@"courseNotes"]];
            }else {
                dataArr = [TrainCourseNoteModel  mj_objectArrayWithKeyValuesArray:dic[@"notes"]];
            }
            [noteMuArr addObjectsFromArray:dataArr];
            if (noteMuArr.count>0) {
                TrainCourseNoteModel *model = [noteMuArr firstObject];
                 int   totalpages =[model.totPage intValue];
                if(index < totalpages || totalpages == 0){
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.tableView.mj_header endRefreshing];
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
                TrainCourseDiscussModel *model = [discussMuArr firstObject];
                int   totalpages =[model.totPage intValue];
                if(index >= totalpages || totalpages == 0){
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.tableView.mj_header endRefreshing];
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
//            NSLog(@"---%@",dataArr);
            [AppraiseMuArr addObjectsFromArray:dataArr];

            if (AppraiseMuArr.count>0 ) {
                TrainCourseAppraiseModel *model = [AppraiseMuArr firstObject];
                int   totalpages =[model.totPage intValue];
                if(index < totalpages || totalpages == 0){
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.tableView.mj_header endRefreshing];

            
        }
            break;
            
        default:
            break;
    }
         [self.tableView train_reloadData];

         [TrainProgressHUD hide];
         
     } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
         
         [self.tableView train_reloadData];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         [TrainProgressHUD hide];
         
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
-(void)creatDifferentCourseDetailView{
    
    
     switch (self.courseMode ) {
        case TrainCourseDetailModeDirectory:
        {
            [self creatCourseDetailDirectoryView];
            
        }
            break;
        case TrainCourseDetailModeNote:
        {
            [self creatCourseDetailNoteView];

        }
            break;
        case TrainCourseDetailModeDiscuss:
        {
            [self creatCourseDetailDiscussView];

        }
            break;
        case TrainCourseDetailModeAppraise:
        {
            [self creatCourseDetailAppraiseView];

        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 创建课程详情的目录
-(void)creatCourseDetailDirectoryView{
    
    
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
    
    self.tableView.tableHeaderView = freeSizeView;
    
    
    
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
                if (self.courseMode == TrainCourseDetailModeDirectory) {
                    [self.tableView train_reloadData];
                    [self updateDownloadSize];
                }
                
            }
            
        } cancelButtonTitle:@"否" destructiveButtonTitle:@"是" otherButtonTitles:nil, nil];
        
        
    }
    
    
}


- (UIView *)tableNODataView:(trainStyle)style{
    
    netReloader = [[TrainNodataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) trainStyle:style reloadBlock:^{
        [self downloadCourseInfo:currIndex];
        
        [netReloader dismiss];
        
    }];
    
    return netReloader;
}
-(void)dissTablePlace{
    [netReloader dismiss];
    
}
- (UIView *)makePlaceHolderView {
    return [self tableNODataView:trainStyleNoData];
}


-(void)updateDownloadSize{
    
    
    NSArray  *arr = [NSArray arrayWithArray: self.downLoadMuArr];
    
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

// 去缓存页面
-(void)gotoCacheVC{
    
    TrainCacheListViewController  *cacheVC = [[TrainCacheListViewController alloc]init];
    cacheVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cacheVC animated:YES];
    
}

#pragma mark - 创建课程详情的笔记
//-(void)viewDidLayoutSubviews{
// 
//    if (self.courseMode == TrainCourseDetailModeNote) {
//        
//        CGRect  size = self.tableView.frame;
//        size.size.height -= 50;
//        self.tableView.frame = size;
//        
//        downView.frame = CGRectMake(0, CGRectGetMaxY(size), TrainSCREENWIDTH, 50);
//        
//    }
//}
-(void)creatCourseDetailNoteView{
 
    
    if (self.isRegister && !noteDownView) {
        noteDownView = [[UIView alloc]initWithFrame:CGRectMake(0, TrainSCREENHEIGHT - 50 , TrainSCREENWIDTH, 50)];
        noteDownView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        noteDownView.tag = 10001;
        
        UIButton  *addnote =[[UIButton alloc]initCustomButton];
        addnote.backgroundColor = TrainNavColor ;
        addnote.layer.cornerRadius = 8;
        addnote.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [addnote setTitle:@"添加笔记" forState:UIControlStateNormal];
        [addnote setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addnote addTarget:self action:@selector(addnote) forControlEvents:UIControlEventTouchUpInside];
        [noteDownView addSubview:addnote];
        addnote.sd_layout
        .centerXEqualToView(noteDownView)
        .centerYEqualToView(noteDownView)
        .widthIs(150)
        .heightIs(40);
        
    }
    
    [self.view addSubview:noteDownView];
    

    UIWindow  *keywindow =[UIApplication sharedApplication].keyWindow;
    
    [keywindow addSubview:noteDownView];

    
}

#pragma mark -加笔记
-(void)addnote{

 
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    
    [mudic setObject:notEmptyStr(self.courseDetailModel.type) forKey:@"type"];
    [mudic setObject:notEmptyStr(self.courseDetailModel.c_id) forKey:@"c_id"];
    [mudic setObject:notEmptyStr(self.courseDetailModel.object_id) forKey:@"object_id"];
    [mudic setObject:notEmptyStr(self.lastHour_id) forKey:@"hour_id"];
    [mudic setObject:notEmptyStr(self.courseDetailModel.room_id) forKey:@"room_id"];
    
    TrainAddNoteViewController   *noteVC =[[TrainAddNoteViewController alloc]init];
    
    noteVC.infoDic      = mudic;
    noteVC.isEditNote   = NO;
    noteVC.delegate     = self;
    [self.navigationController pushViewController:noteVC animated:YES];
    
    
}

-(void)saveNoteSuccess:(NSDictionary *)dic{
    if (!TrainDictIsEmpty(dic)) {
        if ([self.courseDetailModel.type isEqualToString:@"TRAIN"]) {
            noteMuArr =[TrainCourseNoteModel  mj_objectArrayWithKeyValuesArray:dic[@"courseNotes"]];
        }else {
            noteMuArr = [TrainCourseNoteModel  mj_objectArrayWithKeyValuesArray:dic[@"notes"]];
        }
        [self.tableView train_reloadData];
    }else{
        [self downloadCourseInfo:1];
    }
}



#pragma mark - 创建课程详情的 taolun

-(void)creatCourseDetailDiscussView{
    
    if (self.isRegister && !commentView) {
        
        commentView = [[UIView alloc]initWithFrame:CGRectMake(0, TrainSCREENHEIGHT - TRAINDOWNHEIGHT, TrainSCREENWIDTH,TRAINDOWNHEIGHT)];
        commentView.tag = 10002;
        commentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        commentTextView = [[TrainCustomTextView alloc]init];
        commentTextView.font = [UIFont systemFontOfSize:14.0f];
        commentTextView.isAutolayoutHeight = YES;
        commentTextView.maxNumberOfLines = 4;
        commentTextView.placeholder = TrainCommentText;
        commentTextView.placeholderColor = TrainContentColor;
        commentTextView.backgroundColor = [UIColor whiteColor];
        commentTextView.delegate = self;
        [commentView addSubview:commentTextView];
        
        __weak  typeof(commentView)weakView = commentView;
        commentTextView.trainTextHeightChangeBlock =^(CGFloat height){
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect   sizeFrame = weakView.frame;
                
                float  y = sizeFrame.origin.y;
                y = y + sizeFrame.size.height - (height +20);
                
                sizeFrame.origin.y    = y;
                sizeFrame.size.height = height +20;
                weakView.frame        = sizeFrame;

            }];
            
        };
        
        UIButton  *button = [[UIButton alloc]initCustomButton];
        button.layer.cornerRadius = 3.0f;
        
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:TrainNavColor];
        [button addTarget:self action:@selector(sendComment:)];
        [commentView addSubview:button];
        
        button.sd_layout
        .rightSpaceToView(commentView,TrainMarginWidth)
        .bottomSpaceToView(commentView,10)
        .widthIs(50)
        .heightIs(30);
        
        commentTextView.sd_layout
        .leftSpaceToView(commentView,TrainMarginWidth)
        .rightSpaceToView(button,10)
        .topSpaceToView(commentView,10)
        .bottomSpaceToView(commentView,10);
        
        //        注册通知

    }

    UIWindow  *keywindow =[UIApplication sharedApplication].keyWindow;
    
    [keywindow addSubview:commentView];
    

    
}

#pragma  mark -发表讨论
-(void)sendComment:(UIButton *)btn
{
    if ([TrainStringUtil trainIsBlankString:commentTextView.text]) {
      
        [TrainProgressHUD showMsgWithoutView:@"输入为空"];

        return;
    }
    [TrainProgressHUD showCustomAnimation:@"加载中……" withImgArry:@[] inview:nil];
    TrainWeakSelf(self);
    if ( !commentInfo) {
        NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
        
        [mudic setObject:commentTextView.text                    forKey:@"content"];
        [mudic setObject:notEmptyStr(self.courseDetailModel.object_id) forKey:@"object_id"];
        [mudic setObject:notEmptyStr(self.lastHour_id)           forKey:@"classHour_id"];
        [mudic setObject:notEmptyStr(self.courseDetailModel.type)      forKey:@"type"];
        [mudic setObject:notEmptyStr(self.courseDetailModel.room_id)   forKey:@"room_id"];
        [mudic setObject:notEmptyStr(self.courseDetailModel.c_id)      forKey:@"c_id"];
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
                if (TrainStringIsEmpty(str)) {
                    str = @"发表新讨论失败,请重试";
                }
                [TrainProgressHUD showMsgWithoutView:str];

                
            }
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
           
            [TrainProgressHUD showMsgWithoutView:TrainNetWorkError];
            [TrainProgressHUD shareinstance].hud.offset = CGPointMake(0, 150.f);
      
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
                    
                    [self.tableView reloadRowsAtIndexPaths:@[commentSelect] withRowAnimation:UITableViewRowAnimationNone];
                    [weakself resetCommentView];
                    
                    
                }else{
                    
                    currIndex = 1;
                    [weakself downloadCourseInfo:1];
                    [weakself resetCommentView];
                }
                
            }else{
                NSString  *str = dic[@"msg"];
                if (TrainStringIsEmpty(str)) {
                    str = @"发表新讨论失败,请重试";
                }
                [TrainProgressHUD showMsgWithoutView:str];
                

            }
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            
            [TrainProgressHUD showMsgWithoutView:TrainNetWorkError];
            [TrainProgressHUD shareinstance].hud.offset = CGPointMake(0, 150.f);
      
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
    [TrainNotiCenter addObserver:self selector:@selector(changeKeyboardFram:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [TrainNotiCenter addObserver:self selector:@selector(KeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)removeNotifications{
    [TrainNotiCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [TrainNotiCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)changeKeyboardFram:(NSNotification *)noti{
    NSDictionary  *info =[noti userInfo];
    CGFloat  keyHeight =[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    TrainNSLog(@"1111111111111noti----");

    [UIView animateWithDuration:0.25 animations:^{
        CGRect   sizeFrame = commentView.frame;
        sizeFrame.origin.y = TrainSCREENHEIGHT - keyHeight - sizeFrame.size.height;
        commentView.frame = sizeFrame;
       
    }];
    
}
-(void)KeyboardHide:(NSNotification *)noti{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect   sizeFrame = commentView.frame;
        sizeFrame.origin.y = TrainSCREENHEIGHT - sizeFrame.size.height;
        commentView.frame = sizeFrame;
        
    }];
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    if (!commentInfo && TrainStringIsEmpty(topicType)) {
        
        [TrainAlertTools showActionSheetWith:self title:@"" message:@"" callbackBlock:^(NSInteger btnIndex) {
            
            if (btnIndex == 1 || btnIndex == 2) {
                topicType =(btnIndex == 1)? @"T" : @"Q";
//                if (self.delegate && [self.delegate respondsToSelector:@selector(WMTableCommentSelectWith:)]) {
//                    
//                    [self.delegate WMTableCommentSelectWith:YES];
//                }

                [commentTextView becomeFirstResponder];
            
            }
            
        } destructiveButtonTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发话题",@"发问答", nil];
        return NO;
        
    }else{
        return YES;
    }
    return YES;
}

-(void)resetCommentView{
    
    commentInfo   = nil;
    huiFuName     = nil;
    topicType     = @"";
    commentTextView.text = @"";
    commentTextView.placeholder = TrainCommentText;
    [commentTextView resignFirstResponder];
    
}



-(void)removeOnlyTopicPostWith:(TrainCourseDiscussModel *)model{
    //
    TrainWeakSelf(self);
    [TrainAlertTools showActionSheetWith:self title:@"" message:@"" callbackBlock:^(NSInteger btnIndex) {
        
        if(btnIndex == 0){
            [TrainProgressHUD showCustomAnimation:@"加载中……" withImgArry:@[] inview:nil];
            
            if (huiFuName ) {
                [[TrainNetWorkAPIClient client] trainRemoveTopicPostWithTopic_id:model.object_id post_id:model.mypost_id Success:^(NSDictionary *dic) {
                    
                    NSString  *str = @"";
                    if ([dic[@"success"] isEqualToString:@"S"]) {
                        str = @"删除成功";
                        [self updateAfterRemovePost:model];
                        
                    }else{
                        str = TrainStringIsEmpty(dic[@"msg"]) ? @"删除失败,请重试" : dic[@"msg"];
                    }
                    [weakself resetCommentView];
                    
                    [TrainProgressHUD showMsgWithoutView:str];

                } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
                  
                    [TrainProgressHUD showMsgWithoutView:TrainNetWorkError];
                    [TrainProgressHUD shareinstance].hud.offset = CGPointMake(0, 150.f);
                    
                }];
                
            }else{
                
                
                NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
                [mudic setObject:self.courseDetailModel.object_id forKey:@"object_id"];
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
                        [self.tableView train_reloadData];
                        
                    }else{
                        str = (TrainStringIsEmpty(dic[@"msg"])) ? @"删除失败" : dic[@"msg"] ;
                    }
                    [weakself resetCommentView];
                    
                    [TrainProgressHUD showMsgWithoutView:str];
                    
                } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
                    
                    [TrainProgressHUD showMsgWithoutView:TrainNetWorkError];
                    [TrainProgressHUD shareinstance].hud.offset = CGPointMake(0, 150.f);
                    
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
    
        [self.tableView reloadRowsAtIndexPaths:@[commentSelect] withRowAnimation:UITableViewRowAnimationNone];
    
}


-(void)commentHuiFu{
    
    [commentTextView becomeFirstResponder];
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(WMTableCommentSelectWith:)]) {
//        
//        [self.delegate WMTableCommentSelectWith:YES];
//    }

    NSString  *placeholderStr;
    if (huiFuName) {
        placeholderStr =[NSString  stringWithFormat:@"@%@",huiFuName];
    }else{
        placeholderStr =[NSString  stringWithFormat:@"@%@",commentInfo.full_name];
    }
    commentTextView.placeholder =placeholderStr;
    [self.tableView scrollToRowAtIndexPath:commentSelect atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}


#pragma mark - 创建课程详情的  pingjia

-(void)creatCourseDetailAppraiseView{

    

}
-(void)gotoAppraiseView{
  
        
        NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
        
        [mudic setObject:notEmptyStr(self.courseDetailModel.type )     forKey:@"type"];
        [mudic setObject:notEmptyStr(self.courseDetailModel.c_id)      forKey:@"c_id"];
        [mudic setObject:notEmptyStr(self.courseDetailModel.object_id) forKey:@"object_id"];
        [mudic setObject:notEmptyStr(self.lastHour_id)           forKey:@"hour_id"];
        [mudic setObject:notEmptyStr(self.courseDetailModel.room_id)   forKey:@"room_id"];
        
        TrainAddAppraiseViewController *appraiseVC =[[TrainAddAppraiseViewController alloc]init];
        
        appraiseVC.delegate =self;
        appraiseVC.infoDic = mudic;
        
        [self.navigationController pushViewController:appraiseVC animated:YES];
    
}

-(void)saveAppraiseSuccess:(NSDictionary *)dic{
    
    TrainCourseAppraiseModel *mo = [TrainCourseAppraiseModel  mj_objectWithKeyValues:dic];
    
    if (AppraiseMuArr.count > 0) {
        [AppraiseMuArr replaceObjectAtIndex:0 withObject:mo];
        NSIndexPath  *index =[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (self.courseMode)
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
    switch (self.courseMode)
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
    switch (self.courseMode)
    {
        case TrainCourseDetailModeDirectory:
        {
            
            TrainCourseDirectoryCell *listCell = [tableView dequeueReusableCellWithIdentifier:kDirectoryIdentifier];
            TrainCourseDirectoryModel   *listModel =  hourMuArr[indexPath.row];
            __block TrainDownloadModel  *downModel = nil;
//            NSLog(@"++cell++%p",self.downLoadMuArr);

            [self.downLoadMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TrainDownloadModel  *downM = obj;
                if (downM.selectIndex == indexPath.row ) {
                    downModel = downM;
                    *stop = YES;
                }
            }];
            
            listCell.isRegister = self.isRegister;
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
            TrainCourseNoteCell  *noteCell = [tableView dequeueReusableCellWithIdentifier:kNoteIdentifier];
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
            TrainCourseDiscussCell  *discussCell = [tableView dequeueReusableCellWithIdentifier:kDiscussIdentifier];
            TrainCourseDiscussModel *model = discussMuArr[indexPath.row];
            discussCell.index = indexPath.row;
            discussCell.model =model;
            
            TrainWeakSelf(self);
            discussCell.topicLine =^(TrainCourseDiscussModel *mod, NSString *userName){
               
                if(weakself.isRegister){
                    if ([mod.myuser_id isEqualToString:TrainUser.user_id] ) {
                        
                        commentInfo     = mod;
                        commentSelect   = indexPath;
                        huiFuName       = userName;
                        
                        [weakself removeOnlyTopicPostWith:mod];
                        
                    }else{
                        BOOL  qqq = [commentInfo.discuss_id isEqual:mod.discuss_id];
                        if (commentInfo && qqq ) {
                            [weakself resetCommentView];
                            
                        }else{
                            commentInfo     = mod;
                            commentSelect   = indexPath;
                            huiFuName       = userName;
                            [weakself commentHuiFu];
                        }
                    }

                }else{
                  
                    [TrainAlertTools showTipAlertViewWith:weakself title:@"提示" message:@"您还没有报名，请先报名" buttonTitle:@"确定" buttonStyle:TrainAlertActionStyleCancel];                }
            
                
            };
            discussCell.topicName =^(NSString *user_id){
                NSLog(@"%@",user_id);
            };
            
            return discussCell;
        }
            break;
        case TrainCourseDetailModeAppraise:
        {
            TrainCourseAppraiseCell  *appraiseCell = [tableView dequeueReusableCellWithIdentifier:kAppraiseIdentifier];
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
                model.courseName    = self.courseDetailModel.name;
                model.hourName      = listModel.title;
                model.selectIndex   = index.row;
                model.imageUrl      = self.defaultImageURL;
                model.last_time     = [listModel.last_time integerValue];
                
                if ([listModel.c_type isEqualToString:@"V"]) {

                    [self.downManager addDownloadWithDownLoadModel:model];
                    [self.downLoadMuArr addObject:model];
                    [self.downReloadCellTimer setFireDate:[NSDate date]];
                   
                    [TrainProgressHUD showMsgWithoutView:@"已添加进任务列表"];

                    
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
                
                [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            
        } cancelButtonTitle:@"否" destructiveButtonTitle:@"是" otherButtonTitles:nil, nil];
        
        
        
        
    }
    
    
}


#pragma mark - 下载 delegate


-(void)fileDownloadManagerStartDownload:(TrainDownloadModel *)download{
    
}

-(void)fileDownloadManagerReceiveResponse:(TrainDownloadModel *)download FileSize:(uint64_t)totalLength{
    NSArray   *arr =  [NSArray arrayWithArray:self.downLoadMuArr];
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
        NSArray   *arr =  [NSArray arrayWithArray:self.downLoadMuArr];
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainDownloadModel  *downM = obj;
            
            if ([downM.CHO_id isEqualToString:download.CHO_id]) {
                download.status = TrainFileDownloadStateFinish;
                [self.downLoadMuArr replaceObjectAtIndex:idx withObject:download];
                *stop = YES;
            }
        }];
        if (arr.count > 0) {
            [self.tableView train_reloadData];
            [self updateDownloadSize];
            NSIndexPath  *index = [NSIndexPath indexPathForRow:download.selectIndex inSection:0];
            if (self.courseMode == TrainCourseDetailModeDirectory) {
                
                [self.tableView  reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            
        }
    }else{
        
    }
    
}

-(void)fileDownloadManagerUpdateProgress:(TrainDownloadModel *)download didReceiveData:(uint64_t)receiveLength downloadSpeed:(NSString *)downloadSpeed{
    
    NSArray   *arr =  [NSArray arrayWithArray:self.downLoadMuArr];

    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainDownloadModel  *downM = obj;
        
        if ([downM.CHO_id isEqualToString:download.CHO_id]) {
            
//            TrainDownloadModel *newDown = self.downLoadMuArr[idx];
//            newDown = download;
            
            [self.downLoadMuArr replaceObjectAtIndex:idx withObject:download];
//            NSLog(@"++progress+%p",self.downLoadMuArr);

            *stop = YES;
        }
    }];
//    NSIndexPath  *index = [NSIndexPath indexPathForRow:download.selectIndex inSection:0];
//    if (self.courseMode == TrainCourseDetailModeDirectory) {
//        
//        [self.tableView  reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
//        
//    }
}


-(void)reloadCell{
    if (self.courseMode == TrainCourseDetailModeDirectory && hourMuArr.count >0  ) {
        
        __block BOOL    isscfinish = YES;
//        
        [self.downLoadMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainDownloadModel *dddModel = obj;
            if (dddModel.status == TrainFileDownloadStateDownloading || dddModel.status == TrainFileDownloadStateWaiting ) {
                isscfinish = NO;
                *stop =YES;
            }
        }];
        
        if (isscfinish && self.downReloadCellTimer.isValid) {
            [self.downReloadCellTimer invalidate];
            self.downReloadCellTimer = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView train_reloadData];

        });
        
    }
    
}



#pragma  mark 删除自己的评价

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.courseMode == TrainCourseDetailModeAppraise) {
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
    if (editingStyle == UITableViewCellEditingStyleDelete && self.courseMode == TrainCourseDetailModeAppraise) {
        
//        [self trainShowHUDOnlyActivity];
        
        BOOL   isclass = NO;
        TrainCourseAppraiseModel  *appModel = [AppraiseMuArr firstObject];
        
        NSString * appraise_id = appModel.app_id;
        
        [[TrainNetWorkAPIClient client] trainCourseDeleteAppraiseWithIsClass:isclass Appraise_id:appraise_id Success:^(NSDictionary *dic) {
            
            
//            [self trainShowHUDOnlyText:TrainDeleteSuccess andoff_y:150.0f];
            
            TrainCourseAppraiseModel  *newApp = [[TrainCourseAppraiseModel alloc]init];
            newApp.create_by = @"0";
            newApp.grade = @"0";
            newApp.totPage = @"0";
            [AppraiseMuArr replaceObjectAtIndex:0 withObject:newApp];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
//            [self trainShowHUDOnlyText:TrainDeleteFail];
            
        }];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.isRegister) {
        NSString   *str;
        if (self.courseMode == TrainCourseDetailModeDirectory) {
            str =@"您还没有报名，请先报名";
        }else if (self.courseMode == TrainCourseDetailModeAppraise) {
            str =@"亲,您先参加课程才能评价哦!";
        }else{
            return;
        }
        [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:str buttonTitle:@"确定" buttonStyle:TrainAlertActionStyleCancel];
        
    }else{
        if (self.courseMode == TrainCourseDetailModeDirectory ) {
            selectIndex = indexPath.row;
            // 顺序播放
//            [self ordertoplaymovieWithSelectRow:indexPath.row];
            //
            // 顺序播放
            if ([self.condition isEqualToString:@"O"]) {
                [self ordertoplaymovieWithSelectRow:indexPath.row];
            }else {
                TrainCourseDirectoryModel  *listModel = hourMuArr[indexPath.row];
                [self playerWithHour:listModel];
            }
        }
        else if (self.courseMode == TrainCourseDetailModeAppraise && indexPath.row == 0) {
            
            TrainCourseAppraiseModel  *appModel = [AppraiseMuArr firstObject];
            if (appModel.grade && [appModel.grade intValue] == 0) {
            
                [self gotoAppraiseView];
            }
            
            
        }else if (self.courseMode == TrainCourseDetailModeDiscuss){

            [commentTextView resignFirstResponder];
            
        }
        
    }
}

//按顺序进行播放
-(void)ordertoplaymovieWithSelectRow:(NSInteger)selectRow{
    
    TrainCourseDirectoryModel  *hourModel = hourMuArr[selectRow];

    if ([hourModel.h_type isEqualToString:@"H"] ||[hourModel.h_type isEqualToString:@"E"] ) {
        
        BOOL   isplayer = YES;
        for ( int i = (int)selectRow; i >0; i--) {
            TrainCourseDirectoryModel  *listHour = hourMuArr[i-1];
            if ([listHour.h_type isEqualToString:@"H"] ||[listHour.h_type isEqualToString:@"E"]  ) {
                if ( ![listHour.ua_status isEqualToString:@"C"]  && ![listHour.ua_status isEqualToString:@"P"]) {
                    isplayer = NO;
                }
            }
        }
        if (isplayer) {
            
            [self playerWithHour:hourModel];

        }else{
            [TrainProgressHUD showMsgWithoutView:TrainOrderToPlayText];

        }
    }
}

-(void)autoPlayHour  {
    
    if(currHourIndex >= 0 && currHourIndex  < hourMuArr.count){
        
        BOOL  isPlayer = NO ;
        TrainCourseDirectoryModel *nextHour ;
        for ( NSInteger i = currHourIndex + 1; i < hourMuArr.count ; i++) {
            TrainCourseDirectoryModel  *listHour = hourMuArr[i];
            if ([listHour.h_type isEqualToString:@"H"] ||[listHour.h_type isEqualToString:@"E"]  ) {
                nextHour = listHour ;
                isPlayer = YES ;
                selectIndex = i ;
                break ;
            }
        }
    if (isPlayer) {
        
        NSString  *title ;
        
        if([nextHour.c_type isEqualToString:@"V"] || [nextHour.c_type isEqualToString:@"L"]){
            
            NSIndexPath *selectRow = [NSIndexPath indexPathForRow:selectIndex inSection:0];
            [self.tableView selectRowAtIndexPath:selectRow animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:self.tableView didSelectRowAtIndexPath:selectRow];
            
            return ;
        }else if([nextHour.c_type isEqualToString:@"D"] ){
            
            if([nextHour.list_init_file isEqualToString:@"pic_txt"]){
                title = @"下一个课时为图文,是否开始学习?";
                
            }else {
                title = @"下一个课时为文档,是否开始学习?";
            }
            
        }else  if([nextHour.c_type isEqualToString:@"E"] ){
            
            title = @"下一个课时为考试,是否开始学习?";

        }else  if([nextHour.c_type isEqualToString:@"O"]){
            
            title = @"下一个课时为链接,是否开始学习?";
          
        }else  if([nextHour.c_type isEqualToString:@"P"]){
            
            if ([nextHour.h5 isEqualToString:@"H"]){
                
                title = @"下一个课时为H5课程包,是否开始学习?";
            }else {
                title = @"下一个课时为课程包,暂不支持移动端播放,请到PC端观看";
                [TrainAlertTools  showTipAlertViewWith:self title:@"提示" message:title buttonTitle:@"好的" buttonStyle:TrainAlertActionStyleCancel];

                return ;
            }
            
        }else if ([nextHour.h5 isEqualToString:@"H"]){
            
            title = @"下一个课时为H5课程包,是否开始学习?";
        }

        [TrainAlertTools showAlertWith:self title:@"提示" message:title callbackBlock:^(NSInteger btnIndex) {
            
            if(btnIndex ==1){
                
                NSIndexPath *selectRow = [NSIndexPath indexPathForRow:selectIndex inSection:0];
                [self tableView:self.tableView didSelectRowAtIndexPath:selectRow];
                [self.tableView selectRowAtIndexPath:selectRow animated:NO scrollPosition:UITableViewScrollPositionMiddle];

            }
            
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    }else{

        [TrainProgressHUD showMsgWithoutView:@"没有下一个课时了"];
    }
  
    }
}


-(void)updateCurrentHourDataWithVC:(TrainCourseDirectoryModel *)hourModel {
    
    [self playerWithHour:hourModel];
}
// 根据课时不同进行处理
-(void)playerWithHour:(TrainCourseDirectoryModel *)hourModel{
    
    if ([hourModel.h_type isEqualToString:@"H"] ||[hourModel.h_type isEqualToString:@"E"] ) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(WMTableviewSelect:)]) {
            [self.delegate WMTableviewSelect:hourModel];
        }
    }
    if([hourModel.c_type isEqualToString:@"D"] || [hourModel.c_type isEqualToString:@"E"]){
        
        currHourIndex = selectIndex;

        NSString *urlString = @"";
        if ([hourModel.c_type isEqualToString:@"D"]) {
            
            if([hourModel.list_init_file isEqualToString:@"pic_txt"]){
            
                urlString = hourModel.starting_url ;
            }else {
                
                urlString = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"viewcoursedoc" object_id:hourModel.list_init_file andtarget_id:nil];
            }
            
        }else if([hourModel.c_type isEqualToString:@"E"]){
            
            urlString = hourModel.starting_url ;
//            urlString = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"onlineExam" object_id:hourModel.object_id andtarget_id:@"0"];
        }
        TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
        webVC.webURL = urlString;
        webVC.navTitle = hourModel.title;
        webVC.hourtype = hourModel.c_type;
        webVC.isCourse = YES ;

        TrainWeakSelf(self);
        webVC.updataHourStatus = ^(NSString *hourStatus,NSString *score,NSString *exam_time){
            
            if ([hourModel.c_type isEqualToString:@"E"]) {
                
                if (![hourModel.ua_status isEqualToString:@"C"]) {
                    
                    [weakself updateExamHourWithmodel:hourModel];
                }
            }else if ([hourModel.c_type isEqualToString:@"D"]){
                if ( ![hourModel.ua_status isEqualToString:@"C"]) {
                    
                    hourModel.ua_status = @"C";
                    [weakself finishExamOrDoc:YES andListModel:hourModel andExamStatus:hourStatus andExamScore:score andExamtime:exam_time];
                }
                
            }
        };
        [self.navigationController pushViewController:webVC animated:YES];
        
        
    }else if([hourModel.c_type isEqualToString:@"V"] || [hourModel.c_type isEqualToString:@"L"]){
        
        currHourIndex = selectIndex;

        
    }else if([hourModel.c_type isEqualToString:@"O"]){
        
        currHourIndex = selectIndex;

        TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
        webVC.webURL = hourModel.starting_url;
        webVC.navTitle = hourModel.title;
        webVC.isCourse = YES ;
        [self finishExamOrDoc:YES andListModel:hourModel andExamStatus:nil   andExamScore:nil andExamtime:nil];
            [self.navigationController pushViewController:webVC animated:YES];
        

    }else if ([hourModel.c_type isEqualToString:@"P"]){
        
        if ([hourModel.is_free isEqualToString:@"H"] ) {
            
            currHourIndex = selectIndex;
            
            TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
            webVC.webURL = hourModel.starting_url;
            webVC.navTitle = hourModel.title;
            webVC.isCourse = YES ;
            [self.navigationController pushViewController:webVC animated:YES];
        }else{
            
            [TrainAlertTools  showTipAlertViewWith:self title:@"提示" message:TrainHourNotSupportText buttonTitle:@"好的" buttonStyle:TrainAlertActionStyleCancel];

        }
       
    }else if ([hourModel.h5 isEqualToString:@"H"]){
        
        currHourIndex = selectIndex;

        TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
        webVC.webURL = hourModel.starting_url;
        webVC.navTitle = hourModel.title;
        webVC.isCourse = YES ;
        
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else
    {
    
//        [TrainAlertTools  showTipAlertViewWith:self title:@"提示" message:TrainHourNotSupportText buttonTitle:@"好的" buttonStyle:TrainAlertActionStyleCancel];
    }
    
}

-(void)updateExamHourWithmodel:(TrainCourseDirectoryModel *)listModel {
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainGetHourStatusWithC_id:listModel.c_id object_id:self.courseDetailModel.object_id  lh_id:listModel.list_id success:^(NSDictionary *dic) {
        
        NSString  *is_complete = dic[@"is_complete"];
        [weakself updateExamStatus:is_complete andListModel:listModel];
        
        if ([is_complete  isEqualToString:@"P"]) {
            listModel.ua_status = @"C";
            
        }else{
            listModel.ua_status = is_complete;
        }
        [weakself.tableView reloadData];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
    
}

- (void)updateExamStatus:(NSString *)examStatus  andListModel:(TrainCourseDirectoryModel *)listModel{
    
    if ([examStatus isEqualToString:@""]) {
        return;
    }
    
    NSString  *message  =@"";
    NSString  *actionTitile = @"";
    
    if ([examStatus isEqualToString:@"P"]) {
        message = [NSString stringWithFormat:@"恭喜您, %@ 考试 已通过",listModel.title];
        actionTitile = @"学习下一课时";
    }else if ([examStatus isEqualToString:@"F"]) {
        message = [NSString stringWithFormat:@"很遗憾, %@ 考试 未能通过,请继续努力",listModel.title];
        actionTitile = @"再一次";
    }else if ([examStatus isEqualToString:@"M"]) {
        message = [NSString stringWithFormat:@"%@ 考试 正在阅卷,请耐心等待",listModel.title];
        actionTitile = @"";
    }else if ([examStatus isEqualToString:@"I"]) {
        message = [NSString stringWithFormat:@"%@ 考试 正在进行中",listModel.title];
        actionTitile = @"继续考试";
    }
    
    [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:message buttonTitle:@"知道了" buttonStyle:TrainAlertActionStyleCancel];
    
}


/**
 *  课程详情中 保存考试或文档的状态
 * 考试状态: P 通过  F 失败   M 待阅卷  I  考试进行中  N"   考试未开始"
 *
 *  @param isDoc     YES  DOC   NO  Exam
 *  @param listModel
 *  @param status    考试状态
 *  @param score     考试成绩
 *  @param exam_time 考试时间
 */

//文档上传的参数
//ccm.object_id  培训课程id
//ccm.lh_id   课时id
//ccm.c_id  课程id
//ccm.cw_id  文档id
//ccm.user_id


//考试参数：	ccm.object_id  培训课程id
//ccm.lh_id   课时id
//ccm.c_id  课程id
//ccm.cw_id  考试id
//ccm.user_id
//ccm.status  完成状态
//ccm.time    时间
//ccm.score   分数


-(void)finishExamOrDoc:(BOOL)isDoc andListModel:(TrainCourseDirectoryModel *)listModel andExamStatus:(NSString  *)status andExamScore:(NSString *)score andExamtime:(NSString *)exam_time{
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:self.courseDetailModel.object_id forKey:@"ccm.object_id"];
    [mudic setObject:listModel.list_id forKey:@"ccm.lh_id"];
    [mudic setObject:listModel.c_id forKey:@"ccm.c_id"];
    [mudic setObject:listModel.object_id forKey:@"ccm.cw_id"];
  
    if (!isDoc) {
        [mudic setObject:status forKey:@"ccm.status"];
        [mudic setObject:exam_time forKey:@"ccm.time"];
        [mudic setObject:score forKey:@"ccm.score"];

    }
    
    [[TrainNetWorkAPIClient client] trainUpdateHourDorEStatusWithIsExam:!isDoc infoDic:mudic Success:^(NSDictionary *dic) {
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
    
    [self.tableView reloadData];
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollDidScrollStop:)]) {
        [self.delegate scrollDidScrollStop:scrollView.contentOffset.y];
    }
}



-(TrainDownloadManager *)downManager{
    if (!_downManager) {
        _downManager = [TrainDownloadManager sharedFileDownloadManager];
    }
    
    
    return _downManager;
}

-(NSMutableArray *)downLoadMuArr{
    if (! _downLoadMuArr) {
        NSArray  *arr =[ TrainDownloadModel findWithFormat:@"c_id = %@",self.courseDetailModel.c_id];
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:arr];
        _downLoadMuArr = muArr;
    }
//    TrainDownloadModel *model = (_downLoadMuArr.count>0)?_downLoadMuArr[0]:nil;
//    NSLog(@"----progress  %f",model.progress);
//    NSLog(@"----progress %p  ",_downLoadMuArr);
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



@end
