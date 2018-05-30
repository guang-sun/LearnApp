//
//  TrainDocumentListViewController.m
//   KingnoTrain
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainDocumentListViewController.h"

#import "TrainClassMenuView.h"
#import "TrainDocListModel.h"
#import "TrainSearchViewController.h"
#import "TrainDocListTableViewCell.h"
#import "TrainWebViewController.h"

@interface TrainDocumentListViewController ()<TrainClassMenuDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray                  *btnArr;
    TrainDocumentClass              documentClass;
    TrainBaseTableView              *docListTableView;
    //    NSArray             *chooseFormatArr;
    NSString            *chooseFormatStr;
    NSString            *chooseClassID;
    NSArray             *treeArr;
    NSDictionary        *treeDic;
    
    NSMutableArray      *documentArr;
    
    
}
@property (nonatomic, strong) TrainClassMenuView  *classMenuView;
@property(nonatomic,strong) UIView       *seplineLab;
@property(nonatomic, strong)  NSArray          *chooseFormatArr;
@property(nonatomic, strong)  NSArray          *docClassMenuArr;



@end

@implementation TrainDocumentListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    documentClass =(!self.isMyDoc)?TrainDocumentClassNew:TrainDocumentClassMine;
    
    if (!_isMyDoc) {
        self.navigationItem.leftBarButtonItem = nil ;
        
        chooseFormatStr = @"";
        chooseClassID = @"0";
        UIButton *rightBtn =[[UIButton alloc]initCustomButton];
        rightBtn.image = [UIImage imageNamed:@"Train_Search"];
        rightBtn.frame = CGRectMake(TrainSCREENWIDTH-40, 0, 30, 44);
        
        [rightBtn addTarget:self action:@selector(pushSearch)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        
        
        _classMenuView =[[TrainClassMenuView alloc]initWithFrame:CGRectZero andArr:self.docClassMenuArr];
        _classMenuView.delegate =self;
        [self.view addSubview:_classMenuView];
        self.classMenuView.frame = CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainCLASSHEIGHT);
        [self downLoadClassMenuData];
    }
    NSString   *navTitle =(self.isMyDoc)?@"我的文库":@"文库";
    [self.navigationItem setTitle:navTitle];
    [self creatTableUI];
//    [self downLoadDocData:1];
    
}

-(NSArray *)chooseFormatArr{
    if (!_chooseFormatArr) {
        _chooseFormatArr = [TrainLocalData returnChooseDocClass];
    }
    return _chooseFormatArr;
}
-(NSArray *)docClassMenuArr{
    
    if (! _docClassMenuArr) {
        _docClassMenuArr =[TrainLocalData returnDocClassMenu];
    }
    return _docClassMenuArr;
}

-(void)pushSearch{
    [_classMenuView dismissTopMenu];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TrainSearchViewController *searchVC =[[TrainSearchViewController alloc]init];
        searchVC.selectMode =TrainSearchStyleDoc;
        searchVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchVC animated:YES];
        
    });
    
}

#pragma  mark -文库分类数据

-(void)downLoadClassMenuData{
    
    [[TrainNetWorkAPIClient client] trainDocMenuCategoryWithSuccess:^(NSDictionary *dic) {
        if (dic) {
            treeArr =dic[@"dirlist"];
            treeDic =dic;
            _classMenuView.collectArr=treeArr;
            _classMenuView.tableCollectDic =treeDic;
            _classMenuView.istable =YES;
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        treeArr =[NSArray new];
        treeDic=[NSDictionary new];
        _classMenuView.collectArr=treeArr;
        _classMenuView.tableCollectDic =treeDic;
        _classMenuView.istable =YES;
        
    }];
}


-(void)TrainClassMenuSelectDic:(NSDictionary *)dic{
    if ([dic allKeys].count >1) {
        
        chooseClassID =[dic[@"id"] stringValue];
        documentClass =TrainDocumentClassCategory;
        
    }else {
        chooseFormatStr =dic[@"name"];
        documentClass =TrainDocumentClassFormat;
        
    }
    [self refreshData];
}

-(void)TrainClassMenuSelectIndex:(int)index{
    NSString  *string =self.docClassMenuArr[index];
    if ([string isEqualToString:@"格式"]) {
        _classMenuView.collectArr=self.chooseFormatArr;
        _classMenuView.tableCollectDic =nil;
        _classMenuView.istable =NO;
        _classMenuView.collectSelect =([chooseFormatStr isEqualToString:@"JPG"])?@"IMG":chooseFormatStr;
        ;
        
    }else if ([string isEqualToString:@"分类"]) {
        _classMenuView.collectArr=treeArr;
        _classMenuView.tableCollectDic =treeDic;
        _classMenuView.istable =YES;
        
    }
    if (index ==0) {
        chooseFormatStr = @"全部";
        documentClass =TrainDocumentClassNew;
        [self refreshData];
        
    }else if(index ==1){
        chooseFormatStr = @"全部";
        documentClass =TrainDocumentClassHot;
        [self refreshData];
    }else if(index ==2){
        
        chooseFormatStr = @"全部";
        documentClass =TrainDocumentClassChoose;
        
    }else if(index ==3){
        chooseClassID = @"0";
        documentClass =TrainDocumentClassChoose;
    }
    
    
    
    
    
    
}
-(void)refreshData{
    [self downLoadDocData:1];
    docListTableView.currentpage =1;
    if (documentArr.count> 0) {
        [docListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}


-(void)downLoadDocData:(int)index{
    
    [self trainShowHUDOnlyActivity];
    [docListTableView dissTablePlace];
    
    [[TrainNetWorkAPIClient client]trainDocListWithtype:documentClass format:chooseFormatStr categoryId:chooseClassID curPage:index Success:^(NSDictionary *dic) {
        
        if (index ==1) {
            documentArr =[NSMutableArray array];
        }
        
        NSArray  *arr;
        if (documentClass == TrainDocumentClassMine) {
             arr =(dic[@"knowledgeSharing"])?dic[@"knowledgeSharing"]:[NSArray new];
        }else{
             arr =(dic[@"documents"])?dic[@"documents"]:[NSArray new];

        }
        NSArray  *dataArr =[TrainDocListModel mj_objectArrayWithKeyValuesArray:arr];
        [documentArr addObjectsFromArray:dataArr];
        if (documentArr.count>0) {
            TrainDocListModel *model =[documentArr objectAtIndex:0];
            docListTableView.totalpages =[model.totPage intValue];
        }
        
        docListTableView.trainMode = trainStyleNoData;
        [docListTableView EndRefresh];
        [self trainHideHUD];
        
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        docListTableView.trainMode = trainStyleNoNet;
        
        [docListTableView EndRefresh];
        [self trainHideHUD];
        if (documentArr.count>0) {
            [self trainShowHUDNetWorkError];
        }
    }];
    
}

-(void)creatTableUI{
    CGRect  frameSize =(self.isMyDoc)?CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight):CGRectMake(0, TrainNavorigin_y + TrainCLASSHEIGHT, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight-49-TrainCLASSHEIGHT);
    
    docListTableView =[[TrainBaseTableView alloc]initWithFrame:frameSize andTableStatus:tableViewRefreshAll];
    //       customV.frame =frameSize;
    [self.view addSubview:docListTableView];
    docListTableView.delegate =self;
    docListTableView.dataSource =self;
    docListTableView.rowHeight =70.0f;
//    docListTableView.estimatedRowHeight = 70.0f;
//    docListTableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值，可以省略
    [docListTableView registerClass:[TrainDocListTableViewCell class] forCellReuseIdentifier:@"docCell"];
    __weak  __typeof(self)weakSelf =self;
    docListTableView.headBlock =^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf downLoadDocData:1];
        
    };
    docListTableView.footBlock=^(int  index){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf downLoadDocData:index];
    };
    docListTableView.refreshBlock =^(){
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf downLoadDocData:1];
        
    };
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return documentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainDocListTableViewCell  *docCell = [tableView dequeueReusableCellWithIdentifier:@"docCell"];
    docCell.model =documentArr[indexPath.row];
    docCell.trainDocCollectStatus = ^(NSString *msg){
        
        [self trainShowHUDOnlyText:msg];
        
    };
    return docCell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TrainDocListModel  *model = documentArr[indexPath.row];
    
    NSString  *webURL = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"viewdoc" object_id:model.en_id andtarget_id:nil];
    TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
    webVC.webURL    =webURL;
    webVC.navTitle  = model.name;
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
