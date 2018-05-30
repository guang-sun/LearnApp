//
//  TrainSearchResultViewController.m
//  SOHUEhr
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainSearchResultViewController.h"
#import "TrainSearchBar.h"
#import "TrainBaseTableView.h"
#import "TrainClassMenuView.h"
//#import "TrainCourseModel.h"
//#import "TrainGroupAndTopicModel.h"
//#import "TrainDocListModel.m"

#import "TrainCourseClassListCell.h"
#import "TrainDocListTableViewCell.h"
#import "TrainTopicSearchListCell.h"
#import "TrainGroupListCell.h"

#import "TrainNewMovieViewController.h"
#import "TrainGroupDetailViewController.h"
#import "TrainWebViewController.h"

#import "TrainTopicDetailViewController.h"


//#import "header"
@interface TrainSearchResultViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,TrainClassMenuDelegate>
{
    NSMutableArray                      *resultCouArr;
    NSMutableArray                      *resultTopArr;
    NSMutableArray                      *resultGroArr;
    NSMutableArray                      *resultDocArr;
    TrainClassMenuView                  *topMenuView;
    TrainSearchBar                      *customSearch;
    TrainBaseTableView                  *resultTableView;
    
}


@end

@implementation TrainSearchResultViewController

-(void)viewDidAppear:(BOOL)animated{
    
       [super viewDidAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self creatNavSearch];
    [self creatResultTableView];
//    [self downLoadSearchResultData:1];
    // Do any additional setup after loading the view.
}
-(void)creatNavSearch{
    
    customSearch =[[TrainSearchBar alloc]initWithFrame:CGRectMake(10, 0, TrainSCREENWIDTH-50, 44)];
    customSearch.trainSearchBarStyle =TrainSearchBarStyleDefault;
    
    customSearch.customPlaceholder = TrainSearchTitleText;
    customSearch.textfileRadius = 15.0f;
    customSearch.text = _searchTitle;
    customSearch.delegate =self;
    customSearch.searchBackgroupColor =[UIColor clearColor];

    self.navigationItem.leftBarButtonItem = nil ;
    
    
    if (@available(iOS 11.0, *)) {
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  TrainSCREENWIDTH - 70 , 44)];
        
        customSearch.translatesAutoresizingMaskIntoConstraints = NO;
        //    [self.foundSearchBar becomeFirstResponder];
        UITextField *searchField = [customSearch valueForKey:@"_searchField"]; // 先取出textfield
        
        //        [searchField setValue:[UIFont customFontOfSize:12.0f] forKey:@"_placeholderLabel.font"];
        [searchField setValue:[UIFont systemFontOfSize:12.0f] forKeyPath:@"_placeholderLabel.font"];
        
        [container addSubview:customSearch];
        
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [ container.widthAnchor constraintEqualToConstant: TrainSCREENWIDTH - 70 ],
                                                  [container.heightAnchor constraintEqualToConstant:40]
                                                  
                                                  ]];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [customSearch.topAnchor constraintEqualToAnchor:container.topAnchor constant:5.f], // 顶部约束
                                                  [customSearch.leftAnchor constraintEqualToAnchor:container.leftAnchor constant:  0.f ], // 左边距约束
                                                  [customSearch.rightAnchor constraintEqualToAnchor:container.rightAnchor constant: - 5.0f], // 右边距约束
                                                  [customSearch.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant: - 5.0f], // 底部约束
                                                  
                                                  ]];
        customSearch.textfileRadius = 15.0f;
        
        self.navigationItem.titleView = container ;
        
    } else {
        
        self.navigationItem.titleView =  customSearch;
        
    }
    
    UIButton *cancaleBtn =[[UIButton alloc]initCustomButton];
    cancaleBtn.frame =CGRectMake(TrainSCREENWIDTH -40, 0, 30, 44);
    cancaleBtn.titleLabel.font =[UIFont systemFontOfSize:(14.0f)];
    cancaleBtn.cusTitleColor =[UIColor whiteColor];
    [cancaleBtn addTarget:self action:@selector(rightCancel) forControlEvents:UIControlEventTouchUpInside];
    cancaleBtn.cusTitle =@"取消";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancaleBtn];
    
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

    [self.navigationController popViewControllerAnimated:NO];
    
    return NO;
}
-(void)rightCancel{
    
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)creatResultTableView{
    topMenuView =[[TrainClassMenuView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainCLASSHEIGHT) andArr:@[@"课程",@"话题",@"文档"] ];
    topMenuView.delegate =self;
    if (_selectMode == TrainSearchStyleTopic || _selectMode == TrainSearchStyleCircle ) {
        topMenuView.selectIndex = 1;

    }else{
        topMenuView.selectIndex = _selectMode;

    }
    [self.view addSubview:topMenuView];
    
    
    resultTableView =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y + TrainCLASSHEIGHT, TrainSCREENWIDTH, TrainSCREENHEIGHT - TrainNavHeight -TrainCLASSHEIGHT)  andTableStatus:tableViewRefreshAll];
    [self.view addSubview:resultTableView];
    resultTableView.delegate =self;
    resultTableView.dataSource =self;
    [resultTableView registerClass:[TrainCourseClassListCell class] forCellReuseIdentifier:@"trainCourseCell"];
    [resultTableView registerClass:[TrainGroupListCell class] forCellReuseIdentifier:@"trainGroupCell"];
    [resultTableView registerClass:[TrainDocListTableViewCell class] forCellReuseIdentifier:@"trainDocCell"];
    [resultTableView registerClass:[TrainTopicSearchListCell class] forCellReuseIdentifier:@"trainTopicCell"];
    __weak __typeof(self)weakSelf = self;
    
    resultTableView.headBlock =^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        [strongSelf downLoadSearchResultData:1];
        
    };
    resultTableView.footBlock=^(int  index){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf downLoadSearchResultData:index];
        
    };
    resultTableView.refreshBlock =^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf downLoadSearchResultData:1];
        
    };
    
}


-(void)downLoadSearchResultData:(int) index{
    
    [self trainShowHUDOnlyActivity];
    [resultTableView dissTablePlace];

    [[TrainNetWorkAPIClient client] trainSearchResultWithStyle:_selectMode isTags:_isTag title:_searchTitle curPage:index Success:^(NSDictionary *dic) {
    
        if (dic) {
           
            NSArray  *dateArr;
            switch (_selectMode) {
                case TrainSearchStyleCourse:{
                    
                    if (index ==1) {
                        resultCouArr =[NSMutableArray new];
                    }
                    dateArr =[TrainCourseAndClassModel mj_objectArrayWithKeyValuesArray:dic[@"course"]];
                    [resultCouArr addObjectsFromArray:dateArr];

                }
                    break;
                case TrainSearchStyleCircle:{
                    if (index ==1) {
                        resultGroArr =[NSMutableArray new];
                    }
                    dateArr =[TrainGroupModel mj_objectArrayWithKeyValuesArray:dic[@"hotCircle"]];
                    [resultGroArr addObjectsFromArray:dateArr];

                }
                    break;
                case TrainSearchStyleDoc:{
                    if (index ==1) {
                        resultDocArr =[NSMutableArray new];
                    }
                    dateArr =[TrainDocListModel mj_objectArrayWithKeyValuesArray:dic[@"document"]];
                    [resultDocArr addObjectsFromArray:dateArr];
                    
                    
                }
                    break;
                case TrainSearchStyleTopic:{
                    if (index ==1) {
                        resultTopArr =[NSMutableArray new];
                    }
                    dateArr =[TrainTopicModel mj_objectArrayWithKeyValuesArray:dic[@"topic"]];
                    [resultTopArr addObjectsFromArray:dateArr];
                    
                    
                }
                    break;
                default:
                    break;
            };
            resultTableView.trainMode = trainStyleNoData;
            [resultTableView EndRefresh];
            [self trainHideHUD];

        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        resultTableView.trainMode = trainStyleNoNet;
        [resultTableView EndRefresh];
        [self trainHideHUD];

    }];
    
    
}
-(void)TrainClassMenuSelectIndex:(int)index{
    
    if (index == 1) {
        _selectMode = TrainSearchStyleTopic;
        
    }else{
        _selectMode = index;

    }
    switch (_selectMode) {
        case TrainSearchStyleCourse:{
            
            if ( TrainArrayIsEmpty(resultCouArr)) {
                [self downLoadSearchResultData:1];
            }
        }
            break;
        case TrainSearchStyleCircle:{
            
            if ( TrainArrayIsEmpty(resultGroArr)) {
                [self downLoadSearchResultData:1];
            }
        }
            break;
        case TrainSearchStyleDoc:{
            if ( TrainArrayIsEmpty(resultDocArr)) {
                [self downLoadSearchResultData:1];
            }
        }
            break;
        case TrainSearchStyleTopic:{
            if ( TrainArrayIsEmpty(resultTopArr)) {
                [self downLoadSearchResultData:1];
            }
        }
            break;
        default:
            break;
    };
    
    [resultTableView train_reloadData];
    resultTableView.currentpage =1;
    [resultTableView scrollRectToVisible:CGRectZero animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_selectMode == TrainSearchStyleCourse ) {
       
        return  TrainArrayIsEmpty(resultCouArr)?0 : resultCouArr.count;
        
    }else if (_selectMode == TrainSearchStyleCircle ) {
        
        return  TrainArrayIsEmpty(resultGroArr)?0 : resultGroArr.count;

    }else if (_selectMode == TrainSearchStyleDoc){
        return  TrainArrayIsEmpty(resultDocArr)?0 : resultDocArr.count;

    }else if(_selectMode == TrainSearchStyleTopic){
        return  TrainArrayIsEmpty(resultTopArr)?0 : resultTopArr.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (_selectMode) {
        case TrainSearchStyleCourse:{
            TrainCourseClassListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"trainCourseCell"];
            cell.isClass =NO;
            cell.searchStr =_searchTitle;
            cell.model =resultCouArr[indexPath.row];
            return cell;
        }
            break;
        case TrainSearchStyleCircle:{
            
            TrainGroupListCell *groupCell = [tableView dequeueReusableCellWithIdentifier:@"trainGroupCell"];
            groupCell.searchTitle = _searchTitle;
            groupCell.model = resultGroArr[indexPath.row];
            

            return groupCell;
        }
            break;
        case TrainSearchStyleDoc:{
            TrainDocListTableViewCell *docCell =[tableView dequeueReusableCellWithIdentifier:@"trainDocCell"];
            docCell.searchStr =_searchTitle;
            docCell.model =resultDocArr[indexPath.row];
            docCell.trainDocCollectStatus = ^(NSString *msg){
                
                [self trainShowHUDOnlyText:msg];
            };
            
            return docCell;
        }
            break;
        case TrainSearchStyleTopic:{
            
            TrainTopicSearchListCell *topicCell =[tableView dequeueReusableCellWithIdentifier:@"trainTopicCell"];
            topicCell.searchStr =_searchTitle;
            topicCell.model =resultTopArr[indexPath.row];
            return topicCell;
            
        }
            break;
        default:
            break;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (_selectMode) {
        case TrainSearchStyleCourse:
           return  trainAutoLoyoutImageSize(100);
            break;
        case TrainSearchStyleCircle:
            return  [resultTableView cellHeightForIndexPath:indexPath model:resultGroArr[indexPath.row] keyPath:@"model" cellClass:[TrainGroupListCell class] contentViewWidth:TrainSCREENWIDTH];;
            break;
        case TrainSearchStyleDoc:
            return  70;
            break;
        case TrainSearchStyleTopic:
            return  [resultTableView cellHeightForIndexPath:indexPath model:resultTopArr[indexPath.row] keyPath:@"model" cellClass:[TrainTopicSearchListCell class] contentViewWidth:TrainSCREENWIDTH];;;
            break;
        default:
            break;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    if ( _selectMode == TrainSearchStyleCourse) {
        TrainCourseAndClassModel *courseModel =resultCouArr[indexPath.row];
        TrainNewMovieViewController  *movieVC =[[TrainNewMovieViewController alloc]init];
        if (TrainStringIsEmpty(courseModel.type) ) {
            courseModel.type = @"TRAIN";
        }
        courseModel.room_id = @"0";
        courseModel.class_id = @"0";
        movieVC.courseModel = courseModel;
       
        [self.navigationController pushViewController:movieVC animated:YES];
        
    }else if (_selectMode == TrainSearchStyleCircle) {
        
        TrainGroupModel  *groupModel =[resultGroArr objectAtIndex:indexPath.row];
        
        TrainGroupDetailViewController *groupVC =[[TrainGroupDetailViewController alloc]init];
        groupVC.group_id = groupModel.group_id;
        [self.navigationController pushViewController:groupVC animated:YES];

    }else if(_selectMode == TrainSearchStyleDoc) {
        
        TrainDocListModel  *docModel = resultDocArr[indexPath.row];
        NSString  *webURL = [[TrainNetWorkAPIClient alloc] trainWebViewMode:@"viewdoc" object_id:docModel.en_id andtarget_id:nil];
        TrainWebViewController  *webVC =[[TrainWebViewController alloc]init];
        webVC.webURL =webURL;
        webVC.navTitle = docModel.name;
        [self.navigationController pushViewController:webVC animated:YES];

       
    }else if(_selectMode == TrainSearchStyleTopic){
        
        TrainTopicModel  *topicModel =[resultTopArr objectAtIndex:indexPath.row];
        
        TrainTopicDetailViewController  * topicVC =[[TrainTopicDetailViewController alloc]init];
        topicVC.model =topicModel;
        topicVC.updateModel = ^(TrainTopicModel *model){
            
            if (model) {
                [resultTopArr replaceObjectAtIndex:indexPath.row withObject:model];
                [resultTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [resultTopArr removeObjectAtIndex:indexPath.row];
                [resultTableView train_reloadData];
            }
        };
        
        [self.navigationController pushViewController:topicVC animated:YES];
        
        

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
