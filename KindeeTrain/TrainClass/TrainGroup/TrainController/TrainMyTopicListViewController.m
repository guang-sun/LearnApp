//
//  TrainMyTopicListViewController.m
//  SOHUEhr
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainMyTopicListViewController.h"
#import "TrainClassMenuView.h"
#import "TrainGroupAndTopicModel.h"
#import "TrainTopicListCell.h"
#import "TrainTopicDetailViewController.h"


@interface TrainMyTopicListViewController ()<TrainClassMenuDelegate,UITableViewDelegate,UITableViewDataSource>{
 
    TrainBaseTableView              *myTopicTableView;
    NSMutableArray                  *myTopicMuArr;
    NSString                        *topicMode;
}

@property(nonatomic, strong) TrainClassMenuView              *classMenuView;

@end

@implementation TrainMyTopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    removeTopic  参数user_id strObj=[{"object_id":1,"id":1},{"object_id":2,"id":2},{"object_id":3,"id":3}] 
    
    topicMode = @"0";
    self.navigationItem.title = @"我的话题";
//    @[@"话题",@"问答"]
    _classMenuView =[[TrainClassMenuView alloc]initWithFrame:CGRectZero andArr:@[@"全部",@"问答",@"精华"]];
    _classMenuView.delegate =self;
    _classMenuView.frame = CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainCLASSHEIGHT);
    [self.view addSubview:_classMenuView];
    
//    [self downLoadGroupAndTopicData:1];
    [self creatTableUI];
    // Do any additional setup after loading the view.
}


-(void)dealloc{
    NSLog(@"myTopic--dealloc ---");
}
#pragma mark - topMenu 点击事件
-(void)TrainClassMenuSelectIndex:(int)index{
    
    switch (index) {
        case 0:
            topicMode =@"0";
            break;
        case 1:
            topicMode =@"Q";
            break;
        case 2:
            topicMode =@"E";
            break;
            
        default:
            break;
    }

    [self refreshData];
}
-(void)refreshData{
    myTopicTableView.currentpage =1;
    [self downLoadGroupAndTopicData:1];
    [myTopicTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
}

#pragma  mark - 圈子, 话题 列表下载数据
-(void)downLoadGroupAndTopicData:(int )index{
    
    [self trainShowHUDOnlyActivity];
    [myTopicTableView dissTablePlace];
    
    TrainWeakSelf(self);
    
    [[TrainNetWorkAPIClient client] trainMyTopicListWithtype:topicMode curPage:index Success:^(NSDictionary *dic) {
            
            if (index == 1) {
                myTopicMuArr = [NSMutableArray array];
            }
            NSArray  *dataArr = [TrainTopicModel mj_objectArrayWithKeyValuesArray:dic[@"topic"]];
            [myTopicMuArr addObjectsFromArray:dataArr];
        
            if (myTopicMuArr.count>0) {
                TrainTopicModel *model =[myTopicMuArr objectAtIndex:0];
                myTopicTableView.totalpages =[model.totPage intValue];
            }
        
            myTopicTableView.trainMode = trainStyleNoData;
            [myTopicTableView EndRefresh];
            [weakself trainHideHUD];
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            
            myTopicTableView.trainMode = trainStyleNoNet;
            [myTopicTableView EndRefresh];
            [weakself trainShowHUDNetWorkError];
        }];
    
    
}

-(void)creatTableUI{
    
    myTopicTableView =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y + TrainCLASSHEIGHT, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight-TrainCLASSHEIGHT) andTableStatus:tableViewRefreshAll];
    [self.view addSubview:myTopicTableView];
    myTopicTableView.delegate =self;
    myTopicTableView.dataSource =self;
    [myTopicTableView registerClass:[TrainTopicListCell class] forCellReuseIdentifier:@"cellTopic"];
    
    TrainWeakSelf(self);
    
    myTopicTableView.headBlock =^(){
        
        [weakself downLoadGroupAndTopicData:1];
    };
    myTopicTableView.footBlock=^(int  index){

        [weakself downLoadGroupAndTopicData:index];
        
    };
    myTopicTableView.refreshBlock =^(){
        
        [weakself downLoadGroupAndTopicData:1];
        
    };
}
#pragma mark - tableview  代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return myTopicMuArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    TrainTopicListCell  *topicCell =[tableView dequeueReusableCellWithIdentifier:@"cellTopic"];
    //    topicCell.isImageTap =NO;
    __block TrainTopicModel *listModel = myTopicMuArr[indexPath.row];
    topicCell.model = listModel;
    topicCell.isImageTap = NO;
    TrainWeakSelf(self);
    topicCell.topicTouchBlock = ^( NSString *str , TrainTopicModel *topModel){
    
        [weakself updateTopicTopAndCollect:str andModel:topModel andIndex:indexPath];
        
    };
    
    return topicCell;
    
}

- (void)updateTopicTopAndCollect:(NSString *)str andModel:(TrainTopicModel *)topicModel andIndex:(NSIndexPath *)index{
    
    [self trainShowHUDOnlyText:str];
    __block TrainTopicModel *listModel = myTopicMuArr[index.row];
    listModel  = topicModel;
    
    [myTopicTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [myTopicTableView cellHeightForIndexPath:indexPath model:myTopicMuArr[indexPath.row] keyPath:@"model" cellClass:[TrainTopicListCell class] contentViewWidth:TrainSCREENWIDTH];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
        TrainTopicModel  *topicModel =[myTopicMuArr objectAtIndex:indexPath.row];
        
        TrainTopicDetailViewController  * topicVC =[[TrainTopicDetailViewController alloc]init];
        topicVC.model =myTopicMuArr[indexPath.row];
        topicVC.model = topicModel;
        topicVC.updateModel = ^(TrainTopicModel *model){
        
            if (model) {
                [myTopicMuArr replaceObjectAtIndex:indexPath.row withObject:model];
                [myTopicTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [myTopicMuArr removeObjectAtIndex:indexPath.row];
                [myTopicTableView train_reloadData];
            }
        };

        [self.navigationController pushViewController:topicVC animated:YES];
        
    
    
    
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
