//
//  TrainCourseDetailModel.h
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseModel.h"

@interface TrainCourseDetailModel : TrainBaseModel

@end

//@interface TrainCourseIntroductionModel  : TrainBaseModel
//
//@end


@interface TrainCourseDirectoryModel  : TrainBaseModel

@property(nonatomic,copy) NSString   *c_id;
@property(nonatomic,copy) NSString   *c_type;    // 课时的类型  //    V 视频 L 直播   D 文档  E 考试   p (is_free 为h5的) 课程包   O 链接
@property(nonatomic,copy) NSString   *h_type;    // 章节 单元  C   U  D 课时H
@property(nonatomic,copy) NSString   *h5;    //  判断课时是否为h5
@property(nonatomic,copy) NSString   *list_id;
@property(nonatomic,copy) NSString   *list_init_file;
@property(nonatomic,copy) NSString   *last_study_date;
@property(nonatomic,copy) NSString   *last_time;
@property(nonatomic,copy) NSString   *object_id;
@property(nonatomic,copy) NSString   *title;
@property(nonatomic,copy) NSString   *ua_status;
@property(nonatomic,copy) NSString   *ua_study_num;
@property(nonatomic,copy) NSString   *ua_time;
@property(nonatomic,copy) NSString   *user_id;
@property(nonatomic,copy) NSString   *is_free;         //  在P下 如果为H 则 是  h5
@property(nonatomic,copy) NSString   *starting_url;    //  课程包 地址
@property(nonatomic,copy) NSString   *is_start ;    //  课程包 地址
@property(nonatomic,copy) NSString   *is_end;    //  课程包 地址
@property(nonatomic,copy) NSString   *course_objectid;

@property(nonatomic,assign) BOOL         isDown;
@property(nonatomic,copy) NSString      *condition;
@property(nonatomic,assign) NSInteger   saveTime;    // 课时学习时间
@property(nonatomic,assign) NSInteger   saveGo_Num;  //离线保存是只有退出才是1
@end



@interface TrainCourseNoteModel  : TrainBaseModel
@property(nonatomic,copy) NSString   *content;
@property(nonatomic,copy) NSString   *create_date;
@property(nonatomic,copy) NSString   *create_name;
@property(nonatomic,copy) NSString   *totPage;

@property(nonatomic,assign) BOOL    isOpen;
@property(nonatomic,assign,readonly)  BOOL  isShowButton;

@end



@interface TrainCourseDiscussModel  : TrainBaseModel
@property(nonatomic,copy) NSString   *collect_num;
@property(nonatomic,copy) NSString   *content;
@property(nonatomic,copy) NSString   *create_date;
@property(nonatomic,copy) NSString   *full_name;
@property(nonatomic,copy) NSString   *hit_num;
@property(nonatomic,copy) NSString   *discuss_id;
@property(nonatomic,copy) NSString   *is_elite;
@property(nonatomic,copy) NSString   *is_stick;
@property(nonatomic,copy) NSString   *object_id;
@property(nonatomic,copy) NSString   *post_num;
@property(nonatomic,strong)NSArray   *posts;
@property(nonatomic,copy) NSString   *sphoto;
@property(nonatomic,copy) NSString   *timeDifference;
@property(nonatomic,copy) NSString   *title;
@property(nonatomic,copy) NSString   *top_num;
@property(nonatomic,copy) NSString   *totCount;
@property(nonatomic,copy) NSString   *totPage;
@property(nonatomic,copy) NSString   *type;
@property(nonatomic,copy) NSString   *user_id;
@property(nonatomic,copy) NSString   *myuser_id;   //课程回复 判断是否为自己的话题
@property(nonatomic,copy) NSString   *mypost_id;   // 用于 课程话题回复删除
@property(nonatomic,assign) BOOL     isFirst;
@end


@interface TrainCourseDiscussListModel  : TrainBaseModel

@property(nonatomic,copy) NSArray   *child_post_list;
@property(nonatomic,copy) NSString  *sphoto;//
@property(nonatomic,copy) NSString  *content;//
@property(nonatomic,copy) NSString  *create_date;
@property(nonatomic,copy) NSString  *curPage;
@property(nonatomic,copy) NSString  *end;
@property(nonatomic,copy) NSString  *from_post_id;
@property(nonatomic,copy) NSString  *from_user_id;
@property(nonatomic,copy) NSString  *full_name;
@property(nonatomic,copy) NSString  *goPage;
@property(nonatomic,copy) NSString  *discuss_id;
@property(nonatomic,copy) NSString  *last_update_by;
@property(nonatomic,copy) NSString  *now_time;
@property(nonatomic,copy) NSString  *pageSize;
@property(nonatomic,copy) NSString  *row_no;
@property(nonatomic,copy) NSString  *site_id;
@property(nonatomic,copy) NSString  *start;
@property(nonatomic,copy) NSString  *topic_id;
@property(nonatomic,copy) NSString  *totCount;
@property(nonatomic,copy) NSString  *totPage;
@property(nonatomic,copy) NSString  *user_id;
@property(nonatomic,copy) NSString  *username;
@property(nonatomic,copy) NSString  *super_id;
@property(nonatomic,assign) BOOL     isFirst;

@end


@interface TrainCourseAppraiseModel  : TrainBaseModel

@property(nonatomic,copy) NSString   *app_id;
@property(nonatomic,copy) NSString   *content;
@property(nonatomic,copy) NSString   *create_by;
@property(nonatomic,copy) NSString   *create_date;
@property(nonatomic,copy) NSString   *create_name;
@property(nonatomic,copy) NSString   *grade;
@property(nonatomic,copy) NSString   *totPage;
@property(nonatomic,copy) NSString   *user_id;
@property(nonatomic,copy) NSString   *mphoto;
@property(nonatomic,copy) NSString   *audit_status;
@property(nonatomic,assign) BOOL    isOpen;
@property(nonatomic,assign,readonly)  BOOL  isShowButton;
@end
