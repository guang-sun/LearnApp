//
//  TrainCacheCourseListViewController.m
//  SOHUEhr
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 com.sohu-inc. All rights reserved.
//

#import "TrainCacheCourseListViewController.h"
#import "TrainDownloadModel.h"
#import "TrainLocalVideoViewController.h"
#import "TrainDownloadManager.h"
#import "TrainCourseDetailModel.h"
#import "TrainLocalLearnRecord.h"

@interface TrainCacheCourseListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UIButton            *editBtn;
    
    BOOL                isEdit ;
    
    UIView              *downView;

    UITableView         *downTableView;
    NSMutableArray      *selectArr;
    NSArray             *hourArr;

    
}

@property(nonatomic, strong) TrainDownloadManager  *downManager;
@end

@implementation TrainCacheCourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TrainDownloadModel  *model;
    if (_fileArr.count>0) {
        model = _fileArr[0];
        
        NSString  *CriteriaStr = [NSString stringWithFormat:@"c_id = %@",model.c_id];
        hourArr = [TrainCourseDirectoryModel findByCriteria:CriteriaStr];
    }
    
    self.navigationItem.title = model.courseName;
    
    isEdit  = NO;
    
    editBtn =[[UIButton alloc]initCustomButton];;
    editBtn.frame =CGRectMake(TrainSCREENWIDTH-40, 0, 40, 44);
    editBtn.cusTitle = @"编辑";
    editBtn.cusSelectTitle = @"完成";
    editBtn.selected = NO;
    [editBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn  addTarget:self action:@selector(courseEdit:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navBar creatRightBarItem:editBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        selectArr = [NSMutableArray array];
        for (int  i = 0; i < _fileArr.count; i++) {
            [selectArr addObject:@"N"];
        }

    });
    
    [self creatDownView];

    [self creatUI];
    
    [self resetSelectStatus:NO];
    
    // Do any additional setup after loading the view.
}

-(void)resetSelectStatus:(BOOL) isSelect{
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.fileArr  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TrainDownloadModel *model = obj;
            model.isSelect = isSelect;
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [downTableView reloadData];
        });
        
    });
    
    
}


-(void)courseEdit:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        isEdit = YES;
        
        downView.sd_layout.heightIs(TrainCLASSHEIGHT);
        downView.hidden = NO;
        selectArr =[NSMutableArray array];
        
        [self resetSelectStatus:NO];
        
        
    }else {
        isEdit = NO;
        downView.sd_layout.heightIs(0);
        downView.hidden = YES;
    }
  

    [UIView animateWithDuration:0.3 animations:^{
        [downView updateLayout];
    }];
    [downTableView reloadData];
}


-(void)creatDownView{
    
    if (!downView) {
        downView = [[UIView alloc]init];
        downView.hidden =YES;
        [self.view addSubview:downView];
        
        CGFloat  btnWidth = (TrainSCREENWIDTH - 90)/2.0;

        UIButton *allSelectBtn =[[UIButton alloc]initCustomButton];;
        allSelectBtn.cusTitle = @"全选";
//        allSelectBtn.frame = CGRectMake((30) , 10, btnWidth, 30);
        allSelectBtn.layer.borderColor   = [UIColor darkGrayColor].CGColor;
        allSelectBtn.layer.cornerRadius  = 5;
        allSelectBtn.layer.masksToBounds = YES;
        allSelectBtn.layer.borderWidth   = 0.2;
        [allSelectBtn  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [allSelectBtn  addTarget:self action:@selector(allSelectCell) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:allSelectBtn];
        
        UIButton *deleteBtn =[[UIButton alloc]initCustomButton];;
//        deleteBtn.frame = CGRectMake((60) +btnWidth, 10, btnWidth, 30);
        deleteBtn.cusTitle = @"删除";
        deleteBtn.layer.borderColor   = [UIColor darkGrayColor].CGColor;
        deleteBtn.layer.cornerRadius  = 5;
        deleteBtn.layer.masksToBounds = YES;
        deleteBtn.layer.borderWidth   = 0.2;
        [deleteBtn  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [deleteBtn  addTarget:self action:@selector(detelleCell) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:deleteBtn];
        
        
        downView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view)
        .heightIs(40);
        
        allSelectBtn.sd_layout
        .leftSpaceToView(downView,30)
        .widthIs(btnWidth)
        .centerYEqualToView(downView)
        .heightIs(30);
        
        
        deleteBtn.sd_layout
        .rightSpaceToView(downView,30)
        .widthIs(btnWidth)
        .centerYEqualToView(downView)
        .heightIs(30);
    }
}


-(void)allSelectCell{
    
    [self resetSelectStatus:YES];
}


-(void)detelleCell{
    

    NSMutableArray  *muArr = [NSMutableArray array];
    
    [self.fileArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        TrainDownloadModel *selectModel = obj;
        if (selectModel.isSelect ) {
            [muArr addObject:selectModel];
        }
    }];
    
    if (muArr.count == 0) {
        
        [self trainShowHUDOnlyText:@"抱歉,您未选中任意一个课时,请重新选择"];
        
        editBtn.selected = NO;
        isEdit = NO;
        downView.sd_layout.heightIs(0);
        downView.hidden = YES;
        [self resetSelectStatus:NO];
        
        return;
    }
 
    [ TrainAlertTools showAlertWith:self title:@"提示" message:@"删除选中课时?" callbackBlock:^(NSInteger btnIndex) {
        
        if(btnIndex == 1){
            
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [muArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TrainDownloadModel *model = obj;
               
                    [self.downManager deleteDownloadWithFileId:model];
                    
                }];
                
                
                NSMutableArray  *arr =[NSMutableArray arrayWithArray:_fileArr];
                
                [arr removeObjectsInArray:muArr];
                
                _fileArr = arr;
                
                if (_updateFileArr) {
                    _updateFileArr(_fileArr);
                }
                if (_fileArr.count == 0) {

                    dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                    });
                    return ;
                 }
               
                dispatch_async(dispatch_get_main_queue(), ^{

                    editBtn.selected = NO;
                    isEdit = NO;
                    downView.sd_layout.heightIs(0);
                    downView.hidden = YES;
                    [self resetSelectStatus:NO];
                });
                
                
            });
        }
        
    } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
}

-(void)creatUI{
    
    
    downTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    downTableView.delegate   = self;
    downTableView.dataSource = self;
    downTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    downTableView.rowHeight = 60;
    downTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    [downTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"downCell"];
    [self.view addSubview:downTableView];
    
    downTableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,TrainNavorigin_y)
    .bottomSpaceToView(downView,0);
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return (TrainArrayIsEmpty(_fileArr))?0:_fileArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell  *downCell = [tableView dequeueReusableCellWithIdentifier:@"downCell"];
    
    for (UIView  *view in downCell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    TrainDownloadModel *model =_fileArr[indexPath.row];
    
    float   rightWith = 10;
    if (isEdit ==YES) {
        
        rightWith = 40;
        UIButton  *button =[[UIButton alloc]initWithFrame:CGRectMake(TrainSCREENWIDTH-30, 20, 20, 20)];
        [button setImage:[UIImage imageNamed:@"train_checkbox_on"]
                forState:UIControlStateNormal];
        [button setImage:[UIImage imageThemeColorWithName:@"train_checkbox_off"]
                forState:UIControlStateSelected];
        [button setImage:[UIImage imageThemeColorWithName:@"train_checkbox_off"]  forState:UIControlStateHighlighted | UIControlStateSelected];
        [button setImage:[UIImage imageThemeColorWithName:@"train_checkbox_off"]  forState:UIControlStateHighlighted ];

        button.selected = model.isSelect;
        [downCell.contentView addSubview:button];
        [button setUserInteractionEnabled:YES];
        button.tag = indexPath.row;
        [button addTarget:self action:@selector(selectbuttontap:)
         forControlEvents:UIControlEventTouchUpInside];
        
    }
    UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(15, 15, TrainSCREENWIDTH - rightWith, 30)];
    lable.text = model.hourName;
    lable.font = [UIFont systemFontOfSize:14.0];
    
    lable.textColor =[UIColor blackColor];
    [downCell.contentView addSubview:lable];
    

    UILabel  *separatorline =[[UILabel alloc]initWithLineView];

    separatorline.frame = CGRectMake(15, 60-1, TrainSCREENWIDTH-30, 1);
    [downCell.contentView addSubview:separatorline];
    return downCell;

    
    
    
}

#pragma mark - 选中
-(void)selectbuttontap:(UIButton*)sender
{
    NSInteger index=sender.tag;
    sender.selected = !sender.selected;
    if (self.fileArr.count > index) {
        TrainDownloadModel *selectModel = self.fileArr[index];
        selectModel.isSelect = !selectModel.isSelect;

    }

    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
    [downTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( !isEdit) {
        
        if (hourArr.count > 0) {
            TrainDownloadModel *videoModel = _fileArr[indexPath.row];
            __block TrainCourseDirectoryModel  *hourModel ;
            [hourArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TrainCourseDirectoryModel *enumModel  = obj ;
                if ([enumModel.list_id isEqualToString:videoModel.hour_id]) {
                    hourModel = enumModel ;
                    *stop = YES ;
                }
            }];
            videoModel.last_time = [hourModel.last_time integerValue];
            
            TrainCourseDirectoryModel *enumModel  = [hourArr firstObject];
            if ([enumModel.condition isEqualToString:@"O"]) {
                
                TrainDownloadModel *md = videoModel;
                [self ordertoplaymovieWithSelectRow:md];
                
            }else {
                TrainLocalVideoViewController *localVideoVC = [[TrainLocalVideoViewController alloc]init];
                localVideoVC.videoModel = _fileArr[indexPath.row];
                localVideoVC.isfinishVideo = ([hourModel.ua_status isEqualToString:@"C"]) ? YES : NO;
                localVideoVC.object_id = hourModel.course_objectid ;
                
                localVideoVC.trainSaveLocalBlock = ^(BOOL isfinish, TrainLocalLearnRecord *record) {
                    
                    if (isfinish) {
                        record.s_status = @"C";
                        hourModel.ua_status = @"C";
                    }else {
                        record.s_status = hourModel.ua_status ;
                    }
                    hourModel.last_time = [NSString stringWithFormat:@"%ld",record.last_time] ;
                    [hourModel saveOrUpdateByColumnName:@[@"c_id",@"list_id"]];
                    [record saveOrUpdateByColumnName:@[@"c_id",@"lh_id"]];
                    
                };
                [self.navigationController pushViewController:localVideoVC animated:YES];
            }
            
        }else {
            TrainLocalVideoViewController *localVideoVC = [[TrainLocalVideoViewController alloc]init];
            localVideoVC.videoModel = _fileArr[indexPath.row];
            [self.navigationController pushViewController:localVideoVC animated:YES];
        }
        
        
    }else{
        
        if (self.fileArr.count > indexPath.row) {
            
            
        }
    }
}
//按顺序进行播放
-(void)ordertoplaymovieWithSelectRow:(TrainDownloadModel *)videoModel{
    
    
    __block TrainCourseDirectoryModel  *hourModel ;
    __block NSInteger  currIndex ;
    [hourArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrainCourseDirectoryModel *enumModel  = obj ;
        if ([enumModel.list_id isEqualToString:videoModel.hour_id]) {
            hourModel = enumModel ;
            currIndex = idx ;
            *stop = YES ;
        }
    }];
    
    if ([hourModel.h_type isEqualToString:@"H"] ||[hourModel.h_type isEqualToString:@"E"] ) {
        
        BOOL   isplayer = YES;
        
        for ( NSInteger i = currIndex; i >0; i--) {
            TrainCourseDirectoryModel  *listHour = hourArr[i-1];
            
            if ([listHour.h_type isEqualToString:@"H"] ||[listHour.h_type isEqualToString:@"E"]  ) {
                if ( ![listHour.ua_status isEqualToString:@"C"]  && ![listHour.ua_status isEqualToString:@"P"]) {
                    isplayer = NO;
                }
                break ;
            }
        }
        
        if (isplayer) {
            
            TrainLocalVideoViewController *localVideoVC = [[TrainLocalVideoViewController alloc]init];
            localVideoVC.videoModel = videoModel;
            localVideoVC.isfinishVideo = ([hourModel.ua_status isEqualToString:@"C"]) ? YES : NO;
            localVideoVC.object_id = hourModel.course_objectid ;
            
            localVideoVC.trainSaveLocalBlock = ^(BOOL isfinish, TrainLocalLearnRecord *record) {
                
                if (isfinish) {
                    record.s_status = @"C";
                    hourModel.ua_status = @"C";
                }else {
                    record.s_status = hourModel.ua_status ;
                }
                hourModel.last_time = [NSString stringWithFormat:@"%ld",record.last_time] ;
                [hourModel saveOrUpdateByColumnName:@[@"c_id",@"list_id"]];
                
                [record saveOrUpdateByColumnName:@[@"c_id",@"lh_id"]];
                
            };
            
            
            [self.navigationController pushViewController:localVideoVC animated:YES];
            
        }else{
            [TrainProgressHUD showMsgWithoutView:TrainOrderToPlayText];
            
        }
    }
}


-(TrainDownloadManager *)downManager{
    if (! _downManager) {
        _downManager = [TrainDownloadManager sharedFileDownloadManager];
        
    }
    return _downManager;
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
