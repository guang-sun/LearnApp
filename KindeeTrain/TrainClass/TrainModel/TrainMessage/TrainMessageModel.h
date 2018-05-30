//
//  TrainMessageModel.h
//   KingnoTrain
//
//  Created by apple on 17/1/4.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import "TrainBaseModel.h"

@interface TrainMessageModel : TrainBaseModel

@property(nonatomic, strong)  NSString   *category_id;
@property(nonatomic, strong)  NSString   *category_name;
@property(nonatomic, strong)  NSString   *content;
@property(nonatomic, strong)  NSString   *create_by;
@property(nonatomic, strong)  NSString   *create_by_name;
@property(nonatomic, strong)  NSString   *create_date;
@property(nonatomic, strong)  NSString   *curPage;
@property(nonatomic, strong)  NSString   *end;
@property(nonatomic, strong)  NSString   *expired_status;
@property(nonatomic, strong)  NSString   *featured;   //
@property(nonatomic, strong)  NSString   *goPage;
@property(nonatomic, strong)  NSString   *hits;
@property(nonatomic, strong)  NSString   *message_id;
@property(nonatomic, strong)  NSString   *last_update_by;
@property(nonatomic, strong)  NSString   *object_id;
@property(nonatomic, strong)  NSString   *originalthumb;
@property(nonatomic, strong)  NSString   *pageSize;
@property(nonatomic, strong)  NSString   *post_num;
@property(nonatomic, strong)  NSString   *promoted; //
@property(nonatomic, strong)  NSString   *site_id;
@property(nonatomic, strong)  NSString   *site_name;
@property(nonatomic, strong)  NSString   *start;
@property(nonatomic, strong)  NSString   *sticky;   //
@property(nonatomic, strong)  NSString   *tag_id;
@property(nonatomic, strong)  NSString   *thumb;
@property(nonatomic, strong)  NSString   *title;
@property(nonatomic, strong)  NSString   *totCount;
@property(nonatomic, strong)  NSString   *totPage;
@property(nonatomic, strong)  NSString   *type;
@property(nonatomic, strong)  NSString   *ups_num;
@property(nonatomic, strong)  NSString   *user_id;
@end
