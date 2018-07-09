//
//  TrainNetWorkAPIClient.h
//  SOHUTrain
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainNetWorkClientBase.h"



@interface TrainNetWorkAPIClient : TrainNetWorkClientBase


#pragma mark - webView


/**
 嵌页面weburl拼接
 @param mod       mod
 @param object_id object_id
 
 @return  嵌页面weburl
 */
- (NSString *)trainWebViewMode:(NSString *)mod
                     object_id:(NSString *)object_id
                  andtarget_id:(NSString *)target_id;


/**
 给URL添加个人信息session
 @param baseURL 基础URL
 
 @return 添加个人信息session的URL
 */
- (NSString *)trainWebViewAddEmpidWithBaseURL:(NSString  *)baseURL;


/**
 文档的评价状态查询
 
 @param doc_id 文档id
 @param success
 @param failure
 */
- (void )trainwebDocIsAppraise:(NSString *)doc_id
                       success:(defaultSuccessBlock)success
                    andFailure:(defaultFailureBlock)failure;




-(void)trainGetAPPUpdateWithSuccess:(defaultSuccessBlock)success
                         andFailure:(defaultFailureBlock)failure;


#pragma   mark - 登陆


/**
 登陆

 @param url 站点

 */
- (void)trainloginAppWithBaseUrl:(NSString *)url
                        userName:(NSString *)userName
                        passWord:(NSString *)passWord
                         Success:(defaultSuccessBlock)success
                      andFailure:(defaultFailureBlock)failure;

/**
 欢迎页
 @param url 站点
 
 */
- (void)trainGetWelcomeWithBaseUrl:(NSString *)url
                         Success:(defaultSuccessBlock)success
                      andFailure:(defaultFailureBlock)failure;


#pragma   mark - 首页


/*
 * 首页 轮播图
 */


/**
 首页 数据  轮播图
 
 @param success
 @param failure
 */
- (void)trainHomeDataWithSuccess:(defaultSuccessBlock)success
                      andFailure:(defaultFailureBlock)failure;

/**
 首页 九宫格最新数据
 @param success
 @param failure
 */
- (void)trainHomeCollectionWithSuccess:(defaultSuccessBlock)success
                            andFailure:(defaultFailureBlock)failure;


#pragma mark - 报名
- (void)trainGetRegisterListWithregName:(NSString *)reg_name
                                curPage:(int)curPage
                                Success:(defaultSuccessBlock)success
                             andFailure:(defaultFailureBlock)failure;



#pragma  mark - 用户个人中心


/**
 个人中心头部信息
 
 @param user_id 用户id
 @param success
 @param failure
 */
-(void)trainGetUserCenterWithUser_id:(NSString *)user_id
                             Success:(defaultSuccessBlock)success
                          andFailure:(defaultFailureBlock)failure;


/**
 个人中心 课程,圈子,话题
 
 @param type
 @param user_id 用户id
 @param curPage
 @param success
 @param failure
 */
-(void)trainGetUserCenterWithType:(TrainCenterStyle)type
                          User_id:(NSString *)user_id
                          curPage:(int)curPage
                          Success:(defaultSuccessBlock)success
                       andFailure:(defaultFailureBlock)failure;


#pragma mark - 搜索

/*
 *
 */


/**
 获取搜索页面标签
 
 @param success
 */
-(void)trainSearchHotTagSuccess:(defaultSuccessBlock)success;


/*
 *
 style   TrainSearchStyleCourse ,TrainSearchStyleTopic,TrainSearchStyleDoc
 isTags   是否是标签搜索
 */


/**
 全局搜索
 
 @param style   搜索类型  课程\话题\文档
 @param isTags  标签查询
 @param title   搜索文字
 @param curPage 分页
 @param success
 @param failure
 */
-(void)trainSearchResultWithStyle:(TrainSearchStyle)style
                           isTags:(BOOL )isTags
                            title:(NSString *)title
                          curPage:(int)curPage
                          Success:(defaultSuccessBlock)success
                       andFailure:(defaultFailureBlock)failure;


#pragma   mark - 课程


/**
 课程类型分类
 
 @param success
 @param failure
 */
- (void)trainCourseMenuCategoryWithSuccess:(defaultSuccessBlock)success
                                andFailure:(defaultFailureBlock)failure;


/**
 课程列表
 
 @param type       课程 班级 我的课程 我的班级
 @param order      课程或班级的类型:  最新 最热 分类
 @param categoryId 分类查询 的分类 id
 @param curPage    分页
 @param success
 @param failure
 */
- (void)trainCourseListWithcourseType:(TrainMode )type
                                order:(TrainChooseMode )order
                         CourseFormat:(NSString *)CourseFormat
                           categoryid:(NSString *)categoryId
                              curPage:(int)curPage
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure;


/**
 课程的报名状态
 
 @param course_objectId 课程object_id
 @param success
 @param failure
 */
-(void)trainCourseRegisterStatusWithCourseID:(NSString *)course_objectId
                                     Success:(defaultSuccessBlock)success
                                  andFailure:(defaultFailureBlock)failure;


/**
 课程的报名
 
 @param course_objectId 课程object_id
 @param success
 @param failure
 */
-(void)traincourseRegisterWithCourseId:(NSString *)course_objectId
                           register_id:(NSString *)register_id
                                  name:(NSString *)name
                               Success:(defaultSuccessBlock)success
                            andFailure:(defaultFailureBlock)failure;


/**
 课程 详情
 
 @param mode    type  简介 目录 笔记  讨论 评价
 @param infoDic object_id  c_id  type   room_id  class_id  curPage
 @param success
 @param failure
 */
- (void)trainCourseDetailInfoWithMode:(TrainCourseDetailMode)mode
                              infoDic:(NSDictionary *)infoDic
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure;


/**
 获取视频url
 
 @param object_id    课时的object_id
 @param success
 @param failure
 */
- (void)trainGetMovieUrlWithobject_id:(NSString *)object_id
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure;



/**
更新课时 文档or 考试的状态

@param infoDic
@param success
@param failure
*/
- (void)trainUpdateHourDorEStatusWithIsExam:(BOOL )isExam
                                 infoDic:(NSDictionary *)infoDic
                                 Success:(defaultSuccessBlock)success
                              andFailure:(defaultFailureBlock)failure;


/**
 获取课时的状态
 */
- (void)trainGetHourStatusWithC_id:(NSString *)c_id
                         object_id:(NSString *)object_id
                             lh_id:(NSString *)lh_id
                           success:(defaultSuccessBlock)success
                        andFailure:(defaultFailureBlock)failure;


/**
 更新学习记录
 
 @param isCourse 课程或 班级课程
 @param infoDic
 @param success
 @param failure
 */
- (void)trainUpdateStudyTimeWithIsCourse:(BOOL )isCourse
                                 infoDic:(NSDictionary *)infoDic
                                 Success:(defaultSuccessBlock)success
                              andFailure:(defaultFailureBlock)failure;

/**
 课程 详情  -->添加笔记or 编辑
 
 @param isEditNote
 @param infoDic    key: notes.content  object_id  notes.hour_id  notes.is_public   type=
 room_id notes.c_id
 @param success
 @param failure
 */
- (void)trainCourseAddOrEditNoteWithisEditNote:(BOOL )isEditNote
                                       infoDic:(NSDictionary *)infoDic
                                       Success:(defaultSuccessBlock)success
                                    andFailure:(defaultFailureBlock)failure;


/*
 *
 
 */


/**
 课程 详情 -->添加讨论
 
 @param infoDic content object_id  classHour_id  type room_id c_id
 @param success
 @param failure
 */
- (void)trainCourseAddNewDiscussWithinfoDic:(NSDictionary *)infoDic
                                    Success:(defaultSuccessBlock)success
                                 andFailure:(defaultFailureBlock)failure;


/**
 课程 详情 -->回复 讨论
 
 @param infoDic  infoDic Key = topic_id   from_user_id   from_post_id  content
 if(一级){from_user_id=0  from_post_id=0}
 
 @param success
 @param failure
 */
- (void)trainPostTopicWithinfoDic:(NSDictionary *)infoDic
                         postType:(BOOL)isPostCourse
                          Success:(defaultSuccessBlock)success
                       andFailure:(defaultFailureBlock)failure;



/**
 课程 详情 --> 添加评价
 
 @param infoDic  object_id  grade  content  type room_id
 @param success
 @param failure
 */
- (void)trainCourseAddAppraiseWithinfoDic:(NSDictionary *)infoDic
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure;

/*
 *
 */

/**
 课程 详情 --> 删除评价
 
 @param isClass     班级Or 课程

 */
- (void)trainCourseDeleteAppraiseWithIsClass:(BOOL)isClass
                                 Appraise_id:(NSString *)Appraise_id
                                     Success:(defaultSuccessBlock)success
                                  andFailure:(defaultFailureBlock)failure;


#pragma mark 课程班级

/**
 班级 --> 课程 or 详情
 
 @param isClassCourse 课程 or 详情
 @param class_id      班级id
 @param curPage       分页
 @param success
 @param failure
 */
- (void)trainClassDetailWithClassMode:(TrainClassMode )classMode
                             class_id:(NSString *)class_id
                              curPage:(int)curPage
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure;



/**
 班级成绩策略
 */
- (void)trainClassGradeInfoWithClass_id:(NSString *)class_id
                              tactic_id:(NSString *)tactic_id
                                Success:(defaultSuccessBlock)success
                             andFailure:(defaultFailureBlock)failure ;



/**
 班级获取班级阶段
 */
- (void)trainClassphaseInfoWithClass_id:(NSString *)class_id
                                Success:(defaultSuccessBlock)success
                             andFailure:(defaultFailureBlock)failure  ;

/**
 *
 * 获取阶段资源
 */
- (void)trainClassphaseResoureWithClass_id:(NSString *)class_id
                                    sec_id:(NSString *)sec_id
                                   Success:(defaultSuccessBlock)success
                                andFailure:(defaultFailureBlock)failure ;


/**
 *
 * 获取班级评论列表
 */
- (void)trainClassCommentListWithClass_id:(NSString *)class_id
                                    grade:(NSInteger )grade
                                  pageNum:(NSInteger )pageNum
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure ;

/**
 *
 * 添加班级评价
 */
- (void)trainAddClassCommentWithClass_id:(NSString *)class_id
                                   grade:(NSString *)grade
                                 content:(NSString *)content
                                 Success:(defaultSuccessBlock)success
                              andFailure:(defaultFailureBlock)failure  ;

/**
 *
 * 获取阶段资源
 */
- (void)trainClassPhaseHourListWithClass_id:(NSString *)class_id
                                       c_id:(NSString *)c_id
                                    room_id:(NSString *)room_id
                                    Success:(defaultSuccessBlock)success
                                 andFailure:(defaultFailureBlock)failure ;

/**
 *
 * 获取班级同学
 */
- (void)trainClassMatesListWithClass_id:(NSString *)class_id
                                pageNum:(NSInteger )pageNum
                                Success:(defaultSuccessBlock)success
                             andFailure:(defaultFailureBlock)failure  ;

/**
 *
 * 班级双收藏
 */
- (void)trainClassCollectWithClass_id:(NSString *)class_id
                            iscollect:(BOOL )iscollect
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure ;



/**
 班级 报名 -->报名 or 取消报名
 
 @param isRegister 报名 or 取消报名
 @param class_id   班级id
 @param regiter_id 报名id
 @param success
 @param failure
 */
- (void)trainClassDetailRegisterWithisRegister:(BOOL)isRegister
                                      class_id:(NSString *)class_id
                                    regiter_id:(NSString *)regiter_id
                                       Success:(defaultSuccessBlock)success
                                    andFailure:(defaultFailureBlock)failure;


/**
 班级 报名 --> 班级 签到
 
 @param regiter_id 报名id
 @param success
 @param failure
 */
- (void)trainClassSignInWithregiter_id:(NSString *)regiter_id
                               Success:(defaultSuccessBlock)success
                            andFailure:(defaultFailureBlock)failure;





/**
 班级 详情
 
 @param status   学员 或 讲师
 @param class_id 班级id
 @param success
 @param failure
 */
- (void)trainClassDetailMoreWithdetailMode:(TrainClassDetailStatus )status
                                  class_id:(NSString *)class_id
                                   curPage:(int )curPage
                                   Success:(defaultSuccessBlock)success
                                andFailure:(defaultFailureBlock)failure;

#pragma mark 我的笔记list



/**
 我的笔记list
 
 @param curPage 分页
 @param success
 @param failure
 */
- (void)trainMyNoteWithcurPage:(int )curPage
                       Success:(defaultSuccessBlock)success
                    andFailure:(defaultFailureBlock)failure;


/**
 我的笔记 -->删除
 
 @param note_id 笔记id
 @param success
 @param failure
 */
- (void)trainDeleteMyNoteWithNote_id:(NSString *)note_id
                             Success:(defaultSuccessBlock)success
                          andFailure:(defaultFailureBlock)failure;

#pragma mark - 圈子


/**
 圈子列表
 
 @param type    最新 最热
 @param curPage 分页
 @param success
 @param failure
 */
- (void)trainGroupListWithtype:(TrainTopicMode )type
                       curPage:(int)curPage
                       Success:(defaultSuccessBlock)success
                    andFailure:(defaultFailureBlock)failure;


/**
 我的圈子list
 
 @param type join  or manage
 @param curPage
 @param success
 @param failure
 */
- (void)traingetMyGroupListWithType:(TrainGroupMode )type
                            curPage:(int)curPage
                            Success:(defaultSuccessBlock)success
                         andFailure:(defaultFailureBlock)failure;



/**
 圈子列表   圈子详情内  if(keyword) -> 搜索话题 title
 @param infoDic  key: group_id  type  curPage  keywords
 @param success
 @param failure
 */
- (void)trainGroupDetailtWithinfoDic:(NSDictionary *)infoDic
                             Success:(defaultSuccessBlock)success
                          andFailure:(defaultFailureBlock)failure;



/**
 圈子列表 -->加入圈子
 
 @param group_id 圈子id
 @param success
 @param failure
 */
- (void)trainJoinGrouptWithgroup_id:(NSString *)group_id
                            Success:(defaultSuccessBlock)success
                         andFailure:(defaultFailureBlock)failure;



#pragma mark - 话题


/**
 话题列表 list
 
 @param type    最新 最热 精华 问答
 @param curPage 分页
 @param success
 @param failure
 */
- (void)trainTopicListWithtype:(TrainTopicMode )type
                       curPage:(int)curPage
                       Success:(defaultSuccessBlock)success
                    andFailure:(defaultFailureBlock)failure;



/**
 我的话题列表
 
 @param type    全部 问答
 @param curPage 分页
 @param success
 @param failure
 */
- (void)trainMyTopicListWithtype:(NSString  *)type
                         curPage:(int)curPage
                         Success:(defaultSuccessBlock)success
                      andFailure:(defaultFailureBlock)failure;

/*
 *
 */

/**
 话题--> 赞
 
 @param topic_id topic_id
 @param success
 @param failure
 */
- (void)trainTopicSupportWithtopic_id:(NSString *)topic_id
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure;

/*
 *
 */


/**
 话题 -->收藏
 
 @param topic_id topic_id
 @param success
 @param failure
 */
- (void)trainTopicCollectWithtopic_id:(NSString *)topic_id
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure;


/**
 话题详情
 
 @param topic_id 话题id
 @param group_id 圈子id
 @param curpage
 @param success
 @param failure
 */
- (void)trainTopicDetailInfoWithTopic_id:(NSString *)topic_id
                                group_id:(NSString *)group_id
                                 curPage:(int)curpage
                                 Success:(defaultSuccessBlock)success
                              andFailure:(defaultFailureBlock)failure;


/**
 圈子详情 发表新话题
 
 @param group_id 圈子id
 @param title    title
 @param content  内容
 @param success
 @param failure
 */
- (void)trainAddTopicWithGroup_id:(NSString *)group_id
                       topicTitle:(NSString *)title
                     topicContent:(NSString *)content
                      topic_tagid:(NSString *)topic_tagid
                          Success:(defaultSuccessBlock)success
                       andFailure:(defaultFailureBlock)failure;



///**
// 圈子详情 发表新话题
//
// @param group_id    圈子id
// @param title       title
// @param content     内容
// @param topic_tagid  话题标签id
// @param success
// @param failure
// */
//- (void)trainAddTopicWithFile:(NSData *)fileData
//                   topicTitle:(NSString *)title
//                 topicContent:(NSString *)content
//                  topic_tagid:(NSString *)topic_tagid
//                      Success:(defaultSuccessBlock)success
//                   andFailure:(defaultFailureBlock)failure;
//
///**
// 上传image
// 
// @param imageDataArr 图片data 数组
// @param progress 上传进度
// @param success
// @param failure
// */
//- (void)trainUploadImage:(TrainAFNUploadfileBlock)imageDataArr
//                progress:(TrainAFNProgressBlock)progress
//                 Success:(defaultSuccessBlock)success
//              andFailure:(defaultFailureBlock)failure;



/**
 上传image
 
 @param imageDataArr 图片data 数组
 @param progress 上传进度
 @param success
 @param failure
 */
- (void)trainUploadImage:(NSArray <NSData *>*)imageDataArr
                progress:(defaultProgressBlock)progress
                 Success:(defaultSuccessBlock)success
              andFailure:(defaultFailureBlock)failure;


/**
 获取圈子话题的标签
 
 @param success
 */
-(void)trainGetTopicTagSuccess:(defaultSuccessBlock)success
                    andFailure:(defaultFailureBlock)failure;


/**
 话题详情 删除话题

 @param strObj json格式的字符串 例:[{"object_id":1,"id":1},{"object_id":2,"id":2},{"object_id":3,"id":3}]  object_id 为圈子id  id 为话题id

 */
- (void)trainRemoveTopicWithtopicInfo:(NSString *)strObj
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure;

/**
 话题详情 删除回复
 
 */
- (void)trainRemoveTopicPostWithTopic_id:(NSString *)topic_id
                                 post_id:(NSString *)post_id
                                 Success:(defaultSuccessBlock)success
                              andFailure:(defaultFailureBlock)failure;




#pragma mark - 文库

/**
 文库 分类
 
 @param success
 @param failure
 */
- (void)trainDocMenuCategoryWithSuccess:(defaultSuccessBlock)success
                             andFailure:(defaultFailureBlock)failure;


/**
 文库列表list
 
 @param type        最新  最热 文档类型 分类
 @param format      文档类型
 @param category_id 分类id
 @param curPage     分页
 @param success
 @param failure
 */
- (void)trainDocListWithtype:(TrainDocumentClass)type
                      format:(NSString *)format
                  categoryId:(NSString *)category_id
                     curPage:(int)curPage
                     Success:(defaultSuccessBlock)success
                  andFailure:(defaultFailureBlock)failure;

/**
 文库 --> 收藏或取消
 
 @param isCollect 收藏或取消
 @param doc_id    doc_id
 @param success
 @param failure
 */
- (void)trainDocCollectWithIsCollect:(BOOL)isCollect
                              doc_id:(NSString *)doc_id
                             Success:(defaultSuccessBlock)success
                          andFailure:(defaultFailureBlock)failure;



#pragma mark - 考试 评估 调查

/**
 考试 list
 
 @param examMode    班级 课程 独立
 @param examStatus  完成 or 未完成 通过 or 不通过
 @param examCurpage
 @param success
 @param failure
 */
- (void)trainExamListWithExamMode:(TrainExamMode )examMode
                       examStatus:(TrainExamCompleteStatus)examStatus
                      examCurpage:(int)examCurpage
                          Success:(defaultSuccessBlock)success
                       andFailure:(defaultFailureBlock)failure;



/*
 *  考试  回顾考试
 */

/**
 考试  -->回顾考试
 
 @param Atmp_id Atmp_id
 @param success
 @param failure
 */
- (void)trainReviewExamWithAtmp_id:(NSString *)Atmp_id
                           Success:(defaultSuccessBlock)success
                        andFailure:(defaultFailureBlock)failure;




/**
 考试 --> (评估 调查 作业)
 
 @param isHomeWork 作业 问卷 调查
 @param isFirst     if(isHomeWork)(作业 :完成 未完成 ) else( EVALUATE (问卷) SURVEY (调查) )
 @param examCurpage
 @param success
 @param failure
 */
- (void)trainQuesOrHomeWorkWithisHomeWork:(BOOL )isHomeWork
                                  isFirst:(BOOL)isFirst
                              examCurpage:(int)examCurpage
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure;


#pragma mark - 我的收藏


/**
 我的收藏列表
 
 @param type 收藏类型  T话题  D文档
 @param curPage
 @param success
 @param failure
 */
- (void)trainCollectWithType:(NSString *)type
                     curPage:(int )curPage
                     Success:(defaultSuccessBlock)success
                  andFailure:(defaultFailureBlock)failure;


#pragma mark - 我的积分


/**
 我的积分
 
 */
- (void)trainGetIntegralListlWithcurPage:(int )curPage
                                 Success:(defaultSuccessBlock)success
                              andFailure:(defaultFailureBlock)failure;


/**
 我的积分  积分等级 OR 积分规则
 
 */
- (void)trainIntegralRuleOrLevellWithtype:(TrainIntegralStatus)type
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure;


#pragma mark - 资讯


/**
 获取资讯分类信息

 */
- (void)trainGetMessageMenuCategoryWithSuccess:(defaultSuccessBlock)success
                                    andFailure:(defaultFailureBlock)failure;

/**
 获取资讯list
 
 */
- (void)trainGetMessagelistWithOrderField:(NSString *)orderField
                              category_id:(NSString *)category_id
                                 promoted:(NSString *)promoted
                                  curPage:(int )curPage
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure;



#pragma mark - 消息
/**
 获取消息list
 */
- (void)trainGetNewslistWithisRead:(TrainNewsMode )isRead
                           curPage:(int )curPage
                           Success:(defaultSuccessBlock)success
                        andFailure:(defaultFailureBlock)failure;

/**
 h获取消息的详情
 
 */
- (void)trainGetNewsDetailWithid:(NSString *)news_id
                         Success:(defaultSuccessBlock)success
                      andFailure:(defaultFailureBlock)failure;


- (void)trainReadNewsWithisid:(NSString *)news_id
                      Success:(defaultSuccessBlock)success
                   andFailure:(defaultFailureBlock)failure;



#pragma mark - 意见反馈 && 建议
/**
    意见反馈 && 建议
 */
- (void)trainSendOurSuggestWithcontent:(NSString *)content
                               Success:(defaultSuccessBlock)success
                            andFailure:(defaultFailureBlock)failure;

- (void)trainUpdateLocalRecordWithcontent:(NSString *)content
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure ;


@end
