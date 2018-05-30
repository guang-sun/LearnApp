//
//  TrainMyIntegralViewController.m
//   KingnoTrain
//
//  Created by apple on 16/12/6.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainMyIntegralViewController.h"
#import "TrainMyIntegarlListCell.h"
#import "TrainIntegralMoel.h"
#import "TrainImageButton.h"
#import "TrainIntegralRuleViewController.h"
#import "TrainCircleView.h"
#define CircleWidth     150

@interface TrainMyIntegralViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    TrainBaseTableView      *integralTableV;
    TrainCircleView         *circleView;
    NSMutableArray          *integralMuArr;
    
    UILabel                 *levelLab, *nextLevelLab, *nextLevelScoreLab;
    
}


@end

@implementation TrainMyIntegralViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:TrainNavColor] forBarMetrics: UIBarMetricsDefault];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"积分";
    
    
    UIView *navBgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, CircleWidth+30)];
    navBgView.backgroundColor = TrainNavColor;
    [self.view addSubview:navBgView];
    [self.view sendSubviewToBack:navBgView];
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, CircleWidth+30)];
    view.backgroundColor =TrainNavColor;
    //    [bgScroll addSubview:view];
    
    TrainImageButton *ruleBtn = [[TrainImageButton alloc]initWithFrame:CGRectMake(TrainSCREENWIDTH - 90, 10, 90, 15) andImage:[UIImage imageNamed:@"Train_MyIntegral_rule"] andTitle:@"积分规则" ];
    ruleBtn.cusTitleColor = [UIColor whiteColor];
    
    TrainWeakSelf(self);
    ruleBtn.touchAction = ^(UIButton * sender){
        
        TrainIntegralRuleViewController *ruleVC =[[TrainIntegralRuleViewController alloc]init];
        ruleVC.integralStatus = TrainIntegralStatusRule;
        [weakself.navigationController pushViewController:ruleVC animated:YES];
    };
    
    [view addSubview:ruleBtn];
    
    
    TrainImageButton *levelRuleBtn = [[TrainImageButton alloc]initWithFrame:CGRectMake(TrainSCREENWIDTH - 90, 40, 90, 15) andImage:[UIImage imageNamed:@"Train_MyIntegral_rule"] andTitle:@"等级规则" ];
    levelRuleBtn.cusTitleColor = [UIColor whiteColor];
    levelRuleBtn.touchAction = ^(UIButton * sender){
        
        TrainIntegralRuleViewController *ruleVC =[[TrainIntegralRuleViewController alloc]init];
        ruleVC.integralStatus = TrainIntegralStatusLevel;
        [weakself.navigationController pushViewController:ruleVC animated:YES];
    };
    
    [view addSubview:levelRuleBtn];

    
    circleView =[[TrainCircleView alloc]initWithFrame:CGRectMake((TrainSCREENWIDTH - CircleWidth)/2, 0, CircleWidth, CircleWidth) andcircleMode:TraincircleModeArc];
    circleView.progressColor =[UIColor whiteColor ];
    circleView.lineWidth = 2;
    circleView.circleBgLineColor =[UIColor whiteColor];
    [view addSubview:circleView];
    
    
    levelLab = [[UILabel alloc]initCustomLabel];
    levelLab.textAlignment = NSTextAlignmentCenter;
    levelLab.textColor = [UIColor whiteColor];
    levelLab.font = [UIFont  systemFontOfSize:12.0f];
    //    levelLab.text =@"初试锋芒";
    [view addSubview:levelLab];
    levelLab.frame = CGRectMake((TrainSCREENWIDTH - 200) / 2, CircleWidth - 20, 100, 20);
    
    
    nextLevelLab = [[UILabel alloc]initCustomLabel];
    //    nextLevelLab.text =@"崭露头角";
    nextLevelLab.textAlignment = NSTextAlignmentCenter;
    nextLevelLab.font = [UIFont  systemFontOfSize:12.0f];
    nextLevelLab.textColor = [UIColor whiteColor];
    [view addSubview:nextLevelLab];
    nextLevelLab.frame = CGRectMake((TrainSCREENWIDTH) / 2, CircleWidth - 20,100, 20);
    
    nextLevelScoreLab = [[UILabel alloc]initCustomLabel];
    nextLevelScoreLab.font = [UIFont  systemFontOfSize:12.0f];
    nextLevelScoreLab.textAlignment = NSTextAlignmentCenter;
    //    nextLevelScoreLab.text =;
    nextLevelScoreLab.textColor = [UIColor whiteColor];
    [view addSubview:nextLevelScoreLab];
    nextLevelScoreLab.frame = CGRectMake(20, CircleWidth, (TrainSCREENWIDTH - 40), 20);
    
    
    
    
    
    integralTableV =[[TrainBaseTableView alloc]initWithFrame:CGRectZero andTableStatus:tableViewRefreshFooter];
    integralTableV.backgroundColor =[UIColor clearColor];
    integralTableV.dataSource =self;
    integralTableV.delegate =self;
    integralTableV.tableHeaderView = view;
    integralTableV.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view  addSubview:integralTableV];
    [integralTableV registerClass:[TrainMyIntegarlListCell class] forCellReuseIdentifier:@"MYCell"];
    
    
    integralTableV.footBlock = ^(int  index){
        [weakself downLoadIntegral:index];
    };
    
    integralTableV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(TrainNavorigin_y, 0, 0, 0));
    
    [self downLoadIntegral:1];
}

//getIntegralRule  积分规则 user_id,rule_type=up 奖励，down 扣除
//getIntegralLevel 积分等级  user_id
//getMyIntegral  等级说明 user_id,curPage
-(void)downLoadIntegral:(int )index{
    
    [self trainShowHUDOnlyActivity];
    [integralTableV dissTablePlace];
    TrainWeakSelf(self);
    
    [[TrainNetWorkAPIClient client] trainGetIntegralListlWithcurPage:index Success:^(NSDictionary *dic) {
       
        if (index  == 1 ) {
            integralMuArr =[NSMutableArray array];
            [weakself updataIntegarl:dic];
        }
        NSArray  *arr =[TrainIntegralMoel  mj_objectArrayWithKeyValuesArray:dic[@"integralList"]];
        [integralMuArr addObjectsFromArray:arr];
        
        if (integralMuArr.count > 0) {
            TrainIntegralMoel  *model = integralMuArr[0];
            integralTableV.totalpages = [model.totPage intValue];
        }
        integralTableV.trainMode = trainStyleNoData;
        [integralTableV EndRefresh];
        [weakself trainHideHUD];

    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        integralTableV.trainMode = trainStyleNoNet;
        [integralTableV EndRefresh];
        [weakself trainShowHUDNetWorkError];
    
    }];
  }

-(void)updataIntegarl:(NSDictionary *)dic{
    levelLab.text = (dic[@"myLevelName"])?dic[@"myLevelName"]:@"";
    nextLevelLab.text = (dic[@"nextLevelName"])?dic[@"nextLevelName"]:@"";;
    nextLevelScoreLab.text = [NSString stringWithFormat:@"距离下一等级还差%@积分",[dic[@"nextLevelScore"] stringValue]];
    circleView.text = [dic[@"myIntegralScore"] stringValue];
    int   nowscore = 0 ;
    if (dic[@"myIntegralScore"] && [dic[@"myIntegralScore"] intValue] >= 0) {
        nowscore =[dic[@"myIntegralScore"] intValue];
    }
    int   nextscore = 0 ;
    if ( dic[@"nextLevelScore"] && [dic[@"nextLevelScore"] intValue] >= 0) {
        nextscore =[dic[@"nextLevelScore"] intValue];
    }
    
    if (nextscore > 0) {
        circleView.percent = nowscore * 1.0 /(nowscore + nextscore) * 100;
    }else{
        circleView.percent = 0;
        
    }
    
}

//-(void)rightSign{
//
//
//
//    NSLog(@"右侧铃铛  点击");
//
//
//
//}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"2----%f",scrollView.contentOffset.y);
    float    off_y =scrollView.contentOffset.y;
    
    if (off_y > 0) {
        integralTableV.bounces =YES;
    }else{
        integralTableV.bounces =NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    integralTableV.bounces =YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return integralMuArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrainMyIntegarlListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MYCell"];
    cell.model = integralMuArr[indexPath.row];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"积分来源";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [integralTableV cellHeightForIndexPath:indexPath cellContentViewWidth:TrainSCREENWIDTH tableView:tableView];
}

-(void)dealloc{
    NSLog(@"=-=-==-dealloc=%@",[self class]);
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
