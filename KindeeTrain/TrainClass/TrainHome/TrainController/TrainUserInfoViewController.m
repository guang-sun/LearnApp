//
//  TrainUserInfoViewController.m
//  SOHUEhr
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainUserInfoViewController.h"

#import "TrainCourseAndClassModel.h"
#import "TrainGroupAndTopicModel.h"
#import "TrainClassMenuView.h"
#import "TrainCenterCourseListCell.h"
#import "TrainCenterGroupListCell.h"
#import "TrainGroupListCell.h"
#define centerHeight         TrainScaleWith6(240)

@interface TrainUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,TrainClassMenuDelegate>{
    
    NSDictionary            *centerDic;
    TrainCenterStyle        centerStyle;
    NSMutableArray          *courseMuArr, *groupMuArr ,*topicMuArr;
    UIView                  *headView;
    TrainBaseTableView      *centerTableView;
    
    UIImageView             *userImage;
    UILabel                 *positionLab, *nameLab, *constellationLab,
    *courseNumLab, *courseTimeLab;
    TrainClassMenuView      *headMenuView;
}

@end

@implementation TrainUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    centerStyle = TrainCenterStyleCourse;
    courseMuArr = [NSMutableArray array];
    groupMuArr = [NSMutableArray array];
    topicMuArr = [NSMutableArray array];
    self.navigationItem.title = @"个人中心" ;
    
    [self downloadUserCenterHeader];
    // Do any additional setup after loading the view.
}


#pragma mark - download 个人中心信息
-(void)downloadUserCenterHeader{
    
    [self trainShowHUDOnlyActivity];
    
    [[TrainNetWorkAPIClient client] trainGetUserCenterWithUser_id:_user_id Success:^(NSDictionary *dic) {
        
        if (dic) {
            
            if (dic[@"obj"]) {
                
                centerDic =dic[@"obj"];
                if (!centerTableView) {
                    [self creatTableView];
                }
                [self updataCenterInfo:centerDic];
                
                if ( TrainArrayIsEmpty( courseMuArr)){
                    [self downloadCenterdata:1];
                }
                
            }
            
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        [self trainHideHUD];
    }];
}

#pragma mark - download 个人中心 课程  圈子信息

-(void)downloadCenterdata:(int)index{
    
    [self trainShowHUDOnlyActivity];
    
    [centerTableView dissTablePlace];
    
    [[TrainNetWorkAPIClient client] trainGetUserCenterWithType:centerStyle User_id:_user_id curPage:index Success:^(NSDictionary *dic) {
        
        if (index ==1) {
            if (centerStyle == TrainCenterStyleCourse) {
                courseMuArr = [NSMutableArray array];
            }else if ( centerStyle == TrainCenterStyleCircle){
                groupMuArr =[NSMutableArray array];
            }else if (centerStyle == TrainCenterStyleTopic){
                topicMuArr = [NSMutableArray array];
            }
        }
        if (centerStyle == TrainCenterStyleCourse) {
            
            NSArray  *dataArr = [TrainCourseAndClassModel mj_objectArrayWithKeyValuesArray:dic[@"HotCourse"]];
            [courseMuArr addObjectsFromArray:dataArr];
            
            if(courseMuArr.count >0){
                TrainCourseAndClassModel *courseModel = [courseMuArr firstObject];
                centerTableView.totalpages = [courseModel.totPage intValue];
            }
            
            
        }else if ( centerStyle == TrainCenterStyleCircle){
            NSArray  *dataArr = [TrainGroupModel mj_objectArrayWithKeyValuesArray:dic[@"hotCircle"]];
            [groupMuArr addObjectsFromArray:dataArr];
            
            if(groupMuArr.count >0){
                TrainGroupModel *groupModel = [groupMuArr firstObject];
                centerTableView.totalpages = [groupModel.totPage intValue];
            }
            
        }else if(centerStyle == TrainCenterStyleTopic){
            NSArray  *dataArr = [TrainTopicModel mj_objectArrayWithKeyValuesArray:dic[@"HotTopic"]];
            [topicMuArr addObjectsFromArray:dataArr];
        }
        
        centerTableView.trainMode = trainStyleNoData;
        [self trainHideHUD];
        [centerTableView EndRefresh];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        centerTableView.trainMode = trainStyleNoData;
        [self trainShowHUDNetWorkError];
        [centerTableView EndRefresh];
        
        
        
    }];
}


#pragma mark - 创建 headview
-(void)creatTableHeadView{
    
    if (!headView) {
        headView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH,centerHeight)];
    }
    
    UIImageView  *bgimageView =[[UIImageView alloc]init];
    bgimageView.image =[UIImage imageNamed:@"bgimageView"];
    
    
    [headView addSubview:bgimageView];
    
    userImage =[[UIImageView alloc]init];
    userImage.layer.cornerRadius = TrainScaleWith6(30) ;
    userImage.layer.masksToBounds = YES;
    userImage.image = [UIImage imageNamed:@"user_avatar_default"];
    userImage.contentMode=UIViewContentModeScaleAspectFill;
    [bgimageView addSubview:userImage];
    
    
    positionLab =[[UILabel alloc]initWithFrame:CGRectZero];
    positionLab.text =@"";
    positionLab.layer.cornerRadius = 5.f;
    positionLab.layer.masksToBounds = YES;
    positionLab.font =[UIFont systemFontOfSize:16.0f];
    positionLab.textColor =[UIColor whiteColor];
    positionLab.textAlignment =NSTextAlignmentCenter;
    positionLab.backgroundColor =[UIColor colorWithRed:255 green:255 blue:255 alpha:0.2];
    [bgimageView addSubview:positionLab];
    
    
    
    
    nameLab =[[UILabel alloc]init];
    nameLab.textColor =[UIColor whiteColor];
    nameLab.font =[UIFont systemFontOfSize:TrainTitleFont];
    nameLab.textAlignment =NSTextAlignmentCenter;
    nameLab.backgroundColor =[UIColor clearColor];
    [bgimageView addSubview:nameLab];
    
    constellationLab =[[UILabel alloc]init];
    constellationLab.textColor =[UIColor whiteColor];
    constellationLab.font =[UIFont systemFontOfSize:TrainTitleFont];
    constellationLab.textAlignment =NSTextAlignmentCenter;
    constellationLab.backgroundColor =[UIColor clearColor];
    [bgimageView addSubview:constellationLab];
    
    
    
    UIImageView *downImage = [[UIImageView alloc]init];
    downImage.image =[UIImage imageNamed:@"downimage"];
    [headView addSubview:downImage];
    
    courseNumLab =[[UILabel alloc]init];
    courseNumLab.textColor =[UIColor colorWithRed:40.0/255 green:183.0/255 blue:153.0/255 alpha:1];
    courseNumLab.font =[UIFont systemFontOfSize:TrainScaleWith6(20)];
    [downImage addSubview:courseNumLab];
    
    courseTimeLab =[[UILabel alloc]init];
    courseTimeLab.textColor =[UIColor colorWithRed:39.0/255 green:169.0/255 blue:227.0/255 alpha:1];
    courseTimeLab.font =[UIFont systemFontOfSize:TrainScaleWith6(20)];
    [downImage addSubview:courseTimeLab];
    
    bgimageView.sd_layout
    .leftEqualToView(headView)
    .rightEqualToView(headView)
    .topEqualToView(headView)
    .heightIs(TrainScaleWith6(170));
    
    
    userImage.sd_layout
    .centerXEqualToView(bgimageView)
    .topSpaceToView(bgimageView,TrainScaleWith6(15))
    .widthIs(TrainScaleWith6(60))
    .heightEqualToWidth();
    
    positionLab.sd_layout
    .centerXEqualToView(bgimageView)
    .topSpaceToView(userImage,TrainScaleWith6(10))
    .heightIs(TrainScaleWith6(20));
    
    nameLab.sd_layout
    .centerXEqualToView(bgimageView)
    .topSpaceToView(positionLab,TrainScaleWith6(15))
    .widthIs(TrainSCREENWIDTH-50)
    .heightIs(TrainScaleWith6(15));
    
    constellationLab.sd_layout
    .centerXEqualToView(bgimageView)
    .topSpaceToView(nameLab,TrainScaleWith6(10))
    .widthIs(TrainSCREENWIDTH-50)
    .heightIs(TrainScaleWith6(15));
    
    
    downImage.sd_layout
    .leftEqualToView(headView)
    .rightEqualToView(headView)
    .topSpaceToView(bgimageView,0)
    .heightIs(TrainScaleWith6(70));
    
    courseNumLab.sd_layout
    .leftSpaceToView(downImage,TrainSCREENWIDTH*0.26)
    .topSpaceToView(downImage,TrainScaleWith6(20))
    .widthIs(TrainSCREENWIDTH*0.20)
    .heightIs(TrainScaleWith6(20));
    
    
    courseTimeLab.sd_layout
    .leftSpaceToView(downImage,TrainSCREENWIDTH*0.68)
    .topSpaceToView(downImage,TrainScaleWith6(20))
    .widthIs(TrainSCREENWIDTH*0.20)
    .heightIs(TrainScaleWith6(20));
    
}

-(void)updataCenterInfo:(NSDictionary *)dic{
    
    NSString  *imageURL = [NSString stringWithFormat:@"%@%@",TrainIP,notEmptyStr(dic[@"sphoto"])];
    [userImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"user_avatar_default.png"] options:SDWebImageAllowInvalidSSLCertificates];
    
    NSString *positStr = [NSString stringWithFormat:@"%@",dic[@"group_name"]] ;
    float  posWidth = positStr.length * positionLab.font.lineHeight ;
    
    positionLab.sd_layout.widthIs(TrainScaleWith6(posWidth));
    [positionLab updateLayout];
    
    positionLab.text = positStr;
    
    nameLab.text = dic[@"full_name"];
    
    NSString  *data =@"";
    if (!TrainStringIsEmpty(dic[@"hire_dt"])) {
        data = dic[@"hire_dt"];
    }
    constellationLab.text = [NSString stringWithFormat:@"入职日期：%@",data];
    
    courseNumLab.text =[dic[@"courseCount"] stringValue];
    int time =[dic[@"courseTimes"] intValue];
    courseTimeLab.text =[NSString stringWithFormat:@"%d h",time / 60 / 60 ];
    
}

#pragma mark - 创建tableview

-(void)creatTableView{
    
    
    headView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH,centerHeight)];
    [self creatTableHeadView];
    
    centerTableView = [[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT - TrainNavHeight) andTableStatus:tableViewRefreshFooter];
    centerTableView.delegate = self;
    centerTableView.dataSource = self;
    centerTableView.tableHeaderView = headView;
    centerTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    [self.view addSubview:centerTableView];
    
    [centerTableView registerClass:[TrainCenterCourseListCell class] forCellReuseIdentifier:@"courseCell"];
    [centerTableView registerClass:[TrainGroupListCell class] forCellReuseIdentifier:@"groupCell"];
    
    TrainWeakSelf(self);
    centerTableView.footBlock =^(int index){
        [weakself downloadCenterdata:index];
    };
    
}


#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (centerStyle == TrainCenterStyleCourse) {
        
        return (TrainArrayIsEmpty(courseMuArr))?0:courseMuArr.count;
        
    }else if(centerStyle == TrainCenterStyleCircle){
        
        return (TrainArrayIsEmpty(groupMuArr))?0:groupMuArr.count;
        
    }else if(centerStyle == TrainCenterStyleTopic){
        
        return (TrainArrayIsEmpty(topicMuArr))?0:topicMuArr.count;
        
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (centerStyle == TrainCenterStyleCourse) {
        
        TrainCenterCourseListCell  *courseCell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
        courseCell.model = courseMuArr[indexPath.row];
        
        return courseCell;
        
    }else if(centerStyle == TrainCenterStyleCircle){
        TrainGroupListCell  *groupCell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
        groupCell.model = groupMuArr[indexPath.row];
        
        return groupCell;
        
    }else if(centerStyle == TrainCenterStyleTopic){
        
        
    }
    
    UITableViewCell   *cell =[[UITableViewCell alloc]init];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!headMenuView) {
        headMenuView =[[TrainClassMenuView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, 40) andArr:@[@"课程",@"圈子"]];
        headMenuView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        headMenuView.delegate = self;
    }
    return headMenuView;
    
    
}

#pragma mark - 课程 圈子点击切换
-(void)TrainClassMenuSelectIndex:(int)index{
    centerStyle = index;
    
    if (centerStyle == TrainCenterStyleCourse) {
        if(TrainArrayIsEmpty(courseMuArr)){
            [self downloadCenterdata:1];
        }else{
            
            if(courseMuArr.count >0){
                TrainCourseAndClassModel *courseModel = [courseMuArr firstObject];
                centerTableView.totalpages = [courseModel.totPage intValue];
                centerTableView.currentpage = (int)courseMuArr.count / 10 +1;
            }
            [centerTableView train_reloadData];
        }
        
    }else if(centerStyle == TrainCenterStyleCircle){
        if(TrainArrayIsEmpty(groupMuArr)){
            [self downloadCenterdata:1];
        }else{
            
            if(groupMuArr.count >0){
                TrainGroupModel *groupModel = [groupMuArr firstObject];
                centerTableView.totalpages = [groupModel.totPage intValue];
                centerTableView.currentpage = (int)groupMuArr.count / 10 +1;
            }
            [centerTableView train_reloadData];
        }
        
    }else if(centerStyle == TrainCenterStyleTopic){
        if(TrainArrayIsEmpty(topicMuArr)){
            [self downloadCenterdata:1];
        }else{
            [centerTableView train_reloadData];
        }
    }
    centerTableView.currentpage =1;
    [centerTableView setContentOffset:CGPointMake(0,0) animated:NO];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (centerStyle == TrainCenterStyleCourse) {
        
        return 70;
        
    }else if(centerStyle == TrainCenterStyleCircle){
        
        return [tableView cellHeightForIndexPath:indexPath model:groupMuArr[indexPath.row] keyPath:@"model" cellClass:[TrainGroupListCell class] contentViewWidth:TrainSCREENWIDTH];
        
    }else if(centerStyle == TrainCenterStyleTopic){
        return 0;
    }
    return 0;
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
