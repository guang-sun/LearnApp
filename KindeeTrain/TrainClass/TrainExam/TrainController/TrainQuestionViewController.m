//
//  TrainQuestionViewController.m
//  SOHUEhr
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainQuestionViewController.h"
#import "TrainExamModel.h"
#import "TrianExamListCell.h"
#import "TrainWebViewController.h"


@interface TrainQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    TrainBaseTableView          *qusetionTableView;
    BOOL                        isFirst;
    
    NSMutableArray              *qusetionMuArr;
    
}


@end

@implementation TrainQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    isFirst = YES;
    UISegmentedControl  *segment =[[UISegmentedControl alloc]initWithFrame:CGRectMake((TrainSCREENWIDTH -TrainScaleWith6(216))/2, 5, TrainScaleWith6(216), 30)];
    segment.tintColor =[UIColor whiteColor];
    if (_isHomeWork) {
        [segment insertSegmentWithTitle:@"未完成" atIndex: 0 animated: NO ];
        [segment insertSegmentWithTitle:@"已完成" atIndex: 1 animated: NO ];
    }else{
        [segment insertSegmentWithTitle:@"调查" atIndex: 0 animated: NO ];
        [segment insertSegmentWithTitle:@"评估" atIndex: 1 animated: NO ];
    }

    segment.layer.borderWidth =1.0f;
    segment.layer.borderColor =[UIColor whiteColor].CGColor;
    segment.selectedSegmentIndex =0;
    [segment addTarget:self action:@selector(segmentTouch:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    [self creatUI];
    
}
-(void)segmentTouch:(UISegmentedControl *)seg{
    
    isFirst =(seg.selectedSegmentIndex ==0 )?YES:NO;
    [self refreshData];
}
-(void)refreshData{
    [self downloadDate:1];
    qusetionTableView.currentpage =1;
    if (qusetionMuArr.count> 0) {
        [qusetionTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
    
}

-(void)downloadDate:(int)index{
    
    [self trainShowHUDOnlyActivity];
    
    [qusetionTableView dissTablePlace];
    
    [[TrainNetWorkAPIClient client] trainQuesOrHomeWorkWithisHomeWork:_isHomeWork isFirst:isFirst examCurpage:index Success:^(NSDictionary *dic) {
        if (index == 1) {
            qusetionMuArr =[NSMutableArray array];
        }
        NSArray *dataArr =[TrainExamModel mj_objectArrayWithKeyValuesArray:dic[@"classExam"]];
        [qusetionMuArr addObjectsFromArray:dataArr];
        
        if (qusetionMuArr.count > 0) {
            TrainExamModel *model = [qusetionMuArr firstObject];
            qusetionTableView.totalpages = [model.totPage intValue];
        }
        
        qusetionTableView.trainMode = trainStyleNoData;
        [qusetionTableView EndRefresh];
        [self trainHideHUD];

    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        qusetionTableView.trainMode = trainStyleNoNet;
        [qusetionTableView EndRefresh];
        [self trainShowHUDNetWorkError];
    }];
    
 }


-(void)creatUI{
    
    qusetionTableView=[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight) andTableStatus:tableViewRefreshAll];
    qusetionTableView.dataSource =self;
    qusetionTableView.delegate =self;
    [qusetionTableView registerClass:[TrianExamListCell class] forCellReuseIdentifier:@"EXAMCELL"];
    [self.view addSubview:qusetionTableView];
    
    TrainWeakSelf(self);
    
    qusetionTableView.headBlock =^(){

        [weakself downloadDate:1];
    };
    qusetionTableView.footBlock = ^(int index){

        [weakself downloadDate:index];
    };
    qusetionTableView.refreshBlock = ^(){

        [weakself downloadDate:1];
    };
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return qusetionMuArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrianExamListCell  *examCell =[tableView dequeueReusableCellWithIdentifier:@"EXAMCELL"];
   
    TrainExamModel  *model =qusetionMuArr[indexPath.row];
    TrainExamStyle  examStyle = TrainExamStyleSurvey;
    if (_isHomeWork) {
        examStyle = TrainExamStyleHomeWork;
    }
    
    TrainWeakSelf(self);
    examCell.isHasLogo = NO;
    examCell.examStyle = examStyle;
    examCell.model     = model;
    examCell.returnWebUrlBlock =^(NSString *webUrl ){
        
        [weakself getoWebViewWithUrl:webUrl andmodel:model];
    };
    
    
    return examCell;
}


-(void)getoWebViewWithUrl:(NSString *)webURL andmodel:(TrainExamModel *)model{
    
    TrainWebViewController *webVC =[[TrainWebViewController alloc]init];
    webVC.webURL =webURL;
    webVC.navTitle = model.name;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:TrainSCREENWIDTH tableView:tableView];
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
