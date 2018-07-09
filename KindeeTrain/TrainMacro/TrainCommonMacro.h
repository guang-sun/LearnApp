//
//  TrainCommonMacro.h
//  SOHUEhr
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年  . All rights reserved.
//

#ifndef TrainCommonMacro_h
#define TrainCommonMacro_h



/**
 搜索类型

 */
typedef NS_ENUM(NSInteger){
    
    TrainSearchStyleCourse =0,
    TrainSearchStyleCircle,
    TrainSearchStyleDoc,
    TrainSearchStyleTopic

}TrainSearchStyle;

/**
 
 个人中心
 */
typedef NS_ENUM(NSInteger){
    
    TrainCenterStyleCourse =0,
    TrainCenterStyleCircle,
    TrainCenterStyleTopic,
    TrainCenterStyleDoc
    
}TrainCenterStyle;


/**
 课程类型
 */
typedef NS_ENUM(NSInteger){
    TrainModeCourse     =0 ,
    TrainModeClass      = 1,
    TrainModeMyCourse   = 2,
    TrainModeMyClass    = 3,
    TrainModeMyNotClass    = 4  

}TrainMode;

/**
 课程查询分类(最新, 最热)
 */
typedef NS_ENUM(NSInteger){
    TrainChooseModeNew = 0 ,  // 最新
    TrainChooseModeHot    ,   // 最热
    TrainChooseModeChoose     // 分类
    
}TrainChooseMode;



/**
  培训课程详情
 */
typedef NS_ENUM(NSInteger){
    TrainCourseDetailModeIntroduction   = 0 ,//简介
    TrainCourseDetailModeDirectory      = 1 ,//目录
    TrainCourseDetailModeNote           = 2 ,//笔记
    TrainCourseDetailModeDiscuss        = 3 ,//讨论
    TrainCourseDetailModeAppraise            //评价
    
}TrainCourseDetailMode;

/**
 班级详情分类
 */
typedef NS_ENUM(NSInteger){
    
    TrainClassModeCourse   = 0 ,  //课程
    TrainClassModeDetail   = 1 ,  //详情
    TrainClassModeSurvey   = 2 ,  //调查
    TrainClassModeEvaluate = 3 ,  //评估
    TrainClassModeExam     = 4 ,  //考试
    
}TrainClassMode;

/**
 班级课程详情 讲师  学员 评价
 */
typedef NS_ENUM(NSInteger){
    
    TrainClassDetailStatusTeacher =1,
    TrainClassDetailStatusStudent,
    TrainClassDetailStatusAppraise ,
    TrainClassDetailStatusMates
    
}TrainClassDetailStatus;


typedef NS_ENUM(NSInteger){
    TrainClassRegisterStatusNone = 0 ,  //未报名
    TrainClassRegisterStatusWaiting,    // 审核
    TrainClassRegisterStatusLining,     //排队
    TrainClassRegisterStatusFinish,     //报名成功,不可退出
    TrainClassRegisterStatusFinishExit  //成功.可退出
    
}TrainClassRegisterStatus;


/**
 话题类型
 */
typedef NS_ENUM(NSInteger){
    TrainTopicModeNew = 0,   //最新
    TrainTopicModeHot = 1,   //最热
    TrainTopicModePre = 2,   //精华
    TrainTopicModeAD  = 3    //问答
}TrainTopicMode;

/**
 我的圈子
 */
typedef NS_ENUM(NSInteger){
    TrainGroupModeJoin = 0,      //加入的圈子
    TrainGroupModeManager = 1,   //管理的圈子
}TrainGroupMode;


/**
 文库topMenu
 */
typedef NS_ENUM(NSInteger){
    TrainDocumentClassChoose =0, //查询
    TrainDocumentClassHot ,
    TrainDocumentClassNew,
    TrainDocumentClassFormat,
    TrainDocumentClassCategory,
    TrainDocumentClassMine       //我的文档
}TrainDocumentClass;


/**
 考试菜单
 */
typedef NS_ENUM(NSInteger){
    TrainExamModeAll = 0,
    TrainExamModeCourse,
    TrainExamModeClass,
    TrainExamModeIndependent
    
}TrainExamMode;

/**
 考试类型
 */
typedef NS_ENUM(NSInteger){
    TrainExamStyleExam = 0,
    TrainExamStyleSurvey,
    TrainExamStyleEvaluate,
    TrainExamStyleHomeWork
    
}TrainExamStyle;


/**
 考试状态
 */
typedef NS_ENUM(NSInteger){
    TrainExamCompleteStatusUnFinish = 0,
    TrainExamCompleteStatusFinish,
    TrainExamCompleteStatussPass,
    TrainExamCompleteStatusFail
    
}TrainExamCompleteStatus;



/**
 积分等级or规则
 */
typedef NS_ENUM(NSInteger){
    TrainIntegralStatusRule = 0,
    TrainIntegralStatusLevel
    
}TrainIntegralStatus;

typedef enum{
    TrainNewsModeUnread =0,  //未读
    TrainNewsModeRead    //已读
}TrainNewsMode;

#endif /* TrainCommonMacro_h */
