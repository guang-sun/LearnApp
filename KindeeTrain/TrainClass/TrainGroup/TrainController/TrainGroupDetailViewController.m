//
//  TrainGroupDetailViewController.m
//  SOHUEhr
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainGroupDetailViewController.h"
#import "TrainSearchBar.h"
#import "TrainTopicListCell.h"
#import "TrainTopicDetailViewController.h"
#import "TrainClassMenuView.h"
#import "TrainGroupSearchViewController.h"
#import "TrainAddNewTopicViewController.h"


@interface TrainGroupDetailViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,TrainClassMenuDelegate>
{
    BOOL                    isGroupMember;
    UIButton                *rightBtn;
    
    NSMutableArray          *topicMuArr;
    
    UIView                  *groupInfoView;
    UIImageView             *groupLeftImageV;
    UILabel                 *titleLab ,*messageNumLab ,*peopleNumLab  ,*replyNumLab ,
                            *supportNumLab , *writeLab;
    UIView                  *lastView;
    NSArray                 *GroupStickArr;
    NSString                *topicType;
   
    UIView                  *joinGroupView;

    TrainClassMenuView      *headMenuView;
}

@property(nonatomic, strong) TrainSearchBar         *topSearch;
@property(nonatomic, strong) TrainBaseTableView     *topicListTableView;


@end

@implementation TrainGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    if (@available(iOS 11.0, *)) {
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  TrainSCREENWIDTH - 100 , 44)];
        
        self.topSearch.translatesAutoresizingMaskIntoConstraints = NO;
        //    [self.foundSearchBar becomeFirstResponder];
        UITextField *searchField = [self.topSearch valueForKey:@"_searchField"]; // 先取出textfield
        
        //        [searchField setValue:[UIFont customFontOfSize:12.0f] forKey:@"_placeholderLabel.font"];
        [searchField setValue:[UIFont systemFontOfSize:12.0f] forKeyPath:@"_placeholderLabel.font"];
        
        [container addSubview:self.topSearch];
        
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [ container.widthAnchor constraintEqualToConstant: TrainSCREENWIDTH - 100 ],
                                                  [container.heightAnchor constraintEqualToConstant:40]
                                                  
                                                  ]];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.topSearch.topAnchor constraintEqualToAnchor:container.topAnchor constant:5.f], // 顶部约束
                                                  [self.topSearch.leftAnchor constraintEqualToAnchor:container.leftAnchor constant:  5.f ], // 左边距约束
                                                  [self.topSearch.rightAnchor constraintEqualToAnchor:container.rightAnchor constant: - 5.0f], // 右边距约束
                                                  [self.topSearch.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant: - 5.0f], // 底部约束
                                                  
                                                  ]];
        self.topSearch.textfileRadius = 15.0f;
        
        self.navigationItem.titleView = container ;
        
    } else {
        
        
        self.topSearch.frame = CGRectMake(40, 0, TrainSCREENWIDTH - 80, 44);
        self.navigationItem.titleView =  self.topSearch;
        
    }

    
    topicType = @"T";
    rightBtn =[[UIButton alloc]initCustomButton];
    rightBtn.frame = CGRectMake(TrainSCREENWIDTH - 40, 0, 30, 44);
    rightBtn.tag =1;
    rightBtn.cusTitleColor =[UIColor  whiteColor];
    rightBtn.image =[UIImage imageNamed:@"Train_Topic_Detail_AddTopic"];
    [rightBtn addTarget:self action:@selector(addNewtopic:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

    [self creatTopicTableView];
    

    // Do any additional setup after loading the view.
}




#pragma mark - searchRightItem  发话题或 取消
-(void)addNewtopic:(UIButton  *)btn{
   
    [self  pushAddTopic];
    
}

-(void)pushAddTopic{
    
    if (!isGroupMember) {
        
        [self trainShowHUDOnlyText:TrainNotJoinText];
       
    }else {
        
        TrainWeakSelf(self);
        TrainAddNewTopicViewController *newTopicVC =[[TrainAddNewTopicViewController alloc]init];
        newTopicVC.group_id = _group_id;
        newTopicVC.addTopicSuccess = ^(){
            
            [weakself TrainClassMenuSelectIndex:0];
        };
        [self.navigationController pushViewController:newTopicVC animated:YES];

    }
    
}

#pragma mark  search 圈内搜索话题

-(void)searchTopicText:(NSString *)text{
    if ([TrainStringUtil trainIsBlankString:text]) {
        
        [self trainShowHUDOnlyText:TrainSearchNullText];
        
    }else{
        
        TrainGroupSearchViewController *searchVC =[[TrainGroupSearchViewController alloc]init];
        searchVC.searchText = text;
        searchVC.group_id = _group_id;
       
        [self.navigationController pushViewController:searchVC animated:NO];
        
        self.topSearch.text = @"";
        [self.topSearch resignFirstResponder];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchTopicText:searchBar.text];
}

# pragma mark -   获取圈子详情页面

# pragma mark  获取圈子信息


-(void)downLoadGroupInfo:(int)index{
    
    [self trainShowHUDOnlyActivity];
    [self.topicListTableView dissTablePlace];
    
    NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(_group_id) forKey:@"group_id"];
    [mudic setObject:topicType forKey:@"type"];
    [mudic setObject:[NSString stringWithFormat:@"%d",index] forKey:@"curPage"];
    

    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainGroupDetailtWithinfoDic:mudic Success:^(NSDictionary *dic) {
        
        if (dic[@"pv_flag"] && [dic[@"pv_flag"] integerValue] != -1 ) {
            isGroupMember = YES;
        }else {
            isGroupMember = NO;
            [weakself creatJoinGroupView];
        }

        if (index == 1 ) {
            topicMuArr =[NSMutableArray new];
        }
        NSArray  *dataArr =[TrainTopicModel mj_objectArrayWithKeyValuesArray:dic[@"topic"]];
        [topicMuArr addObjectsFromArray:dataArr];
        
        GroupStickArr = [TrainTopicModel mj_objectArrayWithKeyValuesArray:dic[@"stick"]];
        if(!groupInfoView){
            [weakself updateGroupInfo:dic[@"group"]];
        }
        if (topicMuArr.count>0) {
            TrainTopicModel *groupInfo =[topicMuArr firstObject];
            weakself.topicListTableView.totalpages = [groupInfo.totPage intValue];
        }

        weakself.topicListTableView.trainMode = trainStyleNoData;
        [weakself.topicListTableView EndRefresh];
        [weakself trainHideHUD];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        weakself.topicListTableView.trainMode = trainStyleNoNet;
        [weakself.topicListTableView EndRefresh];
        [weakself trainShowHUDNetWorkError];

    }];
    
}
-(void)creatJoinGroupView{
    if (!joinGroupView) {
        
        joinGroupView = [[UIView alloc]init];
        joinGroupView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview: joinGroupView];
        
        UIButton  *button = [[UIButton alloc]initCustomButton];
        button.cusFont = 14.0f;
        button.backgroundColor = TrainNavColor;
        [button setTitle:@"加入圈子" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius =8;
        [button addTarget:self action:@selector(joinGroup)];
        [joinGroupView addSubview:button];
        
        joinGroupView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view)
        .heightIs(50);
        
        button.sd_layout
        .centerXEqualToView(joinGroupView)
        .centerYEqualToView(joinGroupView)
        .widthIs(150)
        .heightIs(40);
        
    }
    
}
#pragma mark - 加入圈子
-(void)joinGroup{
   
    [self trainShowHUDOnlyActivity];
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainJoinGrouptWithgroup_id:_group_id Success:^(NSDictionary *dic) {
        if ([dic[@"success"] boolValue]) {
            
            [weakself trainShowHUDOnlyText:TrainJoinGroupText];
            isGroupMember = YES;
            [joinGroupView removeFromSuperview];
            weakself.topicListTableView.frame =CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight);
        }else{
            [weakself trainShowHUDOnlyText:dic[@"msg"]];

        }

    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        [weakself trainShowHUDNetWorkError];
    }];
}

-(void)updateGroupInfo:(NSDictionary *)dic{
    
   
    
    if(!groupInfoView){
        float   groupInfoHei = (GroupStickArr.count >0 )?trainAutoLoyoutImageSize(trainIconWidth) + 30 + 40 * GroupStickArr.count:trainAutoLoyoutImageSize(trainIconWidth) + 30;
        
        groupInfoView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH,groupInfoHei)];
        groupInfoView.backgroundColor = [UIColor whiteColor];
        [self creatGroupInfoView];
        
        float  hei = (isGroupMember)?TrainSCREENHEIGHT-TrainNavHeight:TrainSCREENHEIGHT-TrainNavHeight- 49;
        
        self.topicListTableView.tableHeaderView = groupInfoView;
        self.topicListTableView.frame = CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, hei);
        
    }
    
    if (TrainDictIsEmpty(dic) ) {
        return;
    }
    titleLab.text = dic[@"title"];
    
    NSString  *messNum =([dic[@"topic_num"] intValue]>0)?[dic[@"topic_num"] stringValue]:@"0";
    messageNumLab.text =[@"话题数:" stringByAppendingString:messNum];
    
    NSString  *peoNum =([dic[@"member_num"] intValue]>0)?[dic[@"member_num"] stringValue]:@"0";
    peopleNumLab.text =[@"成员数:" stringByAppendingString:peoNum];
    
    NSString  *replyNum =([dic[@"post_num"] intValue]>0)?[dic[@"post_num"] stringValue]:@"0";
    replyNumLab.text =[@"回复数:" stringByAppendingString:replyNum];
    
    NSString  *supNum =([dic[@"top_num"] intValue]>0)?[dic[@"top_num"] stringValue]:@"0";
    supportNumLab.text =[@"点赞数:" stringByAppendingString:supNum];
    
    NSString  *userName =(dic[@"username"] || ![dic[@"username"] isEqualToString:@""])?dic[@"username"]:@"";
    
    writeLab.text =[@"组长: " stringByAppendingString:userName];
    
}
#pragma mark - 圈子头视图
-(void)creatGroupInfoView{
    
    
    groupInfoView.userInteractionEnabled =YES;
    
    groupLeftImageV =[[UIImageView alloc]init];
    groupLeftImageV.image =[UIImage imageNamed:@"GROUP"];
    [groupInfoView addSubview:groupLeftImageV];
    
    titleLab =[[UILabel alloc]initCustomLabel];
    titleLab.cusFont = 16.0f;
    titleLab.textColor =TrainNavColor;
    [groupInfoView addSubview:titleLab];
    
    UIView *fourView =[[UIView alloc]init];
    [groupInfoView addSubview:fourView];
    
    messageNumLab =[[UILabel alloc]creatContentLabel];
    messageNumLab.textColor =TrainColorFromRGB16(0x9C9C9C);
    [fourView addSubview:messageNumLab];
    
    peopleNumLab =[[UILabel alloc]creatContentLabel];
    peopleNumLab.textColor =TrainColorFromRGB16(0x9C9C9C);
    [fourView addSubview:peopleNumLab];
    
    replyNumLab  =[[UILabel alloc]creatContentLabel];
    replyNumLab.textColor =TrainColorFromRGB16(0x9C9C9C);
    [fourView addSubview:replyNumLab];
    
    supportNumLab =[[UILabel alloc]creatContentLabel];
    supportNumLab.textColor =TrainColorFromRGB16(0x9C9C9C);
    [fourView addSubview:supportNumLab];
    
    writeLab =[[UILabel alloc]creatContentLabel];
    writeLab.textColor =TrainColorFromRGB16(0x9C9C9C);
    [groupInfoView addSubview:writeLab];
    
    
    
    
    groupLeftImageV.sd_layout
    .leftSpaceToView(groupInfoView,15)
    .topSpaceToView(groupInfoView,10)
    .widthIs(trainAutoLoyoutImageSize(trainIconWidth))
    .heightEqualToWidth();
    
    titleLab.sd_layout
    .leftSpaceToView(groupLeftImageV,10)
    .topEqualToView(groupLeftImageV)
    .rightSpaceToView(groupInfoView,15)
    .heightIs(trainAutoLoyoutImageSize(20));
    
    fourView.sd_layout
    .leftEqualToView(titleLab)
    .rightEqualToView(titleLab)
    .topSpaceToView(titleLab,5)
    .heightIs(trainAutoLoyoutImageSize(10));
    
    fourView.sd_equalWidthSubviews = @[messageNumLab,peopleNumLab,replyNumLab ,supportNumLab];
    messageNumLab.sd_layout
    .leftEqualToView(fourView)
    .topEqualToView(fourView)
    .heightRatioToView(fourView,1);
    
    peopleNumLab.sd_layout
    .leftSpaceToView(messageNumLab,0)
    .topEqualToView(fourView)
    .heightRatioToView(fourView,1);
    
    replyNumLab.sd_layout
    .leftSpaceToView(peopleNumLab,0)
    .topEqualToView(fourView)
    .heightRatioToView(fourView,1);
    
    supportNumLab.sd_layout
    .leftSpaceToView(replyNumLab,0)
    .rightEqualToView(fourView)
    .topEqualToView(fourView)
    .heightRatioToView(fourView,1);
    
    writeLab.sd_layout
    .leftEqualToView(titleLab)
    .rightEqualToView(titleLab)
    .topSpaceToView(fourView,5)
    .heightIs(trainAutoLoyoutImageSize(10));
    
    [self topTopicListView];
}
#pragma mark - 圈子置顶话题list
-(void)topTopicListView{
    
    UIView  *line =[[UIView alloc]init];
    line.backgroundColor = [UIColor  groupTableViewBackgroundColor ];
    [groupInfoView addSubview:line];
    
    line.sd_layout
    .leftEqualToView(groupInfoView)
    .rightEqualToView(groupInfoView)
    .topSpaceToView(groupLeftImageV,10)
    .heightIs(10);
    
    lastView = line;
    
    
    for (int  i = 0; i < GroupStickArr.count; i++) {
        TrainTopicModel  *infoDic = GroupStickArr[i];
        UIView   *bgView =[[UIView alloc]init];
        [groupInfoView addSubview:bgView];
        
        UIImageView  *topImageView  =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Train_Topic_top"]];
        [bgView addSubview:topImageView];
        
        UILabel  *toptitleLab =[[UILabel alloc]creatTitleLabel];
        toptitleLab.cusFont =12.0f;
        toptitleLab.tag = 100+i;
        toptitleLab.text =infoDic.title;
        toptitleLab.userInteractionEnabled =YES;
        [bgView addSubview:toptitleLab];
        
        
        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(groupStickTap:)];
        [toptitleLab addGestureRecognizer:tap];
        
        
        UIView  *line =[[UIView alloc]initWithLine1View];
        [bgView addSubview:line];
        
        
        bgView.sd_layout
        .leftEqualToView(groupInfoView)
        .rightEqualToView(groupInfoView)
        .topSpaceToView(lastView,0)
        .heightIs(40);
        
        topImageView.sd_layout
        .leftSpaceToView(bgView,15)
        .centerYEqualToView(bgView)
        .widthIs(15)
        .heightIs(15);
        
        toptitleLab.sd_layout
        .leftSpaceToView(topImageView,10)
        .rightSpaceToView(bgView,15)
        .centerYEqualToView(bgView)
        .heightIs(20);
        
        line.sd_layout
        .leftEqualToView(topImageView)
        .rightEqualToView(toptitleLab)
        .bottomSpaceToView(bgView,1)
        .heightIs(0.7);
        
        
        lastView  =bgView;
        
    }
    if (GroupStickArr.count > 0) {
        UIView  *line1 =[[UIView alloc]init];
        line1.backgroundColor = [UIColor  groupTableViewBackgroundColor ];
        [groupInfoView addSubview:line1];
        line1.sd_layout
        .leftEqualToView(groupInfoView)
        .rightEqualToView(groupInfoView)
        .topSpaceToView(lastView,0)
        .heightIs(10);
    }
    
}

-(void)groupStickTap:(UITapGestureRecognizer *)tap{
    int  index = (int)tap.view.tag -100;
    
    TrainTopicDetailViewController  *detailVC =[[TrainTopicDetailViewController alloc]init];
    detailVC.model = GroupStickArr[index];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.topSearch resignFirstResponder];
}


-(void)creatTopicTableView{
   
    
    self.topicListTableView =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight) andTableStatus:tableViewRefreshAll];
    self.topicListTableView.dataSource = self;
    self.topicListTableView.delegate = self;
    self.topicListTableView.tag = 1;
    //    topicTableView.bounces =NO;
//    topicListTableView.tableHeaderView =groupInfoView;
    [self.topicListTableView registerClass:[TrainTopicListCell class] forCellReuseIdentifier:@"topicCell"];
    [self.view addSubview:self.topicListTableView];
    
    
    TrainWeakSelf(self);
    self.topicListTableView.headBlock = ^(){

        [weakself downLoadGroupInfo:1];
    };
    self.topicListTableView.footBlock = ^(int  index){

        [weakself downLoadGroupInfo:index];
    };
    self.topicListTableView.refreshBlock =^(){

        [weakself downLoadGroupInfo:1];
    };
    
//    [self creatJoinGroupView];

}

#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (TrainArrayIsEmpty(topicMuArr))?0:topicMuArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TrainTopicListCell   *topicCell = [tableView dequeueReusableCellWithIdentifier:@"topicCell"];
    __block TrainTopicModel  *listModel = topicMuArr[indexPath.row];
    topicCell.model =listModel;
    topicCell.isImageTap = NO;
    
    TrainWeakSelf(self);
    topicCell.topicTouchBlock = ^(NSString *str, TrainTopicModel *model){
        
        [weakself trainShowHUDOnlyText:str];
        listModel  = model;
        [weakself.topicListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    };
    
    return topicCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        if (!headMenuView) {
            headMenuView =[[TrainClassMenuView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, 40) andArr:@[@"全部",@"精华"]];
            headMenuView.backgroundColor =[UIColor whiteColor];
            //        menuView.selectIndex = topmenuSelectIndex;
            headMenuView.delegate = self;
        }
        return headMenuView;
    
    
}
-(void)TrainClassMenuSelectIndex:(int)index{
    switch (index) {
        case 0:
            topicType = @"T";
            break;
        case 1:
            topicType = @"E";
            break;
        default:
            break;
    }
    [self downLoadGroupInfo:1];
    self.topicListTableView.currentpage =1;
    
    if (topicMuArr.count >0 ) {
        [self.topicListTableView setContentOffset:CGPointMake(0,0) animated:NO];
    }
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:TrainSCREENWIDTH tableView:tableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TrainTopicModel  *topicModel =[topicMuArr objectAtIndex:indexPath.row];
    
    TrainTopicDetailViewController  * topicVC =[[TrainTopicDetailViewController alloc]init];
    topicVC.model = topicModel;
    topicVC.updateModel = ^(TrainTopicModel *model){
        
        if (model) {
            [topicMuArr replaceObjectAtIndex:indexPath.row withObject:model];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [topicMuArr removeObjectAtIndex:indexPath.row];
            [tableView train_reloadData];
        }
    };
    [self.navigationController pushViewController:topicVC animated:YES];
}


-(TrainSearchBar *)topSearch{
    if (!_topSearch) {
        TrainSearchBar *topSearchBar =[[TrainSearchBar alloc]init];
        topSearchBar.trainSearchBarStyle =TrainSearchBarStyleDefault;
        
        topSearchBar.customPlaceholder =@"搜索:圈内话题";
        topSearchBar.textfileRadius = 15.0f;
        topSearchBar.delegate =self;
        topSearchBar.searchBackgroupColor =[UIColor clearColor];
        _topSearch = topSearchBar;
    }
    return _topSearch;
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
