//
//  TrainLocalData.m
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainLocalData.h"

@implementation TrainLocalData


+(NSDictionary *)returnMainDic{
    NSDictionary  *dic =@{
                          @"CODE"   :@"Train_Main_scan",
                          @"QA":@"Train_Main_myAd",
                          @"CACHE"   :@"Train_Main_cache",
                          @"COURSE":@"Train_Main_myCouse",
                          @"CLASS":@"Train_Main_myClass",
                          @"SHARE":@"Train_Main_myDocument",
                          @"EXAM":@"Train_Main_exam",
                          @"SURVEYANDASSESS":@"Train_Main_question",
                          @"TASK":@"Train_Main_myWork",
                          @"TOPIC":@"Train_Main_myTopic",
                          @"NOTES":@"Train_Main_myNote",
                          @"RECORD":@"Train_Main_Learning",
                          @"REGISTER"   :@"Train_Main_register",
                          @"NEWS":@"Train_Main_news",
                          @"INTEGRAL":@"Train_Main_myIntegral",
                          @"COLLECTION":@"Train_Main_myCollect",
                          @"HISTORY":@"Train_Main_browsing",
                          @"MYGROUP":@"Train_Main_mycircle"
                          };
    
    return dic;
    
    
}
+(NSArray *)returnMainMenuArr{
    NSArray *arr =@[@"扫码",@"我的问答",@"缓存",@"我的课程",@"我的班级",@"我的文库",@"我的考试",@"问卷评估",@"我的作业",@"我的话题",@"我的笔记",@"学习档案",@"活动报名",@"资讯动态",@"我的积分",@"我的收藏",@"浏览历史"];
    return arr;
}


+(NSArray  *)returnMainArr{
    
    NSArray  *arr =  @[@{@"fn_key":@"CODE",
                         @"fn_name":@"扫一扫",
                         @"fn_pic":@"wwww",
                         @"targerKey":@"CODE",
                         @"webUrl":@""},
                       @{@"fn_key":@"CACHE",
                         @"fn_name":@"我的缓存",
                         @"fn_pic":@"www",
                         @"targerKey":@"CACHE",
                         @"webUrl":@""},
                       @{@"fn_key":@"COURSE",
                         @"fn_name":@"我的课程",
                         @"fn_pic":@"www",
                         @"targerKey":@"COURSE",
                         @"webUrl":@""},
                       @{@"fn_key":@"CLASS",
                         @"fn_name":@"我的班级",
                         @"fn_pic":@"www",
                         @"targerKey":@"CLASS",
                         @"webUrl":@""},
                       @{@"fn_key":@"SHARE",
                         @"fn_name":@"我的文库",
                         @"fn_pic":@"www",
                         @"targerKey":@"SHARE",
                         @"webUrl":@""},
                       @{@"fn_key":@"EXAM",
                         @"fn_name":@"我的考试",
                         @"fn_pic":@"w",
                         @"targerKey":@"EXAM",
                         @"webUrl":@""},
                       @{@"fn_key":@"TASK",
                         @"fn_name":@"我的作业",
                         @"fn_pic":@"q",
                         @"targerKey":@"TASK",
                         @"webUrl":@""},
                       @{@"fn_key":@"TOPIC",
                         @"fn_name":@"我的话题",
                         @"fn_pic":@"w",
                         @"targerKey":@"TOPIC",
                         @"webUrl":@""},
                       @{@"fn_key":@"COLLECTION",
                         @"fn_name":@"我的收藏",
                         @"fn_pic":@"w",
                         @"targerKey":@"COLLECTION",
                         @"webUrl":@""},
                       @{@"fn_key":@"INTEGRAL",
                         @"fn_name":@"我的积分",
                         @"fn_pic":@"w",
                         @"targerKey":@"INTEGRAL",
                         @"webUrl":@""},
                       @{@"fn_key":@"NOTES",
                         @"fn_name":@"我的笔记",
                         @"fn_pic":@"w",
                         @"targerKey":@"NOTES",
                         @"webUrl":@""},
                       
                       @{@"fn_key":@"SURVEYANDASSESS",
                         @"fn_name":@"我的问卷",
                         @"fn_pic":@"w",
                         @"targerKey":@"SURVEYANDASSESS",
                         @"webUrl":@""},
                       
                       @{@"fn_key":@"MYGROUP",
                         @"fn_name":@"我的圈子",
                         @"fn_pic":@"w",
                         @"targerKey":@"MYGROUP",
                         @"webUrl":@""}];
    
    return  arr ;

}
+(NSArray *)returnCourseClassMenu{
    NSArray  *topDocArr =@[@"最新",@"最热",@"类型",@"分类"];
    return topDocArr;
}
+(NSArray *)returnCourseChooseClass{
    NSArray  *arr =@[@"全部",@"在线",@"面授",@"直播"];
    return arr;
}

+(NSArray *)returnDocClassMenu{
    NSArray  *topDocArr =@[@"最新",@"最热",@"格式",@"分类"];
    return topDocArr;
}
+(NSArray *)returnChooseDocClass{
    NSArray  *arr =@[@"全部",@"DOC",@"XLS",@"PPT",@"TXT",@"PDF",@"IMG",@"VIDEO"];
    return arr;
}

+(NSString *)returnDocImage:(NSString *)str{
    NSDictionary  *dic =@{
                          @"mov" :@"Train_Doc_Mov",
                          @"wmv" :@"Train_Doc_Mov",
                          @"flv" :@"Train_Doc_Mov",
                          @"mp4" :@"Train_Doc_Mov",
                          @"rmvb":@"Train_Doc_Mov",
                          @"rm"  :@"Train_Doc_Mov",
                          @"avi" :@"Train_Doc_Mov",
                          @"mpg" :@"Train_Doc_Mov",
                          @"rmvb":@"Train_Doc_Mov",
                          @"mpeg":@"Train_Doc_Mov",
                          
                          @"doc" :@"Train_Doc_DOC",
                          @"docx":@"Train_Doc_DOC",
                          @"dot" :@"Train_Doc_DOC",
                          @"dotm":@"Train_Doc_DOC",
                          
                          @"ppt" :@"Train_Doc_PPT",
                          @"pptx":@"Train_Doc_PPT",
                          @"pps" :@"Train_Doc_PPT",
                          @"ppsx":@"Train_Doc_PPT",
                          @"pot" :@"Train_Doc_PPT",
                          @"potx":@"Train_Doc_PPT",
                          @"pptm":@"Train_Doc_PPT",
                          @"potm":@"Train_Doc_PPT",
                          @"ppsm":@"Train_Doc_PPT",
                          
                          @"xls" :@"Train_Doc_XLS",
                          @"xlsx":@"Train_Doc_XLS",
                          @"xlsm":@"Train_Doc_XLS",
                          @"xlm" :@"Train_Doc_XLS",
                          @"xlsb":@"Train_Doc_XLS",
                          
                          @"jpg":@"Train_Doc_IMG",
                          @"png":@"Train_Doc_IMG",
                          @"gif":@"Train_Doc_IMG",
                          
                          @"txt":@"Train_Doc_TXT",
                          
                          @"pdf":@"Train_Doc_PDF",
                          @"zip":@"train_default_file",
                          @"rar":@"train_default_file",
                          };
    return dic[str];
}

+(NSArray *)returnCourseDetailMenu{
    
    NSArray  *topDocArr = @[@"简介",@"目录",@"笔记",@"讨论",@"评价"];
    return topDocArr;
    
}


+(NSArray *)returnClassDetailMenu{
    NSArray  *topDocArr = @[@"课程",@"详情",@"调查",@"评估",@"考试"];
    return topDocArr;
}



@end
