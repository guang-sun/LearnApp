//
//  TrainClassMoreViewController.m
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainClassMoreViewController.h"
#import "TrainClassDetailCell.h"
@interface TrainClassMoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    TrainBaseTableView              *moreTableView ;
    TrainClassDetailStatus          status;
    NSMutableArray                  *detaliMuarr;
}



@end

@implementation TrainClassMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:_navTitle];
    if ([_navTitle isEqualToString:@"班级教师"] ) {
        status = TrainClassDetailStatusTeacher;
    }else if ([_navTitle isEqualToString:@"班级学员"] ) {
        status = TrainClassDetailStatusStudent;
    }else if ([_navTitle isEqualToString:@"班级评价"] ) {
        status = TrainClassDetailStatusAppraise;
    }
    [self creatTableView];
    [self downLoadCouseAndClassData:1];

    
    // Do any additional setup after loading the view.
}
-(void)creatTableView{
    moreTableView =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT - TrainNavHeight) andTableStatus:tableViewRefreshFooter];
    [self.view addSubview:moreTableView];
    moreTableView.delegate = self;
    moreTableView.dataSource = self;
    moreTableView.rowHeight = 60;
    [moreTableView registerClass:[TrainClassDetailCell class] forCellReuseIdentifier:@"morecell"];
    TrainWeakSelf(self);
    moreTableView.footBlock=^(int  index){
        __strong __typeof(weakself)strongSelf = weakself;
        [strongSelf downLoadCouseAndClassData:index];
        
    };
    moreTableView.refreshBlock =^(){
        __strong __typeof(weakself)strongSelf = weakself;
        [strongSelf downLoadCouseAndClassData:1];
        
    };
}
-(void)downLoadCouseAndClassData:(int)index{
    
    [self trainShowHUDOnlyActivity];
    [moreTableView dissTablePlace];
    
    
    [[TrainNetWorkAPIClient client] trainClassDetailMoreWithdetailMode:status class_id:_class_id curPage:index Success:^(NSDictionary *dic) {
        if (index == 1) {
            detaliMuarr =[NSMutableArray array];
        }
        NSArray  *dataArr = [NSArray new];
        if (status == TrainClassDetailStatusTeacher) {
            dataArr =[TrainClassUserModel  mj_objectArrayWithKeyValuesArray:dic[@"person"]];
            
        }else  if (status == TrainClassDetailStatusStudent) {
            dataArr =[TrainClassUserModel  mj_objectArrayWithKeyValuesArray:dic[@"person"]];
        }
        
        [detaliMuarr addObjectsFromArray:dataArr];
        
        if (detaliMuarr.count>0) {
            TrainClassUserModel *model =[detaliMuarr firstObject];
            moreTableView.totalpages =[model.totPage intValue];
        }
        
        moreTableView.trainMode = trainStyleNoData;
        [moreTableView EndRefresh];
        [self trainHideHUD];
        

    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        moreTableView.trainMode = trainStyleNoNet;
        [moreTableView EndRefresh];
        [self trainShowHUDNetWorkError];
    }];
    }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (TrainArrayIsEmpty(detaliMuarr))?0:detaliMuarr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainClassDetailCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"morecell"];
    cell.isDetail =NO;
    cell.status = status;
    cell.model =detaliMuarr[indexPath.row];
    //    cell.isApparise =[_navTitle  isEqualToString:@"班级评价"];
    return cell;
    
    
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
