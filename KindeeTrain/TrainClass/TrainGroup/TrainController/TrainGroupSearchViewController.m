//
//  TrainGroupSearchViewController.m
//  SOHUEhr
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainGroupSearchViewController.h"
#import "TrainSearchBar.h"
#import "TrainGroupAndTopicModel.h"
#import "TrainTopicListCell.h"
#import "TrainTopicDetailViewController.h"

@interface TrainGroupSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIButton                *rightBtn;
    NSMutableArray          *searchMuArr;
    NSString                *searchTitle;
}
@property(nonatomic, strong) TrainSearchBar          *topSearch;
@property(nonatomic, strong) TrainBaseTableView      *searchTableView;

@end

@implementation TrainGroupSearchViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.topSearch resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    searchTitle = self.searchText;
    self.topSearch.text= searchTitle;
    self.topSearch.frame = CGRectMake(40, 0, TrainSCREENWIDTH-80, 44);    
    
    if (@available(iOS 11.0, *)) {
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  TrainSCREENWIDTH - 100 , 44)];
        
        self.topSearch.translatesAutoresizingMaskIntoConstraints = NO;
        //    [self.foundSearchBar becomeFirstResponder];
        UITextField *searchField = [self.topSearch valueForKey:@"_searchField"]; // 先取出textfield
        
        //        [searchField setValue:[UIFont customFontOfSize:12.0f] forKey:@"_placeholderLabel.font"];
        [searchField setValue:[UIFont systemFontOfSize:12.0f] forKeyPath:@"_placeholderLabel.font"];
        
        [container addSubview:self.topSearch];
        
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [ container.widthAnchor constraintEqualToConstant: TrainSCREENWIDTH - 100 ],
                                                  [container.heightAnchor constraintEqualToConstant:40]
                                                  
                                                  ]];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.topSearch.topAnchor constraintEqualToAnchor:container.topAnchor constant:5.f], // 顶部约束
                                                  [self.topSearch.leftAnchor constraintEqualToAnchor:container.leftAnchor constant:  5.f ], // 左边距约束
                                                  [self.topSearch.rightAnchor constraintEqualToAnchor:container.rightAnchor constant: - 5.0f], // 右边距约束
                                                  [self.topSearch.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant: - 5.0f], // 底部约束
                                                  
                                                  ]];
        self.topSearch.textfileRadius = 15.0f;
        
        self.navigationItem.titleView = container ;
        
    } else {
        
        
        self.topSearch.frame = CGRectMake(40, 0, TrainSCREENWIDTH - 80, 44);
        self.navigationItem.titleView =  self.topSearch;
        
    }
    

//    [self.navBar creatLeftpopViewtarget:self action:@selector(cancelSearch)];
    
    rightBtn =[[UIButton alloc]initCustomButton];
    rightBtn.frame = CGRectMake(TrainSCREENWIDTH - 40, 0, 30, 44);
    rightBtn.tag =1;
    rightBtn.cusTitleColor =[UIColor  whiteColor];
    rightBtn.cusTitle =@"取消";
    [rightBtn addTarget:self action:@selector(cancelSearch)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self creatSearchResultView];

    [self searchTitleDate:1];

    
    // Do any additional setup after loading the view.
}
//-(void)setSearchText:(NSString *)searchText{
//    searchTitle = searchText;
//    self.topSearch.text = searchText;
////    [self searchTitleDate:1];
//}
# pragma mark - 圈子 搜索
-(void)cancelSearch{
    
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark  search 圈内搜索话题

-(void)searchTopicText:(NSString *)text{
    if ([TrainStringUtil trainIsBlankString:text]) {
        
        [self trainShowHUDOnlyText:TrainSearchNullText];
        
    }else{
        searchTitle = text;
        [self searchTitleDate:1];
        [self.topSearch resignFirstResponder];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchTopicText:searchBar.text];
}

#pragma mark - searchResult data

-(void)searchTitleDate:(int)index{
    
    
    [self trainShowHUDOnlyActivity];
    [self.searchTableView dissTablePlace];
    
    NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(_group_id) forKey:@"group_id"];
    [mudic setObject:@"T" forKey:@"type"];
    [mudic setObject:notEmptyStr(searchTitle) forKey:@"keywords"];
    [mudic setObject:[NSString stringWithFormat:@"%d",index] forKey:@"curPage"];

    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient  client] trainGroupDetailtWithinfoDic:mudic Success:^(NSDictionary *dic) {
        
        if (index == 1 ) {
            searchMuArr =[NSMutableArray new];
        }
        NSArray  *dataArr =[TrainTopicModel mj_objectArrayWithKeyValuesArray:dic[@"topic"]];
        [searchMuArr addObjectsFromArray:dataArr];
        if (!searchMuArr) {
            [weakself creatSearchResultView];
        }
        if (searchMuArr.count>0) {
            TrainTopicModel *groupInfo =[searchMuArr firstObject];
            weakself.searchTableView.totalpages = [groupInfo.totPage intValue];
        }
        
        weakself.searchTableView.trainMode = trainStyleNoData;
        [weakself.searchTableView EndRefresh];
        [weakself trainHideHUD];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        weakself.searchTableView.trainMode = trainStyleNoNet;
        [weakself.searchTableView EndRefresh];
        [weakself trainShowHUDNetWorkError];
        
        
    }];
    
}

#pragma mark - 圈子搜索结果页面

-(void)creatSearchResultView{
    
    self.searchTableView = [[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight) andTableStatus:tableViewRefreshFooter];
    
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    [self.searchTableView registerClass:[TrainTopicListCell class] forCellReuseIdentifier:@"searchtopicCell"];
    [self.view addSubview:self.searchTableView];
   
    TrainWeakSelf(self);
    self.searchTableView.footBlock = ^(int  index){

        [weakself searchTitleDate:index];
    };
    self.searchTableView.refreshBlock =^(){

        [weakself searchTitleDate:1];
    };
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    [self.topSearch resignFirstResponder];
}

#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return searchMuArr.count;
//    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainTopicListCell   *topicCell = [tableView dequeueReusableCellWithIdentifier:@"searchtopicCell"];
    __block TrainTopicModel  *searchModel = searchMuArr[indexPath.row];
    topicCell.model =searchModel;
    
    TrainWeakSelf(self);
    topicCell.topicTouchBlock = ^(NSString *str, TrainTopicModel *model){
        
        [weakself trainShowHUDOnlyText:str];
        searchModel  = model;
        [weakself.searchTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    };
    return topicCell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 150;
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:TrainSCREENWIDTH tableView:tableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TrainTopicModel  *topicModel =[searchMuArr objectAtIndex:indexPath.row];
    
    TrainTopicDetailViewController  * topicVC =[[TrainTopicDetailViewController alloc]init];
    topicVC.model = topicModel;
    topicVC.updateModel = ^(TrainTopicModel *model){
        
        if (model) {
            [searchMuArr replaceObjectAtIndex:indexPath.row withObject:model];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [searchMuArr removeObjectAtIndex:indexPath.row];
            [tableView train_reloadData];
        }
    };
    [self.navigationController pushViewController:topicVC animated:YES];

}


-(TrainSearchBar *)topSearch{
    if (!_topSearch) {
        TrainSearchBar *topSearchBar =[[TrainSearchBar alloc]init];
        topSearchBar.trainSearchBarStyle =TrainSearchBarStyleDefault;
        
        topSearchBar.customPlaceholder =@"搜索:圈内话题";
        topSearchBar.textfileRadius = 15.0f;
        topSearchBar.delegate =self;
        topSearchBar.searchBackgroupColor =[UIColor clearColor];
        _topSearch = topSearchBar;
    }
    return _topSearch;
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
