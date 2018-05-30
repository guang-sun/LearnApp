//
//  TrainDownloadManager.h
//   KingnoTrain
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainDownloader.h"

@protocol TrainFileDownloadManagerDelegate <NSObject>

/*
 下载开始
 */
- (void)fileDownloadManagerStartDownload:(TrainDownloadModel *)download;
/*
 得到响应，获得文件大小等
 */
- (void)fileDownloadManagerReceiveResponse:(TrainDownloadModel *)download FileSize:(uint64_t)totalLength;
/*
 下载过程，更新进度
 */
- (void)fileDownloadManagerUpdateProgress:(TrainDownloadModel *)download didReceiveData:(uint64_t)receiveLength downloadSpeed:(NSString *)downloadSpeed;
/*
 下载完成，包括成功和失败
 */
- (void)fileDownloadManagerFinishDownload:(TrainDownloadModel *)download success:(BOOL)downloadSuccess error:(NSError *)error;

@end



@interface TrainDownloadManager : NSObject


+ (instancetype)sharedFileDownloadManager;

@property (assign, nonatomic) NSInteger maxConDownloadCount;             //当前队列最大同时下载数，默认值是3
@property (assign, nonatomic, readonly) NSInteger currentDownloadCount;  //当前队列中下载数，包括正在下载的和等待的
@property (assign, nonatomic) id<TrainFileDownloadManagerDelegate>delegate;

//添加到下载队列
- (void)addDownloadWithDownLoadModel:(TrainDownloadModel *)filemodel;;

//点击等待项（－》立刻下载／do nothing）
- (void)startDownloadWithFileId:(TrainDownloadModel *)filemodel;

//点击下载项 －》暂停
- (void)suspendDownloadWithFileId:(TrainDownloadModel *)filemodel;

//点击暂停项（－》立刻下载／添加到下载队列）
- (void)recoverDownloadWithFileId:(TrainDownloadModel *)filemodel;

//取消下载，且删除文件，只适用于未下载完成状态，下载完成的直接根据路径删除即可
- (void)cancelDownloadWithFileId:(TrainDownloadModel *)filemodel;
- (void)deleteDownloadWithFileId:(TrainDownloadModel *)filemodel;

//暂停全部
- (void)suspendAllFilesDownload;

//恢复全部
- (void)recoverAllFilesDownload;

//取消全部
- (void)cancelAllFilesDownload;

//获得状态
//- (trai)getFileDownloadStateWithFileId:(SCFileDownLoadModel *)filemodel;


@end
