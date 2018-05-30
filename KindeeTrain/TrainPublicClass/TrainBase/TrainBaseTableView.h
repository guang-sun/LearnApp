//
//  TrainBaseTableView.h
//   KingnoTrain
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UITableView+TrainTableViewPlaceHolder.h"

typedef enum{
    tableViewRefreshAll=0,
    tableViewRefreshHeader,
    tableViewRefreshFooter,
    tableViewRefreshNone
}tableViewRefresh;


typedef NS_ENUM(NSInteger) {
    trainStyleDefault = 0,
    trainStyleNoData,
    trainStyleNoNet,
}trainStyle;

@interface TrainBaseTableView : UITableView

typedef void(^headerRereshBlock)();
typedef void(^FooterRereshBlock)(int  index);
typedef void(^btnRefreshBlock)();

@property(nonatomic,copy) headerRereshBlock  headBlock;
@property(nonatomic,copy) FooterRereshBlock  footBlock;
@property(nonatomic,copy) btnRefreshBlock    refreshBlock;
@property(nonatomic,assign) BOOL    isNull;
@property(nonatomic,assign) BOOL    isNUllNet;
@property(nonatomic,assign) trainStyle      trainMode;
@property(nonatomic,assign)int             totalpages;// 刷新 的总页数
@property(nonatomic,assign )  int             currentpage;
-(instancetype)initWithFrame:(CGRect)frame andTableStatus:(tableViewRefresh )tableStatus;
//-(instancetype)initWithFrame:(CGRect)frame andTarget:(id)target andTableStatus:(tableViewRefresh )tableStatus;

-(void)EndRefresh;
//-(void)updateUIFrame:(CGRect )rect;
-(void)dissTablePlace;

@end
