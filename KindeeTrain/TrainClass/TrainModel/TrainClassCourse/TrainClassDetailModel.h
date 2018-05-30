//
//  TrainClassUserModel.h
//   KingnoTrain
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainBaseModel.h"

@interface TrainClassDetailModel : TrainBaseModel

@end


@interface TrainClassUserModel : TrainBaseModel


@property(nonatomic,copy) NSString  *l_level;

@property(nonatomic,copy) NSString  *class_id;
@property(nonatomic,copy) NSString  *curPage;
@property(nonatomic,copy) NSString  *end;
@property(nonatomic,copy) NSString  *full_name;
@property(nonatomic,copy) NSString  *goPage;
@property(nonatomic,copy) NSString  *group_name;
@property(nonatomic,copy) NSString  *group_shortname;
@property(nonatomic,copy) NSString  *highest_edu_name;
@property(nonatomic,copy) NSString  *Detali_id;
@property(nonatomic,copy) NSString  *le_id;
@property(nonatomic,copy) NSString  *lhnames;
@property(nonatomic,copy) NSString  *pageSize;
@property(nonatomic,copy) NSString  *remark;
@property(nonatomic,copy) NSString  *t_url;
@property(nonatomic,copy) NSString  *site_id;
@property(nonatomic,copy) NSString  *start;
@property(nonatomic,copy) NSString  *totCount;
@property(nonatomic,copy) NSString  *totPage;
@property(nonatomic,copy) NSString  *user_id;
@property(nonatomic,copy) NSString  *photo;

@end



@interface TrainClassCourseModel : TrainBaseModel

@property(nonatomic,copy) NSString  *c_id;
@property(nonatomic,copy) NSString  *c_type;
@property(nonatomic,copy) NSString  *class_id;
@property(nonatomic,copy) NSString  *completed_num;
@property(nonatomic,copy) NSString  *curPage;
@property(nonatomic,copy) NSString  *end;
@property(nonatomic,copy) NSString  *goPage;
@property(nonatomic,copy) NSString  *hour_count;
@property(nonatomic,copy) NSString  *ClassCourse_id;
@property(nonatomic,copy) NSString  *name;
@property(nonatomic,copy) NSString  *object_id;
@property(nonatomic,copy) NSString  *pageSize;
@property(nonatomic,copy) NSString  *picture;
@property(nonatomic,copy) NSString  *room_id;
@property(nonatomic,copy) NSString  *start;
@property(nonatomic,copy) NSString  *totPage;
@property(nonatomic,copy) NSString  *totCount;
@property(nonatomic,copy) NSString  *user_id;
@property(nonatomic,copy) NSString  *type;


@end


@interface TraingailanDatelisModel : TrainBaseModel

@property(nonatomic,copy) NSString  *content;
@property(nonatomic,assign) BOOL    isOpen;
@property(nonatomic,assign,readonly) BOOL   isShowButton;

@end
