//
//  TrainMessageListViewController.m
//   KingnoTrain
//
//  Created by apple on 17/1/4.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import "TrainMessageListViewController.h"
#import "TrainMessageListCell.h"
#import "TrainMessageModel.h"
#import "TrainWebViewController.h"

@interface TrainMessageListViewController ()<TrainClassMenuDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray              *messageMuarr;
    TrainClassMenuView          *menuView;
    NSArray                     *treeArr;
    NSString                    *orderField;
    NSString                    *promoted;
    NSString                    *categoryId;
}
@property(nonatomic, strong) TrainBaseTableView          *messageTableView;

@end

@implementation TrainMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"资讯";
//    [self.navBar removeLeftBtnItem];
    orderField = @"";
    promoted = @"" ;
    categoryId = @"0";
    
    
    
    NSArray  *arr =@[@"全部",@"热门",@"推荐",@"分类"];
    menuView =[[TrainClassMenuView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainCLASSHEIGHT) andArr:arr];
    menuView.delegate =self;
    [self.view addSubview:menuView];

    
    [self downloadTopMenuClass];
    [self creatMessageTableview];
    

    // Do any additional setup after loading the view.
}

-(void)TrainClassMenuSelectDic:(NSDictionary *)dic{
    orderField = @"";
    promoted = @"" ;
    categoryId = dic[@"id"];
    [self refreshData];
    
}
-(void)TrainClassMenuSelectIndex:(int)index{
    switch (index) {
        case 0:{
            orderField = @"";
            promoted = @"" ;
            categoryId = @"0";
        }
            break;
        case 1:{
            orderField = @"H";
            promoted = @"" ;
            categoryId = @"0";
        }
            break;
        case 2:{
            orderField = @"";
            promoted = @"Y" ;
            categoryId = @"0";
        }
            break;
        case 3:{
            
            if (!treeArr || treeArr.count == 0) {
                [self downloadTopMenuClass];
            }
        }
            
        default:
            break;
    }
    if (index != 3) {
        [self refreshData];
        
    }

}


-(void)refreshData{
    [self downLoadNewsData:1];
    self.messageTableView.isNull =YES;
    self.messageTableView.currentpage =1;
    [self.messageTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    
}
-(void)downloadTopMenuClass{
    
    [[TrainNetWorkAPIClient client]trainGetMessageMenuCategoryWithSuccess:^(NSDictionary *dic) {
        NSLog(@"couse menu ==%@ ",dic);
        treeArr =dic[@"dynamicCategoryList"];
        NSDictionary *  treeDic =dic;
        menuView.collectArr=treeArr;
        menuView.tableCollectDic =treeDic;
        menuView.istable =YES;
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        NSLog(@"%ld--- %@",(long)errorCode, errorMsg);
        NSArray *arr =[NSArray new];
        NSDictionary *dic=[NSDictionary new];
        menuView.collectArr=arr;
        menuView.tableCollectDic =dic;
        menuView.istable =YES;
    }];
    
    
    
}

-(void)creatMessageTableview{
    self.messageTableView =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0,TrainCLASSHEIGHT+TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT - TrainNavHeight -TrainCLASSHEIGHT -49) andTableStatus:tableViewRefreshAll];
    [self.view addSubview:self.messageTableView];
    //    customTableV =customView.customTableV;
    self.messageTableView.delegate =self;
    self.messageTableView.dataSource =self;
    
    [self.messageTableView registerClass:[TrainMessageListCell class] forCellReuseIdentifier:@"cell"];

    TrainWeakSelf(self);
    
    self.messageTableView.headBlock =^(){

        [weakself downLoadNewsData:1];
    };
    self.messageTableView.footBlock=^(int  aa){

        [weakself downLoadNewsData:aa];
    };
    self.messageTableView.refreshBlock =^(){

        [weakself downLoadNewsData:1];
        
    };
    
}

#pragma  mark - download数据
-(void)downLoadNewsData:(int )index{
   
    [self trainShowHUDOnlyActivity];
    [self.messageTableView dissTablePlace];
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainGetMessagelistWithOrderField:orderField category_id:categoryId promoted:promoted curPage:index Success:^(NSDictionary *dic) {
        
        if (index == 1) {
            messageMuarr =[NSMutableArray new];
        }
        NSArray  *dataArr = [TrainMessageModel  mj_objectArrayWithKeyValuesArray:dic[@"dynamicList"]];
        [messageMuarr addObjectsFromArray:dataArr];
        
        if (messageMuarr.count>0) {
            TrainMessageModel *model =[messageMuarr objectAtIndex:0];
            weakself.messageTableView.totalpages =[model.totPage intValue];
        }
        weakself.messageTableView.trainMode = trainStyleNoData;
        [weakself.messageTableView EndRefresh];
        [weakself trainHideHUD];

    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        NSLog(@"%@",errorMsg);
        
        weakself.messageTableView.trainMode = trainStyleNoNet;

        [weakself.messageTableView EndRefresh];
        [weakself trainShowHUDNetWorkError];
    }];
    
}
#pragma  mark  - tableview的代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messageMuarr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainMessageListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model =messageMuarr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.messageTableView cellHeightForIndexPath:indexPath model:messageMuarr[indexPath.row] keyPath:@"model" cellClass:[TrainMessageListCell class] contentViewWidth:TrainSCREENWIDTH];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TrainMessageModel  *model = messageMuarr[indexPath.row];
    NSString *urlStr = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"dyndtls" object_id:model.message_id andtarget_id:@"0"];

    TrainWebViewController   *webVC =[[TrainWebViewController alloc]init];
    webVC.webURL    = urlStr;
    webVC.navTitle  = model.title;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
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
