//
//  TrainNetWorkConfiguration.h
//  SOHUEhr
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainNetWorkAPI.h"


@interface TrainNetWorkConfiguration : NSObject

@property (nonatomic, strong, readonly) NSString * hostString;

// 默认配置 url

+ (TrainNetWorkConfiguration *)defaultConfiguration;

// 生成自定义配置， hostString

- (TrainNetWorkConfiguration *)initWithHostString:(NSString *)hostString;


/**************************
 *
 * 获取各请求的 url query path
 *
 ****************************/


#pragma   mark - login  登陆
/**
 *  登陆
 */

+(NSString *)trainLogin;

/**
 *  欢迎页
 */

+(NSString *)trainGetWelcomeAd;

+(NSString *)trainGetAppUpdate;

#pragma   mark - 首页

+(NSString *)trainMain;

+(NSString *)trainWebView;

+(NSString *)trainWebDocIsAppraise;

/**
 *  首页九宫格信息 (类似主题)
 */
+(NSString *)trainmainCollection;

#pragma mark - 报名
+(NSString *)trainGetRegistList;

#pragma   mark - 个人中心

+(NSString *)trainGetUserCenter;

+(NSString *)trainGetUserCenterCourse;

+(NSString *)trainGetUserCenterTopic;

+(NSString *)trainGetUserCenterGroup;



#pragma   mark - 搜索
+(NSString *)trainSearch;

/**
 *  标签list
 */
+(NSString *)trainSearchTags;

/**
 *  圈子标签list
 */
+(NSString *)trainTopicTags;

//#pragma   mark - 消息
//+(NSString *)trainNews;
//
///**
// * 将未读变成已读
// */
//+(NSString *)trainReadNews;

#pragma   mark - 课程

+(NSString *)trainCourse;

+(NSString *)trainMyCourse;

/**
 *  课程分类 list
 */
+(NSString *)trainCourseCategoryList;

/**
 * 课程简介
 */
+(NSString *)trainCourseInfo;

/**
 * 课程目录
 */
+(NSString *)trainCourseHourInfo;

/**
 * 课程笔记
 */
+(NSString *)trainCourseNote;
/**
 * 课程班级笔记
 */
+(NSString *)trainCourseClassNote;

/**
 * 课程讨论
 */
+(NSString *)trainCourseDiscuss;

/**
 * 课程评价
 */
+(NSString *)trainCourseAppraiseList;

/**
 * 获取目录 / 视频 的播放URL
 */
+(NSString *)trainCourseHourURL;

/**
 * 获取课程报名状态
 */
+(NSString *)trainGetCourseRegisterStatus;

/**
 * 课程报名
 */

+(NSString *)trainCourseRegister;



/**
 * 课程  添加笔记
 */

+(NSString *)trainCourseAddNote;

/**
 * 班级课程  添加笔记
 */
+(NSString *)trainClassCourseAddNote;

/**
 * 课程  编辑笔记
 */
+(NSString *)trainCourseEditNote;


/**
 * 课程  添加评价
 */
+(NSString *)trainCourseAddAppraise;

/**
 * 班级课程  添加评价
 */
+(NSString *)trainClassCourseAddAppraise;
/**
 * 课程  删除评价
 */
+(NSString *)trainCourseDeleteAppraise;

/**
 * 班级课程  删除评价
 */
+(NSString *)trainClassCourseDeleteAppraise;


/**
 * 课程  更新课时文档状态
 */
+(NSString *)trainCourseUpdateHourWithDoc;

/**
 * 课程  更新课时 考试状态
 */
+(NSString *)trainCourseUpdateHourWithExam;

/**
 * 课程  更新课时 考试状态
 */
+(NSString *)trainGetHourStatusWithExam;

/**
 * 课程  更新课时学习时间
 */
+(NSString *)trainCourseUpdateStudyTime;
/**
 * 班级课程  更新班级课程课时学习时间
 */
+(NSString *)trainClassUpdateStudyTime;

/**
 更新离线学习记录
 */
+(NSString *)trainUpdateLocalStudyTime ;
#pragma   mark - 班级

+(NSString *)trainClass;

/**
 * 班级 成绩策略
 */
+(NSString *)trainClassGradeInfo;

/**
 * 获取班级阶段
 */
+(NSString *)trainClassPhaseInfo ;

/**
 * 获取阶段资源
 */
+(NSString *)trainClassPhaseRes ;

/**
 * 班级评论列表
 */
+(NSString *)trainClassCommendList ;


/**
 * 添加班级评价
 */
+(NSString *)trainAddClassCommend ;

/**
 * 获取阶段课时
 */
+(NSString *)trainClassPhaseHourList ;

/**
 * 班级 详情 更多学员
 */
+(NSString *)trainClassAllMates ;
/**
 * 班级 收藏
 */
+(NSString *)trainClassCollect ;

+(NSString *)trainMyClassNotRegister;

/**
 * 班级 课程list
 */
+(NSString *)trainClassCourseList;

/**
 * 班级 详情 (概览 , 讲师 list ,学员list )
 */
+(NSString *)trainClassDetail;
/**
 * 班级 调查 评估 考试
 */
+(NSString *)trainClassExamList;

+(NSString *)trainMyClass;

/**
 * 班级 报名
 */
+(NSString *)trainClassRegister;

/**
 * 班级 退出报名
 */
+(NSString *)trainClassUnRegister;

/**
 * 班级 签到
 */
+(NSString *)trainClassSignIn;

/**
 * 班级 详情 更多学员
 */
+(NSString *)trainClassMorePerson;

/**
 * 班级 详情 更多讲师
 */
+(NSString *)trainClassMoreLecturer;

/**
 * 班级 详情 更多评价  (暂未实现)
 */
+(NSString *)trainMoreApparise;

#pragma   mark - 圈子  话题

+(NSString *)trainGroup;

/**
 我的圈子list
 
 */
+(NSString *)trainMyGroup;

+(NSString *)trainMyjoinGroup;

+(NSString *)trainMyManagerGroup;


/**
 * 圈子  详情
 */
+(NSString *)trainGroupInfo;




/**
 * 圈子  加入圈子
 */
+(NSString *)trainGroupJoin;

+(NSString *)trainTopic;

/**
 * 话题   我的话题list
 */
+(NSString *)trainMyTopic;

/**
 * 话题   话题详情
 */
+(NSString *)trainTopicInfo;

/**
 * 话题   话题点赞
 */
+(NSString *)trainTopicTop;

/**
 * 话题   话题收藏
 */
+(NSString *)trainTopicCollect;

/**
 * 话题   话题 回复
 */
+(NSString *)trainTopicPost;


/**
 课程讨论 回复
 */
+(NSString *)trainCoursePost;

/**
 * 话题   课程 添加新讨论
 */
+(NSString *)trainAddCourseTopic;

/**
 * 话题   课程 添加新讨论
 */
+(NSString *)trainAddNewTopic;

/**
 * 话题   上传话题的pic
 */
+(NSString *)trainuploadImage;

/**
 * 话题   删除话题
 */
+(NSString *)trainRemoveTopic;

/**
 * 话题   删除话题的回复
 */
+(NSString *)trainRemoveTopicPost;


#pragma   mark - 文库

+(NSString *)trainDocument ;
+(NSString *)trainmyDocument;

/**
 * 文库   收藏文库
 */
+(NSString *)trainDocAddCollect ;

/**
 * 文库   取消收藏文库
 */
+(NSString *)trainDocCancelCollect ;

/**
 * 文库   文库分类list
 */
+(NSString *)trainDocCategoryList ;


#pragma   mark - 我的收藏
+(NSString *)trainMyCollectCourse ;
+(NSString *)trainMyCollectTopic ;
+(NSString *)trainMyCollectDoc ;
+(NSString *)trainMyCollect ;

#pragma   mark - 考试

/**
 * 考试   全部考试
 */
+(NSString *)trainALLExam ;

/**
 * 考试   独立考试
 */
+(NSString *)trainExamIndependent ;

/**
 * 考试   课程考试
 */
+(NSString *)trainExamCourse ;

/**
 * 考试   班级考试
 */
+(NSString *)trainExamClass ;

/**
 * 考试   考试 回顾
 */
+(NSString *)trainExamReview ;

/**
 * 考试   作业 or 调查  mobileExam.publish_key=WORK (作业) EVALUATE (问卷) SURVEY (调查)
 */
+(NSString *)trainExamList ;


#pragma   mark - 我的笔记

+(NSString *)trainMyNote ;

/**
 * 我的笔记   编辑
 */
+(NSString *)trainMyNoteEdit ;

/**
 * 我的笔记   删除
 */
+(NSString *)trainMyNoteDelete ;

#pragma   mark - 积分

/**
 * 积分   积分信息
 */
+(NSString *)trainIntegral ;

/**
 * 积分  积分等级规则
 */
+(NSString *)trainIntegralLevel ;

/**
 * 积分  积分分数规则
 */
+(NSString *)trainIntegralRule ;

#pragma   mark - 资讯

/**
 * 资讯分类
 */
+(NSString *)trainMessageCategory ;

/**
 * 资讯列表
 */
+(NSString *)trainMessageList ;

#pragma   mark - 消息中心


/**
 * 消息列表
 */
+(NSString *)trainNewsList;

/**
 * 消息详情
 */
+(NSString *)trainNewsDetail ;

/**
 * 读取消息
 */
+(NSString *)trainReadNews ;


#pragma mark - 意见反馈 && 建议
/**
 意见反馈 && 建议
 */
+(NSString *)trainSendSuggest;







@end
