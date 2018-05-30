//
//  TrainClassMoreHeaderView.h
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainMacroDefine.h"

typedef void (^tableViewHeadTouch)();

@interface TrainClassMoreHeaderView : UITableViewHeaderFooterView

@property(nonatomic,copy) NSString  *title;
@property(nonatomic,assign)BOOL     isshowMore;
@property(nonatomic,copy) tableViewHeadTouch headerTouch;
@end
