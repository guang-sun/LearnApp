//
//  TrainDocListModel.h
//  SOHUEhr
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseModel.h"

@interface TrainDocListModel : TrainBaseModel


@property(nonatomic,copy)  NSString  *create_by;
@property(nonatomic,copy)  NSString  *create_by_name;
@property(nonatomic,copy)  NSString  *descr;
@property(nonatomic,copy)  NSString  *download_count;
@property(nonatomic,copy)  NSString  *en_id;
@property(nonatomic,copy)  NSString  *file_size;
@property(nonatomic,copy)  NSString  *format;
@property(nonatomic,copy)  NSString  *doc_id;
@property(nonatomic,copy)  NSString  *is_collected;
@property(nonatomic,copy)  NSString  *name;
@property(nonatomic,copy)  NSString  *read_count;
@property(nonatomic,copy)  NSString  *totPage;
@property(nonatomic,copy)  NSString  *url;
@property(nonatomic,copy)  NSString  *is_appraise;
@property(nonatomic,copy)  NSString  *exam_id;

@end
