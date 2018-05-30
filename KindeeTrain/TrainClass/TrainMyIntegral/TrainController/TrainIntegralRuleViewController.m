//
//  TrainIntegralRuleViewController.m
//   KingnoTrain
//
//  Created by apple on 16/12/6.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainIntegralRuleViewController.h"
#import "TrainIntegarlRuleCell.h"
#include "TrainIntegralMoel.h"

@interface TrainIntegralRuleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    TrainBaseTableView     *customTableV;
    NSMutableArray          *ruleMuArr;
}


@end

@implementation TrainIntegralRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ruleMuArr = [NSMutableArray array];
    
    NSString *navTitle = @"";
    if (_integralStatus == TrainIntegralStatusRule) {
        navTitle =  @"积分规则" ;
    }else{
        navTitle =  @"积分等级" ;
    }
    
    self.navigationItem.title =navTitle;
    
    NSArray  *ruleArr = @[@"用户操作",@"限制条件",@"积分分值"];
    NSArray  *levelArr = @[@"名称",@"等级",@"分数(分)"];
    for (int i = 0; i < 3; i++) {
        UILabel  *userLab =[[UILabel alloc]initCustomLabel];
        userLab.frame = CGRectMake( TrainSCREENWIDTH / 3 * i, TrainNavorigin_y, TrainSCREENWIDTH /3, 40);
        userLab.textAlignment = NSTextAlignmentCenter;
        userLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if (_integralStatus == TrainIntegralStatusRule) {
            
            userLab.text = ruleArr[i];
        }else{
            
            userLab.text = levelArr[i];
        }
       
        [self.view addSubview:userLab];
    }
    customTableV =[[TrainBaseTableView alloc]initWithFrame:CGRectZero andTableStatus:tableViewRefreshNone];
    customTableV.backgroundColor =[UIColor clearColor];
    customTableV.dataSource =self;
    customTableV.delegate =self;
    customTableV.rowHeight=40;
    customTableV.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view  addSubview:customTableV];
    [customTableV registerClass:[TrainIntegarlRuleCell  class] forCellReuseIdentifier:@"IntegarlCell"];
    customTableV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(40 + TrainNavHeight, 0, 0, 0));
    
    [self downLoadIntegral];
    
}

//getIntegralRule  积分规则 user_id,rule_type=up 奖励，down 扣除
//getIntegralLevel 积分等级  user_id
//getMyIntegral  等级说明 user_id,curPage
-(void)downLoadIntegral{

    [self trainShowHUDOnlyActivity];
    [customTableV dissTablePlace];
    
    
    [[TrainNetWorkAPIClient client] trainIntegralRuleOrLevellWithtype:_integralStatus Success:^(NSDictionary *dic) {
        
        if (_integralStatus == TrainIntegralStatusRule) {
            
            NSArray  *upArr  =[TrainIntegarlRuleModel  mj_objectArrayWithKeyValuesArray:dic[@"up"]];
            NSArray  *downArr  =[TrainIntegarlRuleModel  mj_objectArrayWithKeyValuesArray:dic[@"down"]];
            [ruleMuArr addObjectsFromArray:upArr];
            [ruleMuArr addObjectsFromArray:downArr];
            
        }else{
            
            NSArray  *arr  =[TrainIntegarlLevelModel  mj_objectArrayWithKeyValuesArray:dic[@"level"]];
            [ruleMuArr addObjectsFromArray:arr];
        }
        customTableV.trainMode = trainStyleNoData;
        [customTableV EndRefresh];
        [self trainHideHUD];
        
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
       
        customTableV.trainMode = trainStyleNoNet;
        [customTableV EndRefresh];
        [self trainShowHUDNetWorkError];

    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ruleMuArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainIntegarlRuleCell *ruleCell = [tableView dequeueReusableCellWithIdentifier:@"IntegarlCell"];

    if (_integralStatus == TrainIntegralStatusRule) {
      
        ruleCell.rulemodel = ruleMuArr[indexPath.row];
    
    }else{
    
        ruleCell.levelmodel = ruleMuArr[indexPath.row];
    
    }
    return ruleCell;
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
