//
//  TrainSearchViewController.m
//  SOHUEhr
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainSearchViewController.h"
#import "TrainSearchResultViewController.h"
#import "TrainCustomCollectionView.h"
#import "TrainSearchBar.h"


@interface TrainSearchViewController ()<UISearchBarDelegate,TrainCustomCollectionViewDataSource,TrainCustomCollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
{
    NSArray                     *tagList;
    TrainSearchBar              *customSearch;
    UITableView                 *searchHistoryTableV;
  //  NSArray                     *hotSearchArr;
    TrainCustomCollectionView   *searchTagCollection;
    
    
}
@property(nonatomic,strong)    NSMutableArray           *searchHistoryArr;


@end

@implementation TrainSearchViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (customSearch) {
        [customSearch becomeFirstResponder];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self creatNavSearch];
    [self downLoadHotTag];
    [self creatHistoryAndTagView];
    
    // Do any additional setup after loading the view.
}

-(void)creatNavSearch{

    customSearch = [[TrainSearchBar alloc]initWithFrame:CGRectMake(10, 0, TrainSCREENWIDTH - 70, 44)];
    customSearch.trainSearchBarStyle =TrainSearchBarStyleDefault;
    
    customSearch.customPlaceholder = TrainSearchTitleText;
    customSearch.textfileRadius = 15.0f;
    customSearch.delegate =self;
    customSearch.searchBackgroupColor =[UIColor clearColor];
    
    
    if (@available(iOS 11.0, *)) {
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  TrainSCREENWIDTH - 70 , 44)];
        
        customSearch.translatesAutoresizingMaskIntoConstraints = NO;
        //    [self.foundSearchBar becomeFirstResponder];
        UITextField *searchField = [customSearch valueForKey:@"_searchField"]; // 先取出textfield
        
        //        [searchField setValue:[UIFont customFontOfSize:12.0f] forKey:@"_placeholderLabel.font"];
        [searchField setValue:[UIFont systemFontOfSize:12.0f] forKeyPath:@"_placeholderLabel.font"];
        
        [container addSubview:customSearch];
        
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [ container.widthAnchor constraintEqualToConstant: TrainSCREENWIDTH - 70 ],
                                                  [container.heightAnchor constraintEqualToConstant:40]
                                                  
                                                  ]];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [customSearch.topAnchor constraintEqualToAnchor:container.topAnchor constant:5.f], // 顶部约束
                                                  [customSearch.leftAnchor constraintEqualToAnchor:container.leftAnchor constant:  0.f ], // 左边距约束
                                                  [customSearch.rightAnchor constraintEqualToAnchor:container.rightAnchor constant: - 5.0f], // 右边距约束
                                                  [customSearch.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant: - 5.0f], // 底部约束
                                                  
                                                  ]];
        customSearch.textfileRadius = 15.0f;
        
        self.navigationItem.titleView = container ;
        
    } else {
        
        self.navigationItem.titleView =  customSearch;
        
    }
    
    
    
    
    UIButton *cancaleBtn =[[UIButton alloc]initCustomButton];
    cancaleBtn.frame =CGRectMake(TrainSCREENWIDTH -40, 0, 30, 44);
    cancaleBtn.titleLabel.font  = [UIFont systemFontOfSize:14.0f];
    cancaleBtn.cusTitleColor =[UIColor whiteColor];
    [cancaleBtn addTarget:self action:@selector(rightCancel) forControlEvents:UIControlEventTouchUpInside];
    cancaleBtn.cusTitle =@"取消";
    
    self.navigationItem.leftBarButtonItem = nil ;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancaleBtn];


}
-(void)rightCancel{
    [customSearch resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)downLoadHotTag{
    
    
    [[TrainNetWorkAPIClient client]trainSearchHotTagSuccess:^(NSDictionary *dic) {
        tagList =dic[@"tags"];
        [searchTagCollection reloadData];
    }];
}

-(NSMutableArray *)searchHistoryArr{
    
    if (!_searchHistoryArr) {
        NSDictionary  *dic =[TrainUserDefault objectForKey:TrainSearchHistory];
        NSArray *arr = dic[TrainUser.emp_id];
        _searchHistoryArr =[NSMutableArray arrayWithArray:arr];
    }
    return _searchHistoryArr;
    
}
-(void)saveSearchHistory:(NSArray  *)arr{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary  *dic =[TrainUserDefault objectForKey:TrainSearchHistory];
        NSMutableDictionary  *mudic =[NSMutableDictionary dictionaryWithDictionary:dic];
        [mudic setObject:arr forKey:TrainUser.emp_id];
        NSDictionary * saveDic =[NSDictionary dictionaryWithDictionary:mudic];
        [TrainUserDefault setObject:saveDic forKey:TrainSearchHistory];
        [TrainUserDefault synchronize];

    });
    
}


-(void)creatHistoryAndTagView{
    
    
    searchHistoryTableV =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    searchHistoryTableV.delegate =self;
    searchHistoryTableV.dataSource =self;
    searchHistoryTableV.bounces =NO;
    searchHistoryTableV.rowHeight =30;
    searchHistoryTableV.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    [searchHistoryTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"trainSearchCell"];
    [self.view addSubview:searchHistoryTableV];
    
    float historyHei = [self jisuanSearchHeight];
    
    searchHistoryTableV.sd_layout
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .topSpaceToView(self.view,TrainNavorigin_y + 15)
    .heightIs(historyHei);
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing=15;
    
    searchTagCollection =[[TrainCustomCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout andistap:NO];
    searchTagCollection.delegate =self;
    searchTagCollection.dataSource =self;
    [searchTagCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"tagCell"];
    [searchTagCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"COLLECTHEADER"];
    [self.view addSubview:searchTagCollection];
    
    searchTagCollection.sd_layout
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .topSpaceToView(searchHistoryTableV,10)
    .bottomEqualToView(self.view);

}

-(float)jisuanSearchHeight{
    float historyHei = 0.0f;
    
    if (!TrainArrayIsEmpty(self.searchHistoryArr)) {
        
        if (self.searchHistoryArr.count >= 5) {
            historyHei = 30*7+10;
        }else {
            historyHei = 30*(self.searchHistoryArr.count+2)+10;
        }
    }
    return historyHei;
}

#pragma mark - search代理


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    if (!TrainArrayIsEmpty(self.searchHistoryArr)) {
        if (![self.searchHistoryArr containsObject:searchBar.text]) {
          
            if (self.searchHistoryArr.count >=5) {
                [self.searchHistoryArr removeLastObject];
            }
            [self.searchHistoryArr insertObject:searchBar.text atIndex:0];
            NSArray *saveArr =[NSArray arrayWithArray:self.searchHistoryArr];
            [self saveSearchHistory:saveArr];
        }
    }else{
        
        [self.searchHistoryArr addObject:searchBar.text];
        [self saveSearchHistory:self.searchHistoryArr];
    }
    [UIView animateWithDuration:0.3 animations:^{
        float historyHei = [self jisuanSearchHeight];
        
        searchHistoryTableV.sd_layout.heightIs(historyHei);
        [searchHistoryTableV updateLayout];
    }];
    [searchHistoryTableV reloadData];
    [self pushSearchResult:searchBar.text istags:NO];
}
-(void)pushSearchResult:(NSString *)result istags:(BOOL)tags{
    
    [customSearch resignFirstResponder];
    
    TrainSearchResultViewController *seacherResuleVC =[[TrainSearchResultViewController alloc]init];
    seacherResuleVC.searchTitle = result;
    seacherResuleVC.selectMode = _selectMode;
    seacherResuleVC.isTag = tags;
    [self.navigationController pushViewController:seacherResuleVC animated:NO];
    
}
#pragma mark - tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.searchHistoryArr.count >=5)?5:self.searchHistoryArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"trainSearchCell"];
    cell.textLabel.text =self.searchHistoryArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lable =[[UILabel alloc]initCustomLabel];
    lable.frame =CGRectMake(0, 0, TrainSCREENWIDTH, 30);
    //    lable.backgroundColor =[UIColor groupTableViewBackgroundColor];
    lable.text =@"搜索历史:";
    return lable;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH-30, 40)];
    UIButton  *button =[[UIButton alloc]initCustomButton];
    button.frame =CGRectMake((TrainSCREENWIDTH-100-30)/2, 5,100 , 30);
    button.cusTitle =@"清空搜索历史";
    button.cusTitleColor =[UIColor redColor];
    button.backgroundColor =[UIColor whiteColor];
    button.layer.borderWidth =1.0f;
    button.layer.borderColor =[UIColor lightGrayColor].CGColor;
    button.layer.cornerRadius =8.0f;
    button.layer.masksToBounds =YES;
    [button addTarget:self action:@selector(cleanSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self pushSearchResult:self.searchHistoryArr[indexPath.row] istags:NO] ;
}
-(void)cleanSearchHistory{
    NSDictionary  *dic =[TrainUserDefault objectForKey:TrainSearchHistory];
    NSMutableDictionary *mudic =[NSMutableDictionary dictionaryWithDictionary:dic];
    [mudic removeObjectForKey:TrainUser.emp_id];
    dic =[NSDictionary dictionaryWithDictionary:mudic];
    [TrainUserDefault setObject:dic forKey:TrainSearchHistory];
    [TrainUserDefault synchronize];
    
    self.searchHistoryArr =[NSMutableArray array];
    [UIView animateWithDuration:0.3 animations:^{
        searchHistoryTableV.sd_layout.heightIs(0);
        [searchHistoryTableV updateLayout];
    }];
    [searchHistoryTableV reloadData];
}

#pragma mark - collection代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return tagList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell  *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"tagCell" forIndexPath:indexPath];
    
    UILabel *lable =[[UILabel alloc]initCustomLabel];
    NSDictionary  *dic =tagList[indexPath.row];
    lable.text =dic[@"name"];
    lable.textAlignment =NSTextAlignmentCenter;
    lable.cusFont =14.f;
    lable.textColor =TrainColorFromRGB16(0xA4A4A4);
    [cell.contentView addSubview:lable];
    lable.layer.borderWidth =1.0f;
    lable.layer.borderColor =TrainColorFromRGB16(0xA4A4A4).CGColor;
    lable.layer.cornerRadius =8.0;
    lable.layer.masksToBounds =YES;
    lable.backgroundColor =[UIColor whiteColor];
    lable.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString  *str =tagList[indexPath.row][@"name"];
    CGSize cellsize = [str boundingRectWithSize:CGSizeMake(TrainSCREENWIDTH-30, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}  context:nil].size;
    cellsize.width  +=40;
    cellsize.height +=15;
    return cellsize;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self pushSearchResult:tagList[indexPath.row][@"name"] istags:YES];
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(TrainSCREENWIDTH-30, 30);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind ==UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"COLLECTHEADER" forIndexPath:indexPath];
        
        UILabel  *lable =[[UILabel  alloc]initCustomLabel];
        lable.frame =CGRectMake(0, 0, TrainSCREENWIDTH-30, 30);
        lable.text =@"标签:";
        [header addSubview:lable];
        return header;
    }
    return nil;
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
