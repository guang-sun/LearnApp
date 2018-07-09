//
//  TrainNewClassInfoViewController.m
//  KindeeTrain
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainNewClassInfoViewController.h"
#import "TrainClassInfoTableViewCell.h"
#import "TrainClassMatesTableViewCell.h"
#import "TrainClassInfoSectionView.h"
#import "TrainClassDetailModel.h"
#import "TrainClassMoreViewController.h"


@interface TrainNewClassInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString  *tactic_id;
@property (nonatomic, assign) BOOL    isMore;

@property (nonatomic, copy) NSString  *classIntro;

@property (nonatomic, copy) NSString  *gradeText;

@property (nonatomic, strong) NSArray  *mateArr;

@end

@implementation TrainNewClassInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self rzaddTableview];
    
    [self downloadInfoDate];
    self.isMore = NO ;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        self.infoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self rzgetClassGradeInfo];
    
    // Do any additional setup after loading the view.
}

#pragma mark - WMStickyPageViewControllerDelegate
- (UIScrollView *)stretchScrollView {
    return self.infoTableView;
}


-(void)downloadInfoDate{
    
    [self trainShowHUDOnlyActivity];
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainClassDetailWithClassMode:TrainClassModeDetail class_id:_class_id curPage:1 Success:^(NSDictionary *dic) {
        
//        weakself.gaiLanModel.content = classInfo[@"introduction"];
//
//        NSArray  *dataArr =[TrainClassUserModel  mj_objectArrayWithKeyValuesArray:dic[@"lecturer"]];
        NSArray  *dataArr1 =[TrainClassUserModel  mj_objectArrayWithKeyValuesArray:dic[@"person"]];
        weakself.mateArr = dataArr1 ;
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:2];
        [self.infoTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        
        [weakself trainHideHUD];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        
        [weakself trainShowHUDNetWorkError];
    }];
    
    
}
- (void)rzGetGradeInfo {
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainClassGradeInfoWithClass_id:self.class_id tactic_id:self.tactic_id Success:^(NSDictionary *dic) {
        
        [weakself rzGradeInfoWithDic:dic];
    
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
       
        
    }];
    
}

- (void)rzGradeInfoWithDic:(NSDictionary *)dic {
    
    NSMutableString  *grade = [NSMutableString string];
    
    NSString *totalscore = [dic[@"totalscore"] stringValue];
    NSString *passscore  = [dic[@"passscore"] stringValue];
    NSArray  *gradArr    = dic[@"tactics"];
    if (!TrainStringIsEmpty(totalscore)) {
        [grade appendFormat:@"总分: %@分",totalscore];
    }
    if(!TrainStringIsEmpty(passscore)){
        [grade appendFormat:@"及格分: %@分\n",passscore];
    }
    if (!TrainArrayIsEmpty(gradArr)) {
        
        [gradArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [grade appendFormat:@"%zi %@",idx + 1 , obj];
            if (idx + 1 < gradArr.count ) {
                [grade appendString:@"\n"];
            }
        }];
 
    }
    self.gradeText = grade ;
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
    [self.infoTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    
}


- (void)rzaddTableview {
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TrainClassInfoSectionView  *sectionview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([TrainClassInfoSectionView class])];
    
    NSString  *titleText = @"" ;
    if (section == 0) {
        titleText = @"班级简介" ;
    }else if (section == 1) {
        titleText = @"成绩策略" ;
    }else if (section == 2) {
        titleText = @"同班同学" ;
    }
    sectionview.title = titleText ;
    sectionview.isMore = NO ; // (section == 2)  ;
    
    return  sectionview ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrainWeakSelf(self);
    if (indexPath.section == 2) {
       
        TrainClassMatesTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TrainClassMatesTableViewCell class])];
        
        cell.gradeArr = self.mateArr ;
        cell.rzgetMoreMatesblock = ^{
            [weakself rzPushAllClassMates];
        };
        
        return cell ;
    }    
    TrainClassInfoTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TrainClassInfoTableViewCell class])];
    cell.isShowMore = (indexPath.section == 0) ;
    cell.isMore = (indexPath.section == 0) ? self.isMore : YES ;

    if (indexPath.section == 0) {
        cell.contentText = self.classIntro ;
    }else if (indexPath.section ==1) {
        cell.contentText = self.gradeText ;
    }

    cell.rzMoreBlock = ^(BOOL isSelect) {
        weakself.isMore = isSelect ;
        [tableView reloadData];
    } ;
    
    return cell ;
}


- (void)rzPushAllClassMates {
    
    TrainClassMoreViewController *moreVC =[[TrainClassMoreViewController alloc]init];
    moreVC.navTitle = @"班级学员";
    moreVC.class_id = self.class_id;
    
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)setClassInfo:(NSDictionary *)classInfo {
    _classInfo = classInfo ;
    if (TrainStringIsEmpty(self.tactic_id)) {
        self.tactic_id = [classInfo[@"tactic_id"] stringValue];
        NSString *info = classInfo [@"introduction"];
        self.classIntro = (TrainStringIsEmpty(info)) ? @"暂无简介" :  info ;
        
        [self rzGetGradeInfo ];

//        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
//        [self.infoTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        
        
    }
}


- (TrainBaseTableView *)infoTableView {
    if (!_infoTableView) {
        TrainBaseTableView *tableview =[[TrainBaseTableView alloc]initWithFrame:CGRectZero  andTableStatus:tableViewRefreshNone];

        tableview.delegate    = self;
        tableview.dataSource  = self;
        tableview.rowHeight   = UITableViewAutomaticDimension ;
        tableview.estimatedRowHeight   = trainAutoLoyoutImageSize(100) ;
        
        UINib  *nib =[UIView loadNibNamed:@"TrainClassInfoSectionView"];
        [tableview registerNib:nib forHeaderFooterViewReuseIdentifier:@"TrainClassInfoSectionView"];
        [tableview registerClass:[TrainClassInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TrainClassInfoTableViewCell class])];
        [tableview registerClass:[TrainClassMatesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TrainClassMatesTableViewCell class])];

        _infoTableView = tableview ;
    }
    return _infoTableView ;
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
