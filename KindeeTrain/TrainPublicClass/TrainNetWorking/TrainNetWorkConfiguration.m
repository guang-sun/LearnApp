//
//  TrainNetWorkConfiguration.m
//  SOHUEhr
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainNetWorkConfiguration.h"

@implementation TrainNetWorkConfiguration

static TrainNetWorkConfiguration *defaultConfiguration = nil;


+ (TrainNetWorkConfiguration *)defaultConfiguration
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        defaultConfiguration = [[TrainNetWorkConfiguration alloc] initWithHostString:TrainIP];
    });
    return defaultConfiguration;
}

- (TrainNetWorkConfiguration *)initWithHostString:(NSString *)hostString{
    self = [super init];
    if (self)
    {
        _hostString = hostString;
    }
    
    return self;
 
}


+(NSString *)trainGetAppUpdate{
    return @"/appws/user/getUpdate.action";
}

/**
 *  登陆
 */

+(NSString *)trainLogin{
    
    return @"/appws/user/loginApp.action";

}

/**
 *  欢迎页
 */

+(NSString *)trainGetWelcomeAd{
    
    return @"/appws/user/getStartPage.action";
    
}

#pragma   mark - 首页

+(NSString *)trainMain{
//    return @"/appws/user/login.action";
    return @"/appws/user/homePage.action";

}



+(NSString *)trainWebView{
//    return @"/ilearn/common/pages/validate.jsp";
    return @"/learn/common/pages/validate.jsp";
//    return @"/kindee/common/pages/validate.jsp";
}
+(NSString *)trainWebDocIsAppraise{
    return @"/appws/user/docIsappraise.action";
}

/**
 *  首页九宫格信息 (类似主题)
 */

+(NSString *)trainmainCollection{
    return @"/appws/user/getFns.action";
}

#pragma mark - 报名
+(NSString *)trainGetRegistList{
    return @"/appws/user/regist.action";
}


#pragma   mark - 个人中心

+(NSString *)trainGetUserCenter{
    return @"/appws/user/center.action";
}

+(NSString *)trainGetUserCenterCourse{
    return @"/appws/user/centerCourse.action";
}
+(NSString *)trainGetUserCenterTopic{
    return @"/appws/user/centerTopic.action";
}
+(NSString *)trainGetUserCenterGroup{
    return @"/appws/user/centerGroup.action";
}





#pragma   mark - 搜索
+(NSString *)trainSearch{
    return @"/appws/user/mobileSearch.action";
}

/**
 *  文档标签list
 */
+(NSString *)trainSearchTags{
    return @"/appws/user/getLabels.action";
}
/**
 *  圈子标签list
 */
+(NSString *)trainTopicTags{
    return @"/appws/user/getTopicTagList.action";
}

#pragma   mark - 课程

+(NSString *)trainCourse{
    return @"/appws/user/getCourseList.action";
}

+(NSString *)trainMyCourse{
    return @"/appws/user/getMyCourseList.action";
}

/**
 *  课程分类 list
 */
+(NSString *)trainCourseCategoryList{
    return  @"/appws/user/getCourseCategoryLst.action";
}

/**
 * 课程简介
 */
+(NSString *)trainCourseInfo{
    return @"/appws/user/getCourseInfo.action";
}
/**
 * 课程目录
 */
+(NSString *)trainCourseHourInfo{
    return @"/appws/user/getHourList.action";
}

/**
 * 课程笔记
 */
+(NSString *)trainCourseNote{
    return @"/appws/user/notes.action";
}

/**
 * 课程笔记
 */
+(NSString *)trainCourseClassNote{
    return @"/appws/user/getClassCourseNote.action";
}


/**
 * 课程讨论
 */
+(NSString *)trainCourseDiscuss{
    return @"/appws/user/discussion.action";
//    return @"/appws/user/newDiscussion.action";
}

/**
 * 课程评价
 */
+(NSString *)trainCourseAppraiseList{
    return @"/appws/user/findCommentLst.action";
//    return @"/appws/user/newFindCommentLst.action";
}

/**
 * 获取目录 / 视频 的播放URL
 */
+(NSString *)trainCourseHourURL{
    return @"/appws/user/getPlayLink.action";
}



/**
 *  获取课程报名状态
 */
+(NSString *)trainGetCourseRegisterStatus{
    return @"/appws/user/isRegi.action";
}

/**
 *  课程报名
 */
+(NSString *)trainCourseRegister{
    return @"/appws/user/signUpCourse.action";
}


/**
 * 课程  添加笔记
 */
+(NSString *)trainCourseAddNote{
    return @"/appws/user/addNotes.action";
}

/**
 * 班级课程  添加笔记
 */
+(NSString *)trainClassCourseAddNote{
    return @"/appws/user/addClassCourseNote.action";
}

/**
 * 课程  编辑笔记
 */
+(NSString *)trainCourseEditNote{
    return @"/appws/user/editNotes.action";
}

/**
 * 课程  添加评价
 */
+(NSString *)trainCourseAddAppraise{
    return @"/appws/user/addComment.action";
}
/**
 * 班级课程  添加评价
 */
+(NSString *)trainClassCourseAddAppraise{
    return @"/appws/user/addClassCourseComment.action";
}

/**
 * 课程  删除评价
 */
+(NSString *)trainCourseDeleteAppraise{
    return @"/appws/user/delComment.action";
}



/**
 * 班级课程  删除评价
 */
+(NSString *)trainClassCourseDeleteAppraise{
    return @"/appws/user/delClassComment.action";
}

/**
 * 课程  更新课时文档状态
 */
+(NSString *)trainCourseUpdateHourWithDoc{
    return @"/appws/user/saveMobileCourseDoc.action";
}

/**
 * 课程  更新课时 考试状态
 */
+(NSString *)trainCourseUpdateHourWithExam{
    return @"/appws/user/saveMobileCourseExam.action";
}
/**
 * 课程  更新课时 考试状态
 */
+(NSString *)trainGetHourStatusWithExam{
    return @"/appws/user/getHourStatus.action";
}

/**
 * 课程  更新课时学习时间
 */
+(NSString *)trainCourseUpdateStudyTime{
    return @"/appws/user/addLh.action";
}
/**
 * 班级课程  更新班级课程课时学习时间
 */
+(NSString *)trainClassUpdateStudyTime{
    return @"/appws/user/saveVideoStudyRecordByClass.action";
}
/**
 更新离线学习记录
 */
+(NSString *)trainUpdateLocalStudyTime {
    
    return @"/appws/user/addOffLine.action";
}

#pragma   mark - 班级

+(NSString *)trainClass{
    return @"/appws/user/getClassList.action";
}


/**
 * 班级 成绩策略
 */
+(NSString *)trainClassGradeInfo{
    return @"/appws/user/getClassTactic.action";
}

/**
 * 获取班级阶段
 */
+(NSString *)trainClassPhaseInfo{
    return @"/appws/user/getClassJdList.action";
}

/**
 * 获取阶段资源
 */
+(NSString *)trainClassPhaseRes{
    return @"/appws/user/getClassJdRes.action";
}

/**
 * 获取阶段课时
 */
+(NSString *)trainClassPhaseHourList{
    return @"/appws/user/getHourList.action";
}


/**
 * 班级评论列表
 */
+(NSString *)trainClassCommendList{
    return @"/appws/user/getClassComment.action";
}

/**
 * 添加班级评价
 */
+(NSString *)trainAddClassCommend{
    return @"/appws/user/addClassComment.action";
}


/**
 * 班级 详情 更多学员
 */
+(NSString *)trainClassAllMates{
    return @"/appws/user/getClassStudents.action";
}
/**
 * 班级 收藏
 */
+(NSString *)trainClassCollect{
    return @"/appws/user/classFav.action";
}


/**
 * 班级 课程list
 */
+(NSString *)trainClassCourseList{
    
//    return @"/appws/user/getClassCourse.action";
    return @"/appws/user/getClassCourseList.action";
}
/**
 * 班级 详情 (概览 , 讲师 list ,学员list )
 */
+(NSString *)trainClassDetail{
    return @"/appws/user/getClassInfo.action";
}
/**
 * 班级 调查 评估 考试
 */
+(NSString *)trainClassExamList{
    return @"/appws/user/getClassExamSvEv.action";
}


+(NSString *)trainMyClass{
    return @"/appws/user/myClass.action";
//    return @"/appws/user/getMyClass.action";
}

+(NSString *)trainMyClassNotRegister{
    return @"/appws/user/getClassList.action";
    //    return @"/appws/user/getMyClass.action";
}

/**
 * 班级 报名
 */
+(NSString *)trainClassRegister{
    return @"/appws/user/signUpClass.action";
}

/**
 * 班级 退出报名
 */
+(NSString *)trainClassUnRegister{
    return @"/appws/user/dropOutClass.action";
}

/**
 * 班级 签到
 */
+(NSString *)trainClassSignIn{
    return @"/appws/user/signInClass.action";
}

/**
 * 班级 详情 更多学员
 */
+(NSString *)trainClassMorePerson{
    return @"/appws/user/getClassPersonList.action";
}

/**
 * 班级 详情 更多讲师
 */
+(NSString *)trainClassMoreLecturer{
    return @"/appws/user/getClassLecturerList.action";
}

/**
 * 班级 详情 更多评价  (暂未实现)
 */
+(NSString *)trainMoreApparise{
    return @"/appws/user/getClassLecturerList.action";
}

#pragma   mark - 圈子  话题

+(NSString *)trainGroup{
    return @"/appws/user/getGroupList.action";
}

+(NSString *)trainMyGroup{
    return @"/appws/user/getMyGroupList.action";
}

+(NSString *)trainMyjoinGroup{
    return @"/appws/user/getMyJoinGroup.action";
}
+(NSString *)trainMyManagerGroup{
    return @"/appws/user/getMyManagerGroup.action";
}
/**
 * 圈子  详情
 */
+(NSString *)trainGroupInfo{
    return @"/appws/user/getGroupInfo.action";
}

/**
 * 圈子  加入圈子
 */
+(NSString *)trainGroupJoin{
    return @"/appws/user/joinGroup.action";
}

+(NSString *)trainTopic{
    return @"/appws/user/getTopicList.action";
}

/**
 * 话题   我的话题list
 */
+(NSString *)trainMyTopic{
    return @"/appws/user/getMytopicList.action";
}

/**
 * 话题   话题详情
 */
+(NSString *)trainTopicInfo{
    return @"/appws/user/getTopicInfo.action";
}

/**
 * 话题   话题点赞
 */
+(NSString *)trainTopicTop{
    return @"/appws/user/topTopic.action";
}

/**
 * 话题   话题收藏
 */
+(NSString *)trainTopicCollect{
    return @"/appws/user/collectTopic.action";
}

/**
 * 话题   话题 回复
 */
+(NSString *)trainTopicPost{
    return @"/appws/user/postTopic.action";
    
}

/**
 课程讨论 回复

 */
+(NSString *)trainCoursePost{
    return @"/appws/user/postCoursePost.action";
    
}
/**
 * 话题   课程 添加新讨论
 */
+(NSString *)trainAddCourseTopic{
    return @"/appws/user/insertd.action";
//    return @"/appws/user/newInsertd.action";
}

/**
 * 话题   课程 添加新讨论
 */
+(NSString *)trainAddNewTopic{
    return @"/appws/user/addTopic.action";
}
/**
 * 话题   上传话题的pic
 */
+(NSString *)trainuploadImage{
    return @"/appws/user/uploadTopicPic.action";
}

/**
 * 话题   删除话题
 */
+(NSString *)trainRemoveTopic{
    return @"/appws/user/removeTopic.action";
}

/**
 * 话题   删除话题的回复
 */
+(NSString *)trainRemoveTopicPost{
    return @"/appws/user/removeTopicPost.action";
}



#pragma   mark - 文库
+(NSString *)trainDocument {
    return @"/appws/user/getShareList.action";
//        return @"/appws/user/share.action";

}

+(NSString *)trainmyDocument {
    //    return @"/appws/user/getShareList.action";
    return @"/appws/user/share.action";
    
}
/**
 * 文库   收藏文库
 */
+(NSString *)trainDocAddCollect {
    return @"/appws/user/addDocOper.action";
}

/**
 * 文库   取消收藏文库
 */
+(NSString *)trainDocCancelCollect {
    return @"/appws/user/cancelCollection.action";
}

/**
 * 文库   文库分类list
 */
+(NSString *)trainDocCategoryList {
    return @"/appws/user/getDir123List.action";
}


#pragma   mark - 我的收藏
+(NSString *)trainMyCollectCourse {
    return @"/appws/user/getMyCollect.action";
}
+(NSString *)trainMyCollectTopic {
    return @"/appws/user/MycollectTopic.action";
}
+(NSString *)trainMyCollectDoc {
    return @"/appws/user/MycollectTopic.action";
}
+(NSString *)trainMyCollect {
    return @"/appws/user/getMyCollect.action";
}

#pragma   mark - 考试

/**
 * 考试   全部考试
 */
+(NSString *)trainALLExam {
    return @"/appws/user/getAllExam.action";
}

/**
 * 考试   独立考试
 */
+(NSString *)trainExamIndependent {
    return @"/appws/user/getIndependentExam.action";
}

/**
 * 考试   课程考试
 */
+(NSString *)trainExamCourse {
    return @"/appws/user/getCourseExam.action";
}

/**
 * 考试   班级考试
 */
+(NSString *)trainExamClass {
    return @"/appws/user/getClassExam.action";
}

/**
 * 考试   考试 回顾
 */
+(NSString *)trainExamReview {
    return @"/appws/user/reviewExam.action";
}

/**
 * 考试   作业 or 调查  mobileExam.publish_key=WORK (作业) EVALUATE (问卷) SURVEY (调查)
 */
+(NSString *)trainExamList {
    return @"/appws/user/getExam.action";
}


#pragma   mark - 我的笔记

+(NSString *)trainMyNote {
    return @"/appws/user/getMyNotes.action";
}

/**
 * 我的笔记   编辑
 */
+(NSString *)trainMyNoteEdit {
    return @"/appws/user/editNotes.action";
}

/**
 * 我的笔记   删除
 */
+(NSString *)trainMyNoteDelete {
    return @"/appws/user/delNote.action";
}

#pragma   mark - 积分

/**
 * 积分   积分信息
 */
+(NSString *)trainIntegral {
    return @"/appws/user/getMyIntegral.action";
}

/**
 * 积分  积分等级规则
 */
+(NSString *)trainIntegralLevel {
    return @"/appws/user/getIntegralLevel.action";
}

/**
 * 积分  积分分数规则
 */
+(NSString *)trainIntegralRule {
    return @"/appws/user/getIntegralRule.action";
}

#pragma   mark - 资讯

/**
 * 资讯分类
 */
+(NSString *)trainMessageCategory{
    return @"/appws/user/findDynamicCategory.action";
}

/**
 * 资讯列表
 */
+(NSString *)trainMessageList {
    return @"/appws/user/findDynamicList.action";
    
}

#pragma   mark - 消息中心


/**
 * 消息列表
 */
+(NSString *)trainNewsList {
    return @"/appws/user/myMessage.action";
    
}

/**
 * 消息详情
 */
+(NSString *)trainNewsDetail {
    return @"/appws/user/getMessageById.action";
    
}
/**
 * 读取消息
 */
+(NSString *)trainReadNews {
    return @"/appws/user/readMessage.action";
    
}

//#pragma   mark - 消息
//+(NSString *)trainNews{
//    return @"/appws/user/myMessage.action";
//}

///**
// * 将未读变成已读
// */
//+(NSString *)trainReadNews{
//    return  @"/appws/user/readMessage.action";
//}


#pragma mark - 意见反馈 && 建议
/**
 意见反馈 && 建议
 */
+(NSString *)trainSendSuggest{
    return @"/appws/user/addFeedBack.action";
}





@end
