//
//  TrainNewCouseHourViewController.m
//  KindeeTrain
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainNewCouseHourViewController.h"
#import "TrainClassPhaseModel.h"

#import "TrainClassExamCell.h"
#import "TrainClassResCourseCell.h"
#import "TrainClassCourseHourCell.h"
#import "TrainWebViewController.h"
#import "TrainClassExamRecordCell.h"


NSString   *const   kRZClassResCourseCell = @"RZClassResCourseCell" ;
NSString   *const   kRZClassExamResCell   = @"RZClassExamResCell" ;
NSString   *const   kRZClassCourseHourCell = @"RZClassCourseHourCell" ;
NSString   *const   kRZClassExamRecordCell = @"RZClassExamRecordCell" ;


@interface TrainNewCouseHourViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger      selectIndex ; // 资源阶段
    
    NSIndexPath    *currIndex ;
    
}
@property(nonatomic, strong) NSArray                *phaseArr ;
@property(nonatomic, strong) NSMutableDictionary    *phaseMuDic ;
@property(nonatomic, strong) NSMutableArray         *currResMuArr ;
@property(nonatomic, strong) NSMutableDictionary    *hourMuDic ;

@property(nonatomic, strong) UIView     *resBgView ;
@property(nonatomic, strong) UIButton   *leftButton ;
@property(nonatomic, strong) UIButton   *rightButton ;
@property(nonatomic, strong) UILabel    *contentLabel ;


@end

@implementation TrainNewCouseHourViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.phaseArr.count == 0) {
        [self rzGetClassResData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectIndex = 0 ;
    currIndex  = [NSIndexPath indexPathForRow:0 inSection:0 ];
    
    
    [self rzaddTopView];
    [self rzAddSubView];
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        self.infoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currResMuArr = [NSMutableArray arrayWithCapacity:1];
    // Do any additional setup after loading the view.
}

#pragma mark - WMStickyPageViewControllerDelegate
- (UIScrollView *)stretchScrollView {
    return self.infoTableView;
}

- (void)rzaddTopView {
    
    [self.view addSubview:self.resBgView ];
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.rightButton];
    [self.view addSubview:self.contentLabel];
    
    [self.resBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view ).offset(5);
        make.top.equalTo(self.view ).offset(5);
        make.right.equalTo(self.view ).offset(-5);
        make.height.mas_equalTo(50);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.resBgView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(15);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.resBgView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(15);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftButton.mas_right);
        make.right.equalTo(self.rightButton.mas_left);
        make.centerY.equalTo(self.resBgView);
        make.height.mas_equalTo(40);

    }];
}


- (void)rzAddSubView {
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resBgView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}


- (void)rzlastPhaseRes {
    
    if (selectIndex == 0) {
        [TrainProgressHUD showMessage:@"没有上一个阶段了" inView:self.view];
    }else {
        
        [self rzgetCurrPhaseMode:selectIndex -1];
        
    }
}

- (void)rzNextPhaseRes {
    
    if (selectIndex == _phaseArr.count - 1) {
        [TrainProgressHUD showMessage:@"没有下一个阶段了" inView:self.view];
    }else {
        
        [self rzgetCurrPhaseMode:selectIndex + 1];
    }
}

- (void)rzgetCurrPhaseMode:(NSInteger )index {
    
    if (index <  _phaseArr.count && index >= 0 ) {
        selectIndex = index ;
        TrainClassPhaseModel *model = _phaseArr [index] ;
        
        self.contentLabel .text = model.sec_name ;
        
        TrainWeakSelf(self);
        [self trainShowHUDOnlyActivity];

        [[TrainNetWorkAPIClient client] trainClassphaseResoureWithClass_id:self.class_id sec_id:model.sec_id Success:^(NSDictionary *dic) {
            
            NSArray *arr = [TrainClassResModel mj_objectArrayWithKeyValuesArray:dic[@"classJdRes"]];
            weakself.currResMuArr = [NSMutableArray arrayWithArray:arr] ;
            [weakself.infoTableView reloadData];
            [weakself trainHideHUD];
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            
            [weakself trainHideHUD];

        }] ;
    }
}


- (void)rzClassHourOpen:(UIButton *)button {
    
    if (button.tag < self.currResMuArr.count ) {
        
        TrainClassResModel *model = self.currResMuArr[button.tag] ;
        if (!model.isOpen) {
            
            if ([model.obj_type isEqualToString:@"EXAM"] || [model.obj_type isEqualToString:@"EVALUATE"] || [model.obj_type isEqualToString:@"SURVEY"]  ) {
               
                model.isOpen = YES ;
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:button.tag];
                [self.infoTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
            }else {
             
                if (model.resList.count > 0) {
                    
                    model.isOpen = YES ;
                    
                    NSIndexSet *set = [NSIndexSet indexSetWithIndex:button.tag];
                    [self.infoTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
                }else {
                    
                    [self rzGetPhasehourListWithModel:model index:button.tag];
                }
            }
        }else {
       
            model.isOpen = NO ;
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:button.tag];
            [self.infoTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)rzGetPhasehourListWithModel:(TrainClassResModel *)model  index:(NSInteger )index{
    
    [self trainShowHUDOnlyActivity];
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainClassPhaseHourListWithClass_id:self.class_id c_id:model.c_id room_id:model.classroom_id Success:^(NSDictionary *dic) {
        
        NSArray *arr = [TrainCourseDirectoryModel mj_objectArrayWithKeyValuesArray:dic[@"hour"]];
        model.resList = arr ;
        model.isOpen = YES ;
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [weakself.infoTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        
        [weakself trainHideHUD];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        [weakself trainHideHUD];
    }];
    
}


#pragma  mark - download DATA
- (void)rzGetClassResData {
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainClassphaseInfoWithClass_id:self.class_id Success:^(NSDictionary *dic) {
        
        weakself.phaseArr = [TrainClassPhaseModel mj_objectArrayWithKeyValuesArray:dic[@"classJdList"]];
        [weakself rzgetCurrPhaseMode:selectIndex];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }] ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.currResMuArr.count  ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TrainClassResModel *model = self.currResMuArr[section] ;
    if (model.isOpen ) {
        
        if ([model.obj_type isEqualToString:@"EXAM"] || [model.obj_type isEqualToString:@"EVALUATE"] || [model.obj_type isEqualToString:@"SURVEY"]  ) {

            return  2 ;
        }else {
            
            return model.resList.count + 1 ;
        }
    }
    return 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 30 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TrainClassFootView"];
    while (footView.subviews.count) {
        [footView.subviews.lastObject removeFromSuperview];
    }
    UIView  *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, TrainSCREENWIDTH , 30);
    [footView addSubview:view];
    
    UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
    TrainClassResModel *model = self.currResMuArr[section] ;
    UIImage *downImage = [UIImage imageNamed:@"Train_Select_down"] ;
    downImage = [downImage imageByScalingAndCroppingForSize:CGSizeMake(30, 15)];

    UIImage *upImage = [UIImage imageNamed:@"Train_Select_up"] ;
    upImage = [upImage imageByScalingAndCroppingForSize:CGSizeMake(30, 15)];

    
    [button setImage:downImage forState:UIControlStateNormal];
    [button setImage:upImage forState:UIControlStateSelected];
    button.selected = model.isOpen ;
    
    button.tag = section ;
    [button addTarget:self action:@selector(rzClassHourOpen:)];
    [view addSubview:button];
    button.frame = CGRectMake(15, 5, TrainSCREENWIDTH - 30, 20);
    return footView ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TrainClassResModel *model = self.currResMuArr[indexPath.section] ;

    if (indexPath.row == 0 ) {
        if ([model.obj_type isEqualToString:@"CROOM"]) {

            TrainClassResCourseCell *resCell = [tableView dequeueReusableCellWithIdentifier:kRZClassResCourseCell];
            [resCell rzUpdateClassResCellWithModel:model];
            
            return resCell ;
        }
        
        TrainClassExamCell *examCell = [tableView dequeueReusableCellWithIdentifier:kRZClassExamResCell];
        [examCell rzUpdateClassResCellWithModel:model];

        return examCell ;
    }
    
    if ([model.obj_type isEqualToString:@"EXAM"] || [model.obj_type isEqualToString:@"EVALUATE"] || [model.obj_type isEqualToString:@"SURVEY"]  ) {
    
        TrainClassExamRecordCell  *cell = [tableView dequeueReusableCellWithIdentifier:kRZClassExamRecordCell];
        [cell rzUpdateClassExamWithModel:model];
        
        TrainWeakSelf(self);
        cell.rzClassExamJoinBlock = ^(NSString *webURL) {
            [weakself getoWebViewWithUrl:model.starting_url andwebName:model.obj_name];
        };
        cell.rzClassExamReadBlock = ^(NSString *webURL) {
            [weakself getoWebViewWithUrl:webURL andwebName:model.obj_name];

        };
        return cell ;
    }
    TrainClassCourseHourCell *hourCell = [tableView dequeueReusableCellWithIdentifier:kRZClassCourseHourCell];
    
    NSArray  *hourList = model.resList ;
    if (indexPath.row - 1 < hourList.count) {
        hourCell.model = hourList [indexPath.row - 1] ;
    }

    return hourCell ;
}

-(void)getoWebViewWithUrl:(NSString *)webURL andwebName:(NSString *)webName{
    
    TrainWebViewController *webVC =[[TrainWebViewController alloc]init];
    webVC.webURL =webURL;
    webVC.navTitle = webName;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row != 0) {
       
        if (!self.isRegister) {
            
            [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:@"您还没有报名，请先报名" buttonTitle:@"确定" buttonStyle:TrainAlertActionStyleCancel];
            
        }else{
            
            TrainClassResModel *model = self.currResMuArr[indexPath.section] ;
            NSArray  *hourList = model.resList ;
            if (indexPath.row - 1 < hourList.count) {
                TrainCourseDirectoryModel *model = hourList [indexPath.row - 1] ;
                if ([model.condition isEqualToString:@"O"]) {
               
                    [self ordertoplaymovieWithSelectRow:indexPath];
                    
                }else {
                    
                    [self playerWithHour:model];
                }
                currIndex = indexPath ;
            }
        }
    }else {
       
        if (!self.isRegister) {
            
            [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:@"您还没有报名，请先报名" buttonTitle:@"确定" buttonStyle:TrainAlertActionStyleCancel];
            
        }else{
         
            TrainClassResModel *model = self.currResMuArr[indexPath.section] ;
            if ([model.obj_type isEqualToString:@"EXAM"] || [model.obj_type isEqualToString:@"EVALUATE"] || [model.obj_type isEqualToString:@"SURVEY"]  ) {
                
                TrainWebViewController *webVC =[[TrainWebViewController alloc]init];
                webVC.webURL = model.starting_url;
                webVC.navTitle = model.obj_name;
                webVC.isCourse = YES ;
                [self.navigationController pushViewController:webVC animated:YES];
                
            }
        }
    }
    
}

//按顺序进行播放
-(void)ordertoplaymovieWithSelectRow:(NSIndexPath *)selectRow{
    
    TrainClassResModel *model = self.currResMuArr[selectRow.section] ;
    NSArray  *hourList = model.resList ;
    if (selectRow.row - 1 < hourList.count) {
        TrainCourseDirectoryModel *hourModel = hourList [selectRow.row - 1] ;
        
        if ([hourModel.h_type isEqualToString:@"H"] ||[hourModel.h_type isEqualToString:@"E"] ) {
            
            BOOL   isplayer = YES;
            for ( int i = (int)selectRow; i >0; i--) {
                TrainCourseDirectoryModel  *listHour = hourList[i-1];
                if ([listHour.h_type isEqualToString:@"H"] ||[listHour.h_type isEqualToString:@"E"]  ) {
                    if ( ![listHour.ua_status isEqualToString:@"C"]  && ![listHour.ua_status isEqualToString:@"P"]) {
                        isplayer = NO;
                    }
                }
            }
            if (isplayer) {
                
                [self playerWithHour:hourModel];
                
            }else{
                [TrainProgressHUD showMsgWithoutView:TrainOrderToPlayText];
                
            }
        }
    }

}

-(void)autoPlayHour  {
    
    
    TrainClassResModel *model = self.currResMuArr[currIndex.section] ;
    NSArray  *hourList = model.resList ;
//    if (selectRow.row - 1 < hourList.count) {
//        TrainCourseDirectoryModel *hourModel = hourList [selectRow.row - 1] ;
    NSInteger   currHourIndex = currIndex.row - 1 ;
    if(currHourIndex   >= 0 && currHourIndex < hourList.count){
        
        BOOL  isPlayer = NO ;
        TrainCourseDirectoryModel *nextHour ;
        for ( NSInteger i = currHourIndex + 1; i < hourList.count ; i++) {
            TrainCourseDirectoryModel  *listHour = hourList[i];
            if ([listHour.h_type isEqualToString:@"H"] ||[listHour.h_type isEqualToString:@"E"]  ) {
                nextHour = listHour ;
                isPlayer = YES ;
                selectIndex = i ;
                break ;
            }
        }
        if (isPlayer) {
            
            NSString  *title ;
            
            if([nextHour.c_type isEqualToString:@"V"] || [nextHour.c_type isEqualToString:@"L"]){
                
                NSIndexPath *selectRow = [NSIndexPath indexPathForRow:selectIndex inSection:0];
                [self.infoTableView selectRowAtIndexPath:selectRow animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                [self tableView:self.infoTableView didSelectRowAtIndexPath:selectRow];
                
                return ;
            }else if([nextHour.c_type isEqualToString:@"D"] ){
                
                if([nextHour.list_init_file isEqualToString:@"pic_txt"]){
                    title = @"下一个课时为图文,是否开始学习?";
                    
                }else {
                    title = @"下一个课时为文档,是否开始学习?";
                }
                
            }else  if([nextHour.c_type isEqualToString:@"E"] ){
                
                title = @"下一个课时为考试,是否开始学习?";
                
            }else  if([nextHour.c_type isEqualToString:@"O"]){
                
                title = @"下一个课时为链接,是否开始学习?";
                
            }else  if([nextHour.c_type isEqualToString:@"P"]){
                
                if ([nextHour.h5 isEqualToString:@"H"]){
                    
                    title = @"下一个课时为H5课程包,是否开始学习?";
                }else {
                    title = @"下一个课时为课程包,暂不支持移动端播放,请到PC端观看";
                    [TrainAlertTools  showTipAlertViewWith:self title:@"提示" message:title buttonTitle:@"好的" buttonStyle:TrainAlertActionStyleCancel];
                    
                    return ;
                }
                
            }else if ([nextHour.h5 isEqualToString:@"H"]){
                
                title = @"下一个课时为H5课程包,是否开始学习?";
            }
            
            [TrainAlertTools showAlertWith:self title:@"提示" message:title callbackBlock:^(NSInteger btnIndex) {
                
                if(btnIndex ==1){
                    
                    NSIndexPath *selectRow = [NSIndexPath indexPathForRow:selectIndex inSection:0];
                    [self tableView:self.infoTableView didSelectRowAtIndexPath:selectRow];
                    [self.infoTableView selectRowAtIndexPath:selectRow animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                    
                }
                
            } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
            
        }else{
            
            [TrainProgressHUD showMsgWithoutView:@"没有下一个课时了"];
        }
        
    }
}

-(void)updateLearningRecord:(TrainCourseDirectoryModel *)hourModel andreload:(BOOL)isReload{
    
    TrainClassResModel *model = self.currResMuArr[currIndex.section] ;
    if ([model.obj_type isEqualToString:@"EXAM"] || [model.obj_type isEqualToString:@"EVALUATE"] || [model.obj_type isEqualToString:@"SURVEY"]  ) {
        
    }else {
        
        [self rzGetPhasehourListWithModel:model index:currIndex.section];
        
    }
}



-(void)updateCurrentHourDataWithVC:(TrainCourseDirectoryModel *)hourModel {
    
    [self playerWithHour:hourModel];
}
// 根据课时不同进行处理
-(void)playerWithHour:(TrainCourseDirectoryModel *)hourModel{
    
    if ([hourModel.h_type isEqualToString:@"H"] ||[hourModel.h_type isEqualToString:@"E"] ) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(WMTableviewSelect:)]) {
            [self.delegate WMTableviewSelect:hourModel];
        }
    }
    if([hourModel.c_type isEqualToString:@"D"] || [hourModel.c_type isEqualToString:@"E"]){
        
        NSString *urlString = @"";
        if ([hourModel.c_type isEqualToString:@"D"]) {
            
            if([hourModel.list_init_file isEqualToString:@"pic_txt"]){
                
                urlString = hourModel.starting_url ;
            }else {
                
                urlString = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"viewcoursedoc" object_id:hourModel.list_init_file andtarget_id:nil];
            }
            
        }else if([hourModel.c_type isEqualToString:@"E"]){
            
            urlString = hourModel.starting_url ;
            //            urlString = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"onlineExam" object_id:hourModel.object_id andtarget_id:@"0"];
        }
        TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
        webVC.webURL = urlString;
        webVC.navTitle = hourModel.title;
        webVC.hourtype = hourModel.c_type;
        webVC.isCourse = YES ;
        
        TrainWeakSelf(self);
        webVC.updataHourStatus = ^(NSString *hourStatus,NSString *score,NSString *exam_time){
            
            if ([hourModel.c_type isEqualToString:@"E"]) {
                
                if (![hourModel.ua_status isEqualToString:@"C"]) {
                    
                    [weakself updateExamHourWithmodel:hourModel];
                }
            }else if ([hourModel.c_type isEqualToString:@"D"]){
                if ( ![hourModel.ua_status isEqualToString:@"C"]) {
                    
                    hourModel.ua_status = @"C";
                    [weakself finishExamOrDoc:YES andListModel:hourModel andExamStatus:hourStatus andExamScore:score andExamtime:exam_time];
                }
                
            }
        };
        [self.navigationController pushViewController:webVC animated:YES];
        
        
    }else if([hourModel.c_type isEqualToString:@"V"] || [hourModel.c_type isEqualToString:@"L"]){
        
        
        
    }else if([hourModel.c_type isEqualToString:@"O"]){
        
        TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
        webVC.webURL = hourModel.starting_url;
        webVC.navTitle = hourModel.title;
        webVC.isCourse = YES ;
        [self finishExamOrDoc:YES andListModel:hourModel andExamStatus:nil   andExamScore:nil andExamtime:nil];
        [self.navigationController pushViewController:webVC animated:YES];
        
        
    }else if ([hourModel.c_type isEqualToString:@"P"]){
        
        if ([hourModel.is_free isEqualToString:@"H"] ) {
            
            TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
            webVC.webURL = hourModel.starting_url;
            webVC.navTitle = hourModel.title;
            webVC.isCourse = YES ;
            [self.navigationController pushViewController:webVC animated:YES];
        }else{
            
            [TrainAlertTools  showTipAlertViewWith:self title:@"提示" message:TrainHourNotSupportText buttonTitle:@"好的" buttonStyle:TrainAlertActionStyleCancel];
            
        }
        
    }else if ([hourModel.h5 isEqualToString:@"H"]){
        
        TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
        webVC.webURL = hourModel.starting_url;
        webVC.navTitle = hourModel.title;
        webVC.isCourse = YES ;
        
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else
    {
        
        //        [TrainAlertTools  showTipAlertViewWith:self title:@"提示" message:TrainHourNotSupportText buttonTitle:@"好的" buttonStyle:TrainAlertActionStyleCancel];
    }
    
}

-(void)updateExamHourWithmodel:(TrainCourseDirectoryModel *)listModel {
    
    TrainWeakSelf(self);
//    TrainClassResModel *model = self.currResMuArr[currIndex.section] ;
    
    [[TrainNetWorkAPIClient client] trainGetHourStatusWithC_id:listModel.c_id object_id:self.class_id  lh_id:listModel.list_id success:^(NSDictionary *dic) {
        
        NSString  *is_complete = dic[@"is_complete"];
        [weakself updateExamStatus:is_complete andListModel:listModel];
        
        if ([is_complete  isEqualToString:@"P"]) {
            listModel.ua_status = @"C";
            
        }else{
            listModel.ua_status = is_complete;
        }
        [weakself.infoTableView reloadRowsAtIndexPaths:@[currIndex] withRowAnimation:UITableViewRowAnimationNone];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
    
}

- (void)updateExamStatus:(NSString *)examStatus  andListModel:(TrainCourseDirectoryModel *)listModel{
    
    if ([examStatus isEqualToString:@""]) {
        return;
    }
    
    NSString  *message  =@"";
    NSString  *actionTitile = @"";
    
    if ([examStatus isEqualToString:@"P"]) {
        message = [NSString stringWithFormat:@"恭喜您, %@ 考试 已通过",listModel.title];
        actionTitile = @"学习下一课时";
    }else if ([examStatus isEqualToString:@"F"]) {
        message = [NSString stringWithFormat:@"很遗憾, %@ 考试 未能通过,请继续努力",listModel.title];
        actionTitile = @"再一次";
    }else if ([examStatus isEqualToString:@"M"]) {
        message = [NSString stringWithFormat:@"%@ 考试 正在阅卷,请耐心等待",listModel.title];
        actionTitile = @"";
    }else if ([examStatus isEqualToString:@"I"]) {
        message = [NSString stringWithFormat:@"%@ 考试 正在进行中",listModel.title];
        actionTitile = @"继续考试";
    }
    
    [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:message buttonTitle:@"知道了" buttonStyle:TrainAlertActionStyleCancel];
    
}


/**
 *  课程详情中 保存考试或文档的状态
 * 考试状态: P 通过  F 失败   M 待阅卷  I  考试进行中  N"   考试未开始"
 *
 *  @param isDoc     YES  DOC   NO  Exam
 *  @param listModel
 *  @param status    考试状态
 *  @param score     考试成绩
 *  @param exam_time 考试时间
 */

//文档上传的参数
//ccm.object_id  培训课程id
//ccm.lh_id   课时id
//ccm.c_id  课程id
//ccm.cw_id  文档id
//ccm.user_id


//考试参数：    ccm.object_id  培训课程id
//ccm.lh_id   课时id
//ccm.c_id  课程id
//ccm.cw_id  考试id
//ccm.user_id
//ccm.status  完成状态
//ccm.time    时间
//ccm.score   分数


-(void)finishExamOrDoc:(BOOL)isDoc andListModel:(TrainCourseDirectoryModel *)listModel andExamStatus:(NSString  *)status andExamScore:(NSString *)score andExamtime:(NSString *)exam_time{
    TrainClassResModel *model = self.currResMuArr[currIndex.section] ;

    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:model.obj_id forKey:@"ccm.object_id"];
    [mudic setObject:listModel.list_id forKey:@"ccm.lh_id"];
    [mudic setObject:listModel.c_id forKey:@"ccm.c_id"];
    [mudic setObject:listModel.object_id forKey:@"ccm.cw_id"];
    
    if (!isDoc) {
        [mudic setObject:status forKey:@"ccm.status"];
        [mudic setObject:exam_time forKey:@"ccm.time"];
        [mudic setObject:score forKey:@"ccm.score"];
        
    }
    
    [[TrainNetWorkAPIClient client] trainUpdateHourDorEStatusWithIsExam:!isDoc infoDic:mudic Success:^(NSDictionary *dic) {
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
    
    [self.infoTableView reloadRowsAtIndexPaths:@[currIndex] withRowAnimation:UITableViewRowAnimationNone];
    
}


- (UITableView *)infoTableView {
    if (!_infoTableView) {
        UITableView *tableview =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        tableview.delegate    = self;
        tableview.dataSource  = self;
        tableview.rowHeight   = UITableViewAutomaticDimension ;
        tableview.estimatedRowHeight   = trainAutoLoyoutImageSize(150) ;
        
        tableview.estimatedSectionFooterHeight = 0 ;
        tableview.estimatedSectionHeaderHeight = 0 ;
        
        UINib  *nib =[UIView loadNibNamed:NSStringFromClass([TrainClassResCourseCell class])];
        [tableview registerNib:nib forCellReuseIdentifier: kRZClassResCourseCell];
        
        UINib  *nib1 =[UIView loadNibNamed:NSStringFromClass([TrainClassExamCell class])];
        [tableview registerNib:nib1 forCellReuseIdentifier: kRZClassExamResCell];
        
        [tableview registerClass:[TrainClassCourseHourCell class] forCellReuseIdentifier: kRZClassCourseHourCell ];
        
        [tableview registerClass:[TrainClassExamRecordCell class] forCellReuseIdentifier: kRZClassExamRecordCell ];

        
        
        [tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"TrainClassFootView"];
        
        
        _infoTableView = tableview ;
    }
    return _infoTableView ;
}

- (UIView *)resBgView {
    
    if (!_resBgView) {
        UIView *view = [[UIView alloc]init];
        _resBgView = view ;
    }
    return _resBgView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = TrainColorFromRGB16(0x6B6B6B);
        [button addTarget:self action:@selector(rzlastPhaseRes)];
        UIImage *image = [UIImage imageNamed:@"class_leftArrow"];
        image =  [image imageByScalingAndCroppingForSize:CGSizeMake(10, 40)];
        button.image = image ;
        
        _leftButton = button ;
    }
    return _leftButton ;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = TrainColorFromRGB16(0x6B6B6B);
        
        UIImage *image = [UIImage imageNamed:@"class_rightArrow"];
       image =  [image imageByScalingAndCroppingForSize:CGSizeMake(10, 40)];
        button.image = image ;
        
        [button addTarget:self action:@selector(rzNextPhaseRes)];
        
        _rightButton = button ;
    }
    return _rightButton ;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        
        UILabel *label =  [[UILabel alloc]initCustomLabel];
        label.textColor = TrainNavColor ;
        label.backgroundColor =  TrainColorFromRGB16(0xEEEEEE);
        label.textAlignment = NSTextAlignmentCenter ;
        _contentLabel = label;
    }
    return _contentLabel ;
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
