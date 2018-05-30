//
//  TrainGroupAndTopicModel.h
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainBaseModel.h"

@interface TrainGroupAndTopicModel : TrainBaseModel

@end


@interface TrainGroupModel : TrainBaseModel

@property(nonatomic,copy) NSString  *about;
@property(nonatomic,copy) NSString  *group_id;//
@property(nonatomic,copy) NSString  *logo;
@property(nonatomic,copy) NSString  *member_num;
@property(nonatomic,copy) NSString  *topic_num;
@property(nonatomic,copy) NSString  *url_Circle;
@property(nonatomic,copy) NSString  *username;
@property(nonatomic,copy) NSString  *join_condition; //加入条件PUBLIC(公开)/PRIVATE(私密)/INVITATION(邀请)',
@property(nonatomic,copy) NSString  *curPage;
@property(nonatomic,copy) NSString  *end;
@property(nonatomic,copy) NSString  *goPage;
@property(nonatomic,copy) NSString  *pageSize;
@property(nonatomic,copy) NSString  *site_id;
@property(nonatomic,copy) NSString  *start;
@property(nonatomic,copy) NSString  *top_num;
@property(nonatomic,copy) NSString  *title;
@property(nonatomic,copy) NSString  *totPage;
@property(nonatomic,copy) NSString  *create_date;
@property(nonatomic,copy) NSString  *post_num;


@end

@interface TrainTopicModel : TrainBaseModel
//话题
@property(nonatomic,copy) NSString  *collect_num;   //收藏数
@property(nonatomic,copy) NSString  *content;       // 内容
@property(nonatomic,copy) NSString  *full_name;     //作者昵称
@property(nonatomic,copy) NSString  *gg_title;      //圈子title
@property(nonatomic,copy) NSString  *hit_num;       //查看数
@property(nonatomic,copy) NSString  *topic_id;
@property(nonatomic,copy) NSString  *is_elite;      // 是否加精  0/1
@property(nonatomic,copy) NSString  *is_stick;      // 是否置顶  0/1
@property(nonatomic,copy) NSString  *is_mobile;     //是否手机端 发布 Y(手机)  N(pc)
@property(nonatomic,copy) NSString  *object_id;
@property(nonatomic,copy) NSString  *sphoto;        //发起人 头像
@property(nonatomic,copy) NSString  *top_num;       // 话题数
@property(nonatomic,copy) NSString  *totCount;
@property(nonatomic,copy) NSString  *type;          // 是否是问答 T 不是问答
@property(nonatomic,copy) NSString  *user_id;
@property(nonatomic,copy) NSString  *collected;     // 是否收藏
@property(nonatomic,copy) NSString  *toped;         // 是否点赞
@property(nonatomic,strong) NSArray *pics;          //话题图片集
@property(nonatomic,copy) NSString  *timeDifference;// 转化后日期
@property(nonatomic,copy) NSString  *title;
@property(nonatomic,copy) NSString  *totPage;
@property(nonatomic,copy) NSString  *create_date;
@property(nonatomic,copy) NSString  *post_num;
@property(nonatomic,copy) NSString  *object_type;   // 区分话题来源，GROUP 圈子。CTRAIN 课程 CROOM班级
@end

@interface TrainTopicCommentModel : TrainBaseModel

@property(nonatomic,copy) NSArray   *child_post_list;
@property(nonatomic,copy) NSString  *sphoto;//
@property(nonatomic,copy) NSString  *content;//
@property(nonatomic,copy) NSString  *create_date;
@property(nonatomic,copy) NSString  *curPage;
@property(nonatomic,copy) NSString  *end;
@property(nonatomic,copy) NSString  *full_name;
@property(nonatomic,copy) NSString  *goPage;
@property(nonatomic,copy) NSString  *comment_id;
@property(nonatomic,copy) NSString  *pageSize;
@property(nonatomic,copy) NSString  *start;
@property(nonatomic,copy) NSString  *topic_id;
@property(nonatomic,copy) NSString  *totCount;
@property(nonatomic,copy) NSString  *totPage;
@property(nonatomic,copy) NSString  *user_id;
@property(nonatomic,copy) NSString  *username;
@property(nonatomic,copy) NSString  *from_full_name;

@end
