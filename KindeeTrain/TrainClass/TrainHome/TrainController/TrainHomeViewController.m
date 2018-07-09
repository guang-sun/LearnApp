//
//  TrainHomeViewController.m
//   KingnoTrain
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainHomeViewController.h"
#import "TrainSearchBar.h"
#import "TrainCustomCollectionView.h"
#import "TrainScrollImageView.h"
#import "TrainWebViewController.h"
#import "TrainHomeCollectionViewCell.h"
#import "TrainSearchViewController.h"
#import "TrainSetUPViewController.h"
#import "TrainScanViewController.h"
#import "TrainCourseClassViewController.h"
#import "TrainDocumentListViewController.h"
#import "TrainExamListViewController.h"
#import "TrainQuestionViewController.h"
#import "TrainMyTopicListViewController.h"
#import "TrainMyGroupListViewController.h"
#import "TrainMyNoteViewController.h"
#import "TrainMyCollectViewController.h"
#import "TrainMyIntegralViewController.h"
#import "TrainNewsListViewController.h"
#import "TrainCacheListViewController.h"
#import "TrainDownloadManager.h"
#import "TrainCourseDetailModel.h"
#import "TrainLocalLearnRecord.h"
#import <SDCycleScrollView.h>
#import "TrainNewClassListViewController.h"

#define IMAGESCROLLHEIGHT   TrainSCREENWIDTH * 1.0 / 2.0
#define IMAGESCROLLTIME     5.0f

@interface TrainHomeViewController ()<TrainCustomCollectionViewDataSource,TrainCustomCollectionViewDelegate,UISearchBarDelegate,SDCycleScrollViewDelegate>
{
    NSArray                     *imageArr;
    NSArray                     *collectArr;
    NSString                    *saveVersion;
    NSInteger                   unRead;
  
}
//@property (nonatomic,strong)  TrainScrollImageView      *imagescroll;
@property (nonatomic,strong)  TrainCustomCollectionView *homeCollectionView;
@property (nonatomic,strong)  TrainSearchBar            *topSearchBar;
@property (nonatomic,strong)  UIButton                  *newsButton;
@property (nonatomic,strong)  SDCycleScrollView         *homeTopimageView;
@end

@implementation TrainHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    //    [self scrollheight:scroll_y];
    [self trainWillAppearDownloadData];
    [self.homeTopimageView adjustWhenControllerViewWillAppera];
    [self rzUploadLearnRecord];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"---%@",NSHomeDirectory());
    
    imageArr = [NSArray array];
    
    if (@available(iOS 11.0, *)) {
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  TrainSCREENWIDTH - 100 , 44)];
        
        self.topSearchBar.translatesAutoresizingMaskIntoConstraints = NO;
        //    [self.foundSearchBar becomeFirstResponder];
        UITextField *searchField = [self.topSearchBar valueForKey:@"_searchField"]; // 先取出textfield
        
        //        [searchField setValue:[UIFont customFontOfSize:12.0f] forKey:@"_placeholderLabel.font"];
        [searchField setValue:[UIFont systemFontOfSize:12.0f] forKeyPath:@"_placeholderLabel.font"];
        
        [container addSubview:self.topSearchBar];
        
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [ container.widthAnchor constraintEqualToConstant: TrainSCREENWIDTH - 100 ],
                                                  [container.heightAnchor constraintEqualToConstant:40]
                                                  
                                                  ]];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.topSearchBar.topAnchor constraintEqualToAnchor:container.topAnchor constant:5.f], // 顶部约束
                                                  [self.topSearchBar.leftAnchor constraintEqualToAnchor:container.leftAnchor constant:  5.f ], // 左边距约束
                                                  [self.topSearchBar.rightAnchor constraintEqualToAnchor:container.rightAnchor constant: - 5.0f], // 右边距约束
                                                  [self.topSearchBar.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant: - 5.0f], // 底部约束
                                                  
                                                  ]];
        self.topSearchBar.textfileRadius = 15.0f;

        self.navigationItem.titleView = container ;
        
    } else {
        
        self.topSearchBar.frame = CGRectMake(40, 0, TrainSCREENWIDTH - 80, 44);
        self.navigationItem.titleView =  self.topSearchBar;
        
    }
    
    UIButton *setupBtn  = [[UIButton alloc]initCustomButton];
    setupBtn.image = [UIImage imageNamed:@"Train_Main_setUP"];
    [setupBtn setImage:[UIImage imageNamed:@"Train_Main_setUP"] forState:UIControlStateHighlighted];

    [setupBtn addTarget:self action:@selector(popSetUPVC)];
    setupBtn.frame = CGRectMake(5, 0, 30, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setupBtn];
    
    
    UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake(TrainSCREENWIDTH-40, 0, 30, 44)];
    button.imageEdgeInsets =UIEdgeInsetsMake(-5, 7, 0, -7);
    [button setImage:[UIImage imageNamed:@"Train_Main_ReadNews"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Train_Main_UnReadNews"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(pushNews) forControlEvents:UIControlEventTouchUpInside];
    self.newsButton = button ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [self trainGetLocalCollectArr];

    [self creatCollectionView];
    [self trainDownloadData];

    // Do any additional setup after loading the view.
}

- (void)trainGetLocalCollectArr{
    
    NSData *data = [TrainUserDefault objectForKey:TrainCollectionVersion];
    NSDictionary *dic =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (dic[TrainUser.user_id]) {
        NSDictionary *saveDic = dic[TrainUser.user_id];
        
         collectArr = [TrainHomeModel mj_objectArrayWithKeyValuesArray: saveDic[@"Collect"]];
    }else {
        
        collectArr = [NSMutableArray array];
    }
}
- (void)rzUploadLearnRecord{
    
    Reachability  * reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    NetworkStatus networkStatus1 = [reach currentReachabilityStatus];
    
    if (networkStatus1 ==NotReachable) {
        
    }else if (networkStatus1 ==ReachableViaWiFi || networkStatus1 ==ReachableViaWWAN){
        
        [self updataLearnStatus];
    }
    
    
}
-(void)updataLearnStatus{
    
    NSArray  *arr = [TrainLocalLearnRecord findAll];
    
    if(arr.count > 0){
        
        NSMutableArray  *muArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainLocalLearnRecord *record = obj;
            
            NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
            [mudic setObject:record.c_id forKey:@"c_id"];
            [mudic setObject:record.cw_id forKey:@"cw_id"];
            [mudic setObject:record.lh_id forKey:@"lh_id"];
            [mudic setObject:record.object_id forKey:@"object_id"];
            [mudic setObject:record.s_status forKey:@"s_status"];
            [mudic setObject:record.user_id forKey:@"user_id"];
            [mudic setObject:[NSString stringWithFormat:@"%ld",(long)record.go_num] forKey:@"go_num"];
            [mudic setObject:[NSString stringWithFormat:@"%ld",(long)record.last_time] forKey:@"last_time"];
            [mudic setObject:[NSString stringWithFormat:@"%ld",(long)record.time] forKey:@"time"];
            [muArr addObject:mudic];
            
        }];
        
        NSData *data = [muArr mj_JSONData];
        NSString  *string = [muArr mj_JSONString];
        //          NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:nil];
        [[TrainNetWorkAPIClient client] trainUpdateLocalRecordWithcontent:string Success:^(NSDictionary *dic) {
            NSLog(@"离线记录==%@",dic);
            if ([dic[@"status"] boolValue]) {
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TrainLocalLearnRecord *record = obj ;
                    [record deleteObjectsByColumnName:@[@"c_id",@"lh_id"]];
                }];
                
                
            }
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            
        }];
    }
    
}


-(void)pushNews{
    
    TrainNewsListViewController *newsVC =[[TrainNewsListViewController alloc]init];
    newsVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:newsVC animated:YES];
}

-(void)popSetUPVC{

    TrainSetUPViewController  *leftVC =[[TrainSetUPViewController alloc]init];
    leftVC.hidesBottomBarWhenPushed =YES;
    
    [self.navigationController pushViewController:leftVC animated:YES];

}



-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    TrainSearchViewController *searchVC =[[TrainSearchViewController alloc]init];
    searchVC.selectMode = TrainSearchStyleCourse;
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
    return NO;
}


-(void)trainWillAppearDownloadData{
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainHomeDataWithSuccess:^(NSDictionary *dic) {
        if (dic) {
            
            unRead = [dic[@"UnReadmessageCount"] integerValue];
            weakself.newsButton.selected = (unRead > 0) ? YES : NO ;// (unRead > 0);
            
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
}
-(void)trainDownloadData{
    
    [self trainShowHUDOnlyActivity];
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainHomeDataWithSuccess:^(NSDictionary *dic) {
        if (dic) {
            
            saveVersion =[dic[@"fn_version"] stringValue];
            imageArr = dic[@"NewsPic"];
            unRead = [dic[@"UnReadmessageCount"] integerValue];

            weakself.newsButton.selected = (unRead > 0) ? YES : NO ;// (unRead > 0);
            [weakself saveCollection:saveVersion];
            [weakself.homeCollectionView reloadData];
            
        }
        [self.homeCollectionView.mj_header endRefreshing];
        [self trainHideHUD];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
   
        [self.homeCollectionView.mj_header endRefreshing];
        [self trainShowHUDNetWorkError];
        
    }];
}

-(void)creatCollectionView{
    
    [self.view addSubview:self.homeCollectionView];
    
    self.homeCollectionView.mj_header  =[MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self trainDownloadData];
        
    }];

}

#pragma mark - 首页九宫格 通过后台设置
#pragma mark 判断九宫格版本是否已缓存
-(void)saveCollection:(NSString *)version{
    
    NSData *data = [TrainUserDefault objectForKey:TrainCollectionVersion];
    NSDictionary *dic =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (dic[TrainUser.user_id]) {
        NSDictionary *saveDic = dic[TrainUser.user_id];
        
        if (![version isEqualToString:saveDic[@"version"]]) {
            
            [self downLoadCollection:version];
        
        }else{
            
            collectArr = [TrainHomeModel mj_objectArrayWithKeyValuesArray: saveDic[@"Collect"]];
            if(collectArr.count ==0){
                [self downLoadCollection:version];
            }else{
                [self.homeCollectionView reloadData];
            }
        }
    }else{
        [self downLoadCollection:version];
    }
    
}

-(void)downLoadCollection:(NSString *)version{
    
    [[TrainNetWorkAPIClient client] trainHomeCollectionWithSuccess:^(NSDictionary *dic) {
        if (dic) {
            NSLog(@"mainCollect ===%@",dic);
            if (dic[@"function"]) {
                
                NSArray  *arr = dic[@"function"];
                
                if (!arr || arr.count == 0) {

                    arr = [TrainLocalData returnMainArr];
                
                }else {
                    
                    [self saveCollectArrWith:arr];

                }
                collectArr =[TrainHomeModel mj_objectArrayWithKeyValuesArray:arr];

            }
            [self.homeCollectionView reloadData];
        }
        
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        [self.homeCollectionView reloadData];
        
    }];
}


- (void)saveCollectArrWith:(NSArray *)arr{
    
    NSDictionary  *dic=@{@"version":saveVersion,
                         @"Collect":arr};
    NSData *data = [TrainUserDefault objectForKey:TrainCollectionVersion];
    NSDictionary *dict =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableDictionary  *muSaveDic =[NSMutableDictionary dictionaryWithDictionary:dict];
    [muSaveDic setObject:dic forKey: TrainUser.user_id];
    NSDictionary  *saveDic =[NSDictionary dictionaryWithDictionary:muSaveDic];
    NSData *savedata =[NSKeyedArchiver archivedDataWithRootObject:saveDic];
    [TrainUserDefault setObject:savedata forKey:TrainCollectionVersion];
    [TrainUserDefault synchronize];
    
}



#pragma mark ---- getter

-(TrainCustomCollectionView *)homeCollectionView{
    if (!_homeCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(TrainSCREENWIDTH/3, TrainSCREENWIDTH/3);
        layout.headerReferenceSize =CGSizeMake(TrainSCREENWIDTH, IMAGESCROLLHEIGHT);
        layout.footerReferenceSize =CGSizeMake(TrainSCREENWIDTH, 0.1);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing =0;
        layout.minimumLineSpacing=0;
        
        
        TrainCustomCollectionView  *maincollect =[[TrainCustomCollectionView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainTabbarHeight - TrainNavHeight ) collectionViewLayout:layout andistap:YES];
        maincollect.dataSource =self;
        maincollect.delegate =self;
        maincollect.showsVerticalScrollIndicator =NO;
        maincollect.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:maincollect];
        [maincollect registerClass:[TrainHomeCollectionViewCell class] forCellWithReuseIdentifier:@"trainHomeCell"];
        
        [maincollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"trainHomeHeader"];
        [maincollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"trainHomeFooter"];
        _homeCollectionView =maincollect;
    }
    return _homeCollectionView;
}




#pragma mark - collection 代理

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return collectArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TrainHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"trainHomeCell" forIndexPath:indexPath];
    
    TrainHomeModel  *model = collectArr[indexPath.row];
    cell.model = model ;
    
    return cell;
}
-(NSArray *)dataSourceArrayOfCollectionView:(TrainCustomCollectionView *)collectionView{
    return collectArr;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark collection移动后的数据源

-(void)TrainCustomCollectionView:(TrainCustomCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
    
    NSArray   *arr = [TrainHomeModel mj_keyValuesArrayWithObjectArray:newDataArray];
   
    [self saveCollectArrWith:arr];
    collectArr = newDataArray ;
}

#pragma mark  collection头视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"trainHomeHeader" forIndexPath:indexPath];
        if (indexPath.section ==0) {
            
            __block NSMutableArray *imageUrlArr = [NSMutableArray array];
            __block NSMutableArray *titleArr = [NSMutableArray array];
        
            [imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
                NSDictionary  *dic =obj;
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TrainIP,dic[@"image"]];
                [imageUrlArr addObject:imageUrl];
                [titleArr addObject:dic[@"title"]];
                
            }];
            self.homeTopimageView.imageURLStringsGroup = imageUrlArr;
            self.homeTopimageView.titlesGroup = titleArr;
            [headerView addSubview:self.homeTopimageView];
            

        }else {
            UIView  *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, 100)];
            view.backgroundColor =[UIColor greenColor];
            [headerView addSubview:view];
        }
        return headerView;
        
    }
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"trainHomeFooter" forIndexPath:indexPath];
    return footer;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    TrainHomeModel  *model  = collectArr[indexPath.row];
    NSString  *keyStr = model.fn_key ;
    
    if ([keyStr  isEqualToString:@"CODE"]) {
        
        TrainScanViewController  *scanVC =[[TrainScanViewController alloc]init];
        scanVC.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:scanVC animated:YES];
        
    }
//    else  if ([keyStr  isEqualToString:@"REGISTER"]) {
//
////        TrainRegisterListViewController  *regVC =[[TrainRegisterListViewController alloc]init];
////        [self.navigationController pushViewController:regVC animated:YES];
//
//
//    }
    else  if ([keyStr  isEqualToString:@"CACHE"]) {
        
        TrainCacheListViewController  *cacheVC =[[TrainCacheListViewController alloc]init];
        cacheVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cacheVC animated:YES];
        
        
    }else  if ([keyStr  isEqualToString:@"COURSE"]) {
        
        TrainCourseClassViewController *courseVC = [[TrainCourseClassViewController alloc]init];
        courseVC.courseMode =([keyStr  isEqualToString:@"CLASS"])?TrainModeMyClass: TrainModeMyCourse;
        courseVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:courseVC animated:YES];
        
    }else if( [keyStr  isEqualToString:@"CLASS"]){
        
        TrainNewClassListViewController *courseVC = [[TrainNewClassListViewController alloc]init];
        courseVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:courseVC animated:YES];
//        TrainNavigationController *nav =[[TrainNavigationController alloc]initWithRootViewController:[NSClassFromString(@"TrainNewClassListViewController") new]];
//        [self.navigationController pushViewController:courseVC animated:YES];
//
    }else  if ([keyStr  isEqualToString:@"SHARE"]) {
        
        TrainDocumentListViewController   *docVC =[[TrainDocumentListViewController alloc]init];
        docVC.isMyDoc = YES;
        docVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:docVC animated:YES];
        
    }else  if ([keyStr  isEqualToString:@"EXAM"]) {
        
        TrainExamListViewController  *examVC =[[TrainExamListViewController alloc]init];
        examVC.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:examVC animated:YES];
        
    }else  if ([keyStr  isEqualToString:@"SURVEYANDASSESS"] || [keyStr  isEqualToString:@"TASK"]) {
        TrainQuestionViewController  *quesVC =[[TrainQuestionViewController alloc]init];
        quesVC.hidesBottomBarWhenPushed = YES;

        quesVC.isHomeWork = ([keyStr  isEqualToString:@"TASK"])?YES:NO;
        [self.navigationController pushViewController:quesVC animated:YES];
    }else  if ([keyStr  isEqualToString:@"TOPIC"] ) {
        
        TrainMyTopicListViewController  *myTopicVC =[[TrainMyTopicListViewController alloc]init];
        myTopicVC.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myTopicVC animated:YES];
        
        
    }else  if ([keyStr  isEqualToString:@"MYGROUP"]) {
        
        TrainMyGroupListViewController  *myGroupVC =[[TrainMyGroupListViewController alloc]init];
        myGroupVC.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:myGroupVC animated:YES];
        
        
    }else  if ([keyStr  isEqualToString:@"NOTES"]) {
        
        TrainMyNoteViewController  *myNoteVC =[[TrainMyNoteViewController alloc]init];
        myNoteVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myNoteVC animated:YES];
        
    }else  if ([keyStr  isEqualToString:@"COLLECTION"]) {
        TrainMyCollectViewController  *myCollectVC =[[TrainMyCollectViewController alloc]init];
        myCollectVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myCollectVC animated:YES];
//
        
        
    }else  if ([keyStr  isEqualToString:@"INTEGRAL"]) {
        

        TrainMyIntegralViewController *inteVC =[[TrainMyIntegralViewController   alloc]init];
        inteVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inteVC animated:YES];
        
    }else  {
        
        [TrainAlertTools  showTipAlertViewWith:self title:@"提示" message:TrainHomeMore buttonTitle:@"知道了" buttonStyle:TrainAlertActionStyleCancel];
        
    }
    
    
}

-(TrainSearchBar *)topSearchBar{
    if (!_topSearchBar) {
        TrainSearchBar *topSearch =[[TrainSearchBar alloc]init];
        topSearch.trainSearchBarStyle =TrainSearchBarStyleDefault;
        
        topSearch.customPlaceholder = TrainSearchTitleText;
        topSearch.textfileRadius = 15.0f;
        topSearch.delegate =self;
        topSearch.searchBackgroupColor =[UIColor clearColor];

        _topSearchBar = topSearch;
    }
    return _topSearchBar;
}

-(SDCycleScrollView *)homeTopimageView{
    if(!_homeTopimageView){
        
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, IMAGESCROLLHEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"lunImageBg"]];
        cycleScrollView2.autoScrollTimeInterval = 5.0f;
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView2.titleLabelTextFont = [UIFont systemFontOfSize:trainAutoLoyoutTitleSize(15.0f)];
        cycleScrollView2.titleLabelHeight =trainAutoLoyoutTitleSize(30.0f);
        cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 分页控件
        _homeTopimageView = cycleScrollView2;
    }
    return _homeTopimageView;
}

//
//-(TrainScrollImageView *)imagescroll{
//    if (!_imagescroll) {
//        TrainScrollImageView   *mainimagescroll =[[TrainScrollImageView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, IMAGESCROLLHEIGHT) WithDelay:IMAGESCROLLTIME];
//        
//        _imagescroll =mainimagescroll;
//        
//    }
//    return _imagescroll;
//}

#pragma mark - 轮播图点击
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if(imageArr.count > 0 ){
        NSDictionary  *dic =imageArr[index];
        [self screollTouch:dic];
    }
}

-(void)screollTouch:(NSDictionary *)dic{
    
    NSString  *imageType = dic[@"link_type"];
    NSString  *webURL = @"";
    
    if ([imageType isEqualToString:@"D"]) {
        webURL = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"dyndtls" object_id:[dic[@"link_id"] stringValue] andtarget_id:nil];
    }else {
        webURL = dic[@"link_url"];
        if([webURL isEqualToString:@""]){
            return;
        }else if([webURL hasPrefix:TrainIP]){
            // 判断register.id= 是否存在  存在则是我们需要改的
            if ([webURL rangeOfString:@"register.id="].location !=NSNotFound) {
                // 定位 register.id= 的 range
                NSRange  range =[webURL rangeOfString:@"register.id="];
                
                //  截取 register.id= 和以后的字符
                NSString  *regist =[webURL substringFromIndex:range.location];
                NSLog(@"%@",regist);
                // 截取 register.id=803
                NSArray  *arr =[regist componentsSeparatedByString:@"&"];
                NSString *object =[arr firstObject];
                //                截取 803
                arr =[object componentsSeparatedByString:@"="];
                NSString   *object_id =[arr lastObject];
                
                //                拼接url
                webURL = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"reg" object_id:object_id andtarget_id:nil];
            }else{
                webURL = [[TrainNetWorkAPIClient alloc] trainWebViewAddEmpidWithBaseURL:webURL];
            }
        }
    }
    TrainWebViewController *webVC =[[TrainWebViewController alloc]init];
    webVC.webURL = webURL;
    webVC.navTitle = dic[@"title"];
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
