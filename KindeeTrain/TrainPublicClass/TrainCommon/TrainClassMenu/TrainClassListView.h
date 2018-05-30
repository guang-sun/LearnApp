//
//  TrainClassListView.h
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainMacroDefine.h"

@interface TrainClassListView : UIView

@property(nonatomic,strong) NSArray      *listArr;
@property(nonatomic,strong) NSDictionary *listDic;
@property(nonatomic,assign) BOOL         ishidetable;
@property(nonatomic,copy)   NSString     *collectSelect;

@property(nonatomic,strong) UICollectionView  *classCollectionView;
@property(nonatomic,strong) UITableView       *classTableView;

@property(nonatomic,copy)  void  (^hideView)();
@property(nonatomic,copy)  void  (^classDidselect)(NSDictionary *dic);

-(id)initWithFrame:(CGRect)frame WithArrar:(NSArray *)arr andDic:(NSDictionary *)dic andistable:(BOOL )istable;

@end
