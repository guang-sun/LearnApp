//
//  TrainClassDetailViewController.m
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainClassDetailViewController.h"

#import "TrainClassDetailCell.h"
#import "TrainClassCourseListCell.h"
#import "TrainClassMenuView.h"
#import "TrainClassMoreHeaderView.h"
#import "TrainClassMoreViewController.h"
#import "TrainMoviePlayerViewController.h"
#import "TrainNewMovieViewController.h"
#import "TrainExamModel.h"
#import "TrianExamListCell.h"
#import "TrainWebViewController.h"
#import "TrainImageButton.h"

#define   DownHeight   50
#define   imageViewHeight  (TrainSCREENWIDTH*9/16)
#define maxNum   5    // 详情 讲师 和 学员 list最大数量 显示更多

@interface TrainClassDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,TrainClassMenuDelegate>
{
    UIView                  *tableHeadView;
    UILabel                 *classNameLab, *classPriceLab;
    UIView                  *downView;
    UIImageView             *classBgImageV;

    TrainImageButton        *signButton;
    TrainClassRegisterStatus          Regstatus;
    
    TrainClassMenuView      *menuView;
    TrainClassMode          classMode;

    NSMutableArray          *courseMuArr, *classDetailMuArr ,
                            *surveyMuArr, *evaluateMuArr , *ExamMuArr;

    NSArray                 *ClassHeaderArr;
    
    NSString                *register_id;
    NSDictionary            *classInfo;
    
}
@property(nonatomic, copy) NSString    *classUrl;

@property(nonatomic,strong)    UIView                  *succesView;
@property(nonatomic,strong)    UIButton                *exitBtn;
@property(nonatomic,strong)    UIButton                *registBtn;
@property(nonatomic,strong)    TrainBaseTableView      *classTableV;
@property(nonatomic,strong)    TraingailanDatelisModel *gaiLanModel;
@property(nonatomic,strong)    TrainClassMenuView      *topMenuView;

@end


@implementation TrainClassDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ClassHeaderArr =@[@"班级概览",@"班级教师",@"班级学员"];
    classMode = TrainClassModeCourse;
    courseMuArr  = [NSMutableArray array];
    classDetailMuArr   = [NSMutableArray array];
    Regstatus = TrainClassRegisterStatusNone;
    
    [self.navigationItem setTitle:_navTitle];
    
    [self creatDownUnregistView];
    [self  downloadDate:1];

}
#pragma  mark  - 报名
#pragma  mark - 底部签到

-(void)creatDownUnregistView{
    
    downView =[[UIView alloc]init];
    downView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:downView];
    
    downView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,0)
    .heightIs(DownHeight);

    [downView addSubview:self.exitBtn];
    [downView addSubview:self.registBtn];
    [downView addSubview:self.succesView];
    self.exitBtn.hidden     = YES;
    self.succesView.hidden  = YES;
    self.registBtn.hidden   = YES;
}

-(void)updateDownUnRegistView{
    
    self.exitBtn.hidden     = YES;
    self.succesView.hidden  = YES;
    self.registBtn.hidden   = YES;
    
    if (Regstatus == TrainClassRegisterStatusNone ) {
        
        self.registBtn.frame =CGRectMake((TrainSCREENWIDTH - 160)/2, 5, 160, 40);
        _registBtn.cusTitle     = @"立即参加";
        self.registBtn.hidden = NO;
        
    } else if(Regstatus == TrainClassRegisterStatusWaiting || Regstatus == TrainClassRegisterStatusLining) {
        
        self.exitBtn.hidden   = NO;
        self.registBtn.hidden = NO;
        
        float  width =(TrainSCREENWIDTH - 60)/2;
        self.exitBtn.frame =CGRectMake(20, 5, width, 40);
        self.registBtn.frame =CGRectMake(40+width, 5, width, 40);

        _registBtn.cusTitle = (Regstatus == TrainClassRegisterStatusWaiting)?@"等待审核...":@"正在排队...";
        _registBtn.backgroundColor =[UIColor lightGrayColor];
        _registBtn.userInteractionEnabled =NO;
        
    }else if(Regstatus == TrainClassRegisterStatusFinish || Regstatus == TrainClassRegisterStatusFinishExit){
        float  width =(TrainSCREENWIDTH - 60)/2;
        self.exitBtn.hidden     = NO;
        self.succesView.hidden = NO;
        

        self.exitBtn.frame =CGRectMake(20, 5, width, 40);
        self.succesView.frame =CGRectMake(40+width, 5, width, 40);
        signButton.frame = CGRectMake(0, 0, width, 40);
        signButton.imageSize = CGSizeMake(20, 20);
        
        if (Regstatus == TrainClassRegisterStatusFinish) {
            _exitBtn.backgroundColor = [UIColor lightGrayColor];
            _exitBtn.userInteractionEnabled =NO;
        }
        
    }
    
    
}
//
//    "ru_status": "Q", 若"S" 已报名  其他 未报名
//    "ru_wait_status": "N",  =W  等待审核 ==D 等待排队 其他则报名完成
//    "r_type": "2", "2"  buneng退出报名  其他则可以



-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn =[[UIButton alloc]initCustomButton];
        _exitBtn.cusFont =14.0f;
        _exitBtn.cusTitle =@"退出报名";
        _exitBtn.cusTitleColor =[UIColor whiteColor];
        _exitBtn.backgroundColor =TrainColorFromRGB16(0xFF9628);
        _exitBtn.layer.cornerRadius = 5;
        _exitBtn.layer.masksToBounds =YES;
        [_exitBtn addTarget:self action:@selector(exitButton)];
        
    }
    return _exitBtn;
}
-(UIButton *)registBtn{
    if (!_registBtn) {
        _registBtn =[[UIButton alloc]initCustomButton];
        _registBtn.cusFont =14.0f;
        _registBtn.cusTitleColor =[UIColor whiteColor];
        _registBtn.backgroundColor =TrainNavColor;
        _registBtn.layer.cornerRadius = 5;
        _registBtn.layer.masksToBounds =YES;
        [_registBtn addTarget:self action:@selector(buttonTouch)];
        
    }
    return _registBtn;
}
-(UIView *)succesView{
    
    
    if ( !_succesView) {
        _succesView =[[UIView alloc]init];
        _succesView.backgroundColor =TrainNavColor;
        _succesView.userInteractionEnabled =YES;
        _succesView.layer.cornerRadius = 5;
        _succesView.layer.masksToBounds =YES;
    
        UIImage  *image = [UIImage imageNamed:@"Train_Class_Detail_Rili"];
        NSString  *str = [TrainStringUtil trainGetNewTime];
        NSString  *signStr = [NSString stringWithFormat:@"%@   签到",str];
        
        
        signButton =[[TrainImageButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10) andImage:image andTitle:signStr];
        [signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        TrainWeakSelf(self);
        signButton.touchAction = ^(UIButton  *btn ){
            [weakself signBtn];
            
        };
        [_succesView addSubview:signButton];
        
       
    }
    return _succesView;
}



#pragma  mark  报名 退出

//e_not_in_time  当前时间不能退出报名
//e_require  你被指派报名，不允许退出

-(void)exitButton{
    [ self classRegisterStatus:NO];
}


//                r_has_reg  报名已经提交，不能重复报名
//                r_has_reg_wait  报名已经提交，在等待队列中
//                r_no_enable  报名还未开启
//                r_reg_end  报名已经结束

-(void)buttonTouch{
    
    [self classRegisterStatus:YES];
}

-(void)classRegisterStatus:(BOOL)isRegister{
    
    
    [self trainShowHUDOnlyActivity];
    TrainWeakSelf(self);
    
    [[TrainNetWorkAPIClient client] trainClassDetailRegisterWithisRegister:isRegister class_id:_class_id regiter_id:register_id Success:^(NSDictionary *dic) {
        
        if([dic[@"key"] isEqualToString:@"success"]){
            if ( !isRegister) {
                Regstatus = TrainClassRegisterStatusNone;
                [weakself updateDownUnRegistView];
            }else{
                [weakself judgeStatus:dic[@"class"]];
            }
            [weakself trainHideHUD];
        }else{
            [weakself trainShowHUDOnlyText:dic[@"msg"]];
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
       
        [weakself trainShowHUDNetWorkError];
    }];
}
#pragma mark 判断报名状态
-(void)judgeStatus:(NSDictionary *)dic{
    if (![dic[@"ru_status"] isEqualToString:@"S"]) {
        if ([dic[@"ru_wait_status"] isEqualToString:@"W"]) {
            Regstatus =TrainClassRegisterStatusWaiting;
        }else if([dic[@"ru_wait_status"] isEqualToString:@"D"]){
            Regstatus = TrainClassRegisterStatusLining;
        }else{
            Regstatus =TrainClassRegisterStatusNone;
        }
        
    }else{
        if (![dic[@"r_type"] isEqualToString:@"2"]) {
            Regstatus = TrainClassRegisterStatusFinishExit;
        }else{
            Regstatus = TrainClassRegisterStatusFinish;
        }
    }
    [self   updateDownUnRegistView];
}

// 显示 未开始 或 已结束的状态
- (void)showClassStatus{
    
    self.exitBtn.hidden     = YES;
    self.succesView.hidden  = YES;
    self.registBtn.hidden   = YES;
    
    if (self.status == RZClassStatusNotStart ) {
        _registBtn.cusTitle     = @"未开始" ;
        
    }else if (self.status == RZClassStatusEnd ){
        _registBtn.cusTitle     = @"已结束";
    }
    _registBtn.backgroundColor = [UIColor lightGrayColor];
    _registBtn.userInteractionEnabled =NO;
    self.registBtn.frame =CGRectMake((TrainSCREENWIDTH - 160)/2, 5, 160, 40);
    self.registBtn.hidden = NO;
}


#pragma  mark  签到
-(void)signBtn{
   
    [self trainShowHUDOnlyActivity];
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainClassSignInWithregiter_id:register_id Success:^(NSDictionary *dic) {
        if([dic[@"key"] isEqualToString:@"success"]){
            NSString  *str = [TrainStringUtil trainGetNewTime];
            NSString  *signStr = [NSString stringWithFormat:@"%@   已签到",str];
            
            signButton.cusTitle = signStr;
            [weakself trainShowHUDOnlyText:@"签到成功"];

        }else{
            [weakself trainShowHUDOnlyText:dic[@"msg"]];

        }
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        [weakself trainShowHUDNetWorkError];
    }];
    
    
}
#pragma   mark   - 数据请求

/**
 *  downLoad 班级课程列表 和 详情
 *
 *  @param index index
 */
-(void)downloadDate:(int )index{
    
    [self trainShowHUDOnlyActivity];
    
    [_classTableV dissTablePlace];
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainClassDetailWithClassMode:classMode class_id:_class_id curPage:index Success:^(NSDictionary *dic) {
        
        if (classMode == TrainClassModeCourse) {
            NSDictionary  *infoDic = dic[@"class"];
            if (TrainDictIsEmpty(classInfo)) {
                classInfo = dic[@"class"];
            }
            register_id = [infoDic[@"register_id"] stringValue];
            
            if (self.status == RZClassStatusDafeult) {
                [weakself judgeStatus:dic[@"class"]];
          
            }else {
                
                [self  showClassStatus];
            }
            NSString  *imageStr =(infoDic[@"picture"]) ? infoDic[@"picture"]:@"";
            NSString  *image ;
            if ([imageStr hasPrefix:@"/upload/class/pic/"]) {
                image = [TrainIP stringByAppendingFormat:@"%@",imageStr];
            }else{
                image = [TrainIP stringByAppendingFormat:@"/upload/class/pic/%@",imageStr];
            }
            self.classUrl = image;
            
            if (!_classTableV) {
                [weakself addCoursetableView];
            }
            
            if (index == 1) {
                courseMuArr = [NSMutableArray array];
            }
            NSArray  *dataArr =[TrainClassCourseModel  mj_objectArrayWithKeyValuesArray:dic[@"course"]];
            [courseMuArr addObjectsFromArray:dataArr];
            if (courseMuArr.count>0) {
                TrainClassCourseModel *modell =[courseMuArr firstObject];
                _classTableV.totalpages = [modell.totPage intValue];
            }
            
        }else  if(classMode == TrainClassModeDetail){
            
//            if (TrainDictIsEmpty(classInfo)) {
//                classInfo = dic[@"class"];
//            }
            weakself.gaiLanModel.content = classInfo[@"introduction"];

            NSArray  *dataArr =[TrainClassUserModel  mj_objectArrayWithKeyValuesArray:dic[@"lecturer"]];
            NSArray  *dataArr1 =[TrainClassUserModel  mj_objectArrayWithKeyValuesArray:dic[@"person"]];
            
            [classDetailMuArr addObject:dataArr];
            [classDetailMuArr addObject:dataArr1];
            
        }else if (classMode == TrainClassModeSurvey){
            if (index == 1) {
                surveyMuArr = [NSMutableArray array];
            }
            NSArray  *dataArr =[TrainExamModel  mj_objectArrayWithKeyValuesArray:dic[@"trainClassExam"]];
            [surveyMuArr addObjectsFromArray:dataArr];
            if (surveyMuArr.count>0) {
                TrainExamModel *modell =[surveyMuArr firstObject];
                _classTableV.totalpages = [modell.totPage intValue];
            }

        }else if (classMode == TrainClassModeEvaluate){
            if (index == 1) {
                evaluateMuArr = [NSMutableArray array];
            }
            NSArray  *dataArr =[TrainExamModel  mj_objectArrayWithKeyValuesArray:dic[@"trainClassExam"]];
            [evaluateMuArr addObjectsFromArray:dataArr];
            if (evaluateMuArr.count>0) {
                TrainExamModel *modell =[evaluateMuArr firstObject];
                _classTableV.totalpages = [modell.totPage intValue];
            }
            
        }else if (classMode == TrainClassModeExam){
            if (index == 1) {
                ExamMuArr = [NSMutableArray array];
            }
            NSArray  *dataArr =[TrainExamModel  mj_objectArrayWithKeyValuesArray:dic[@"trainClassExam"]];
            [ExamMuArr addObjectsFromArray:dataArr];
            if (ExamMuArr.count>0) {
                TrainExamModel *modell =[ExamMuArr firstObject];
                weakself.classTableV.totalpages = [modell.totPage intValue];
            }
            
        }
        
        _classTableV.trainMode = trainStyleNoData;
        [_classTableV EndRefresh];
        [weakself trainHideHUD];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        _classTableV.trainMode = trainStyleNoData;
        [_classTableV EndRefresh];
        [weakself trainShowHUDNetWorkError];
    }];
    
    
}





-(TrainClassMenuView *)topMenuView{
    if (!_topMenuView ) {
        
        NSArray  *arr = [TrainLocalData returnClassDetailMenu];
        
        _topMenuView =[[TrainClassMenuView alloc]initWithFrame:CGRectZero andArr:arr];
        _topMenuView.delegate = self;
        _topMenuView.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:_topMenuView];
        
        _topMenuView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topSpaceToView(self.view,TrainNavorigin_y)
        .heightIs(TrainCLASSHEIGHT);

    }
    return _topMenuView;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float   scroll_y =scrollView.contentOffset.y;
    if (scroll_y > imageViewHeight) {
        
        self.topMenuView.selectIndex = classMode;
        self.topMenuView.hidden =NO;
    }else{
        menuView.selectIndex = classMode;
        self.topMenuView.hidden =YES;
    }

}

-(void)creatheadView{
    classBgImageV =[[UIImageView alloc]init];
    UIImage  *classDefault = [UIImage imageNamed:@"train_class_default"];
    classBgImageV.image = classDefault;
    [tableHeadView addSubview:classBgImageV];

//    NSString  *imageUrl = [TrainIP stringByAppendingString:(_classUrl)?_classUrl:@""];
    
    [classBgImageV sd_setImageWithURL:[NSURL URLWithString:self.classUrl] placeholderImage:classDefault options:SDWebImageAllowInvalidSSLCertificates];
    NSArray  *arr = [TrainLocalData returnClassDetailMenu];

    menuView =[[TrainClassMenuView alloc]initWithFrame:CGRectZero andArr:arr];
    menuView.delegate = self;
    menuView.backgroundColor =[UIColor whiteColor];
    [tableHeadView addSubview:menuView];

    classBgImageV.sd_layout
    .leftEqualToView(tableHeadView)
    .rightEqualToView(tableHeadView)
    .topEqualToView(tableHeadView)
    .heightIs(imageViewHeight);
    
    
    menuView.sd_layout
    .leftEqualToView(tableHeadView)
    .rightEqualToView(tableHeadView)
    .topSpaceToView(classBgImageV,0)
    .heightIs(TrainCLASSHEIGHT);
    
}

-(void)TrainClassMenuSelectIndex:(int)index{
    classMode = index;
    _classTableV.bounces = (index == 1)?NO:YES;
    
    if (classMode == TrainClassModeCourse ) {
      
        if (TrainArrayIsEmpty(courseMuArr)) {
            [self downloadDate:1];
        }else{
            [_classTableV train_reloadData];
 
        }
   
    }else if (classMode == TrainClassModeDetail){
       
        if (TrainArrayIsEmpty(classDetailMuArr)){
          [self downloadDate:1];
        }else{
            [_classTableV train_reloadData];
        }
        
    }else if (classMode == TrainClassModeSurvey){
        
        if (TrainArrayIsEmpty(surveyMuArr)) {
            [self downloadDate:1];
        }else{
            [_classTableV train_reloadData];

        }

    }else if (classMode == TrainClassModeEvaluate){
        
        if (TrainArrayIsEmpty(evaluateMuArr)) {
            [self downloadDate:1];
        }else{
            [_classTableV train_reloadData];
            
        }

    }else if (classMode == TrainClassModeExam){
        
        if (TrainArrayIsEmpty(ExamMuArr)) {
            [self downloadDate:1];
        }else{
            [_classTableV train_reloadData];
            
        }

    }
}


-(void)addCoursetableView{
    
    tableHeadView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, imageViewHeight + TrainCLASSHEIGHT )];
    [self creatheadView];
    tableViewRefresh   refresh = tableViewRefreshFooter ;
    
    _classTableV =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight-DownHeight) andTableStatus:refresh];
    _classTableV.backgroundColor=[UIColor whiteColor];
    _classTableV.dataSource =self;
    _classTableV.delegate =self;
    _classTableV.tableHeaderView =tableHeadView;
    self.classTableV.rowHeight =100;
    self.classTableV.tag =1;
    _classTableV.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    _classTableV.separatorStyle =UITableViewCellSeparatorStyleNone;
    _classTableV.showsVerticalScrollIndicator =NO;
    [self.view addSubview:_classTableV];
    
    TrainWeakSelf(self);
    _classTableV.headBlock = ^{
        
        [weakself downloadDate:1];
        
    };
    _classTableV.footBlock = ^(int index) {
        [weakself downloadDate:index];

    };
    
    
    [self.classTableV registerClass:[TrainClassCourseListCell class]  forCellReuseIdentifier:@"CourseCell"];
    [self.classTableV registerClass:[TrainClassDetailCell class]  forCellReuseIdentifier:@"ClassCell"];
    [self.classTableV registerClass:[TrianExamListCell class]  forCellReuseIdentifier:@"examCell"];

    
}

//-(TrainBaseTableView *)classTableV{
//    
//    if (_classTableV) {
//        _classTableV =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavHeight, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight-DownHeight) andTableStatus:refresha];
//        _classTableV.backgroundColor=[UIColor whiteColor];
//        _classTableV.dataSource =self;
//        _classTableV.delegate =self;
//        _classTableV.tableHeaderView =tableHeadView;
//        self.classTableV.rowHeight =100;
//        self.classTableV.tag =1;
//        _classTableV.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
//        _classTableV.separatorStyle =UITableViewCellSeparatorStyleNone;
//        _classTableV.showsVerticalScrollIndicator =NO;
//        
//        [self.classTableV registerClass:[TrainClassCourseListCell class]  forCellReuseIdentifier:@"CourseCell"];
//        [self.classTableV registerClass:[TrainClassDetailCell class]  forCellReuseIdentifier:@"ClassCell"];
//        [self.classTableV registerClass:[TrianExamListCell class]  forCellReuseIdentifier:@"examCell"];
//    }
//    return _classTableV;
//}

-(TraingailanDatelisModel *)gaiLanModel{
    if (!_gaiLanModel) {
        TraingailanDatelisModel *gaimodel =[[TraingailanDatelisModel alloc]init];
        gaimodel.content = @"";
        gaimodel.isOpen  = NO;
        _gaiLanModel  = gaimodel;
        
    }
    return _gaiLanModel;
}
#pragma mark - tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (classMode == TrainClassModeDetail) {
        return ClassHeaderArr.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (classMode == TrainClassModeDetail) {
        NSInteger   num = 0;
        if (section !=0) {
            if (classDetailMuArr.count > 0) {
               NSInteger count = [classDetailMuArr[section - 1] count];
                num = (count > maxNum)?maxNum:count;
            }else {
                num = 0;
            }
        }else  if (section == 0){
            num = 1;
        }
        return num;
    }else if (classMode == TrainClassModeCourse){
        
        return  (TrainArrayIsEmpty(courseMuArr))?0:courseMuArr.count;
    
    }else if (classMode == TrainClassModeSurvey){
    
        return  (TrainArrayIsEmpty(surveyMuArr))?0:surveyMuArr.count;

    }else if (classMode == TrainClassModeEvaluate){

        return  (TrainArrayIsEmpty(evaluateMuArr))?0:evaluateMuArr.count;

    }else if (classMode == TrainClassModeExam){

        return  (TrainArrayIsEmpty(ExamMuArr))?0:ExamMuArr.count;

    }
    
    return 0 ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainWeakSelf(self);

    if (classMode == TrainClassModeCourse) {
      
        TrainClassCourseListCell *courseCell =[tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
        TrainClassCourseModel *mod =courseMuArr[indexPath.row];
        courseCell.model = mod;
        
        return courseCell;
        
    }else if (classMode == TrainClassModeDetail){
      
        TrainClassDetailCell *detailCell =[tableView dequeueReusableCellWithIdentifier:@"ClassCell"];
        if (indexPath.section ==0) {
            detailCell.isDetail =YES;
            detailCell.selectionStyle =UITableViewCellSelectionStyleNone;
            detailCell.gailanModel =self.gaiLanModel;
            
            
            detailCell.gaiLanUnfoldblock =^(){
                weakself.gaiLanModel.isOpen =!weakself.gaiLanModel.isOpen;
                [ weakself.classTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
        }else{
            NSArray   *arr =classDetailMuArr[indexPath.section-1];
            TrainClassUserModel  *mod =arr[indexPath.row];
            detailCell.status = indexPath.section;
            detailCell.isDetail = NO;
            detailCell.model =  mod;
            
        }
        return detailCell;

    }
    TrainExamModel  *listModel;
    TrianExamListCell  *     examCell=[tableView dequeueReusableCellWithIdentifier:@"examCell"];

    if (classMode == TrainClassModeSurvey) {
        
        listModel = surveyMuArr [indexPath.row];
    }else if (classMode == TrainClassModeEvaluate) {
        
        listModel = evaluateMuArr[indexPath.row];

    }else if (classMode == TrainClassModeExam) {
        
        listModel = ExamMuArr[indexPath.row];
    }

    examCell.isHasLogo = NO;
    examCell.model = listModel;
    examCell.isCanLearn = (self.status == RZClassStatusDafeult);

    examCell.returnWebUrlBlock =^(NSString *webUrl ){
        
        [weakself getoWebViewWithUrl:webUrl andmodel:listModel];
    };
    return examCell;
  
}

-(void)getoWebViewWithUrl:(NSString *)webURL andmodel:(TrainExamModel *)model{
    
    if(self.status == RZClassStatusDafeult){
        
        if (Regstatus == TrainClassRegisterStatusFinish || Regstatus == TrainClassRegisterStatusFinishExit){
            
            TrainWebViewController *webVC =[[TrainWebViewController alloc]init];
            webVC.webURL =webURL;
            webVC.navTitle = model.name;
            webVC.isCourse = YES ;
            [self.navigationController pushViewController:webVC animated:YES];
            
        }else{
            
            [self trainShowHUDOnlyText:@"您还没有报名,请先去报名"];
        }
    }else {
        
        NSString *msgText;
        if (self.status == RZClassStatusNotStart) {
            
            msgText = @"该班级尚未开启";
        }else {
            msgText = @"该班级已结束";
        }
        
        [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:msgText buttonTitle:@"知道了" buttonStyle:TrainAlertActionStyleCancel];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (classMode == TrainClassModeCourse) {
        
        return 100;
        
    }else if (classMode == TrainClassModeDetail) {
        
        if (indexPath.section ==0) {
            return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:TrainSCREENWIDTH tableView:tableView];
        }
        
        return 60;
    }else if (classMode == TrainClassModeExam || classMode == TrainClassModeEvaluate ||classMode == TrainClassModeSurvey ) {
        
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:TrainSCREENWIDTH tableView:tableView];
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (classMode == TrainClassModeDetail)?40:0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (classMode == TrainClassModeDetail)?10:0.010;
}

#pragma mark -tableView  头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (classMode == TrainClassModeDetail) {
        
        TrainClassMoreHeaderView *header =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
        if (!header) {
            header =[[TrainClassMoreHeaderView alloc]initWithReuseIdentifier:@"Header"];
        }
        NSString  *num = @"";
        BOOL   isShow =NO;;
        
        if (section >= 1 && classDetailMuArr.count > 0) {
            NSArray   *arr =classDetailMuArr[section-1];
            
            if (arr.count > 0) {
                TrainClassUserModel  *mod =arr[0];
                num =(mod.totCount && mod.totCount.intValue ==0)?@"":[NSString stringWithFormat:@"(%@)",mod.totCount];
                if (mod.totCount.intValue > maxNum) {
                    isShow =YES;
                }
            }
        }else{
            num = @"";
        }
        TrainWeakSelf(self);

        header.title =[NSString stringWithFormat:@"%@ %@",ClassHeaderArr[section],num];
        header.isshowMore =isShow;
        header.headerTouch =^(){
            [weakself gotoClassMore:ClassHeaderArr[section]];
            
        };
        return header;
    }
    
    return  nil;
}

-(void)gotoClassMore:(NSString *)name{
    TrainClassMoreViewController *moreVC =[[TrainClassMoreViewController alloc]init];
    moreVC.navTitle = name;
    moreVC.class_id = self.class_id;

    [self.navigationController pushViewController:moreVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (classMode == TrainClassModeDetail) {
        
        UIView   *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 10)];
        view.backgroundColor =[UIColor groupTableViewBackgroundColor];
        
        return view;
    }
    
    return  nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.status == RZClassStatusDafeult) {
       
        if(classMode == TrainClassModeCourse){
            
            if (Regstatus == TrainClassRegisterStatusFinish || Regstatus == TrainClassRegisterStatusFinishExit ) {
                TrainClassCourseModel *mod =courseMuArr[indexPath.row];
                
                TrainNewMovieViewController  *newVC =[[TrainNewMovieViewController alloc]init];
                newVC.hidesBottomBarWhenPushed = YES;
                NSDictionary  *dic = [mod mj_keyValues];
                newVC.courseDic = dic;
                [self.navigationController pushViewController:newVC animated:YES];
                
                
            }else{
                
                [self trainShowHUDOnlyText:@"您还没有报名,请先去报名"];
            }
            
        }
    }else {
        

        NSString *msgText;
        if (self.status == RZClassStatusNotStart) {
            
            msgText = @"该班级尚未开启";
            
        }else {
            msgText = @"该班级已结束";
        }
        
        
        [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:msgText buttonTitle:@"知道了" buttonStyle:TrainAlertActionStyleCancel];
        
    }
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
