//
//  TrainGroupAndTopicListViewController.m
//   KingnoTrain
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainGroupAndTopicListViewController.h"
#import "TrainClassMenuView.h"
#import "TrainGroupAndTopicModel.h"
#import "TrainSearchViewController.h"
#import "TrainGroupListCell.h"
#import "TrainTopicListCell.h"
#import "TrainGroupDetailViewController.h"
#import "TrainTopicDetailViewController.h"



@interface TrainGroupAndTopicListViewController ()<TrainClassMenuDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    BOOL                    isGroup;
    TrainBaseTableView      *customView;
    TrainTopicMode          mode;
    NSMutableArray          *groupMuArr;
    NSMutableArray          *topicMuArr;
    NSArray                 *topTopicArr;
    NSArray                 *topGroupArr;
}

@property (nonatomic, strong) TrainClassMenuView  *classMenuView;

@end

@implementation TrainGroupAndTopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    isGroup =YES;
    mode = TrainTopicModeNew;
    
    self.navigationItem.leftBarButtonItem = nil;
   
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithTitleItems:@[@"圈子",@"话题"]];
    [segment addTarget:self action:@selector(segmentTouch:) forControlEvents:UIControlEventValueChanged];
    
    segment.frame = CGRectMake((TrainSCREENWIDTH - 216)/2, 5, 216, 30);
    
    self.navigationItem.titleView = segment;
    
    UIButton *rightBtn =[[UIButton alloc]initCustomButton];
    rightBtn.image = [UIImage imageNamed:@"Train_Search"];
    rightBtn.frame = CGRectMake(TrainSCREENWIDTH - 40, 0, 30, 44);
    [rightBtn addTarget:self action:@selector(pushSearch)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    topGroupArr =@[@"最新",@"最热"];
    topTopicArr =  @[@"全部",@"问答",@"精华",@"最新",@"最热"]; //@[@"最新",@"最热",@"精华"]; //,@"问答"
    _classMenuView =[[TrainClassMenuView alloc]initWithFrame:CGRectZero andArr:topGroupArr];
    _classMenuView.frame = CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainCLASSHEIGHT);

    _classMenuView.delegate =self;
    [self.view addSubview:_classMenuView];
   
    [self  creatTableUI];
    [self downLoadGroupAndTopicData:1];


}
-(void)pushSearch{
    [_classMenuView dismissTopMenu];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TrainSearchViewController *searchVC =[[TrainSearchViewController alloc]init];
        searchVC.hidesBottomBarWhenPushed =YES;
        searchVC.selectMode = TrainSearchStyleTopic;
        [self.navigationController pushViewController:searchVC animated:YES];
        
    });
    
}

#pragma mark - segment   点击  圈子 话题切换
-(void)segmentTouch:(UISegmentedControl *)seg{
    
    if (seg.selectedSegmentIndex ==0) {
        isGroup =YES;
        mode =TrainTopicModeNew;
        [_classMenuView resetTopMenu:topGroupArr];
    }else{
        [_classMenuView resetTopMenu:topTopicArr];
        isGroup =NO;
        mode =TrainTopicModeNew;
        
    }
    [self refreshData];
}


#pragma mark - topMenu 点击事件
-(void)TrainClassMenuSelectIndex:(int)index{
    NSLog(@"%d",index);
    
    switch (index) {
        case 0:
            mode = TrainTopicModeNew;
            break;
        case 1:
            mode =TrainTopicModeAD;
            break;
        case 2:
            mode =TrainTopicModePre;
            break;
        case 3:
            mode =TrainTopicModeNew;
            break;
        case 4:
            mode =TrainTopicModeHot;
            break;
        default:
            break;
    }

    
    [self refreshData];
    
    
}
-(void)refreshData{
    
    [self downLoadGroupAndTopicData:1];
    customView.currentpage = 1;
    [customView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    
}

#pragma  mark - 圈子, 话题 列表下载数据
-(void)downLoadGroupAndTopicData:(int )index{
    
    [self trainShowHUDOnlyActivity];
    [customView dissTablePlace];
    
    if (isGroup) {
        
        [[TrainNetWorkAPIClient client] trainGroupListWithtype:mode curPage:index Success:^(NSDictionary *dic) {
            if (index == 1) {
                groupMuArr = [NSMutableArray array];
            }
            NSArray  *dataArr = [TrainGroupModel mj_objectArrayWithKeyValuesArray:dic[@"hotCircle"]];
            [groupMuArr addObjectsFromArray:dataArr];
            if (groupMuArr.count>0) {
                TrainGroupModel *model =[groupMuArr firstObject];
                customView.totalpages =[model.totPage intValue];
            }
            customView.trainMode = trainStyleNoData;
            [customView EndRefresh];
            [self trainHideHUD];
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            
            customView.trainMode = trainStyleNoNet;
            [customView EndRefresh];
            [self trainShowHUDNetWorkError];
        }];
        
        
    } else {
        
        [[TrainNetWorkAPIClient client] trainTopicListWithtype:mode curPage:index Success:^(NSDictionary *dic) {
            
            if (index == 1) {
                topicMuArr = [NSMutableArray array];
            }
            NSArray  *dataArr = [TrainTopicModel mj_objectArrayWithKeyValuesArray:dic[@"topic"]];
            [topicMuArr addObjectsFromArray:dataArr];
            if (topicMuArr.count>0) {
                TrainTopicModel *model =[topicMuArr objectAtIndex:0];
                customView.totalpages =[model.totPage intValue];
            }
            customView.trainMode = trainStyleNoData;
            [customView EndRefresh];
            [self trainHideHUD];
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            
            customView.trainMode = trainStyleNoNet;
            [customView EndRefresh];
            [self trainShowHUDNetWorkError];
        }];
    }
    
}

-(void)creatTableUI{
    
    customView =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainCLASSHEIGHT +TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight-49-TrainCLASSHEIGHT) andTableStatus:tableViewRefreshAll];
    [self.view addSubview:customView];
    //    customV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(TOPCLASSHEIGHT, 0, 0, 0));
    //    customTableV =customV.customTableV;
    customView.delegate =self;
    customView.dataSource =self;
    [customView registerClass:[TrainGroupListCell class] forCellReuseIdentifier:@"cellGroup"];
    [customView registerClass:[TrainTopicListCell class] forCellReuseIdentifier:@"cellTopic"];
    __weak  __typeof(self)weakSelf =self;
    
    customView.headBlock =^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf downLoadGroupAndTopicData:1];
    };
    customView.footBlock=^(int  index){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf downLoadGroupAndTopicData:index];
        
    };
    customView.refreshBlock =^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf downLoadGroupAndTopicData:1];
        
    };
}
#pragma mark - tableview  代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(isGroup){
        return   TrainArrayIsEmpty(groupMuArr)?0:groupMuArr.count;
    }
    return   TrainArrayIsEmpty(topicMuArr)?0:topicMuArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isGroup) {
        TrainGroupListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellGroup"];
        cell.model = groupMuArr[indexPath.row];
        return cell;
        
    }
    TrainTopicListCell  *topicCell =[tableView dequeueReusableCellWithIdentifier:@"cellTopic"];
    __block TrainTopicModel *listModel = topicMuArr[indexPath.row];
    topicCell.model = listModel;
    topicCell.isImageTap = NO;
    topicCell.topicTouchBlock = ^( NSString *str , TrainTopicModel *topModel){
        
        [self trainShowHUDOnlyText:str];
        listModel  = topModel;
        [customView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    return topicCell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isGroup) {
        return [customView cellHeightForIndexPath:indexPath model:groupMuArr[indexPath.row] keyPath:@"model" cellClass:[TrainGroupListCell class] contentViewWidth:TrainSCREENWIDTH];
    }
    
    return [customView cellHeightForIndexPath:indexPath model:topicMuArr[indexPath.row] keyPath:@"model" cellClass:[TrainTopicListCell class] contentViewWidth:TrainSCREENWIDTH];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (isGroup) {
        TrainGroupModel  *groupModel =[groupMuArr objectAtIndex:indexPath.row];
        
        TrainGroupDetailViewController *groupVC =[[TrainGroupDetailViewController alloc]init];
        groupVC.group_id = groupModel.group_id;
        groupVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:groupVC animated:YES];
        
    }else{
        TrainTopicModel  *topicModel =[topicMuArr objectAtIndex:indexPath.row];
        
        TrainTopicDetailViewController  * topicVC =[[TrainTopicDetailViewController alloc]init];
        topicVC.model = topicModel;
        topicVC.updateModel = ^(TrainTopicModel *model){
            
            if (model) {
                [topicMuArr replaceObjectAtIndex:indexPath.row withObject:model];
                [customView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [topicMuArr removeObjectAtIndex:indexPath.row];
                [customView train_reloadData];
            }
            
            
        };
        topicVC.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:topicVC animated:YES];
        
    }
    
    
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
