//
//  TrainMyGroupListViewController.m
//  SOHUEhr
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainMyGroupListViewController.h"
#import "TrainClassMenuView.h"
#import "TrainGroupAndTopicModel.h"
#import "TrainGroupListCell.h"
#import "TrainGroupDetailViewController.h"


@interface TrainMyGroupListViewController ()<TrainClassMenuDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    TrainBaseTableView              *myGroupTableView;
    NSMutableArray                  *joinGroupMuArr;
    NSMutableArray                  *managerGroupMuArr;
    TrainGroupMode                  groupType;
}

@property(nonatomic, strong) TrainClassMenuView              *classMenuView;

@end

@implementation TrainMyGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    groupType = TrainGroupModeJoin;
    self.navigationItem.title = @"我的圈子";
    
    _classMenuView =[[TrainClassMenuView alloc]initWithFrame:CGRectZero andArr:@[@"我加入的",@"我管理的"]];
    _classMenuView.delegate =self;
    _classMenuView.frame = CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainCLASSHEIGHT);

    [self.view addSubview:_classMenuView];

    [self downLoadGroupAndTopicData:1];
    [self creatTableUI];
    // Do any additional setup after loading the view.
}

#pragma mark - topMenu 点击事件
-(void)TrainClassMenuSelectIndex:(int)index{
    
    groupType = index;
    [self refreshData];
}
-(void)refreshData{
    myGroupTableView.currentpage = 1;
    
    [myGroupTableView scrollRectToVisible:CGRectZero animated:NO];
    
    if (groupType == TrainGroupModeJoin) {
        if (TrainArrayIsEmpty(joinGroupMuArr)) {
            
            [self downLoadGroupAndTopicData:1];
            
        }else{
            [myGroupTableView train_reloadData];
        }
    }else if (groupType == TrainGroupModeManager) {
        if (TrainArrayIsEmpty(managerGroupMuArr)) {
            
            [self downLoadGroupAndTopicData:1];
            
        }else{
            [myGroupTableView train_reloadData];
        }
    }
    
}


#pragma  mark - 圈子, 话题 列表下载数据
-(void)downLoadGroupAndTopicData:(int )index{
    
    [self trainShowHUDOnlyActivity];
    [myGroupTableView dissTablePlace];
    
    [[TrainNetWorkAPIClient client] traingetMyGroupListWithType:groupType curPage:index Success:^(NSDictionary *dic) {
        
        
        NSArray   *dataArr;
        if (groupType == TrainGroupModeJoin) {
            if (index == 1) {
                joinGroupMuArr = [NSMutableArray array];
            }
            dataArr = [TrainGroupModel mj_objectArrayWithKeyValuesArray:dic[@"hotCircle"]];
            [joinGroupMuArr addObjectsFromArray:dataArr];
            
            if (joinGroupMuArr.count>0) {
                
                TrainGroupModel *model =[joinGroupMuArr firstObject];
                myGroupTableView.totalpages =[model.totPage intValue];
            }
            
            
        }else if(groupType == TrainGroupModeManager){
            
            if (index == 1) {
                managerGroupMuArr = [NSMutableArray array];
            }
            dataArr = [TrainGroupModel mj_objectArrayWithKeyValuesArray:dic[@"hotCircle"]];
            [managerGroupMuArr addObjectsFromArray:dataArr];
            
            if (managerGroupMuArr.count>0) {
                
                TrainGroupModel *model =[managerGroupMuArr firstObject];
                myGroupTableView.totalpages =[model.totPage intValue];
            }
            
            
        }
        
        myGroupTableView.trainMode = trainStyleNoData;
        [myGroupTableView EndRefresh];
        [self trainHideHUD];

        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        myGroupTableView.trainMode = trainStyleNoNet;
        [myGroupTableView EndRefresh];
        [self trainShowHUDNetWorkError];
        
    }];

    
    
}

-(void)creatTableUI{
    
    myGroupTableView =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y + TrainCLASSHEIGHT, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight-TrainCLASSHEIGHT) andTableStatus:tableViewRefreshAll];
    [self.view addSubview:myGroupTableView];
    myGroupTableView.delegate =self;
    myGroupTableView.dataSource =self;
    [myGroupTableView registerClass:[TrainGroupListCell class] forCellReuseIdentifier:@"groupCell"];
    __weak  __typeof(self)weakSelf =self;
    
    myGroupTableView.headBlock =^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf downLoadGroupAndTopicData:1];
    };
    myGroupTableView.footBlock=^(int  index){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf downLoadGroupAndTopicData:index];
        
    };
    myGroupTableView.refreshBlock =^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf downLoadGroupAndTopicData:1];
        
    };
}
#pragma mark - tableview  代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (groupType == TrainGroupModeJoin) {
        
        return (TrainArrayIsEmpty(joinGroupMuArr))?0:joinGroupMuArr.count;
        
    }else   if (groupType == TrainGroupModeManager) {
        
        return (TrainArrayIsEmpty(managerGroupMuArr))?0:managerGroupMuArr.count;
    }
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainGroupListCell  *groupCell =[tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    
    TrainGroupModel *listModel ;
    
    if (groupType == TrainGroupModeJoin) {
        
        listModel = joinGroupMuArr[indexPath.row];
        
    }else   if (groupType == TrainGroupModeManager) {
        
        listModel = managerGroupMuArr[indexPath.row];
    }
    groupCell.model = listModel;
 
    
    return groupCell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (groupType == TrainGroupModeJoin) {
        
        return [myGroupTableView cellHeightForIndexPath:indexPath model:joinGroupMuArr[indexPath.row] keyPath:@"model" cellClass:[TrainGroupListCell class] contentViewWidth:TrainSCREENWIDTH];
        
    }else   if (groupType == TrainGroupModeManager) {
        
        return [myGroupTableView cellHeightForIndexPath:indexPath model:managerGroupMuArr[indexPath.row] keyPath:@"model" cellClass:[TrainGroupListCell class] contentViewWidth:TrainSCREENWIDTH];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TrainGroupModel *listModel ;

    if (groupType == TrainGroupModeJoin) {
        
        listModel = joinGroupMuArr[indexPath.row];
        
    }else   if (groupType == TrainGroupModeManager) {
        
        listModel = managerGroupMuArr[indexPath.row];
    }
    TrainGroupDetailViewController *groupVC =[[TrainGroupDetailViewController alloc]init];
    groupVC.group_id = listModel.group_id;
    [self.navigationController pushViewController:groupVC animated:YES];

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
