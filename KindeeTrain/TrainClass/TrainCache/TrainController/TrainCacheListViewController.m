//
//  TrainCacheListViewController.m
//  SOHUEhr
//
//  Created by apple on 16/11/4.
//  Copyright © 2016年 com.sohu-inc. All rights reserved.
//

#import "TrainCacheListViewController.h"
#import "TrainDownloadManager.h"
#import "TrainClassMenuView.h"

#import "TrainDownloadingCell.h"
#import "TrainDownloadFinishCell.h"
#import "TrainCacheCourseListViewController.h"






typedef NS_ENUM(NSInteger) {
    DownloadStatusFinish  = 1,
    DownloadStatusNotFinish
    
}DownloadStatus;

#define downViewHeight    50
@interface TrainCacheListViewController ()<TrainFileDownloadManagerDelegate,UITableViewDelegate,UITableViewDataSource,TrainClassMenuDelegate>
{
    TrainClassMenuView       *menuView;
    
    UIScrollView             *bgscrollView;
    
    UITableView              *downloadingTableView;
    UITableView              *finishTableView;
    
    UIButton                 *editBtn, *allStartBtn, * allPauseBtn;
    
    UIView                   *downView;
    
    DownloadStatus           menuStatus;
    BOOL                     isEdit;
    
}
@property (strong,nonatomic) NSMutableArray *downloadingMuArr;

@property (strong,nonatomic) NSMutableArray *finishMuArr;
@property (strong,nonatomic) NSDictionary   *finishListDic;

@property (strong,nonatomic) NSTimer        *reloadCellTimer;

@property (nonatomic, strong)  TrainDownloadManager  *manager;
@end

@implementation TrainCacheListViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.manager.delegate = nil;
    if (self.reloadCellTimer.isValid) {
        [self.reloadCellTimer invalidate];
        self.reloadCellTimer = nil;
    }

    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self resetStartDownload];
}

-(void)resetStartDownload{
    [self.manager suspendAllFilesDownload];
    NSArray *arr = [TrainDownloadModel findWithFormat:@"status != 4"];
    [arr  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.manager addDownloadWithDownLoadModel:obj];
        
    }];
    [self.reloadCellTimer setFireDate:[NSDate date]];

}

- (void)viewDidLoad {
    [super viewDidLoad];


//    [self.navBar creatCenterTitle:@"缓存"];
    self.navigationItem.title = @"缓存";
    menuStatus = DownloadStatusFinish;
    isEdit     = NO;
    
    editBtn =[[UIButton alloc]initCustomButton];;
    editBtn.frame =CGRectMake(TrainSCREENWIDTH-40, 0, 40, 44);
    editBtn.cusTitle = @"编辑";
    editBtn.cusSelectTitle = @"完成";
    editBtn.hidden = YES;
    editBtn.selected = NO;
    [editBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn  addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];

    [self dealWithLocalInfo];
    [self creatUI];
    [self resetSelectStatus:NO];

}

-(void)edit:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        isEdit = YES;
        allStartBtn.cusTitle = @"全选";
        allPauseBtn.cusTitle = @"删除";
        
      
    }else {
        
        [self resetSelectStatus:NO];
        
        isEdit = NO;
        allStartBtn.cusTitle = @"全部开始";
        allPauseBtn.cusTitle = @"全部暂停";
    }
    [downloadingTableView reloadData];
    
    
}

-(void)resetSelectStatus:(BOOL) isSelect{
   
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.downloadingMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TrainDownloadModel *model = obj;
            model.isSelect = isSelect;
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [downloadingTableView reloadData];
        });
        
    });
    
    
}



-(void)dealWithLocalInfo{
    
    
    NSArray  *finishArr = [self.finishMuArr copy];
    NSMutableDictionary   *dic  = [NSMutableDictionary dictionary];
    [finishArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainDownloadModel  *item =obj;
        NSString *key = [NSString stringWithFormat:@"%@",item.c_id];
        
        NSMutableArray  *arr =[NSMutableArray arrayWithArray:dic[key]];
        [arr addObject:item];
        [dic setObject:arr forKey:key];
    }];
    self.finishListDic = [NSDictionary dictionaryWithDictionary:dic];

    
    
}

-(void)creatUI{
    menuView =[[TrainClassMenuView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainCLASSHEIGHT) andArr:@[@"已下载",@"下载中"] ];
    menuView.delegate = self;
    [self.view addSubview:menuView];



    bgscrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y+ TrainCLASSHEIGHT, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight-TrainCLASSHEIGHT)];
    bgscrollView.showsHorizontalScrollIndicator =NO;
    bgscrollView.pagingEnabled =YES;
    bgscrollView.delegate =self;
    [self.view addSubview:bgscrollView];
    
    bgscrollView.contentSize =CGSizeMake(TrainSCREENWIDTH*2, 0);
    
    
    finishTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH,TrainSCREENHEIGHT-TrainNavHeight-TrainCLASSHEIGHT) style:UITableViewStylePlain];
    finishTableView.tag= DownloadStatusFinish;
    finishTableView.dataSource =self;
    finishTableView.delegate =self;
    finishTableView.rowHeight = 70;
//    finishTableView.estimatedRowHeight = 70;
    
    finishTableView.tableFooterView =[[UIView alloc]init];
    [finishTableView registerClass:[TrainDownloadFinishCell class] forCellReuseIdentifier:@"finishCell"];
    [bgscrollView addSubview:finishTableView];
    
    downloadingTableView =[[UITableView alloc]initWithFrame:CGRectMake(TrainSCREENWIDTH, 0, TrainSCREENWIDTH,TrainSCREENHEIGHT-TrainNavHeight-TrainCLASSHEIGHT - downViewHeight) style:UITableViewStylePlain];
    downloadingTableView.tag = DownloadStatusNotFinish;
    downloadingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    downloadingTableView.dataSource =self;
    downloadingTableView.delegate =self;
    downloadingTableView.rowHeight = 70;
    [downloadingTableView registerClass:[TrainDownloadingCell  class] forCellReuseIdentifier:@"downloadingCell"];
    downloadingTableView.tableFooterView =[[UIView alloc]init];
    [bgscrollView addSubview:downloadingTableView];
    
    
    downView  = [[UIView alloc]initWithFrame:CGRectMake(TrainSCREENWIDTH, TrainSCREENHEIGHT - TrainNavHeight - TrainCLASSHEIGHT - downViewHeight, TrainSCREENWIDTH, downViewHeight)];
    [bgscrollView addSubview:downView];
    
    CGFloat  btnWidth = (TrainSCREENWIDTH - 90)/2.0;
    
    allStartBtn =[[UIButton alloc]initCustomButton];;
    allStartBtn.frame = CGRectMake((30), 10, btnWidth, 30);
    allStartBtn.cusTitle = @"全部开始";
    allStartBtn.layer.borderColor   = [UIColor darkGrayColor].CGColor;
    allStartBtn.layer.cornerRadius  = 5;
    allStartBtn.layer.masksToBounds = YES;
    allStartBtn.layer.borderWidth   = 0.2;
    [allStartBtn  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [allStartBtn  addTarget:self action:@selector(allStartDownload) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:allStartBtn];
    
    allPauseBtn =[[UIButton alloc]initCustomButton];;
    allPauseBtn.frame = CGRectMake((60) +btnWidth, 10, btnWidth, 30);
    allPauseBtn.cusTitle = @"全部暂停";
    allPauseBtn.layer.borderColor   = [UIColor darkGrayColor].CGColor;
    allPauseBtn.layer.cornerRadius  = 5;
    allPauseBtn.layer.masksToBounds = YES;
    allPauseBtn.layer.borderWidth   = 0.2;
    [allPauseBtn  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [allPauseBtn  addTarget:self action:@selector(allPauseDownload) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:allPauseBtn];

    
}


#pragma  mark  - 已下载和下载中的点击事件

-(void)TrainClassMenuSelectIndex:(int)index{
    if (index == 1) {
        menuStatus = DownloadStatusNotFinish;
        editBtn.hidden = NO;
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [bgscrollView setContentOffset:CGPointMake(TrainSCREENWIDTH, 0) animated:YES];
        [downloadingTableView reloadData];
        
    }else{
        menuStatus = DownloadStatusFinish;
        editBtn.hidden = YES;
        isEdit = NO;
        editBtn.selected = NO;
        allStartBtn.cusTitle = @"全部开始";
        allPauseBtn.cusTitle = @"全部暂停";
        [self resetSelectStatus:NO];
        
        [bgscrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [finishTableView reloadData];
    }
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int  index =bgscrollView.contentOffset.x/TrainSCREENWIDTH;
    menuView.selectIndex =index;
    [self TrainClassMenuSelectIndex:index];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == finishTableView) {
  
        NSArray  *arr = [self.finishListDic allValues];
        return TrainArrayIsEmpty(arr ) ? 0 : arr.count;
    
    }else if (tableView == downloadingTableView){
    
        return TrainArrayIsEmpty(self.downloadingMuArr ) ? 0 : self.downloadingMuArr.count;
    }
    
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == finishTableView) {
        
        TrainDownloadFinishCell *finishCell = [tableView dequeueReusableCellWithIdentifier:@"finishCell"];
        NSString  *key = self.finishListDic.allKeys[indexPath.row];
        finishCell.downloadArr = self.finishListDic[key];
        
        return finishCell;
        
    }
    
    TrainDownloadingCell  *downloadCell = [tableView dequeueReusableCellWithIdentifier:@"downloadingCell"];
    TrainDownloadModel *seleceModel = self.downloadingMuArr [indexPath.row];
    downloadCell.model = seleceModel;
    downloadCell.showSelectView = isEdit;
    downloadCell.selectTouch = ^(BOOL isSelect){
        
        seleceModel.isSelect = isSelect;
        [downloadingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    
    
    };
    
    return downloadCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == downloadingTableView ) {
        TrainDownloadModel  *seleceModel = self.downloadingMuArr[indexPath.row];

        if (!isEdit) {
            if (seleceModel.status == TrainFileDownloadStateWaiting || seleceModel.status == TrainFileDownloadStateSuspending || seleceModel.status == TrainFileDownloadStateFail) {

                seleceModel.status = TrainFileDownloadStateDownloading;
                [downloadingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

                [self.manager addDownloadWithDownLoadModel:seleceModel];

            }else if (seleceModel.status == TrainFileDownloadStateDownloading){
                seleceModel.status = TrainFileDownloadStateSuspending;
                [downloadingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

                [self.manager suspendDownloadWithFileId:seleceModel];
                
            }
        }else{
         
            seleceModel.isSelect = !seleceModel.isSelect;
            [downloadingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

        }
        

 
    }else if (tableView == finishTableView){
        
        TrainCacheCourseListViewController *courseCacheVC =[[TrainCacheCourseListViewController alloc]init];
        NSString  *key = self.finishListDic.allKeys[indexPath.row];

        courseCacheVC.fileArr = self.finishListDic[key];
        courseCacheVC.updateFileArr = ^(NSArray *arr){
            
            self.finishMuArr = nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self dealWithLocalInfo];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [finishTableView reloadData];
                });
                
            });
        };
        [self.navigationController pushViewController:courseCacheVC animated:YES];
    }
    
    
   
}



-(void)allStartDownload{
    
    if (isEdit) {
        
        [self resetSelectStatus:YES];
        [downloadingTableView reloadData];
        
    }else{
        [self.manager recoverAllFilesDownload];
        
    }
}
-(void)allPauseDownload{
    
    if (isEdit) {
        [self.reloadCellTimer setFireDate:[NSDate distantFuture]];
        [ TrainAlertTools showAlertWith:self title:@"提示" message:@"删除选中任务?" callbackBlock:^(NSInteger btnIndex) {
            
            if(btnIndex == 1){
                                    
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSArray  *downArr = [self.downloadingMuArr copy];
                    
                    [downArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        TrainDownloadModel *download = obj;
                        if (download.isSelect == YES) {
                            [self.manager cancelDownloadWithFileId:download];
                            [self.downloadingMuArr removeObject:download];
                        }
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        isEdit = NO;
                        editBtn.selected = NO;
                        allStartBtn.cusTitle = @"全部开始";
                        allPauseBtn.cusTitle = @"全部暂停";
                        
                        [self resetSelectStatus:NO];
                        [self.reloadCellTimer setFireDate:[NSDate date]];

                        
                    });
                    
                });

            }
            
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
        

        
    
    }else{
        [self.manager suspendAllFilesDownload];
        
        NSArray  *downArr = [self.downloadingMuArr copy];
        
        [downArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainDownloadModel *download = obj;
            download.status =  TrainFileDownloadStateSuspending;
        }];
        [downloadingTableView reloadData];
        



    }

}

//#pragma mark - 添加下载任务
//


#pragma mark - 下载 delegate


-(void)fileDownloadManagerStartDownload:(TrainDownloadModel *)download{
//    [self.downloadingMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        TrainDownloadModel * listModel = obj;
//        if ([listModel.CHO_id isEqualToString:download.CHO_id]) {
//            listModel.status = download.status;
//            *stop =YES;
//        }
//    }];
//    if (menuStatus  == DownloadStatusNotFinish) {
//        [downloadingTableView reloadData];
//    }
}

-(void)fileDownloadManagerReceiveResponse:(TrainDownloadModel *)download FileSize:(uint64_t)totalLength{
    NSArray   *arr = self.downloadingMuArr.copy;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainDownloadModel  *downM = obj;
        
        if ([downM.CHO_id isEqualToString:download.CHO_id]) {
            [self.downloadingMuArr replaceObjectAtIndex:idx withObject:download];
            *stop = YES;
        }
    }];
    if (menuStatus  == DownloadStatusNotFinish) {
        [downloadingTableView reloadData];
    }
}

-(void)fileDownloadManagerFinishDownload:(TrainDownloadModel *)download success:(BOOL)downloadSuccess error:(NSError *)error{
    
    
    NSArray   *arr = self.downloadingMuArr.copy;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainDownloadModel  *downM = obj;
        
        if ([downM.CHO_id isEqualToString:download.CHO_id]) {
            [self.downloadingMuArr replaceObjectAtIndex:idx withObject:download];
            *stop = YES;
        }
    }];
    
    if (downloadSuccess) {
        if (menuStatus  == DownloadStatusNotFinish && arr.count > 0) {
            [self.downloadingMuArr removeObject:download];
            [self.finishMuArr addObject:download];
            [self dealWithLocalInfo];
            [downloadingTableView reloadData];
        }
        
    }else{
        if (menuStatus  == DownloadStatusNotFinish && arr.count > 0) {
            [downloadingTableView reloadData];
        }
    }
    
}

-(void)fileDownloadManagerUpdateProgress:(TrainDownloadModel *)download didReceiveData:(uint64_t)receiveLength downloadSpeed:(NSString *)downloadSpeed{
    
    NSArray   *arr = self.downloadingMuArr.copy;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainDownloadModel  *downM = obj;
        
        if ([downM.CHO_id isEqualToString:download.CHO_id]) {
            [self.downloadingMuArr replaceObjectAtIndex:idx withObject:download];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
                [downloadingTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            });
            *stop = YES;
        }
    }];
  

}

-(void)reloadCell{
    if ( menuStatus  == DownloadStatusNotFinish) {
    
        __block BOOL    isscfinish = YES;
        
        [self.downloadingMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainDownloadModel *dddModel = obj;
            if (dddModel.status != TrainFileDownloadStateFinish) {
                isscfinish = NO;
                *stop =YES;
            }
        }];
        
        if (isscfinish && self.reloadCellTimer.isValid) {
            [self.reloadCellTimer invalidate];
            self.reloadCellTimer = nil;
        }
        
        [downloadingTableView reloadData];
        
    }
    
}



-(NSMutableArray *)downloadingMuArr{

    if (TrainArrayIsEmpty(_downloadingMuArr)) {
        NSArray  *arr = [TrainDownloadModel findByCriteria:@"status != 4"];
        NSMutableArray  *muarr = [NSMutableArray arrayWithArray:arr];
        _downloadingMuArr = muarr;
    }
    return _downloadingMuArr;
    
}

-(NSMutableArray *)finishMuArr{
    if (TrainArrayIsEmpty(_finishMuArr)) {
        NSArray  *arr = [TrainDownloadModel findByCriteria:@"status = 4"];
        NSMutableArray  *muarr = [NSMutableArray arrayWithArray:arr];
        _finishMuArr = muarr;
    }
    return _finishMuArr;
}




-(TrainDownloadManager *)manager{
    if (!_manager) {
        _manager = [TrainDownloadManager sharedFileDownloadManager];
        _manager.delegate = self;
    }
    return _manager;
}

-(NSTimer *)reloadCellTimer{
    if (! _reloadCellTimer) {
        _reloadCellTimer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(reloadCell) userInfo:nil repeats:YES];
        
    }
    return _reloadCellTimer;
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
