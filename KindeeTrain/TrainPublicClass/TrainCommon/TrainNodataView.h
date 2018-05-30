//
//  TrainNodataView.h
//  SOHUEhr
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年  . All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TrainBaseTableView.h"
typedef void(^ReloadButtonClickBlock)() ;
//typedef NS_ENUM(NSInteger) {
//    trainStyleDefault = 0,
//    trainStyleNoData,
//    trainStyleNoNet,
//}trainStyle;

@interface TrainNodataView : UIView

- (instancetype)initWithFrame:(CGRect)frame trainStyle:(trainStyle)style
                  reloadBlock:(ReloadButtonClickBlock)reloadBlock ;

- (void)showInView:(UIView *)viewWillShow ;
- (void)dismiss ;
@end
