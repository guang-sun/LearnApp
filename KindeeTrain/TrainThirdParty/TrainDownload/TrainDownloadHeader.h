//
//  TrainDownloadHeader.h
//   KingnoTrain
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#ifndef TrainDownloadHeader_h
#define TrainDownloadHeader_h


#define TrainMaxTaskCount 2 //下载队列并发数

// 缓存主目录
#define learnCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"learnCache"]

// 保存文件名
#define learnFileName(url)  [[[url componentsSeparatedByString:@"/"] lastObject]stringByAppendingString:@".mp4"]

// 文件的存放路径（caches）
#define learnFileFullpath(url) [learnCachesDirectory stringByAppendingPathComponent:learnFileName(url)]

// 文件的已下载长度
#define learnDownloadLength(url) [[[NSFileManager defaultManager] attributesOfItemAtPath:learnFileFullpath(url) error:nil][NSFileSize] integerValue]

// 存储文件信息的路径（caches）
#define learnDownloadDetailPath [learnCachesDirectory stringByAppendingPathComponent:@"downloadDetail.data"]
#define learnDownloadtaskPath [learnCachesDirectory stringByAppendingPathComponent:@"downloadtask.data"]

#endif /* TrainDownloadHeader_h */
