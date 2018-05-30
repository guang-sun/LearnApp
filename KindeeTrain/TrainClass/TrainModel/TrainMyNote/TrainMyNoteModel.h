//
//  TrainMyNoteModel.h
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseModel.h"

@interface TrainMyNoteModel : TrainBaseModel
@property(nonatomic,copy)  NSString *content;

@property(nonatomic,assign) BOOL    isOpen;
@property(nonatomic,assign,readonly)  BOOL  isShowButton;


@property(nonatomic,copy)  NSString *c_id;
@property(nonatomic,copy)  NSString *create_by;
@property(nonatomic,copy)  NSString *note_id;
@property(nonatomic,copy)  NSString *is_public;
@property(nonatomic,copy)  NSString *create_date;
@property(nonatomic,copy)  NSString *create_name;
@property(nonatomic,copy)  NSString *ct_name;
@property(nonatomic,copy)  NSString *end;
@property(nonatomic,copy)  NSString *goPage;
@property(nonatomic,copy)  NSString *hour_id;
@property(nonatomic,copy)  NSString *object_id;
@property(nonatomic,copy)  NSString *pageSize;
@property(nonatomic,copy)  NSString *start;
@property(nonatomic,copy)  NSString *totCount;
@property(nonatomic,copy)  NSString *totPage;

@end
