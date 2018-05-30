//
//  TrainBaseTableView.m
//   KingnoTrain
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainBaseTableView.h"

#import "TrainControllerUtil.h"
#import "TrainNodataView.h"

@interface TrainBaseTableView ()<TrainTableViewPlaceHolderDelegate>
{
    UIView              *view;
    UILabel             *lable ;
    UIButton            *button;
    tableViewRefresh    Status;
    UIRefreshControl    *_refresh;
    __block TrainNodataView *netReloader ;
}

@end

@implementation TrainBaseTableView

//@synthesize totalpages;

-(instancetype)initWithFrame:(CGRect)frame andTableStatus:(tableViewRefresh)tableStatus{
    
    self = [super initWithFrame:frame];
    
    if (self) {

        Status =tableStatus;
        self.isNull  = YES;
        _totalpages  = 1;
        _currentpage = 1;
        [self creatUI];
    }
    return self;
}

- (UIView *)tableNODataView:(trainStyle)style{
    
    netReloader = [[TrainNodataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) trainStyle:style reloadBlock:^{
        if (_refreshBlock) {
            _refreshBlock();
        }
        [netReloader dismiss];
        
    }];
    
    return netReloader;
}
-(void)dissTablePlace{
    [netReloader dismiss];
    
}
- (UIView *)makePlaceHolderView {
    return [self tableNODataView:_trainMode];
}

-(void)setTrainMode:(trainStyle)trainMode{
    _trainMode  = trainMode;
    [self train_reloadData];
}

-(void)setTotalpages:(int)totalpages{
    _totalpages = totalpages;
    
    
    
}
-(void)creatUI{
    self.tableFooterView =[UIView new];
    self.showsVerticalScrollIndicator =NO;
    self.showsHorizontalScrollIndicator =NO;
    self.separatorStyle =UITableViewCellSeparatorStyleNone;

    
    if (Status ==tableViewRefreshAll ||Status ==tableViewRefreshHeader) {
        
        self.mj_header  =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
                _currentpage =1;
                if (_headBlock) {
                    _headBlock();
                }
            }];
        }
        [self.mj_header beginRefreshing];
    
    if (Status ==tableViewRefreshAll || Status ==tableViewRefreshFooter) {
//        MJRefreshAutoNormalFooter  *footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

        TrainWeakSelf(self);
            MJRefreshBackNormalFooter  *footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                if (_currentpage < _totalpages) {
                    _currentpage ++;
                    
                    if (_footBlock) {
                        _footBlock(_currentpage);
                    }
                }else{
                    
                    [weakself.mj_footer endRefreshingWithNoMoreData];
                }
            }];
    
            self.mj_footer  = footer;
            
            [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    
        }
}


-(void)shuaxin{
    view.hidden =YES;
    if (_refreshBlock) {
        _refreshBlock();
    }
}
-(void)setCurrentpage:(int)currentpage{
    _currentpage =currentpage;
}

-(void)EndRefresh{
    
    [self.mj_header endRefreshing];
    if (_currentpage >= _totalpages ) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mj_footer endRefreshing];
    }
}




@end
