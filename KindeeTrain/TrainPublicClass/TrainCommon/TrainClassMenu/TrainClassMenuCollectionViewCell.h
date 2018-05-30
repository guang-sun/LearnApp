//
//  TrainClassMenuCollectionViewCell.h
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrainMacroDefine.h"

@interface TrainClassMenuCollectionViewCell : UICollectionViewCell

@property(nonatomic,assign) BOOL   isTableView;

@property(nonatomic,copy)   NSString    *title;
@property(nonatomic,strong) UIColor   *titleColor;
@property(nonatomic,strong) UIColor   *cusborderColor;
@property(nonatomic,strong) UIColor   *labbackgroup;

@property(nonatomic,assign) BOOL     istable;

@end
