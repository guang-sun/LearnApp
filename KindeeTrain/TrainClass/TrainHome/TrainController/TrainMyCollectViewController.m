//
//  TrainMyCollectViewController.m
//  SOHUEhr
//
//  Created by apple on 16/11/3.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainMyCollectViewController.h"
#import "TrainClassMenuView.h"
#import "TrainGroupAndTopicModel.h"
#import "TrainDocListModel.h"
#import "TrainDocListTableViewCell.h"
#import "TrainTopicListCell.h"
#import "TrainTopicDetailViewController.h"
#import "TrainWebViewController.h"

@interface TrainMyCollectViewController ()<TrainClassMenuDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray                  *myCollectTopicMuArr;
    NSMutableArray                  *myCollectDocMuArr;
    NSString                        *collectType;

}

@property(nonatomic, strong) TrainClassMenuView              *classMenuView;
@property(nonatomic, strong) TrainBaseTableView              *myCollectTableView;



@end


@implementation TrainMyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    collectType = @"T";
    self.navigationItem.title = @"我的收藏" ;
    
    _classMenuView =[[TrainClassMenuView alloc]initWithFrame:CGRectZero andArr:@[@"话题",@"文档"]];
    _classMenuView.delegate =self;
    _classMenuView.frame = CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainCLASSHEIGHT);
    [self.view addSubview:_classMenuView];
    

    
    [self downLoadGroupAndTopicData:1];
    [self creatTableUI];
    // Do any additional setup after loading the view.
}

#pragma mark - topMenu 点击事件
-(void)TrainClassMenuSelectIndex:(int)index{
    
    switch (index) {
        case 0:
            collectType =@"T";
            break;
        case 1:
            collectType =@"D";
            break;
        default:
            break;
    }
    
    [self refreshData];
}
-(void)refreshData{
    self.myCollectTableView.currentpage = 1;
    
    [self.myCollectTableView scrollRectToVisible:CGRectZero animated:NO];

    if ([collectType isEqualToString:@"T"]) {
        
        if (TrainArrayIsEmpty(myCollectTopicMuArr)) {
           
            [self downLoadGroupAndTopicData:1];

        }else{
            [self.myCollectTableView train_reloadData];
        }
        
    }else if ([collectType isEqualToString:@"D"]){
       
        if (TrainArrayIsEmpty(myCollectDocMuArr)) {
           
            [self downLoadGroupAndTopicData:1];

        }else{
            [self.myCollectTableView train_reloadData];
        }
    }
    

}

#pragma  mark - 圈子, 话题 列表下载数据
-(void)downLoadGroupAndTopicData:(int )index{
    
    [self trainShowHUDOnlyActivity];
    [self.myCollectTableView dissTablePlace];
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainCollectWithType:collectType curPage:index Success:^(NSDictionary *dic) {
       
        NSArray   *dataArr;
        if ([collectType isEqualToString:@"T"]) {
            if (index == 1) {
                myCollectTopicMuArr = [NSMutableArray array];
            }
            dataArr = [TrainTopicModel mj_objectArrayWithKeyValuesArray:dic[@"topic"]];
            [myCollectTopicMuArr addObjectsFromArray:dataArr];

            if (myCollectTopicMuArr.count>0) {
                
                TrainTopicModel *model =[myCollectTopicMuArr firstObject];
                weakself.myCollectTableView.totalpages =[model.totPage intValue];
            }

            
        }else if([collectType isEqualToString:@"D"]){
            
            if (index == 1) {
                myCollectDocMuArr = [NSMutableArray array];
            }
            dataArr = [TrainDocListModel mj_objectArrayWithKeyValuesArray:dic[@"doc"]];
            [myCollectDocMuArr addObjectsFromArray:dataArr];
            
            if (myCollectDocMuArr.count>0) {
                
                TrainDocListModel *model =[myCollectDocMuArr firstObject];
               weakself.myCollectTableView.totalpages =[model.totPage intValue];
            }
            

        }
        
        weakself.myCollectTableView.trainMode = trainStyleNoData;
        [weakself.myCollectTableView EndRefresh];
        [weakself trainHideHUD];

    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        weakself.myCollectTableView.trainMode = trainStyleNoNet;
        [weakself.myCollectTableView EndRefresh];
        [weakself trainShowHUDNetWorkError];
    }];
 
}

-(void)creatTableUI{
    
    self.myCollectTableView =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y + TrainCLASSHEIGHT, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight-TrainCLASSHEIGHT) andTableStatus:tableViewRefreshAll];
    [self.view addSubview:self.myCollectTableView];
    self.myCollectTableView.delegate =self;
    self.myCollectTableView.dataSource =self;
    [self.myCollectTableView registerClass:[TrainTopicListCell class] forCellReuseIdentifier:@"cellTopic"];
    [self.myCollectTableView registerClass:[TrainDocListTableViewCell class] forCellReuseIdentifier:@"cellDoc"];

    TrainWeakSelf(self);
    self.myCollectTableView.headBlock =^(){
        [weakself downLoadGroupAndTopicData:1];
    };
   self. myCollectTableView.footBlock=^(int  index){

        [weakself downLoadGroupAndTopicData:index];
        
    };
    self.myCollectTableView.refreshBlock =^(){

        [weakself downLoadGroupAndTopicData:1];
        
    };
}
#pragma mark - tableview  代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([collectType isEqualToString:@"T"]) {
        
        return (TrainArrayIsEmpty(myCollectTopicMuArr))?0:myCollectTopicMuArr.count;
        
    }else   if ([collectType isEqualToString:@"D"]) {
    
        return (TrainArrayIsEmpty(myCollectDocMuArr))?0:myCollectDocMuArr.count;
    }
    return 0;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainWeakSelf(self);

    
    if ([collectType isEqualToString:@"T"]) {
        TrainTopicListCell  *topicCell =[tableView dequeueReusableCellWithIdentifier:@"cellTopic"];
        //    topicCell.isImageTap =NO;
        __block TrainTopicModel *listModel = myCollectTopicMuArr[indexPath.row];
        topicCell.model = listModel;
        
        
        topicCell.topicTouchBlock = ^( NSString *str , TrainTopicModel *topModel){
            
            [weakself trainShowHUDOnlyText:str];
            listModel  = topModel;
            [weakself.myCollectTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        return topicCell;
    }
    
    TrainDocListTableViewCell  *docCell =[tableView dequeueReusableCellWithIdentifier:@"cellDoc"];
    //    topicCell.isImageTap =NO;
    TrainDocListModel *listModel = myCollectDocMuArr[indexPath.row];
    docCell.model = listModel;
    docCell.trainDocCollectStatus = ^( NSString *str ){
        
        [weakself trainShowHUDOnlyText:str];
    };
    
    return docCell;
   
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectType isEqualToString:@"T"]) {
        return [self.myCollectTableView cellHeightForIndexPath:indexPath model:myCollectTopicMuArr[indexPath.row] keyPath:@"model" cellClass:[TrainTopicListCell class] contentViewWidth:TrainSCREENWIDTH];
    }
    
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TrainWeakSelf(self);
    if ([collectType isEqualToString:@"T"]) {
        
        TrainTopicModel  *topicModel =[myCollectTopicMuArr objectAtIndex:indexPath.row];
        
        TrainTopicDetailViewController  * topicVC =[[TrainTopicDetailViewController alloc]init];
        topicVC.model = topicModel;
        topicVC.updateModel = ^(TrainTopicModel *model){
            
            if (model) {
                [myCollectDocMuArr replaceObjectAtIndex:indexPath.row withObject:model];
                [weakself. myCollectTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [myCollectDocMuArr removeObjectAtIndex:indexPath.row];
                [weakself. myCollectTableView train_reloadData];
            }
        };
        [self.navigationController pushViewController:topicVC animated:YES];

    }else if([collectType isEqualToString:@"D"]){
        
        TrainDocListModel  *model = myCollectDocMuArr[indexPath.row];
        
        NSString  *webURL = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"viewdoc" object_id:model.en_id andtarget_id:nil];
        TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
        webVC.webURL =webURL;
        webVC.navTitle = model.name;
        [self.navigationController pushViewController:webVC animated:YES];
        
        
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
