//
//  TrainAddNoteViewController.h
//  SOHUEhr
//
//  Created by apple on 16/10/8.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseViewController.h"

#import "TrainMyNoteModel.h"
@protocol trainNoteDelegate <NSObject>
@required

-(void)saveNoteSuccess:(NSDictionary *)dic;

@end

@interface TrainAddNoteViewController : TrainBaseViewController

/** add :  type room_id hour_id  object_id  c_id
 */
@property(nonatomic, strong) NSDictionary           *infoDic;
@property(nonatomic, assign) id<trainNoteDelegate>  delegate;
@property(nonatomic, copy) void  (^updateNoteEditBlock)(NSString *content);

@property(nonatomic, assign) BOOL                   isEditNote;
@property(nonatomic, strong) TrainMyNoteModel       *editModel;



@end
