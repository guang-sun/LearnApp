//
//  TrainNetWorkAPIClient.m
//  SOHUTrain
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainNetWorkAPIClient.h"

@implementation TrainNetWorkAPIClient



-(void)trainBaseNetWorkWithURl:(NSString *)url
                    parameters:(id )parameters
                       Success:(defaultSuccessBlock)success
                    andFailure:(defaultFailureBlock)failure{
    
    TrainAPIFinishedBlock finish = [self customFinishedBlock:^(id resultObject) {
        
        success(resultObject);
        return YES;
        
    } withFailure:failure];
    
    
    NSString  *params = [self trainCreatURLStringWithbaseURL:nil userinfo:nil parameters:parameters];
    [self.trainAPIEngine trainPostRequest:url parameters:params finished:finish];

    
}


-(void)trainGetAPPUpdateWithSuccess:(defaultSuccessBlock)success
                         andFailure:(defaultFailureBlock)failure
{
    
    TrainNetWorkConfiguration   *netConf = [[TrainNetWorkConfiguration defaultConfiguration] init];
    
    if (!TrainStringIsEmpty(TrainUser.site)) {
        netConf = [[TrainNetWorkConfiguration defaultConfiguration] initWithHostString:TrainUser.site];
    }
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGetAppUpdate]];
    
    NSDictionary  *dic = [self trainAddCommonParameters:nil andUserName:nil];
    
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}


- (void)trainloginAppWithBaseUrl:(NSString *)url
                        userName:(NSString *)userName
                        passWord:(NSString *)passWord
                         Success:(defaultSuccessBlock)success
                      andFailure:(defaultFailureBlock)failure{
    
    TrainNetWorkConfiguration   *netConf = [[TrainNetWorkConfiguration defaultConfiguration] initWithHostString:url];
    TrainNSLog(@"%@",netConf.hostString);
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainLogin]];

    NSMutableDictionary  *mudic = [[NSMutableDictionary alloc]init];
    
    [mudic setObject:notEmptyStr(userName) forKey:@"user.username"];
    [mudic setObject:notEmptyStr(passWord) forKey:@"user.password"];

    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];

    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}

/**
 欢迎页
 @param url 站点
 
 */
- (void)trainGetWelcomeWithBaseUrl:(NSString *)url
                           Success:(defaultSuccessBlock)success
                        andFailure:(defaultFailureBlock)failure{
    
    TrainNetWorkConfiguration   *netConf = [[TrainNetWorkConfiguration defaultConfiguration] initWithHostString:url];
    TrainNSLog(@"-======%@",netConf.hostString);
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGetWelcomeAd]];
    NSDictionary  *dic = [self trainAddCommonParameters:nil andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}

#pragma   mark - 首页

-(void)trainHomeDataWithSuccess:(defaultSuccessBlock)success
                     andFailure:(defaultFailureBlock)failure
{
    
    
    TrainNetWorkConfiguration   *netConf = [[TrainNetWorkConfiguration defaultConfiguration] init];
    
    if (![netConf.hostString isEqualToString:TrainUser.site]) {
        netConf = [[TrainNetWorkConfiguration defaultConfiguration] initWithHostString:TrainUser.site];
    }
        
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMain]];

    NSDictionary  *dic = [self trainAddCommonParameters:nil andUserName:nil];

    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

}

/**
 首页 九宫格最新数据
 @param success
 @param failure
 */
- (void)trainHomeCollectionWithSuccess:(defaultSuccessBlock)success
                            andFailure:(defaultFailureBlock)failure{
    
//    TrainNetWorkConfiguration   *netConf = [[TrainNetWorkConfiguration defaultConfiguration] init];
    
//    if (![netConf.hostString isEqualToString:TrainUser.site]) {
//        netConf = [[TrainNetWorkConfiguration defaultConfiguration] initWithHostString:TrainUser.site];
//    }
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainmainCollection]];
    
    NSDictionary  *dic = [self trainAddCommonParameters:nil andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
}


#pragma mark - 报名
- (void)trainGetRegisterListWithregName:(NSString *)reg_name
                                curPage:(int)curPage
                                Success:(defaultSuccessBlock)success
                             andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGetRegistList]];
    
    NSMutableDictionary  *mudic = [[NSMutableDictionary alloc]init];;
    [mudic setObject:notEmptyStr(reg_name)    forKey:@"reg.name"];
    [mudic setObject:@"0" forKey:@"is_hot"];
    
    NSString  *page = [NSString stringWithFormat:@"%d",curPage];
    [mudic setObject: page forKey:@"reg.curPage"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];

    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}



#pragma  mark - 用户个人中心

-(void)trainGetUserCenterWithUser_id:(NSString *)user_id
                             Success:(defaultSuccessBlock)success
                          andFailure:(defaultFailureBlock)failure{
    
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGetUserCenter]];
    
    NSMutableDictionary  *mudic = [[NSMutableDictionary alloc]init];;
    [mudic setObject:notEmptyStr(user_id)    forKey:@"center.id"];
    [mudic setObject:trainCenterWithUser_id(user_id) forKey:@"center.sc"];
    
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];

    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}

-(void)trainGetUserCenterWithType:(TrainCenterStyle)type
                          User_id:(NSString *)user_id
                          curPage:(int)curPage
                          Success:(defaultSuccessBlock)success
                       andFailure:(defaultFailureBlock)failure{
    
    
    NSString *urlPath = @"";
    switch (type) {
        case TrainCenterStyleCourse:
            urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGetUserCenterCourse]];
            break;
        case TrainCenterStyleCircle:
            urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGetUserCenterGroup]];
            break;
        case TrainCenterStyleTopic:
            urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGetUserCenterTopic]];
            break;
        default:
            break;
    }
    NSString *string = [NSString stringWithFormat:@"%d",curPage];
    
    NSMutableDictionary  *mudic = [[NSMutableDictionary alloc]init];;
    [mudic setObject:notEmptyStr(user_id)    forKey:@"center.id"];
    [mudic setObject:trainCenterWithUser_id(user_id) forKey:@"center.sc"];
    [mudic setObject:notEmptyStr(string) forKey:@"center.curPage"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
    
}


#pragma mark - webView
- (NSString *)trainWebViewMode:(NSString *)mod
                     object_id:(NSString *)object_id
                  andtarget_id:(NSString *)target_id;
{
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(mod) forKey:@"mod"];
    [mudic setObject:notEmptyStr(object_id) forKey:@"object_id"];
    if (!TrainStringIsEmpty(target_id)) {
        [mudic setObject:notEmptyStr(target_id) forKey:@"target_id"];
    }
    [mudic setObject:@"ios" forKey:@"access_way"];
    [mudic setObject:@"app" forKey:@"access_way"];
    
    NSString  *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainWebView]];
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];

    NSString  *weburl = [self trainCreatURLStringWithbaseURL:urlPath userinfo:@"" parameters:dic];
    TrainNSLog(@"%@",weburl);
    return weburl;
    
}
- (NSString *)trainWebViewAddEmpidWithBaseURL:(NSString  *)baseURL{
    NSString  *weburl = [self webUrlAddInfoSession:baseURL];
    TrainNSLog(@"web--%@",weburl);
    return weburl;
}
- (void )trainwebDocIsAppraise:(NSString *)doc_id
                       success:(defaultSuccessBlock)success
                    andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainWebDocIsAppraise]];
    NSMutableDictionary *mudic = [NSMutableDictionary  dictionary];
    [mudic setObject:notEmptyStr(doc_id) forKey:@"appraiseRecord.doc_id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}

#pragma mark - 搜索

-(void)trainSearchHotTagSuccess:(defaultSuccessBlock)success{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainSearchTags]];
    NSDictionary  *dic = [self trainAddCommonParameters:nil andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:nil];

    
}

-(void)trainSearchResultWithStyle:(TrainSearchStyle)style
                           isTags:(BOOL)isTags
                            title:(NSString *)title
                          curPage:(int)curPage
                          Success:(defaultSuccessBlock)success
                       andFailure:(defaultFailureBlock)failure
{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainSearch]];
    
    NSMutableDictionary  *mudic = [[NSMutableDictionary alloc]init];;
    NSString *string = [NSString stringWithFormat:@"%d",curPage];
    NSDictionary  *dic  = nil;
    if (style == TrainSearchStyleCourse) {
        [mudic setObject:@"COURSE" forKey:@"search_type"];
        [mudic setObject:notEmptyStr(string) forKey:@"courseTrain.curPage"];
        [mudic setObject:notEmptyStr(title) forKey:@"courseTrain.title"];

//        if(isTags){
//            [mudic setObject:notEmptyStr(title) forKey:@"courseTrain.tags"];
//            [mudic setObject:notEmptyStr(@"") forKey:@"courseTrain.title"];
//            
//        }else{
//            [mudic setObject:notEmptyStr(title) forKey:@"courseTrain.title"];
//            [mudic setObject:notEmptyStr(@"") forKey:@"courseTrain.tags"];
//            
//        }
        dic = [self trainAddCommonParameters:mudic andUserName:@"courseTrain.user_id"];
        
    }else if(style == TrainSearchStyleCircle){
        
        [mudic setObject:@"CIRCLE" forKey:@"search_type"];
        [mudic setObject:notEmptyStr(string) forKey:@"group.curPage"];

        if(isTags){
            [mudic setObject:notEmptyStr(title) forKey:@"group.tags"];
            [mudic setObject:notEmptyStr(@"") forKey:@"group.title"];
            
        }else{
            [mudic setObject:notEmptyStr(title) forKey:@"group.title"];
            [mudic setObject:notEmptyStr(@"") forKey:@"group.tags"];
            
        }
        dic = [self trainAddCommonParameters:mudic andUserName:@"group.user_id"];
        
    }else if(style == TrainSearchStyleDoc){
        
        
        [mudic setObject:@"SHARE" forKey:@"search_type"];
        [mudic setObject:notEmptyStr(string) forKey:@"document.curPage"];
        
        if(isTags){
            [mudic setObject:notEmptyStr(title) forKey:@"document.tags"];
            [mudic setObject:notEmptyStr(@"") forKey:@"document.name"];
            
        }else{
            [mudic setObject:notEmptyStr(title) forKey:@"document.name"];
            [mudic setObject:notEmptyStr(@"") forKey:@"document.tags"];
            
        }
        dic = [self trainAddCommonParameters:mudic andUserName:@"document.user_id"];
        
        
    }else if(style == TrainSearchStyleTopic){
        
        [mudic setObject:@"TOPIC" forKey:@"search_type"];
        [mudic setObject:notEmptyStr(string) forKey:@"topic.curPage"];
        [mudic setObject:notEmptyStr(title) forKey:@"topic.title"];
        
        dic = [self trainAddCommonParameters:mudic andUserName:@"topic.user_id"];
//        if(isTags){
//            [mudic setObject:notEmptyStr(title) forKey:@"topic.tags"];
//            [mudic setObject:notEmptyStr(@"") forKey:@"topic.title"];
//            
//        }else{
//            [mudic setObject:notEmptyStr(title) forKey:@"topic.title"];
//            [mudic setObject:notEmptyStr(@"") forKey:@"topic.tags"];
//            
//        }
       
    
    }
    
//    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}



#pragma   mark - 课程

-(void)trainCourseMenuCategoryWithSuccess:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure
{
    
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseCategoryList]];
    NSDictionary  *dic = [self trainAddCommonParameters:nil andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
    
}

-(void)trainCourseListWithcourseType:(TrainMode )type
                               order:(TrainChooseMode )order
                        CourseFormat:(NSString *)CourseFormat
                          categoryid:(NSString *)categoryId
                             curPage:(int)curPage
                             Success:(defaultSuccessBlock)success
                          andFailure:(defaultFailureBlock)failure
{
    
    NSString *urlPath = nil;
    NSMutableDictionary  *mudic = [[NSMutableDictionary alloc]init];
    NSString *string = [NSString stringWithFormat:@"%d",curPage];
    NSDictionary  *dic ;

    if (type == TrainModeCourse ) {
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourse]];
        if (order == TrainChooseModeNew) {
            [mudic setObject:@"NEW" forKey:@"courseTrain.order_type"];
        }else if (order == TrainChooseModeHot){
            [mudic setObject:@"HOT" forKey:@"courseTrain.order_type"];
        }else if(order == TrainChooseModeChoose){
            
        }
        [mudic setObject:notEmptyStr(categoryId) forKey:@"courseTrain.category_id"];
        [mudic setObject:notEmptyStr(string) forKey:@"courseTrain.curPage"];
        NSString  *str =@"";
        if([CourseFormat isEqualToString:@"全部"]){
            str = @"";
        }else if([CourseFormat isEqualToString:@"在线"]){
            str = @"O";
            
        }else if([CourseFormat isEqualToString:@"面授"]){
            str = @"C";
            
        }else if([CourseFormat isEqualToString:@"直播"]){
            str = @"L";
            
        }
        [mudic setObject:notEmptyStr(str) forKey:@"courseTrain.c_type"];
        

        dic = [self trainAddCommonParameters:mudic andUserName:@"courseTrain.user_id"];
        
    }else if (type == TrainModeClass) {
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClass]];
        if (order == TrainChooseModeNew) {
            [mudic setObject:@"0" forKey:@"cls.order_num"];
        }else if (order == TrainChooseModeHot){
            [mudic setObject:@"1" forKey:@"cls.order_num"];
        }else if(order == TrainChooseModeChoose){
            
        }
        [mudic setObject:notEmptyStr(string) forKey:@"cls.curPage"];

        dic = [self trainAddCommonParameters:mudic andUserName:@"cls.user_id"];

        
    }else if (type == TrainModeMyCourse) {
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMyCourse]];
        [mudic setObject:string forKey:@"courseTrain.curPage"];
        dic = [self trainAddCommonParameters:mudic andUserName:@"courseTrain.user_id"];

        
    }else if (type == TrainModeMyClass) {
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMyClass]];
        [mudic setObject:string forKey:@"cls.curPage"];
        dic = [self trainAddCommonParameters:mudic andUserName:@"cls.user_id"];

    }else if (type == TrainModeMyNotClass) {
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMyClassNotRegister]];
        [mudic setObject:string forKey:@"cls.curPage"];
        dic = [self trainAddCommonParameters:mudic andUserName:@"cls.user_id"];
        
    }
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
    
}

-(void)trainCourseRegisterStatusWithCourseID:(NSString *)course_objectId
                                     Success:(defaultSuccessBlock)success
                                  andFailure:(defaultFailureBlock)failure{
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGetCourseRegisterStatus]];
    NSDictionary  *dic1 = [NSDictionary dictionaryWithObject:notEmptyStr(course_objectId) forKey:@"courseTrain.object_id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:dic1 andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
    
}

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
                            andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseRegister]];
    NSMutableDictionary   *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(course_objectId) forKey:@"object_id"];
    [mudic setObject:notEmptyStr(register_id) forKey:@"register_id"];
    [mudic setObject:notEmptyStr(name) forKey:@"name"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}

- (void)trainCourseDetailInfoWithMode:(TrainCourseDetailMode)mode
                              infoDic:(NSDictionary *)infoDic
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure;

{
    
    NSString *urlPath = @"";
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
    switch (mode) {
        case TrainCourseDetailModeIntroduction:
            
            urlPath =[self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseInfo]];
            
            break;
        case TrainCourseDetailModeDirectory:
            
            urlPath =[self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseHourInfo]];
           
            if ([infoDic[@"type"] isEqualToString:@"CLASS"]) {
                [mudic setObject:@"class" forKey:@"from"];

            }
            break;
        case TrainCourseDetailModeNote:{
            
            if ([infoDic[@"type"] isEqualToString:@"CLASS"]) {
                
                urlPath =[self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseClassNote]];
            }else{
                urlPath =[self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseNote]];
                
            }
        }
            break;
        case TrainCourseDetailModeDiscuss:
            
            urlPath =[self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseDiscuss]];
            break;
        case TrainCourseDetailModeAppraise:
            
            urlPath =[self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseAppraiseList]];
            break;
            
        default:
            break;
    }
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];

    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}

/**
 获取视频url
 
 @param object_id 课时的object_id     
 @param success
 @param failure
 */
- (void)trainGetMovieUrlWithobject_id:(NSString *)object_id
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure{
    
    NSString  *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseHourURL]];
    
    NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(object_id) forKey:@"object_id"];

    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
    
}

/**
 更新课时 文档or 考试的状态
 
 @param infoDic
 @param success
 @param failure
 */
- (void)trainUpdateHourDorEStatusWithIsExam:(BOOL )isExam
                                    infoDic:(NSDictionary *)infoDic
                                    Success:(defaultSuccessBlock)success
                                 andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath =  @"";
    
    if (isExam) {
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseUpdateHourWithExam]];
        
    }else{
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseUpdateHourWithDoc]];
        
    }
    NSDictionary  *dic = [self trainAddCommonParameters:infoDic andUserName:@"ccm.user_id"];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
    

}

/**
 获取课时的状态
 */
- (void)trainGetHourStatusWithC_id:(NSString *)c_id
                         object_id:(NSString *)object_id
                             lh_id:(NSString *)lh_id
                           success:(defaultSuccessBlock)success
                        andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGetHourStatusWithExam]];
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic  setObject:notEmptyStr(c_id) forKey:@"c_id"];
    [mudic setObject:notEmptyStr(object_id) forKey:@"object_id"];
    [mudic setObject:notEmptyStr(lh_id) forKey:@"lh_id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:@"user_id"];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
    
}


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
                              andFailure:(defaultFailureBlock)failure{
    
    
    NSString *urlPath =  @"";
    
    if (isCourse) {
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseUpdateStudyTime]];
        
    }else{
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassUpdateStudyTime]];
        
    }
    NSDictionary  *dic = [self trainAddCommonParameters:infoDic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
    
}

/*
 * 课程 详情
 添加笔记 或编辑   isEditNote  YES 编辑
 dic 的key: notes.content  object_id  notes.hour_id  notes.is_public   type  room_id notes.c_id
 
 */
- (void)trainCourseAddOrEditNoteWithisEditNote:(BOOL )isEditNote
                                       infoDic:(NSDictionary *)infoDic
                                       Success:(defaultSuccessBlock)success
                                    andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath =  @"";
    NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
    
    if (isEditNote) {
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseEditNote]];
        
    }else{
        
//        if ([infoDic[@"type"] isEqualToString:@"TRAIN"]) {
            urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseAddNote]];
            
//        }else if ([infoDic[@"type"] isEqualToString:@"CLASS"]) {
//            urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassCourseAddNote]];
//        }
//        [mudic removeObjectForKey:@"type"];
        
    }
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];

    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
    
    
}
/*
 * 课程 详情
 添加讨论
 content object_id  classHour_id  type room_id c_id
 */


- (void)trainCourseAddNewDiscussWithinfoDic:(NSDictionary *)infoDic
                                    Success:(defaultSuccessBlock)success
                                 andFailure:(defaultFailureBlock)failure{
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainAddCourseTopic]];
    
    NSDictionary  *dic = [self trainAddCommonParameters:infoDic andUserName:nil];
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

}

/*
 * 课程 详情
 回复 讨论
 infoDic Key = topic_id   from_user_id   from_post_id  content
 if(一级){from_user_id=0  from_post_id=0}
 */

- (void)trainPostTopicWithinfoDic:(NSDictionary *)infoDic
                         postType:(BOOL)isPostCourse
                          Success:(defaultSuccessBlock)success
                       andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath =@"";
    if (isPostCourse) {
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainCoursePost]];
    }else{
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainTopicPost]];
    }
    
    NSDictionary  *dic = [self trainAddCommonParameters:infoDic andUserName:nil];
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

}



/*
 * 课程 详情
 添加评价
 infoDic Key: object_id  grade  content  type room_id
 */

- (void)trainCourseAddAppraiseWithinfoDic:(NSDictionary *)infoDic
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath  = @"";
    NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
    
    //    if ([infoDic[@"type"] isEqualToString:@"TRAIN"]) {
    urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseAddAppraise]];
    
    //    }else if ([infoDic[@"type"] isEqualToString:@"CLASS"]) {
    //        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassCourseAddAppraise]];
    //    }
    //    [mudic removeObjectForKey:@"type"];
    
    
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
    
}
/*
 * 课程 详情
 删除评价
 */
- (void)trainCourseDeleteAppraiseWithIsClass:(BOOL)isClass
                                 Appraise_id:(NSString *)Appraise_id
                                     Success:(defaultSuccessBlock)success
                                  andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath  = @"";
    NSMutableDictionary  *params = [NSMutableDictionary  dictionaryWithCapacity:1];
    NSDictionary  *dic ;
    if(isClass){
        urlPath =[self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassCourseDeleteAppraise]];
        [params setObject:notEmptyStr(Appraise_id) forKey:@"comment.object_id"];
       dic = [self trainAddCommonParameters:params andUserName:@"comment.create_by"];

    }else{
        
        urlPath =[self trainCreatBaseURL:[TrainNetWorkConfiguration trainCourseDeleteAppraise]];
        
        [params setObject:notEmptyStr(Appraise_id) forKey:@"id"];
        dic = [self trainAddCommonParameters:params andUserName:nil];
    }
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
}

/**
 班级成绩策略
 */
- (void)trainClassGradeInfoWithClass_id:(NSString *)class_id
                              tactic_id:(NSString *)tactic_id
                                Success:(defaultSuccessBlock)success
                             andFailure:(defaultFailureBlock)failure {
    
    
    NSString *urlPath  = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassGradeInfo]];
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(class_id) forKey:@"cls.id"];
    [mudic setObject:notEmptyStr(tactic_id) forKey:@"cls.tactic_id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}

/**
 班级获取班级阶段
 */
- (void)trainClassphaseInfoWithClass_id:(NSString *)class_id
                                Success:(defaultSuccessBlock)success
                             andFailure:(defaultFailureBlock)failure {
    
    
    NSString *urlPath  = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassPhaseInfo]];
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(class_id) forKey:@"cls.id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}

/**
 *
 * 获取阶段资源
 */
- (void)trainClassphaseResoureWithClass_id:(NSString *)class_id
                                 sec_id:(NSString *)sec_id
                                Success:(defaultSuccessBlock)success
                             andFailure:(defaultFailureBlock)failure {
    
    
    NSString *urlPath  = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassPhaseRes]];
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(class_id) forKey:@"cls.id"];
    [mudic setObject:notEmptyStr(sec_id) forKey:@"cls.sec_id"];

    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:@"cls.user_id"];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}
/**
 *
 * 获取阶段资源
 */
- (void)trainClassPhaseHourListWithClass_id:(NSString *)class_id
                                     c_id:(NSString *)c_id
                                     room_id:(NSString *)room_id
                                   Success:(defaultSuccessBlock)success
                                andFailure:(defaultFailureBlock)failure {
    
    
    NSString *urlPath  = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassPhaseHourList]];
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(class_id) forKey:@"object_id"];
    [mudic setObject:notEmptyStr(c_id) forKey:@"c_id"];
    [mudic setObject:notEmptyStr(room_id) forKey:@"room_id"];
    [mudic setObject:notEmptyStr(@"class") forKey:@"from"];

    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:@"user_id"];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}

/**
 *
 * 获取班级评论列表
 */
- (void)trainClassCommentListWithClass_id:(NSString *)class_id
                                    grade:(NSInteger )grade
                                  pageNum:(NSInteger )pageNum
                                   Success:(defaultSuccessBlock)success
                                andFailure:(defaultFailureBlock)failure {
    
    NSString *urlPath  = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassCommendList]];
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(class_id) forKey:@"class_id"];
    
    NSString  *gradeType = [NSString stringWithFormat:@"%zi",grade];
    [mudic setObject:gradeType forKey:@"grade_type"];
    
    NSString *cur = [NSString stringWithFormat:@"%ld",(long)pageNum];
    [mudic setObject:cur forKey:@"curPage"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:@"user_id"];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}

/**
 *
 * 添加班级评价
 */
- (void)trainAddClassCommentWithClass_id:(NSString *)class_id
                                    grade:(NSString *)grade
                                  content:(NSString *)content
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure {
    
    NSString *urlPath  = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainAddClassCommend]];
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(class_id) forKey:@"object_id"];
    [mudic setObject:notEmptyStr(grade) forKey:@"grade"];
    [mudic setObject:notEmptyStr(content) forKey:@"content"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:@"user_id"];
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}



/**
 *
 * 获取班级同学
 */
- (void)trainClassMatesListWithClass_id:(NSString *)class_id
                                pageNum:(NSInteger )pageNum
                                Success:(defaultSuccessBlock)success
                             andFailure:(defaultFailureBlock)failure {
    
    NSString *urlPath  = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassAllMates]];
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(class_id) forKey:@"cls.id"];
    
    NSString *cur = [NSString stringWithFormat:@"%ld",(long)pageNum];
    [mudic setObject:cur forKey:@"cls.curPage"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}

/**
 *
 * 班级双收藏
 */
- (void)trainClassCollectWithClass_id:(NSString *)class_id
                            iscollect:(BOOL )iscollect
                            Success:(defaultSuccessBlock)success
                        andFailure:(defaultFailureBlock)failure {
    
    
    NSString *urlPath  = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassCollect]];
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(class_id) forKey:@"class_id"];
    
    if (iscollect) {
        [mudic setObject:notEmptyStr(@"add") forKey:@"fav_type"];
    }else {
        [mudic setObject:notEmptyStr(@"del") forKey:@"fav_type"];
    }
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:@"user_id"];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
}

- (void)trainClassDetailWithClassMode:(TrainClassMode )classMode
                             class_id:(NSString *)class_id
                              curPage:(int)curPage
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure{
    
    NSString  *urlPath = @"";
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    NSString *cur = [NSString stringWithFormat:@"%d",curPage];
    if (classMode == TrainClassModeCourse) {
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassCourseList]];
        [mudic  setObject:notEmptyStr(class_id) forKey:@"class_id"];
        [mudic setObject:cur forKey:@"curPage"];
        
    }else  if (classMode == TrainClassModeDetail){
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassDetail]];
        [mudic  setObject:notEmptyStr(class_id) forKey:@"class_id"];
        
    }else  if (classMode == TrainClassModeSurvey){
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassExamList]];
        [mudic  setObject:@"SURVEY" forKey:@"mobileTrainingClass_Json.type"];
        [mudic  setObject:notEmptyStr(class_id) forKey:@"mobileTrainingClass_Json.object_id"];
        [mudic setObject:cur forKey:@"mobileTrainingClass_Json.curPage"];
        
        
    }else  if (classMode == TrainClassModeEvaluate){
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassExamList]];
        [mudic  setObject:@"EVALUATE" forKey:@"mobileTrainingClass_Json.type"];
        [mudic  setObject:notEmptyStr(class_id) forKey:@"mobileTrainingClass_Json.object_id"];
        [mudic setObject:cur forKey:@"mobileTrainingClass_Json.curPage"];
        
        
        
    }else  if (classMode == TrainClassModeExam){
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassExamList]];
        [mudic  setObject:@"EXAM" forKey:@"mobileTrainingClass_Json.type"];
        [mudic  setObject:notEmptyStr(class_id) forKey:@"mobileTrainingClass_Json.object_id"];
        [mudic setObject:cur forKey:@"mobileTrainingClass_Json.curPage"];
        
        
        
    }
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
    
}

/*
 * 班级 报名
 报名 or 取消报名  isRegister  YES  报名
 */

- (void)trainClassDetailRegisterWithisRegister:(BOOL)isRegister
                                      class_id:(NSString *)class_id
                                    regiter_id:(NSString *)regiter_id
                                       Success:(defaultSuccessBlock)success
                                    andFailure:(defaultFailureBlock)failure{
    
    NSString  *urlPath = @"";
    
    if (isRegister) {
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassRegister]];
    }else {
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassUnRegister]];
        
    }
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic  setObject:notEmptyStr(class_id)   forKey:@"class_id"];
    [mudic  setObject:notEmptyStr(regiter_id) forKey:@"register_id"];
    
    
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
    
    
}

/*
 * 班级 报名
 班级 签到
 */

- (void)trainClassSignInWithregiter_id:(NSString *)regiter_id
                               Success:(defaultSuccessBlock)success
                            andFailure:(defaultFailureBlock)failure{
    
    NSString  *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassSignIn]];
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic  setObject:notEmptyStr(regiter_id) forKey:@"register_id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}

/*
 * 班级 详情
 学员 或 讲师 更多
 */
- (void)trainClassDetailMoreWithdetailMode:(TrainClassDetailStatus )status
                                  class_id:(NSString *)class_id
                                   curPage:(int )curPage
                                   Success:(defaultSuccessBlock)success
                                andFailure:(defaultFailureBlock)failure{
    
    NSString  *urlPath = @"";
    if (status  == TrainClassDetailStatusStudent) {
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassMorePerson]];
    }else if(status == TrainClassDetailStatusTeacher){
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassMoreLecturer]];
        
    }else if(status == TrainClassDetailStatusAppraise){
        //        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainClassMoreapp]];
    }
    
    NSString  *cur = [NSString stringWithFormat:@"%d",curPage];
    NSMutableDictionary  *mudic =[NSMutableDictionary  dictionary];
    [mudic setObject:notEmptyStr(class_id) forKey:@"mobilePerson.class_id"];
    [mudic setObject:notEmptyStr(cur) forKey:@"mobilePerson.curPage"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
    
}


#pragma mark 我的笔记list

/*
 * 我的笔记
 */
- (void)trainMyNoteWithcurPage:(int )curPage
                       Success:(defaultSuccessBlock)success
                    andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMyNote]];
    NSString *cur = [NSString stringWithFormat:@"%d",curPage];
    NSDictionary  *dic1 = [NSDictionary dictionaryWithObject:cur forKey:@"curPage"];
    NSDictionary  *dic = [self trainAddCommonParameters:dic1 andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
}
/*
 * 我的笔记 删除
 */
- (void)trainDeleteMyNoteWithNote_id:(NSString *)note_id
                             Success:(defaultSuccessBlock)success
                          andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMyNoteDelete]];
    NSDictionary  *dic1 = [NSDictionary dictionaryWithObject:notEmptyStr(note_id) forKey:@"id"];
    NSDictionary  *dic = [self trainAddCommonParameters:dic1 andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}


#pragma mark - 圈子

/*
 * 圈子列表
 */
- (void)trainGroupListWithtype:(TrainTopicMode )type
                       curPage:(int)curPage
                       Success:(defaultSuccessBlock)success
                    andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGroup]];
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:[NSString stringWithFormat:@"%zi",type] forKey:@"hotCircle_json.is_hot"];
    [mudic setObject:[NSString stringWithFormat:@"%d",curPage] forKey:@"hotCircle_json.curPage"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:@"hotCircle_json.user_id"];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
}


- (void)traingetMyGroupListWithType:(TrainGroupMode )type
                            curPage:(int)curPage
                            Success:(defaultSuccessBlock)success
                         andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = @"";
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    
    if(type == TrainGroupModeJoin){
        
        urlPath =  [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMyjoinGroup]];
//        [mudic setObject:@"join" forKey:@"hotCircle_json.type"];
        
    }else if(type == TrainGroupModeManager){
        
        urlPath =  [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMyManagerGroup]];

//        [mudic setObject:@"manage" forKey:@"hotCircle_json.type"];
        
    }
    [mudic setObject:[NSString stringWithFormat:@"%d",curPage] forKey:@"hotCircle_json.curPage"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}


/**
 圈子列表   圈子详情内  if(keyword) -> 搜索话题 title
 @param infoDic  key: group_id  type  curPage  keywords
 @param success  11
 @param failure  11
 */
- (void)trainGroupDetailtWithinfoDic:(NSDictionary *)infoDic
                             Success:(defaultSuccessBlock)success
                          andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGroupInfo]];
    NSDictionary  *dic = [self trainAddCommonParameters:infoDic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}

/*
 * 圈子列表
 join  圈子 group_id
 */
- (void)trainJoinGrouptWithgroup_id:(NSString *)group_id
                            Success:(defaultSuccessBlock)success
                         andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainGroupJoin]];
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(group_id) forKey:@"group_id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
}




#pragma mark - 话题

/*
 * 话题列表
 */
- (void)trainTopicListWithtype:(TrainTopicMode )type
                       curPage:(int)curPage
                       Success:(defaultSuccessBlock)success
                    andFailure:(defaultFailureBlock)failure{
    
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainTopic]];
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:[NSString stringWithFormat:@"%zi",type] forKey:@"is_hot"];
    [mudic setObject:[NSString stringWithFormat:@"%d",curPage] forKey:@"topic.curPage"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:@"topic.user_id"];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

}

/*
 * 我的话题列表
 */
- (void)trainMyTopicListWithtype:(NSString  *)type
                         curPage:(int)curPage
                         Success:(defaultSuccessBlock)success
                      andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMyTopic]];
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(type) forKey:@"type"];
    [mudic setObject:[NSString stringWithFormat:@"%d",curPage] forKey:@"curPage"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
}


/*
 *  话题 点赞
 */
- (void)trainTopicSupportWithtopic_id:(NSString *)topic_id
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainTopicTop]];
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(topic_id) forKey:@"top_step.topic_id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}

/*
 *  话题 收藏
 */
- (void)trainTopicCollectWithtopic_id:(NSString *)topic_id
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainTopicCollect]];
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(topic_id) forKey:@"collect.topic_id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

}


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
                              andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainTopicInfo]];
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    NSString *curPageStr = [NSString stringWithFormat:@"%d",curpage];
    [mudic setObject:notEmptyStr(topic_id) forKey:@"topic_id"];
    [mudic setObject:notEmptyStr(group_id) forKey:@"group_id"];
    [mudic setObject:notEmptyStr(curPageStr) forKey:@"curPage"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
}


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
                       andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainAddNewTopic]];
    
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    [mudic setObject:notEmptyStr(group_id)      forKey:@"topic.object_id"];
    [mudic setObject:notEmptyStr(title)         forKey:@"topic.title"];
    [mudic setObject:notEmptyStr(content)       forKey:@"topic.content"];
    [mudic setObject:notEmptyStr(topic_tagid)   forKey:@"topic.tag_id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
    
}




//
///**
// 上传image
// 
// @param imageDataArr 图片data 数组
// @param progress 上传进度
// @param success
// @param failure
// */
////typedef void (^TrainUploadfileBlock) (id<AFMultipartFormData> formData);
//
//- (void)trainUploadImage:(TrainAFNUploadfileBlock)imageBlock
//                progress:(TrainAFNProgressBlock)progress
//                 Success:(defaultSuccessBlock)success
//              andFailure:(defaultFailureBlock)failure{
//    
//    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainuploadImage]];
//    
//    TrainAPIFinishedBlock finish = [self customFinishedBlock:^(id resultObject) {
//        success(resultObject);
//        return YES;
//        
//    } withFailure:failure];
////    NSDictionary  *dic =[NSDictionary dictionary];
//    
//    [self.trainAPIEngine trainAFNUploadRequest:urlPath parameters:nil uploadData:imageBlock uploadProgress:progress finished:finish];
//    
//}


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
              andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainuploadImage]];
    
    TrainAPIFinishedBlock finish = [self customFinishedBlock:^(id resultObject) {
        success(resultObject);
        return YES;
        
    } withFailure:failure];
    NSDictionary  *dic =[NSDictionary dictionary];
    
    [self.trainAPIEngine trainUploadImageRequest:urlPath parameters:dic imageArr:imageDataArr finished:finish progress:progress];
    
}


-(void)trainGetTopicTagSuccess:(defaultSuccessBlock)success
                    andFailure:(defaultFailureBlock)failure{

    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainTopicTags]];
    
    NSDictionary  *dic = [self trainAddCommonParameters:nil andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

}

/**
 话题详情 删除话题
 
 */
- (void)trainRemoveTopicWithtopicInfo:(NSString *)strObj
                              Success:(defaultSuccessBlock)success
                           andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainRemoveTopic]];
    
    NSMutableDictionary   *muDic  = [NSMutableDictionary  dictionary];
    [muDic setObject: strObj forKey:@"strObj"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

}



/**
 话题详情 删除回复
 
 */
- (void)trainRemoveTopicPostWithTopic_id:(NSString *)topic_id
                                 post_id:(NSString *)post_id
                                 Success:(defaultSuccessBlock)success
                              andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainRemoveTopicPost]];
    
    NSMutableDictionary   *muDic  = [NSMutableDictionary  dictionary];
    [muDic setObject: topic_id forKey:@"topic_id"];
    [muDic setObject: post_id forKey:@"post_id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}



#pragma mark - 文库

-(void)trainDocMenuCategoryWithSuccess:(defaultSuccessBlock)success
                            andFailure:(defaultFailureBlock)failure
{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainDocCategoryList]];
    
    NSDictionary  *dic = [self trainAddCommonParameters:nil andUserName:nil];

    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
}

-(void)trainDocListWithtype:(TrainDocumentClass)type
                     format:(NSString *)format
                 categoryId:(NSString *)category_id
                    curPage:(int)curPage
                    Success:(defaultSuccessBlock)success
                 andFailure:(defaultFailureBlock)failure
{
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainDocument]];
    
    NSMutableDictionary   *muDic  = [NSMutableDictionary  dictionary];
    NSString *pageStr = [NSString stringWithFormat:@"%d",curPage];
    [muDic setObject: pageStr forKey:@"document.curPage"];

    if (type == TrainDocumentClassNew || type ==TrainDocumentClassHot) {
        
        NSString  *typeStr = [NSString stringWithFormat:@"%zi",type];
        [muDic setObject: typeStr forKey:@"is_hot"];
        
    }else if (type == TrainDocumentClassFormat) {
        
        [muDic setObject: @"0" forKey:@"is_hot"];
        [muDic setObject:notEmptyStr(format) forKey:@"document.format"];
        
    }else if(type == TrainDocumentClassCategory){
        
        [muDic setObject: @"0" forKey:@"is_hot"];
        [muDic setObject:notEmptyStr(category_id) forKey:@"document.directory_id"];
        
    }else if(type == TrainDocumentClassMine){
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainmyDocument]];
        [muDic setObject: @"2" forKey:@"is_hot"];
        
    }else if(type == TrainDocumentClassChoose){
        return;
    }
    
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:@"document.user_id"];

    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}

-(void)trainDocCollectWithIsCollect:(BOOL)isCollect
                             doc_id:(NSString *)doc_id
                            Success:(defaultSuccessBlock)success
                         andFailure:(defaultFailureBlock)failure
{
    NSString *urlPath = @"";
    NSMutableDictionary  *mudic = [NSMutableDictionary dictionary];
    if (isCollect) {
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainDocAddCollect]];
        [mudic setObject:notEmptyStr(doc_id) forKey:@"docOper.doc_id"];
    }else{
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainDocCancelCollect]];
        [mudic setObject:notEmptyStr(doc_id) forKey:@"doc_ids"];
        
    }
    
    NSDictionary  *dic = [self trainAddCommonParameters:mudic andUserName:@"docOper.user_id"];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
    
}


#pragma mark - 考试 评估 调查
/*
 *  考试
 */
- (void)trainExamListWithExamMode:(TrainExamMode )examMode
                       examStatus:(TrainExamCompleteStatus)examStatus
                      examCurpage:(int)examCurpage
                          Success:(defaultSuccessBlock)success
                       andFailure:(defaultFailureBlock)failure{
    
    NSString  *urlPath = @"";
    switch (examMode) {
        case TrainExamModeAll:
            urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainALLExam]];
            break;
        case TrainExamModeClass:
            urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainExamClass]];
            break;
        case TrainExamModeCourse:
            urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainExamCourse]];
            break;
        case TrainExamModeIndependent:
            urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainExamIndependent]];
            break;
            
        default:
            break;
    }
    
    NSString  *status = @"";
    switch (examStatus) {
        case TrainExamCompleteStatusUnFinish:
            status =@"UN";
            break;
        case TrainExamCompleteStatusFinish:
            status =@"Y";
            break;
        case TrainExamCompleteStatussPass:
            status =@"P";
            break;
        case TrainExamCompleteStatusFail:
            status =@"F";
            break;
            
        default:
            break;
    }
    
    NSString *curpage = [NSString stringWithFormat:@"%d",examCurpage];
    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:notEmptyStr(status)  forKey:@"mobileExam.is_finish"];
    [muDic setObject:curpage forKey:@"mobileExam.curPage"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:@"mobileExam.user_id"];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

    
}
/*
 *  考试  回顾考试
 */
- (void)trainReviewExamWithAtmp_id:(NSString *)atmp_id
                           Success:(defaultSuccessBlock)success
                        andFailure:(defaultFailureBlock)failure{
    
    
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainExamReview]];
    
    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:notEmptyStr(atmp_id)  forKey:@"atmp.performance_id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
}

/*
 *  考试  (评估 调查 作业)
 isHomeWork YES  作业  isFirst if(isHomeWork)(完成 未完成 ) else( 问卷 调查 )
 mobileExam.publish_key=WORK (作业) EVALUATE (问卷) SURVEY (调查)
 */
- (void)trainQuesOrHomeWorkWithisHomeWork:(BOOL )isHomeWork
                                  isFirst:(BOOL)isFirst
                              examCurpage:(int)examCurpage
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure{
    
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainExamList]];
  //  http://101.201.48.193/appws/user/getExam.action?mobileExam.user_id=62&appVersion=1.53&systemType=iOS&mobileExam.publish_key=EVALUATE
    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    [muDic  setObject:[NSString stringWithFormat:@"%d",examCurpage] forKey:@"mobileExam.curPage"];
    if (isHomeWork) {
        [muDic setObject:@"WORK"  forKey:@"mobileExam.publish_key"];
        if (isFirst) {
            [muDic setObject:@"N"  forKey:@"mobileExam.is_finish"];
        }else{
            [muDic setObject:@"Y"  forKey:@"mobileExam.is_finish"];
        }
    }else{
        if ( !isFirst) {
            [muDic setObject:@"EVALUATE"  forKey:@"mobileExam.publish_key"];
        }else{
            [muDic setObject:@"SURVEY"  forKey:@"mobileExam.publish_key"];
        }
    }
    
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:@"mobileExam.user_id"];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
    
    
    
}

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
                  andFailure:(defaultFailureBlock)failure{
    
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMyCollect]];
    
    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    [muDic  setObject:[NSString stringWithFormat:@"%d",curPage] forKey:@"curPage"];
    [muDic  setObject:type  forKey:@"type"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

}

#pragma mark - 我的积分


/**
 我的积分
 
 */
- (void)trainGetIntegralListlWithcurPage:(int )curPage
                                 Success:(defaultSuccessBlock)success
                              andFailure:(defaultFailureBlock)failure{
 
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainIntegral]];
    
    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    [muDic  setObject:[NSString stringWithFormat:@"%d",curPage] forKey:@"curPage"];
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:nil];
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
}

/**
 我的积分  积分等级 OR 积分规则
 
 */
- (void)trainIntegralRuleOrLevellWithtype:(TrainIntegralStatus)type
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath =@"";
    
    if (type == TrainIntegralStatusRule) {
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainIntegralRule]];
    }else if(type == TrainIntegralStatusLevel){
        
        urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainIntegralLevel]];
    }
    
    NSDictionary  *dic = [self trainAddCommonParameters:nil andUserName:nil];
    
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
}


#pragma mark - 资讯


/**
 获取资讯分类信息
 
 */
- (void)trainGetMessageMenuCategoryWithSuccess:(defaultSuccessBlock)success
                                    andFailure:(defaultFailureBlock)failure{
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMessageCategory]];
    
    NSDictionary  *dic = [self trainAddCommonParameters:nil andUserName:nil];
    
    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

}

- (void)trainGetMessagelistWithOrderField:(NSString *)orderField
                              category_id:(NSString *)category_id
                                 promoted:(NSString *)promoted
                                  curPage:(int )curPage
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainMessageList]];
   
    
    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    [muDic  setObject:[NSString stringWithFormat:@"%d",curPage] forKey:@"dynamic.curPage"];
    [muDic  setObject:orderField  forKey:@"dynamic.orderField"];
    [muDic  setObject:category_id  forKey:@"dynamic.category_id"];
    [muDic  setObject:@"1"  forKey:@"dynamic.site_id"];
    [muDic  setObject:promoted  forKey:@"dynamic.promoted"];
    [muDic  setObject:@"10"  forKey:@"dynamic.pageSize"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:nil];
//    dynamic.orderField=%@&dynamic.category_id=%@&dynamic.site_id=%@&dynamic.promoted=%@&dynamic.pageSize=10&dynamic.curPage=%d&user_id
//    
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];

}

#pragma mark - 消息
/**
 获取消息list
 */
- (void)trainGetNewslistWithisRead:(TrainNewsMode )isRead
                           curPage:(int )curPage
                           Success:(defaultSuccessBlock)success
                        andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainNewsList]];
    
    
    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    [muDic  setObject:[NSString stringWithFormat:@"%d",curPage] forKey:@"message.curPage"];
    [muDic  setObject:[NSString stringWithFormat:@"%d",isRead]  forKey:@"message.is_read"];
       
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:@"message.user_id"];
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
}


/**
 h获取消息的详情

 */
- (void)trainGetNewsDetailWithid:(NSString *)news_id
                           Success:(defaultSuccessBlock)success
                        andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainNewsDetail]];
    
    
    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    [muDic  setObject:notEmptyStr(news_id) forKey:@"message.id"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:nil];
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
}

- (void)trainReadNewsWithisid:(NSString *)news_id
                           Success:(defaultSuccessBlock)success
                        andFailure:(defaultFailureBlock)failure{
    
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainReadNews]];

    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    [muDic  setObject:notEmptyStr(news_id) forKey:@"message.my_message_id"];
    [muDic  setObject:notEmptyStr(TrainUser.emp_id)  forKey:@"message.last_update_by"];

    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:@""];
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
}



#pragma mark - 意见反馈 && 建议
/**
 意见反馈 && 建议
 */
- (void)trainSendOurSuggestWithcontent:(NSString *)content
                               Success:(defaultSuccessBlock)success
                            andFailure:(defaultFailureBlock)failure{
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainSendSuggest]];
    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    
    NSDate  *date =[NSDate date];
    NSDateFormatter  *df =[[NSDateFormatter alloc]init];
    [df setDateStyle:NSDateFormatterFullStyle];
    [df setDateFormat:@"yyyy-mm-dd"];
    NSString  *newDateStr = [df stringFromDate:date];
    
    
    [muDic  setObject:newDateStr forKey:@"feedBack.create_by_date"];
    [muDic  setObject:TrainUser.user_id  forKey:@"feedBack.create_by"];
    [muDic  setObject:@"iOS" forKey:@"feedBack.terminal"];
    [muDic  setObject:TrainAPPVersions  forKey:@"feedBack.version"];
    [muDic  setObject:content forKey:@"feedBack.content"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:nil];
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
}

- (void)trainUpdateLocalRecordWithcontent:(NSString *)content
                                  Success:(defaultSuccessBlock)success
                               andFailure:(defaultFailureBlock)failure{
    NSString *urlPath = [self trainCreatBaseURL:[TrainNetWorkConfiguration trainUpdateLocalStudyTime]];
    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    [muDic  setObject:content forKey:@"offline"];
    
    NSDictionary  *dic = [self trainAddCommonParameters:muDic andUserName:nil];
    [self trainBaseNetWorkWithURl:urlPath parameters:dic Success:success andFailure:failure];
}





@end
