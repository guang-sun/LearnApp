//
//  TrainUnfoldView.h
//  SOHUEhr
//
//  Created by apple on 16/10/8.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainMacroDefine.h"

@interface TrainUnfoldView : UIView

@property(nonatomic,copy) NSString   *text;
@property(nonatomic,assign) float    maxHeight;


-(instancetype)initWithMaxHeight:(float)height;

@end
