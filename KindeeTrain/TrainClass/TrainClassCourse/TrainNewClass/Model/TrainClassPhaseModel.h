//
//  TrainClassPhaseModel.h
//  KindeeTrain
//
//  Created by admin on 2018/6/18.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TrainCourseDetailModel.h"
@class TrainClassExamModel ;

@interface TrainClassPhaseModel : NSObject

@property (nonatomic, copy) NSString         *c_id;
@property (nonatomic, copy) NSString         *c_type;
@property (nonatomic, copy) NSString         *last_sec_id;
@property (nonatomic, copy) NSString         *sec_compulsory;
@property (nonatomic, copy) NSString         *sec_id;
@property (nonatomic, copy) NSString         *sec_name;

@end

@interface TrainClassResModel : NSObject

@property (nonatomic, copy) NSString         *allow_num;
@property (nonatomic, copy) NSString         *answer_num;
@property (nonatomic, copy) NSString         *cTypeStr;
@property (nonatomic, copy) NSString         *c_id;
@property (nonatomic, copy) NSString         *class_id;
@property (nonatomic, copy) NSString         *classroom_id;
@property (nonatomic, copy) NSString         *com_h_ids;
@property (nonatomic, copy) NSString         *condition;
@property (nonatomic, copy) NSString         *res_id;
@property (nonatomic, copy) NSString         *hour_num;
@property (nonatomic, assign) BOOL           isStudy;
@property (nonatomic, copy) NSString         *isStudyMsg;
@property (nonatomic, assign) BOOL           is_compulsory;
@property (nonatomic, copy) NSString         *is_end;
@property (nonatomic, copy) NSString         *is_start;
@property (nonatomic, copy) NSString         *jf_mode;
@property (nonatomic, copy) NSString         *obj_id;
@property (nonatomic, copy) NSString         *obj_name;
@property (nonatomic, copy) NSString         *obj_type;
@property (nonatomic, copy) NSString         *p_id;
@property (nonatomic, copy) NSString         *pass_line;
@property (nonatomic, copy) NSString         *picture;
@property (nonatomic, copy) NSString         *sum_score;
@property (nonatomic, copy) NSString         *start_date;
@property (nonatomic, copy) NSString         *starting_url;
@property (nonatomic, copy) NSString         *end_date;
@property (nonatomic, strong) NSArray<TrainClassExamModel *>        *attemptList;

@property (nonatomic, strong) NSArray<TrainCourseDirectoryModel *>  *resList;
@property (nonatomic, assign) BOOL           isOpen;

@end

@interface TrainClassExamModel   : NSObject

@property (nonatomic, copy) NSString         *complete_status; /*完成状态(P完成/I进行中/F未通过/M待阅卷)*/
@property (nonatomic, copy) NSString         *exam_id;
@property (nonatomic, copy) NSString         *exam_status; /*交卷状态(I进行中/C正常交卷/Q强制交卷)*/
@property (nonatomic, copy) NSString         *exam_time; /*考试花费时间(秒) */
@property (nonatomic, copy) NSString         *record_id; /*记录id*/
@property (nonatomic, copy) NSString         *object_score; /*客观题得分*/
@property (nonatomic, copy) NSString         *performance_id; /*成绩id*/
@property (nonatomic, copy) NSString         *right_count; /*正确题目数*/
@property (nonatomic, copy) NSString         *score; /*考试分数*/
@property (nonatomic, copy) NSString         *subject_score; /*主观题得分*/
@property (nonatomic, copy) NSString         *create_date; /*创建时间*/

@end

