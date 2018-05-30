//
//  TrainCourseAndClassModel.h
//   KingnoTrain
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainBaseModel.h"

@interface TrainCourseAndClassModel : TrainBaseModel

//  课程
@property(nonatomic,copy) NSString  *c_id;
@property(nonatomic,copy) NSString  *grade;
@property(nonatomic,copy) NSString  *hours;
@property(nonatomic,copy) NSString  *last_title;
@property(nonatomic,copy) NSString  *lecturer_name;
@property(nonatomic,copy) NSString  *lecturer_photo;
@property(nonatomic,copy) NSString  *study_num;
@property(nonatomic,copy) NSString  *picture;
@property(nonatomic,copy) NSString  *c_type;
@property(nonatomic,copy) NSString  *register_id;
@property(nonatomic,copy) NSString  *price;
@property(nonatomic,copy) NSString  *introduction;
@property(nonatomic,assign) NSInteger  completed_percent;
@property(nonatomic,copy) NSString  *c_status; // 课程报名s 已报名 其他未报名

//  班级
@property(nonatomic,copy) NSString  *cnum;
@property(nonatomic,copy) NSString  *class_id;
@property(nonatomic,copy) NSString  *pnum;
@property(nonatomic,copy) NSString  *room_id;

@property(nonatomic,copy) NSString  *create_date;
@property(nonatomic,copy) NSString  *create_name;

//  gongyou
@property(nonatomic,copy) NSString  *totPage;
@property(nonatomic,copy) NSString  *name;
@property(nonatomic,copy) NSString  *totTime;
@property(nonatomic,copy) NSString  *type;
@property(nonatomic,copy) NSString  *object_id;

@property(nonatomic,copy) NSString   *is_start ;    //  课程包 地址
@property(nonatomic,copy) NSString   *is_end;    //  课程包 地址


@end
