//
//  TrainDownloadManager.m
//   KingnoTrain
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import "TrainDownloadManager.h"


#define  RESPONSE_TO_WAITING_WAY_ONE      1
#define  RESPONSE_TO_WAITING_WAY_TWO      0
#define  RESPONSE_TO_SUSPEND_WAY          1


@interface TrainDownloadManager ()<TrainFileDownloadDelegate>

@property (strong, nonatomic) NSOperationQueue *downloadQueue;            //下载队列
@property (strong, nonatomic) NSMutableArray *suspendDownloadArr;         //取消的下载



@end

@implementation TrainDownloadManager

+ (instancetype)sharedFileDownloadManager
{
    static dispatch_once_t onceToken;
    static TrainDownloadManager *fileDownloadManager = nil;
    dispatch_once(&onceToken, ^{
        fileDownloadManager = [[TrainDownloadManager alloc] init];
    });
    return fileDownloadManager;
}

- (instancetype)init
{
    if(self = [super init]){
        _suspendDownloadArr = [NSMutableArray array];
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.maxConcurrentOperationCount = TrainMaxTaskCount;
    }
    return self;
}

#pragma mark --- Publick Download ---
- (void)addDownloadWithDownLoadModel:(TrainDownloadModel *)filemodel{
    
    BOOL isExist = [self isExistsFileWith:filemodel];
    if ( !isExist) {
        filemodel.status = TrainFileDownloadStateWaiting;
        [filemodel saveOrUpdateByColumnName:@[@"CHO_id"]];
    }
    TrainDownloader  *fileDownload = [[TrainDownloader alloc]initWithDownLoadModel:filemodel delegate:self];
    [_downloadQueue addOperation:fileDownload];
    
    
}


- (void)startDownloadWithFileId:(TrainDownloadModel *)filemodel;
{
    if(self.currentDownloadCount==0){
        return;
    }
    //do nothing
    if(RESPONSE_TO_WAITING_WAY_ONE){
        return;
    }
    //去暂停
    if(RESPONSE_TO_WAITING_WAY_TWO){
        for(NSInteger i=self.maxConDownloadCount;i<self.currentDownloadCount;i++){
            TrainDownloader *fileDownload = [_downloadQueue.operations objectAtIndex:i];
            if([fileDownload.model.CHO_id isEqualToString:filemodel.CHO_id]){
                [fileDownload cancel];
                [_suspendDownloadArr addObject:fileDownload];
                filemodel.status = TrainFileDownloadStateSuspending;
                [filemodel saveOrUpdateByColumnName:@[@"CHO_id"]];

                break;
            }
        }
        return;
    }
    //立即去下载
    NSMutableArray *tmpCancelArray = [NSMutableArray array];
    TrainDownloader *chooseDownload = nil;
    for(NSInteger i=self.maxConDownloadCount;i<self.currentDownloadCount;i++){
        TrainDownloader *fileDownload = [_downloadQueue.operations objectAtIndex:i];
        [fileDownload cancel];
        if([fileDownload.model.CHO_id isEqualToString:filemodel.CHO_id]){
            chooseDownload = fileDownload;
        }
        else{
            [tmpCancelArray addObject:fileDownload];
        }
    }
    TrainDownloader *fileDownload = [_downloadQueue.operations objectAtIndex:self.maxConDownloadCount-1];
    [fileDownload cancelDownloadIfDeleteFile:NO];
    [self addToDownloadWithFileDownload:chooseDownload];
    [self addToDownloadWithFileDownload:fileDownload];
    for(TrainDownloader *fileDownload in tmpCancelArray){
        [self addToDownloadWithFileDownload:fileDownload];
    }
    
    [filemodel saveOrUpdateByColumnName:@[@"CHO_id"]];

}

- (void)suspendDownloadWithFileId:(TrainDownloadModel *)filemodel;
{
    for(TrainDownloader *fileDownload in _downloadQueue.operations){
        if([fileDownload.model.CHO_id isEqualToString:filemodel.CHO_id]){
            [fileDownload cancelDownloadIfDeleteFile:NO];
            [_suspendDownloadArr addObject:fileDownload];
            break;
        }
    }
}

- (void)recoverDownloadWithFileId:(TrainDownloadModel *)filemodel;
{
    //添加到下载队列
    if(RESPONSE_TO_SUSPEND_WAY){
        [self addToDownloadInSuspendArrayWithFileId:filemodel];
        return;
    }
    //立即去下载
    if([self canAddOperationWithoutCancel]){
        [self addToDownloadInSuspendArrayWithFileId:filemodel];
    }
    else if([self hasWaitingOperations]){
        NSMutableArray *tmpCancelArray = [NSMutableArray array];
        for(NSInteger i=self.maxConDownloadCount;i<self.currentDownloadCount;i++){
            TrainDownloader *fileDownload = [_downloadQueue.operations objectAtIndex:i];
            [fileDownload cancel];
            [tmpCancelArray addObject:fileDownload];
        }
        TrainDownloader *fileDownload = [_downloadQueue.operations objectAtIndex:self.maxConDownloadCount-1];
        [fileDownload cancelDownloadIfDeleteFile:NO];
        [self addToDownloadInSuspendArrayWithFileId:filemodel];
        [self addToDownloadWithFileDownload:fileDownload];
        for(TrainDownloader *fileDownload in tmpCancelArray){
            [self addToDownloadWithFileDownload:fileDownload];
        }
    }
    else{
        TrainDownloader *fileDownload = [_downloadQueue.operations lastObject];
        [fileDownload cancelDownloadIfDeleteFile:NO];
        [self addToDownloadInSuspendArrayWithFileId:filemodel];
        [self addToDownloadWithFileDownload:fileDownload];
    }
}

- (void)cancelDownloadWithFileId:(TrainDownloadModel *)filemodel;
{
    //先从下载队列中寻找
    NSString *filePath = @"";
    for(TrainDownloader *fileDownload in _downloadQueue.operations){
        if([fileDownload.model.CHO_id isEqualToString:filemodel.CHO_id]){
            filePath = [self tmpFilePathWithDirectoryPath:learnCachesDirectory fileName:filemodel.saveFileName];
            [fileDownload cancelDownloadIfDeleteFile:YES];
            [filemodel deleteObjectsByColumnName:@[@"CHO_id"]];
            [self removeTmpFileWithPath:filePath];
            
            
            return;
        }
    }
    //再从暂停列表中寻找
    for(TrainDownloader *fileDownload in _suspendDownloadArr){
        if([fileDownload.model.CHO_id isEqualToString:filemodel.CHO_id]){
            filePath = [self tmpFilePathWithDirectoryPath:learnCachesDirectory fileName:filemodel.saveFileName];
            [_suspendDownloadArr removeObject:fileDownload];
            [self removeTmpFileWithPath:filePath];
            [filemodel deleteObjectsByColumnName:@[@"CHO_id"]];

            return;
        }
    }
}
- (void)deleteDownloadWithFileId:(TrainDownloadModel *)filemodel{
    
    NSString  *savePath = [ learnCachesDirectory  stringByAppendingPathComponent:filemodel.saveFileName];

    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
        [filemodel deleteObjectsByColumnName:@[@"CHO_id"]];

    }
    
}
- (void)suspendAllFilesDownload
{
    //需要区分是正在执行的还是等待的，先把排队中的cancel掉，再把正在执行的finish掉
    if([self hasWaitingOperations]){
        NSMutableArray *tmpCancelArray = [NSMutableArray array];
        for(NSInteger i=self.maxConDownloadCount;i<self.currentDownloadCount;i++){
            TrainDownloader *fileDownload = [_downloadQueue.operations objectAtIndex:i];
            [fileDownload cancel];
            [_suspendDownloadArr addObject:fileDownload];
        }
        NSMutableArray *downloadingCancelArray = [NSMutableArray array];
        for(NSInteger i=0;i<self.maxConDownloadCount;i++){
            TrainDownloader *fileDownload = [_downloadQueue.operations objectAtIndex:i];
            [downloadingCancelArray addObject:fileDownload];
        }
        for(TrainDownloader *fileDownload in downloadingCancelArray){
            [fileDownload cancelDownloadIfDeleteFile:NO];
        }
        [tmpCancelArray addObjectsFromArray:downloadingCancelArray];
        [tmpCancelArray addObjectsFromArray:_suspendDownloadArr];
        self.suspendDownloadArr = tmpCancelArray;
    }
    else{
        for(TrainDownloader *fileDownload in _downloadQueue.operations){
            [fileDownload cancelDownloadIfDeleteFile:NO];
            [_suspendDownloadArr addObject:fileDownload];
        }
    }
}

- (void)recoverAllFilesDownload
{
    for(TrainDownloader *fileDownload in _suspendDownloadArr){
        [self addToDownloadWithFileDownload:fileDownload];
    }
    [_suspendDownloadArr removeAllObjects];
}

- (void)cancelAllFilesDownload
{
    //先把排队的取消掉，再把正在下载的取消掉
    if([self hasWaitingOperations]){
        for(NSInteger i=self.maxConDownloadCount;i<self.currentDownloadCount;i++){
            TrainDownloader *fileDownload = [_downloadQueue.operations objectAtIndex:i];
            NSString *filePath = [self tmpFilePathWithDirectoryPath:learnCachesDirectory fileName:fileDownload.model.saveFileName];
            [fileDownload cancel];
            [self removeTmpFileWithPath:filePath];
        }
        NSMutableArray *downloadingCancelArray = [NSMutableArray array];
        for(NSInteger i=0;i<self.maxConDownloadCount;i++){
            TrainDownloader *fileDownload = [_downloadQueue.operations objectAtIndex:i];
            [downloadingCancelArray addObject:fileDownload];
        }
        for(TrainDownloader *fileDownload in downloadingCancelArray){
            NSString *filePath = [self tmpFilePathWithDirectoryPath:learnCachesDirectory fileName:fileDownload.model.saveFileName];
            [fileDownload cancelDownloadIfDeleteFile:YES];
            [self removeTmpFileWithPath:filePath];
        }
    }
    else{
        for(TrainDownloader *fileDownload in _downloadQueue.operations){
            [fileDownload cancelDownloadIfDeleteFile:YES];
        }
    }
    for(TrainDownloader *fileDownload in _suspendDownloadArr){
        NSString *filePath = [self tmpFilePathWithDirectoryPath:learnCachesDirectory fileName:fileDownload.model.saveFileName];
        [self removeTmpFileWithPath:filePath];
    }
    [_suspendDownloadArr removeAllObjects];
}

//- (FileDownloadState)getFileDownloadStateWithFileId:(SCFileDownLoadModel *)filemodel
//{
//    //下载列表中包括正在下载和等待下载中，已经完成的不论成功或失败均不在此列
//    for(SCFileDownload *fileDownload in _suspendDownloadArr){
//        if([fileDownload.model.hour_id  isEqualToString:filemodel.hour_id]){
//            return FileDownloadStateSuspending;
//        }
//    }
//    
//    NSInteger findCount = 0;
//    NSInteger findIndex = 0;
//    for(int i=0;i<self.currentDownloadCount;i++){
//        if(i>=_downloadQueue.operations.count){
//            return FileDownloadStateWaiting;
//        }
//        SCFileDownload *fileDownload = [_downloadQueue.operations objectAtIndex:i];
//        if([fileDownload.model.hour_id isEqualToString:filemodel.hour_id]){
//            findCount++;
//            findIndex=i;
//        }
//    }
//    
//    if(findCount==1 && findIndex<self.maxConDownloadCount){
//        return FileDownloadStateDownloading;
//    }
//    
//    return FileDownloadStateWaiting;
//}
//
#pragma mark --- Private Method ---

- (BOOL)hasWaitingOperations
{
    return self.currentDownloadCount>self.maxConDownloadCount;
}

- (BOOL)canAddOperationWithoutCancel
{
    return self.maxConDownloadCount>self.currentDownloadCount;
}

- (NSString *)tmpFilePathWithDirectoryPath:(NSString *)directoryPath fileName:(NSString *)fileName
{
    return [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_tmp",fileName]];
}

- (void)removeTmpFileWithPath:(NSString *)tmpFilePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:tmpFilePath]){
        [fileManager removeItemAtPath:tmpFilePath error:nil];
    }
}

- (void)addToDownloadInSuspendArrayWithFileId:(TrainDownloadModel *)filemodel
{
    for(int i=0; i<_suspendDownloadArr.count; i++) {
        TrainDownloader *download = _suspendDownloadArr[i];
        if([download.model.hour_id isEqualToString:filemodel.hour_id]){
            [self addDownloadWithDownLoadModel:filemodel];
            [_suspendDownloadArr removeObject:download];
            download = nil;
            return;
        }
    }
}

- (void)addToDownloadWithFileDownload:(TrainDownloader *)fileDownload
{
    [self addDownloadWithDownLoadModel:fileDownload.model];
}

#pragma mark --- Set & Get ---

- (void)setMaxConDownloadCount:(NSInteger)maxConDownloadCount
{
    _downloadQueue.maxConcurrentOperationCount = maxConDownloadCount;
}

- (NSInteger)maxConDownloadCount
{
    return _downloadQueue.maxConcurrentOperationCount;
}

- (NSInteger)currentDownloadCount
{
    return [_downloadQueue.operations count];
}

#pragma mark --- SCFileDownloadDelegate ---

- (void)fileDownloadStart:(TrainDownloadModel *)downModel hasDownloadComplete:(BOOL)downloadComplete
{
    if(downloadComplete){
        [self fileDownloadFinish:downModel success:YES error:nil];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_delegate && [_delegate respondsToSelector:@selector(fileDownloadManagerStartDownload:)]){
                [_delegate fileDownloadManagerStartDownload:downModel];
            }
        });
    }
}

- (void)fileDownloadReceiveResponse:(TrainDownloadModel *)downModel FileSize:(uint64_t)totalLength
{
    
    downModel.totalSize = totalLength;
    [downModel saveOrUpdateByColumnName:@[@"CHO_id"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(_delegate && [_delegate respondsToSelector:@selector(fileDownloadManagerReceiveResponse:FileSize:)]){
            [_delegate fileDownloadManagerReceiveResponse:downModel FileSize:totalLength];
        }
    });
}

- (void)fileDownloadUpdate:(TrainDownloadModel *)downModel didReceiveData:(uint64_t)receiveLength downloadSpeed:(NSString *)downloadSpeed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.delegate && [self.delegate respondsToSelector:@selector(fileDownloadManagerUpdateProgress:didReceiveData:downloadSpeed:)]){
            [_delegate fileDownloadManagerUpdateProgress:downModel didReceiveData:receiveLength downloadSpeed:downloadSpeed];
        }
    });
}

- (void)fileDownloadFinish:(TrainDownloadModel *)downModel success:(BOOL)downloadSuccess error:(NSError *)error
{
    
    if (downloadSuccess) {
        downModel.status = TrainFileDownloadStateFinish;
    }else{
        downModel.status = TrainFileDownloadStateFail;
    }
    
    [downModel saveOrUpdateByColumnName:@[@"CHO_id"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_delegate && [_delegate respondsToSelector:@selector(fileDownloadManagerFinishDownload:success:error:)]){
            [_delegate fileDownloadManagerFinishDownload:downModel success:downloadSuccess error:error];
        }
    });
    
}



-(BOOL)isExistsFileWith:(TrainDownloadModel *)fileModel{
    
    NSArray *arr = [TrainDownloadModel findWithFormat:@"CHO_id =%@",fileModel.CHO_id];
    if ( ! TrainArrayIsEmpty(arr)) {
        
        TrainDownloadModel *localFile = [arr firstObject];
        NSString *localPath = [NSString stringWithFormat:@"%@%@",learnCachesDirectory,localFile.filePath];
        
        if([TrainFileManager fileExistsAtPath:localPath]){
            [localFile deleteObjectsByColumnName:@[@"CHO_id"]];
            return NO;
        }
        return YES;
    }
    return NO;

}





@end
