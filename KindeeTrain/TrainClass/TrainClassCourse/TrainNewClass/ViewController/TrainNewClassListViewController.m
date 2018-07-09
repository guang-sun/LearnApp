//
//  TrainNewClassListViewController.m
//  KindeeTrain
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainNewClassListViewController.h"
#import "TrainCourseAndClassModel.h"

#import "TrainNewClassListTableViewCell.h"

#import "TrainClassDetailViewController.h"
#import "TrainMoviePlayerViewController.h"
#import "TrainSearchViewController.h"
#import "TrainNewMovieViewController.h"
#import "TrainClassHomeViewController.h"
#import "TrainClassMoreViewController.h"
#import "TrainGroupDetailViewController.h"
#import "TrainNewClassModel.h"


@interface TrainNewClassListViewController ()<UITableViewDelegate,UITableViewDataSource ,TrainClassListDelegate>
{
    
    TrainBaseTableView          *courseTableVIew;
    NSMutableArray              *dataMuArr;
    
}
@property(nonatomic,assign) TrainMode          courseMode;


@end

@implementation TrainNewClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _courseMode = TrainModeMyClass ;
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithTitleItems:@[@"未报名",@"已报名"]];
    [segment addTarget:self action:@selector(segmentRegisterTouch:) forControlEvents:UIControlEventValueChanged];
    segment.frame = CGRectMake((TrainSCREENWIDTH - 216)/2, 5, 216, 30);
    segment.selectedSegmentIndex = 1 ;
    self.navigationItem.titleView = segment;
    
    
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

#pragma  mark -课程分类数据

-(void)refreshData{
    [self downLoadCouseAndClassData:1];
    courseTableVIew.currentpage =1;
    [courseTableVIew setContentOffset:CGPointMake(0,0) animated:NO];
    
    
}

-(void)downLoadCouseAndClassData:(int)index{
    
    [self trainShowHUDOnlyActivity];
    [courseTableVIew dissTablePlace];
    [[TrainNetWorkAPIClient client] trainCourseListWithcourseType:_courseMode order:TrainChooseModeChoose CourseFormat:@"" categoryid:@"" curPage:index Success:^(NSDictionary *dic) {
        if (index ==1) {
            dataMuArr =[NSMutableArray new];
        }
        NSArray  *arr = dic[@"classlist"] ;
        NSArray  *dataArr =[TrainNewClassModel mj_objectArrayWithKeyValuesArray:arr];
        [dataMuArr addObjectsFromArray:dataArr];
        if (dataMuArr.count>0) {
            TrainNewClassModel *model = [dataMuArr firstObject];
            courseTableVIew.totalpages = (int)model.totPage ;
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
    
    CGRect frameSize = CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight );

    courseTableVIew =[[TrainBaseTableView alloc]initWithFrame:frameSize  andTableStatus:tableViewRefreshAll];
    [self.view addSubview:courseTableVIew];
    courseTableVIew.delegate    = self;
    courseTableVIew.dataSource  = self;
    courseTableVIew.rowHeight   = UITableViewAutomaticDimension ;
    courseTableVIew.estimatedRowHeight   = trainAutoLoyoutImageSize(100) ;
    UINib *nib = [UIView loadNibNamed:NSStringFromClass([TrainNewClassListTableViewCell class])];
    [courseTableVIew registerNib:nib forCellReuseIdentifier:@"TrainTrainNewClassListTableViewCell"];
    
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
    return dataMuArr.count ;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    TrainNewClassListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TrainTrainNewClassListTableViewCell"];
    cell.model = dataMuArr[indexPath.row];
    cell.delegate = self ;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [ tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    TrainNewClassModel *model = dataMuArr[indexPath.row];
    
    RZClassStatus  status;
    if (model.is_start  <= 0) {
        status = RZClassStatusNotStart ;
    }else if(model.is_end  <= 0){
        status = RZClassStatusEnd ;
    }else {
        status = RZClassStatusDafeult ;
    }
    
    TrainClassHomeViewController  *classDatelisVC =[[TrainClassHomeViewController alloc]init];
    classDatelisVC.hidesBottomBarWhenPushed =YES;
    classDatelisVC.class_id = model.class_id;
    classDatelisVC.navTitle = model.name;
    classDatelisVC.status = status;
    [self.navigationController pushViewController:classDatelisVC  animated:YES];
    
    
}


- (void)rzClassListMates:(TrainNewClassModel *)model {
    
    TrainClassMoreViewController *moreVC =[[TrainClassMoreViewController alloc]init];
    moreVC.navTitle = @"班级学员";
    moreVC.class_id = model.class_id;
    
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)rzClassListTopicGroup:(TrainNewClassModel *)model  {
    
    TrainGroupDetailViewController *groupVC = [[TrainGroupDetailViewController alloc]init];
    groupVC.group_id = model.tactic_id ;
    
    [self.navigationController pushViewController:groupVC animated:YES];
    
}

- (void)rzClassListCollect:(TrainNewClassModel *)model  {
    
    BOOL   iscollect = !model.is_fav ;
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainClassCollectWithClass_id:model.class_id iscollect:iscollect Success:^(NSDictionary *dic) {
        NSString  *message ;
        if (iscollect) {
            message = @"收藏成功";
        }else {
            message = @"取消收藏";
        }
        [TrainProgressHUD showMessage:message inView:weakself.view];
        model.is_fav = iscollect ;
        [courseTableVIew reloadData];
        
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        NSString  *message ;
        if (iscollect) {
            message = @"收藏失败";
        }else {
            message = @"取消收藏失败";
        }
        [TrainProgressHUD showMessage:message inView:weakself.view];
        
    }];
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
