//
//  TrainClassCommendViewController.m
//  KindeeTrain
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainClassCommendViewController.h"
#import "TrainClassCommendCell.h"
#import "TrainCommendStatusCell.h"
#import "TrainCourseDetailModel.h"
#import "TrainAddAppraiseViewController.h"

@interface TrainClassCommendViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,trainAppraiseDelegate>

{
    NSInteger       selectIndex ;
}
@property (nonatomic, strong) UICollectionView  *comCollectionView ;
@property (nonatomic, strong) NSMutableArray     *commentMuArr ;
@property (nonatomic, strong) NSMutableArray     *collectArr ;

@end

@implementation TrainClassCommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectIndex = 0 ;
    
    [self rzaddTableview];
    [self rzCommentList:1];
    NSMutableArray * muArr  = [NSMutableArray arrayWithObjects:@"全部(0)" ,@"好评(0)",@"中评(0)", @"差评(0)", nil];
    self.collectArr = muArr ;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        self.infoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

#pragma mark - WMStickyPageViewControllerDelegate
- (UIScrollView *)stretchScrollView {
    return self.infoTableView;
}


- (void)rzCommentList:(NSInteger)index {
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainClassCommentListWithClass_id:self.class_id  grade:selectIndex pageNum:index Success:^(NSDictionary *dic) {
        if (index == 1 ) {
            weakself.commentMuArr = [NSMutableArray array];
            TrainCourseAppraiseModel *model = [TrainCourseAppraiseModel mj_objectWithKeyValues:dic[@"myCommentJson"]];
            model.ismy = YES ;
            
            if (selectIndex == 0) {
                [weakself.commentMuArr addObject:model];
            }else {
             
                if ([model.grade integerValue] == 1) {
                    if (selectIndex == 3) {
                        [weakself.commentMuArr addObject:model];
                    }
                }else if ([model.grade integerValue] == 5){
                    if (selectIndex == 1) {
                        [weakself.commentMuArr addObject:model];
                    }
                }else if([model.grade integerValue]== 0){
                    
                }else {
                    if (selectIndex == 2) {
                        [weakself.commentMuArr addObject:model];
                    }
                }
            }
        }
        NSArray  *dateArr = [TrainCourseAppraiseModel mj_objectArrayWithKeyValuesArray:dic[@"commentJsons"]];
        [weakself.commentMuArr addObjectsFromArray: dateArr] ;
        if (dateArr.count>0) {
            TrainCourseAppraiseModel *model = [dateArr firstObject];
            weakself.infoTableView.totalpages = (int)model.totPage ;
        }
        [self rzDealWithCommentList:dic];
        [weakself.infoTableView reloadData];
        [weakself.infoTableView EndRefresh];

    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
       
        [weakself.infoTableView EndRefresh];

    }];
}


- (void)rzaddTableview {
    
    [self.view addSubview:self.infoTableView];
    [self.view addSubview:self.comCollectionView];
    UIView *vie =  [[UIView alloc]initWithLineView];
    
    [self.view addSubview:vie];
    [self.comCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [vie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(10);
        make.top.equalTo(self.comCollectionView.mas_bottom);
        
    }];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(vie.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    TrainWeakSelf(self);
    self.infoTableView.headBlock = ^{
        [weakself rzCommentList:1];
        
    };
    
    self.infoTableView.footBlock = ^(int index) {
        [weakself rzCommentList:index];

    };
}


- (void)rzDealWithCommentList:(NSDictionary *)dic {
    
    NSInteger  allNum       = [dic[@"all"] integerValue] ;
    TrainCourseAppraiseModel *model = [TrainCourseAppraiseModel mj_objectWithKeyValues:dic[@"myCommentJson"]];

    NSInteger  praiseNum    = [dic[@"praise"] integerValue]; // 好评
    NSInteger  reviewNum    = [dic[@"review"] integerValue];  //中评
    NSInteger  negativeNum  = [dic[@"negative"] integerValue]; //差评
    if ([model.grade integerValue] > 0) {
        allNum += 1 ;
        if ([model.grade integerValue] == 1) {
            negativeNum +=1 ;
        }else if ([model.grade integerValue] == 5){
            praiseNum +=1 ;
        }else {
            reviewNum +=1 ;
        }
    }
    NSString  *string = [NSString stringWithFormat:@"全部(%zi)",allNum];
    NSString  *string1 = [NSString stringWithFormat:@"好评(%zi)",praiseNum];
    NSString  *string2 = [NSString stringWithFormat:@"差评(%zi)",negativeNum];
    NSString  *string3 = [NSString stringWithFormat:@"中评(%zi)",reviewNum];
    NSMutableArray * muArr  = [NSMutableArray arrayWithObjects:string ,string1, string3, string2, nil];
    self.collectArr = muArr ;
    [self.comCollectionView reloadData];
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.collectArr.count ;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TrainCommendStatusCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TrainCommendStatusCell class]) forIndexPath:indexPath];
    cell.contentText = self.collectArr[indexPath.row];
    cell.isSelect = (indexPath.row == selectIndex);
    
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (selectIndex != indexPath.row) {
        selectIndex = indexPath.row ;
        [collectionView reloadData];
        
        [self.infoTableView.mj_header beginRefreshing];
    }
}

#pragma mark - ============== tableviewDelegate ===================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.commentMuArr.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrainClassCommendCell  *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TrainClassCommendCell class])];
    TrainWeakSelf(self);
    [cell rzUpdateClassCommentWithModel:self.commentMuArr[indexPath.row]];
    cell.rzAddComemdAppresiseBlock = ^{
        [weakself rzaddComappr];
    };
    
    return cell ;
    
}



#pragma  mark 删除自己的评价

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainCourseAppraiseModel  *myAppraise = [self.commentMuArr firstObject];
    int  group = [myAppraise.grade intValue];
    if (indexPath.row == 0 && group > 0 ) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        BOOL   isclass = YES;
        TrainCourseAppraiseModel  *appModel = [self.commentMuArr firstObject];
            
        [[TrainNetWorkAPIClient client] trainCourseDeleteAppraiseWithIsClass:isclass Appraise_id:self.class_id Success:^(NSDictionary *dic) {
        
            TrainCourseAppraiseModel  *newApp = [[TrainCourseAppraiseModel alloc]init];
            newApp.create_by = @"0";
            newApp.grade = @"0";
            newApp.totPage = @"0";
            newApp.ismy = YES ;
            [self.commentMuArr replaceObjectAtIndex:0 withObject:newApp];
            
            [self.infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            
        }];
    }
}



- (void)rzaddComappr {
    
    TrainAddAppraiseViewController  *appraiseVC = [[TrainAddAppraiseViewController alloc]init];
    appraiseVC.class_id = self.class_id ;
    appraiseVC.isclass = YES ;
    appraiseVC.delegate   = self ;
    [self.navigationController pushViewController:appraiseVC animated:YES];
}

- (void)saveAppraiseSuccess:(NSDictionary *)dic {
    
    [self.infoTableView.mj_header beginRefreshing];
    
}

- (TrainBaseTableView *)infoTableView {
    if (!_infoTableView) {
        TrainBaseTableView *tableview =[[TrainBaseTableView alloc]initWithFrame:CGRectZero  andTableStatus:tableViewRefreshAll];
        
        tableview.delegate    = self;
        tableview.dataSource  = self;
        tableview.rowHeight   = UITableViewAutomaticDimension ;
        tableview.estimatedRowHeight   = trainAutoLoyoutImageSize(100) ;
        
        UINib  *nib =[UIView loadNibNamed:@"TrainClassCommendCell"];

        [tableview registerNib:nib forCellReuseIdentifier:NSStringFromClass([TrainClassCommendCell class])];
        
        _infoTableView = tableview ;
    }
    return _infoTableView ;
}


- (UICollectionView *)comCollectionView {
    if (!_comCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        
        CGFloat  width = (TrainSCREENWIDTH - 4 *TrainMarginWidth ) /4.f ;
        layout.itemSize = CGSizeMake(width, 30) ;
        
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collectView.backgroundColor = [UIColor whiteColor];
        collectView.contentInset = UIEdgeInsetsMake(12, TrainMarginWidth, 12, TrainMarginWidth);
        collectView.delegate = self;
        collectView.dataSource = self;
        
        UINib  *nib =[UIView loadNibNamed:@"TrainCommendStatusCell"];
        
        [collectView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([TrainCommendStatusCell class])];
        
        _comCollectionView = collectView;
    }
    return _comCollectionView;
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
