//
//  TrainCourseClassViewController.m
//   KingnoTrain
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainCourseClassViewController.h"
#import "TrainCourseAndClassModel.h"
#import "TrainCourseClassListCell.h"
#import "TrainClassDetailViewController.h"
#import "TrainMoviePlayerViewController.h"
#import "TrainSearchViewController.h"
#import "TrainNewMovieViewController.h"

@interface TrainCourseClassViewController ()<TrainClassMenuDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString                    * courseStr ;
    NSString                    * courseClassID ;
    NSString                    * chooseFormatStr ;
    NSArray                     *treeArr;
    NSDictionary                *treeDic;
    TrainBaseTableView          *courseTableVIew;
    NSMutableArray              *dataMuArr;
    TrainChooseMode             chooseMode;
}

@property (nonatomic ,strong) TrainClassMenuView     *topMenuView;
@end

@implementation TrainCourseClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_courseMode == TrainModeMyClass){
        
        _courseMode = TrainModeMyClass;

        [self.navigationItem setTitle:@"我的班级"];
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithTitleItems:@[@"未报名",@"已报名"]];
        [segment addTarget:self action:@selector(segmentRegisterTouch:) forControlEvents:UIControlEventValueChanged];
        segment.frame = CGRectMake((TrainSCREENWIDTH - 216)/2, 5, 216, 30);
        segment.selectedSegmentIndex = 1 ;
        self.navigationItem.titleView = segment;
        
        
    }else if(_courseMode == TrainModeMyCourse){
    
        [self.navigationItem setTitle:@"我的课程"];

    }else{

        self.navigationItem.leftBarButtonItem = nil;

        chooseMode      = TrainChooseModeNew;
        courseClassID   = @"-1";
        
        self.navigationItem.title = @"课程" ;
//        chooseFormatStr = @"";
//        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithTitleItems:@[@"选课",@"班级"]];
//        [segment addTarget:self action:@selector(segmentTouch:) forControlEvents:UIControlEventValueChanged];
        
//        segment.frame = CGRectMake((TrainSCREENWIDTH - 216)/2, 5, 216, 30);
        
//        self.navigationItem.titleView = segment;

        UIButton   *rightItem = [[UIButton  alloc]initCustomButton];
        rightItem.image = [UIImage imageNamed:@"Train_Search"];
        [rightItem addTarget:self action:@selector(pushSearch)];
        rightItem.frame = CGRectMake(TrainSCREENWIDTH -40, 0, 30, 44);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
 
        self.topMenuView.frame = CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainCLASSHEIGHT);
        [self.view addSubview:self.topMenuView];
        
    }
        [self creatTableUI];

    
    // Do any additional setup after loading the view.
}

- (void)segmentRegisterTouch:(UISegmentedControl *)seg {
   
    if (seg.selectedSegmentIndex ==0) {
        
        _courseMode = TrainModeMyNotClass;

    }else{
        
        _courseMode = TrainModeMyClass;
    }
    
    [self refreshData];
}
-(void)segmentTouch:(UISegmentedControl *)seg{
    
    if (seg.selectedSegmentIndex ==0) {

        _courseMode = TrainModeCourse;
        [self.topMenuView resetTopMenu:[TrainLocalData returnCourseClassMenu]];

    }else{
        _courseMode = TrainModeClass;
        [self.topMenuView resetTopMenu:@[@"最新",@"最热"]];

    }

    [self refreshData];
}
#pragma  mark -课程分类数据

-(void)downLoadClassMenuData{
    
    [[TrainNetWorkAPIClient client] trainCourseMenuCategoryWithSuccess:^(NSDictionary *dic) {
        if (dic) {
            treeArr =dic[@"courseCategory"];
            treeDic =dic;
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        treeArr =[NSArray new];
        treeDic=[NSDictionary new];
        
    }];
}




-(void)TrainClassMenuSelectDic:(NSDictionary *)dic{
    if ([dic allKeys].count >1) {
        
        if([dic[@"id"] intValue] == 0){
            courseClassID = @"-1";
        }else{
            courseClassID = [dic[@"id"] stringValue];
        }
    }else {
        
        chooseFormatStr = dic[@"name"];
        
    }
    [self refreshData];
}

/**
 *  topMenu 点击切换
 *
 *  @param index index
 */

-(void)TrainClassMenuSelectIndex:(int)index{
    
    
    if (_courseMode == TrainModeCourse) {
       
        NSString  *string = [TrainLocalData returnCourseClassMenu][index];
        if ([string isEqualToString:@"类型"]) {
            self.topMenuView.collectArr= [TrainLocalData returnCourseChooseClass];
            self.topMenuView.tableCollectDic = nil;
            self.topMenuView.istable = NO;
            self.topMenuView.collectSelect = chooseFormatStr;
            ;
            
        }else if ([string isEqualToString:@"分类"]) {
            self.topMenuView.collectArr = treeArr;
            self.topMenuView.tableCollectDic = treeDic;
            self.topMenuView.istable =YES;
            
        }
        
    }
    if (!treeArr || treeArr.count == 0) {
        [self downLoadClassMenuData];
    }
    
    if(index == 0){
        
        chooseMode      = TrainChooseModeNew;
     
        [self refreshData];
        
    }else if(index == 1){
        
        chooseMode      = TrainChooseModeHot;
      
        [self refreshData];
        
    }else if(index == 2 || index ==3){
        
        chooseMode      = TrainChooseModeChoose;
      
    }
    courseClassID   = @"-1";
    chooseFormatStr = @"全部";
}




-(void)refreshData{
    [self downLoadCouseAndClassData:1];
    courseTableVIew.currentpage =1;
    [courseTableVIew setContentOffset:CGPointMake(0,0) animated:NO];

    
}


-(void)pushSearch{
    [self.topMenuView dismissTopMenu];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TrainSearchViewController *searchVC =[[TrainSearchViewController alloc]init];
        searchVC.hidesBottomBarWhenPushed =YES;
        searchVC.selectMode = TrainSearchStyleCourse;
        [self.navigationController pushViewController:searchVC animated:YES];
        
    });
}




//-(void)downLoadClassMenuData{
//
//    [[TrainNetWorkAPIClient client] trainCourseMenuCategoryWithSuccess:^(NSDictionary *dic) {
//        if (dic) {
//            NSLog(@"couse menu ==%@ ",dic);
////            treeArr =dic[@"courseCategory"];
////            treeDic =dic;
////            topClassMenuV.collectArr=treeArr;
////            topClassMenuV.tableCollectDic =treeDic;
////            topClassMenuV.istable =YES;
//        }
//    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
////        NSArray *arr =[NSArray new];
////        NSDictionary *dic=[NSDictionary new];
////        topClassMenuV.collectArr=arr;
////        topClassMenuV.tableCollectDic =dic;
////        topClassMenuV.istable =YES;
//    }];
//    
//}

-(void)downLoadCouseAndClassData:(int)index{
    
    [self trainShowHUDOnlyActivity];
    [courseTableVIew dissTablePlace];
    
    [[TrainNetWorkAPIClient client] trainCourseListWithcourseType:_courseMode order:chooseMode CourseFormat:chooseFormatStr categoryid:courseClassID curPage:index Success:^(NSDictionary *dic) {
        
        if (index ==1) {
            dataMuArr =[NSMutableArray new];
        }
        NSArray  *arr =(_courseMode == TrainModeMyClass  || _courseMode == TrainModeClass  || _courseMode == TrainModeMyNotClass) ? dic[@"classlist"]:dic[@"course"];
        NSArray  *dataArr =[TrainCourseAndClassModel mj_objectArrayWithKeyValuesArray:arr];
        
        [dataMuArr addObjectsFromArray:dataArr];
        if (dataMuArr.count>0) {
            TrainCourseAndClassModel *model = [dataMuArr firstObject];
            courseTableVIew.totalpages = [model.totPage intValue];
        }
        courseTableVIew.trainMode = trainStyleNoData;
        [courseTableVIew EndRefresh];
        [self trainHideHUD];
        

        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        courseTableVIew.trainMode = trainStyleNoNet;
        
        [courseTableVIew EndRefresh];
        [self trainShowHUDNetWorkError];
    }];
}
-(void)creatTableUI{
    
    CGRect  frameSize ;
    if (_courseMode == TrainModeMyClass || _courseMode == TrainModeMyCourse || _courseMode == TrainModeMyNotClass) {
        
        frameSize =CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight );
    }else{
        frameSize=CGRectMake(0, TrainNavorigin_y +TrainCLASSHEIGHT, TrainSCREENWIDTH, TrainSCREENHEIGHT - TrainNavHeight - TrainTabbarHeight - TrainCLASSHEIGHT);
    }
    courseTableVIew =[[TrainBaseTableView alloc]initWithFrame:frameSize  andTableStatus:tableViewRefreshAll];
    [self.view addSubview:courseTableVIew];
    courseTableVIew.delegate    = self;
    courseTableVIew.dataSource  = self;
    courseTableVIew.rowHeight   = trainAutoLoyoutImageSize(100) ;
    [courseTableVIew registerClass:[TrainCourseClassListCell class] forCellReuseIdentifier:@"trainCell"];
   
    TrainWeakSelf(self);
    
    courseTableVIew.headBlock =^(){
        [weakself downLoadCouseAndClassData:1];
        
    };
    courseTableVIew.footBlock=^(int  aa){
        [weakself downLoadCouseAndClassData:aa];
        
    };
    courseTableVIew.refreshBlock =^(){
        [weakself downLoadCouseAndClassData:1];
        
    };
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataMuArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrainCourseClassListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"trainCell"];
    cell.isClass = (_courseMode == TrainModeClass || _courseMode == TrainModeMyClass || _courseMode == TrainModeMyNotClass) ? YES : NO ;
    cell.isMyCourse = (_courseMode == TrainModeMyCourse) ? YES :  NO ;
    
    cell.model = dataMuArr[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [ tableView deselectRowAtIndexPath:indexPath animated:YES];
    TrainCourseAndClassModel  *model = dataMuArr[indexPath.row];
    
    if(_courseMode == TrainModeClass || _courseMode == TrainModeMyClass ||_courseMode == TrainModeMyNotClass){
        
       
        RZClassStatus  status;
        if ([model.is_start integerValue] <= 0) {
            status = RZClassStatusNotStart ;
        }else if([model.is_end integerValue] <= 0){
            status = RZClassStatusEnd ;
        }else {
            status = RZClassStatusDafeult ;
        }
        
        TrainClassDetailViewController  *classDatelisVC =[[TrainClassDetailViewController alloc]init];
        classDatelisVC.hidesBottomBarWhenPushed =YES;
        classDatelisVC.class_id = model.class_id;
        classDatelisVC.navTitle = model.name;
        classDatelisVC.status = status;
        [self.navigationController pushViewController:classDatelisVC  animated:YES];
        
        
    }else{
        
        if ([model.is_start integerValue] > 0 && [model.is_end integerValue] > 0)  {
            
            
            TrainNewMovieViewController  *newVC =[[TrainNewMovieViewController alloc]init];
            newVC.hidesBottomBarWhenPushed = YES;
            newVC.courseModel = model;
            [self.navigationController pushViewController:newVC animated:YES];
            
        }else {
          
            NSString *msgText;
            if ([model.is_start integerValue] <= 0) {
                
                msgText = @"该课程尚未开启";
                
            }else {
                msgText = @"该课程已结束";
            }
            
            
            [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:msgText buttonTitle:@"知道了" buttonStyle:TrainAlertActionStyleCancel];
            
        }
        
    }
    
}


-(TrainClassMenuView *)topMenuView{
    
    if (!_topMenuView) {
        
       TrainClassMenuView * topClassMenuV =[[TrainClassMenuView alloc]initWithFrame:CGRectZero andArr:[TrainLocalData returnCourseClassMenu]];
        topClassMenuV.delegate = self;
        _topMenuView = topClassMenuV;
    }
    return _topMenuView;
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
