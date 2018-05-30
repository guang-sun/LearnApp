//
//  TrainExamListViewController.m
//  SOHUEhr
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainExamListViewController.h"
#import "TrainClassMenuView.h"
#import "TrainExamModel.h"
#import "TrianExamListCell.h"
#import "TrainWebViewController.h"

@interface TrainExamListViewController ()<UITableViewDelegate,UITableViewDataSource,TrainClassMenuDelegate>
{
    TrainClassMenuView          *menuView;
    NSArray                     *couseTopArr;
    NSArray                     *classesTopArr;
    TrainBaseTableView          *examTableView;
    BOOL                        isFinish;
    UIView                      *chooseBgView;
    
    TrainExamMode               examMode;
    TrainExamCompleteStatus     examStatus;
    
    NSMutableArray              *examMuArr;
    
}
@property(nonatomic ,strong)    UIButton                *chooseBtn;

@end

@implementation TrainExamListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl  *segment =[[UISegmentedControl alloc]initWithFrame:CGRectMake((TrainSCREENWIDTH -TrainScaleWith6(216))/2, 5, TrainScaleWith6(216), 30)];
    segment.tintColor =[UIColor whiteColor];
    [segment insertSegmentWithTitle:@"未完成" atIndex: 0 animated: NO ];
    [segment insertSegmentWithTitle:@"已完成" atIndex: 1 animated: NO ];
    segment.layer.borderWidth =1.0f;
    segment.layer.borderColor =[UIColor whiteColor].CGColor;
    segment.selectedSegmentIndex =0;
    [segment addTarget:self action:@selector(segmentTouch:) forControlEvents:UIControlEventValueChanged];

    self.navigationItem.titleView = segment;
    examMode    = TrainExamModeAll;
    examStatus  = TrainExamCompleteStatusUnFinish;
    couseTopArr = @[@"全部",@"课程考试",@"班级考试",@"独立考试"];;
    classesTopArr = @[@"全部",@"课程考试",@"班级考试",@"独立考试",@""];
    isFinish =NO;

    [self creatExamUI];
    // Do any additional setup after loading the view.
}
-(UIButton *)chooseBtn{
    if (!_chooseBtn) {
        UIButton  *button  =[[UIButton alloc]initCustomButton];
        button.frame =CGRectMake(TrainSCREENWIDTH*4/5, 0, TrainSCREENWIDTH/5, TrainCLASSHEIGHT);
        button.image =[UIImage imageNamed:@"Train_Select_down"];
        button.imageEdgeInsets =UIEdgeInsetsMake(0, 22, 0,  -22);
        button.titleEdgeInsets =UIEdgeInsetsMake(0, -22, 0, 22);
        button.cusTitleColor =TrainColorFromRGB16(0x969696);
        [button addTarget:self action:@selector(chooseTouch)];
        button.cusFont =14;
        [menuView addSubview:button];
        _chooseBtn =button;
    }
    return _chooseBtn;
    
}

-(void)chooseTouch{
    _chooseBtn.selected = !_chooseBtn.selected;
    if (_chooseBtn.selected) {
        if (!chooseBgView) {
            chooseBgView =[[UIView alloc]init];
            chooseBgView.backgroundColor =[UIColor whiteColor];
            chooseBgView.layer.borderWidth =1.0f;
            chooseBgView.layer.borderColor =[UIColor grayColor].CGColor;
            chooseBgView.backgroundColor =[UIColor groupTableViewBackgroundColor];
            [self.view addSubview:chooseBgView];
            chooseBgView.sd_layout
            .rightSpaceToView(self.view,0)
            .topSpaceToView(menuView,0)
            .widthIs(80)
            .heightIs(90);
            chooseBgView.sd_cornerRadius =@(5);
            
            UIButton   *allBtn =[[UIButton alloc]initCustomButton];
            allBtn.tag =1;
            allBtn.cusTitle =@"全部";
            [allBtn addTarget:self action:@selector(choosetouch:)];
            [chooseBgView addSubview:allBtn];
            
            UIView  *line =[[UIView alloc]init];
            line.backgroundColor =TrainColorFromRGB16(0xD9D9D9);
            [chooseBgView addSubview:line];
            
            UIButton   *succesBtn =[[UIButton alloc]initCustomButton];
            succesBtn.tag =2;
            succesBtn.cusTitle =@"通过";
            [succesBtn addTarget:self action:@selector(choosetouch:)];
            [chooseBgView addSubview:succesBtn];
            
            UIView  *line1 =[[UIView alloc]init];
            line1.backgroundColor =TrainColorFromRGB16(0xD9D9D9);
            [chooseBgView addSubview:line1];
            
            UIButton  *failBtn =[[UIButton alloc]initCustomButton];
            failBtn.tag =3;
            failBtn.cusTitle =@"失败";
            [failBtn addTarget:self action:@selector(choosetouch:)];
            
            [chooseBgView addSubview:failBtn];
            
            allBtn.sd_layout
            .leftEqualToView(chooseBgView)
            .rightEqualToView(chooseBgView)
            .topSpaceToView(chooseBgView,5)
            .heightIs(20);
            
            line.sd_layout
            .leftEqualToView(chooseBgView)
            .rightEqualToView(chooseBgView)
            .topSpaceToView(allBtn,5)
            .heightIs(0.7);
            
            
            succesBtn.sd_layout
            .leftEqualToView(chooseBgView)
            .rightEqualToView(chooseBgView)
            .topSpaceToView(allBtn,10)
            .heightIs(20);
            
            line1.sd_layout
            .leftEqualToView(chooseBgView)
            .rightEqualToView(chooseBgView)
            .topSpaceToView(succesBtn,5)
            .heightIs(0.7);
            
            failBtn.sd_layout
            .leftEqualToView(chooseBgView)
            .rightEqualToView(chooseBgView)
            .topSpaceToView(succesBtn,10)
            .heightIs(20);
            
        }else{
            chooseBgView.hidden =NO;
        }
        
    }else{
        chooseBgView.hidden = YES;
    }
    
    
}
-(void)choosetouch:(UIButton *)btn{
    if (btn.tag == 1) {
        examStatus = TrainExamCompleteStatusFinish;
        self.chooseBtn.cusTitle =@"全部";
        
    }else if (btn.tag == 2) {
        self.chooseBtn.cusTitle =@"通过";
        examStatus = TrainExamCompleteStatussPass;
    }else{
        examStatus = TrainExamCompleteStatusFail;
        self.chooseBtn.cusTitle =@"失败";
    }
    [self downloadDate:1];
    [self disMissChooseView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self disMissChooseView];
    
}
-(void)segmentTouch:(UISegmentedControl *)seg{
    
    [self disMissChooseView];

    if (seg.selectedSegmentIndex ==0) {
        
        [menuView resetTopMenu:couseTopArr];
        self.chooseBtn =nil;
        isFinish =NO;
        examStatus = TrainExamCompleteStatusUnFinish;
    }else{
        [menuView resetTopMenu:classesTopArr];
        self.chooseBtn.cusTitle =@"全部";
        isFinish=YES;
        examStatus = TrainExamCompleteStatusFinish;
        
    }
    examMode = TrainExamModeAll;
    [self refreshData];
}


-(void)TrainClassMenuSelectIndex:(int)index{
    [self disMissChooseView];
    examMode = index;
    [self refreshData];
}

-(void)disMissChooseView{
    _chooseBtn.selected =NO;
    chooseBgView.hidden =YES;
}

-(void)refreshData{
    [self downloadDate:1];
    examTableView.currentpage =1;
    if (examMuArr.count> 0) {
        [examTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
    
}
-(void)downloadDate:(int)index{
    
    [self trainShowHUDOnlyActivity];
    [examTableView dissTablePlace];

    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainExamListWithExamMode:examMode examStatus:examStatus examCurpage:index Success:^(NSDictionary *dic) {
        
        if (index == 1) {
            examMuArr = [NSMutableArray array];
        }
        NSArray  *dataArr = [TrainExamModel mj_objectArrayWithKeyValuesArray:dic[@"classExam"]];
        [examMuArr addObjectsFromArray:dataArr];
        if (examMuArr.count > 0) {
            TrainExamModel *model =[examMuArr firstObject];
            examTableView.totalpages =[model.totPage intValue];
        }
        examTableView.trainMode = trainStyleNoData;
        [examTableView EndRefresh];
        [weakself trainHideHUD];
        
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        examTableView.trainMode = trainStyleNoNet;

        [examTableView EndRefresh];
        [weakself trainShowHUDNetWorkError];
    }];
    
}
-(void)creatExamUI{
    menuView =[[TrainClassMenuView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainCLASSHEIGHT) andArr:couseTopArr];
    menuView.delegate =self;
    [self.view addSubview:menuView];
    
    
    examTableView=[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y +TrainCLASSHEIGHT, TrainSCREENWIDTH, TrainSCREENHEIGHT- TrainNavHeight -TrainCLASSHEIGHT) andTableStatus:tableViewRefreshAll];
    examTableView.dataSource =self;
    examTableView.delegate =self;
    [examTableView registerClass:[TrianExamListCell class] forCellReuseIdentifier:@"EXAMCELL"];
    [self.view addSubview:examTableView];
    
    TrainWeakSelf(self);
    
    examTableView.headBlock =^(){
        [weakself downloadDate:1];
    };
    examTableView.footBlock = ^(int index){

        [weakself downloadDate:index];
    };
    examTableView.refreshBlock = ^(){

        [weakself downloadDate:1];
    };
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return examMuArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrianExamListCell  *examCell =[tableView dequeueReusableCellWithIdentifier:@"EXAMCELL"];
    TrainExamModel  *model = examMuArr[indexPath.row];
    examCell.isHasLogo = YES;
    examCell.model = model;
    
    TrainWeakSelf(self);
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
