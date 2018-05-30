//
//  TrainClassMenuView.h
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TrainMacroDefine.h"

@protocol TrainClassMenuDelegate <NSObject>

@optional
-(void)TrainClassMenuSelectDic:(NSDictionary *)dic;
-(void)TrainClassMenuSelectIndex:(int)index;

@end

@interface TrainClassMenuView : UIView
@property(nonatomic,strong) NSArray       *collectArr;
@property(nonatomic,strong) NSDictionary  *tableCollectDic;
@property(nonatomic,assign) BOOL          istable;
@property(nonatomic,assign) int           selectIndex;
@property(nonatomic,copy)   NSString      *collectSelect;
@property(nonatomic,assign) id<TrainClassMenuDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame andArr:(NSArray *)arr ;
-(void)resetTopMenu:(NSArray *)newArr;
-(void)dismissTopMenu;
@end
