//
//  TrainNewClassModel.h
//  KindeeTrain
//
//  Created by admin on 2018/6/16.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainNewClassModel : NSObject

@property (nonatomic, copy) NSString         *cnum;
@property (nonatomic, copy) NSString         *commentNum;
@property (nonatomic, copy) NSString         *create_date;
@property (nonatomic, copy) NSString         *create_name;
@property (nonatomic, copy) NSString         *end_date;
@property (nonatomic, copy) NSString         *favNum;
@property (nonatomic, copy) NSString         *class_id;
@property (nonatomic, assign) NSInteger      is_end;
@property (nonatomic, assign) NSInteger      is_start;
@property (nonatomic, assign) BOOL           is_fav;
@property (nonatomic, copy) NSString         *name;
@property (nonatomic, copy) NSString         *object_name;
@property (nonatomic, copy) NSString         *picture;
@property (nonatomic, copy) NSString         *register_id;
@property (nonatomic, copy) NSString         *start_date;
@property (nonatomic, copy) NSString         *studentNum;
@property (nonatomic, copy) NSString         *tactic_id;
@property (nonatomic, assign) NSInteger      totPage;
@property (nonatomic, copy) NSString         *type;


@end
