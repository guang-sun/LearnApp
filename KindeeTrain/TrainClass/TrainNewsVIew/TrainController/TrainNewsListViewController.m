//
//  TrainNewsListViewController.m
//   KingnoTrain
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import "TrainNewsListViewController.h"
#import "TrainNewsListCell.h"
#import "TrainNewsDetailViewController.h"



@interface TrainNewsListViewController ()<UITableViewDataSource,UITableViewDelegate,TrainClassMenuDelegate>
{
    NSMutableArray                  *newsMuArr;
    TrainBaseTableView              *newsTableView;
    TrainNewsMode                   readStatus;
}


@end

@implementation TrainNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"消息中心" ;
    NSArray  *arr =@[@"未读",@"已读"];
    readStatus = TrainNewsModeUnread;
    TrainClassMenuView *topMenuV= [[TrainClassMenuView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainCLASSHEIGHT) andArr:arr];
    topMenuV.delegate =self;
    [self.view addSubview:topMenuV];
    
    [self creatTableViewUI];

    // Do any additional setup after loading the view.
}

-(void)creatTableViewUI{
    
    newsTableView =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainCLASSHEIGHT + TrainNavorigin_y, TrainSCREENWIDTH , TrainSCREENHEIGHT - TrainNavHeight -TrainCLASSHEIGHT) andTableStatus:tableViewRefreshAll];
    
    newsTableView.delegate =self;
    newsTableView.dataSource =self;
    [newsTableView registerClass:[TrainNewsListCell class] forCellReuseIdentifier:@"newCell"];
    [self.view addSubview:newsTableView];
    
    TrainWeakSelf(self);
    newsTableView.headBlock =^(){
        [weakself downLoadNewsData:1];
    };
    newsTableView.footBlock=^(int  aa){
        [weakself downLoadNewsData:aa];
    };
    newsTableView.refreshBlock =^(){
        [weakself downLoadNewsData:1];
    };

}

#pragma  mark - download数据
-(void)downLoadNewsData:(int )index{
    
    [self trainShowHUDOnlyActivity];
    
    [newsTableView dissTablePlace];
    
    [[TrainNetWorkAPIClient client] trainGetNewslistWithisRead:readStatus curPage:index Success:^(NSDictionary *dic) {
        
        if (index == 1) {
            newsMuArr =[NSMutableArray new];
        }
        NSArray  *dataArr = [TrainNewsModel  mj_objectArrayWithKeyValuesArray:dic[@"myMessages"]];
        [newsMuArr addObjectsFromArray:dataArr];
        if (newsMuArr.count>0) {
            TrainNewsModel *model =[newsMuArr objectAtIndex:0];
            newsTableView.totalpages =[model.totPage intValue];
        }
        
        newsTableView.trainMode = trainStyleNoData;
        [newsTableView EndRefresh];
        [self trainHideHUD];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        newsTableView.trainMode = trainStyleNoNet;
        [newsTableView EndRefresh];
        [self trainShowHUDNetWorkError];
        

    }];
  }
#pragma  mark  - tableview的代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return newsMuArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainNewsListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"newCell"];
//    cell.isRead = arc4random()%2;
    cell.model =  newsMuArr [indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [newsTableView cellHeightForIndexPath:indexPath model:newsMuArr[indexPath.row] keyPath:@"model" cellClass:[TrainNewsListCell class] contentViewWidth:TrainSCREENWIDTH];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TrainNewsDetailViewController  *detailVC = [[TrainNewsDetailViewController alloc]init];
    detailVC.newsModel = newsMuArr [indexPath.row] ;
    detailVC.readStatus = readStatus ;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
    
    
}
#pragma  mark  -上 已读 未读 点击

-(void)TrainClassMenuSelectIndex:(int)index{
    readStatus =index;
    
    [self downLoadNewsData:1];
    newsTableView.currentpage =1;
    [newsTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    

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
