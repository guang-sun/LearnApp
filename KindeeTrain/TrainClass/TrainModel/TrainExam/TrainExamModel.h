//
//  TrainExamModel.h
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseModel.h"

@interface TrainExamModel : TrainBaseModel


@property(nonatomic,copy) NSString  *answer_number;   //答过
@property(nonatomic,copy) NSString  *answer_number_count; //总次数  0  不限
@property(nonatomic,copy) NSString  *answer_time;  //时间   分钟

@property(nonatomic,copy) NSString  *complete_status;  //状态P 通过  F 失败  I 状态进行中  M  待阅卷  N  状态未开始
@property(nonatomic,copy) NSString  *curPage;
@property(nonatomic,copy) NSString  *end;
@property(nonatomic,copy) NSString  *exam_id;
@property(nonatomic,copy) NSString  *exam_paper_id;
@property(nonatomic,copy) NSString  *goPage;
@property(nonatomic,copy) NSString  *is_Expired;   //是否过期
@property(nonatomic,copy) NSString  *is_review;  //是否可回顾

@property(nonatomic,copy) NSString  *is_published;
@property(nonatomic,copy) NSString  *is_view_score; // =N   完成状态，和分数 不公开
@property(nonatomic,copy) NSString  *name;
@property(nonatomic,copy) NSString  *object_id;
@property(nonatomic,copy) NSString  *object_name;
@property(nonatomic,copy) NSString  *object_type;   // 考试类型 CTRAIN 课程 Independent  独立  CLASS  CROOM 班级
@property(nonatomic,copy) NSString  *p_id;

@property(nonatomic,copy) NSString  *pageSize;
@property(nonatomic,copy) NSString  *pass_line;  //及格线
@property(nonatomic,copy) NSString  *pfm_score;   //得分
@property(nonatomic,copy) NSString  *photo;
@property(nonatomic,copy) NSString  *publish_key;
@property(nonatomic,copy) NSString  *que_count;   //试题数

@property(nonatomic,copy) NSString  *score;      //总分
@property(nonatomic,copy) NSString  *site_id;
@property(nonatomic,copy) NSString  *start;
@property(nonatomic,copy) NSString  *totCount;
@property(nonatomic,copy) NSString  *totPage;
@property(nonatomic,copy) NSString  *type_id;
@property(nonatomic,copy) NSString  *content;

@property(nonatomic,copy) NSString  *user_id;
@property(nonatomic,copy) NSString  *end_date;
@property(nonatomic,copy) NSString  *start_date;


@end
