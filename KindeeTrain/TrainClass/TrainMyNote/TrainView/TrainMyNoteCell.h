//
//  TrainMyNoteCell.h
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainMyNoteModel.h"
@interface TrainMyNoteCell : UITableViewCell

@property(nonatomic,copy) void (^unfoldBlock)() ;
@property(nonatomic,copy) void (^editDeleteBlock)( NSInteger  index) ;

@property(nonatomic,strong) TrainMyNoteModel  *model;
@end
