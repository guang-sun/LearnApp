//
//  TrainDownloadModel.h
//   KingnoTrain
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import "TrainBaseModel.h"


typedef NS_ENUM(NSInteger, TrainFileDownloadState){
    TrainFileDownloadStateWaiting = 0,
    TrainFileDownloadStateDownloading = 1,
    TrainFileDownloadStateSuspending = 2,
    TrainFileDownloadStateFail = 3,
    TrainFileDownloadStateFinish = 4,
};



@interface TrainDownloadModel : TrainBaseModel

@property (nonatomic, copy) NSString    *url;                     //视频地址
@property (nonatomic, copy) NSString    *CHO_id;           // c_id + hour_id+ object_id 判断视频(同样的课在 课程 和班级 不一样)
@property (nonatomic, copy) NSString    *c_id;                     //课程id
@property (nonatomic, copy) NSString    *hour_id;                  //课时id
@property (nonatomic, copy) NSString    *object_id;//

@property (nonatomic, copy) NSString    *courseName;            // 课程名
@property (nonatomic, copy) NSString    *hourName;              //课时名
@property (nonatomic, copy) NSString    *imageUrl;              //课程图片url
@property (strong,nonatomic)NSString    *filePath;              //保存文件路径 默认 cache/learnCache
@property (strong,nonatomic)NSString    *saveFileName;          //保存文件名 默认服务器返回的文件名
@property (nonatomic, assign) NSInteger selectIndex;            //在课程目录 的index
@property (nonatomic, assign) NSInteger  last_time;             //上次观看时间

/** 文件大小 */
@property (nonatomic, assign) long long totalSize;
@property (nonatomic, assign) float     progress;

@property (assign,nonatomic) TrainFileDownloadState status;          //请求状态
@property (assign,nonatomic) BOOL       isSelect;          //请求状态





@end
