//
//  TrainDownloader.m
//   KingnoTrain
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import "TrainDownloader.h"


/*
 需要手动触发isFinished和isExecuting两个属性的KVO
 注意有的文件下载地址支持断点续传，有的不支持
 cancel方法不会立即执行
 */

const double kBufferSize = 1024.0*1024.0;
const NSTimeInterval kDefaultTimeOut = 60;
const NSTimeInterval kCalculateSpeedTime = 1;

#define ErrorDomain  @"TrainFileDownloadErrorDomain"

typedef NS_ENUM(NSInteger, FileDownloadOperationState){
    FileDownloadOperationStateWaiting = 0,     //加入到队列中，处于等待状态(默认)
    FileDownloadOperationStateExecuting = 1,   //正在执行状态
    FileDownloadOperationStateFinished = 2,    //已经完成状态
};



@interface TrainDownloader ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    uint64_t _receivedDataLength;       //目前下载到的数据量
    uint64_t _expectedDataLength;       //文件期望的数据总量
    uint64_t _localFileDataLength;      //本地文件的数据量
    //    uint64_t _timerReceivedDataLength;  //用于计算下载速度
}

//@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSURL *downloadURL;
@property (strong, nonatomic) NSString *tempFileName;
//@property (strong, nonatomic) NSString *downloadSpeed;
@property (strong, nonatomic) NSFileHandle *fileHandle;
@property (strong, nonatomic) NSURLConnection *urlConnetion;
@property (strong, nonatomic) NSMutableData *receivedDataBuffer;
@property (copy, nonatomic)   NSString *directoryPath;    //文件所在文件夹路径
@property (assign, nonatomic) FileDownloadOperationState operationState;

@end

@implementation TrainDownloader

- (id)initWithDownLoadModel:(TrainDownloadModel *)downModel delegate:(id<TrainFileDownloadDelegate>)delegate{
    if(self = [super init]){
        
        self.delegate = delegate;
        self.model = downModel;
        self.model.filePath = learnCachesDirectory;
        self.model.saveFileName = [NSString  stringWithFormat:@"%@.mp4",trainMd5String(self.model.hourName)];
        self.operationState = FileDownloadOperationStateWaiting;
        self.directoryPath = learnCachesDirectory;
        self.tempFileName = [NSString stringWithFormat:@"%@_tmp",self.model.saveFileName];
        self.downloadURL = [NSURL URLWithString:self.model.url];
        
    }
    return self;
}

#pragma mark --- Override Method ---

- (void)main
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:[self finishFilePath]]){
        
        
        if (self.model.status != TrainFileDownloadStateFinish) {
            self.model.status = TrainFileDownloadStateFinish;
            
            NSString  *tmpPath = [learnCachesDirectory  stringByAppendingPathComponent:self.model.saveFileName];
            unsigned long long   size = [[[NSFileManager defaultManager] attributesOfItemAtPath:tmpPath error:nil] fileSize];
            
            self.model.totalSize = [NSString stringWithFormat:@"%llu",size];

        }
        if(_delegate && [_delegate respondsToSelector:@selector(fileDownloadStart:hasDownloadComplete:)]){
            [_delegate fileDownloadStart:self.model hasDownloadComplete:YES];
        }
        [self finishWithUnStart];
    }
    else{
        if(_delegate && [_delegate respondsToSelector:@selector(fileDownloadStart:hasDownloadComplete:)]){
            [_delegate fileDownloadStart:self.model hasDownloadComplete:NO];
        }
        NSMutableURLRequest *fileRequest = [[NSMutableURLRequest alloc] initWithURL:_downloadURL];
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:fileRequest];
        if(![NSURLConnection canHandleRequest:fileRequest]){
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Invalid URL %@",_downloadURL.path]};
            NSError *error = [[NSError alloc] initWithDomain:ErrorDomain code:1 userInfo:userInfo];
            if(_delegate && [_delegate respondsToSelector:@selector(fileDownloadFinish:success:error:)]){
                [_delegate fileDownloadFinish:self.model success:NO error:error];
            }
            [self finishWithUnStart];
        }
        else{
            if(![fileManager fileExistsAtPath:self.directoryPath]){
                [fileManager createDirectoryAtPath:self.directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if(![fileManager fileExistsAtPath:[self filePath]]){
                [fileManager createFileAtPath:[self filePath] contents:nil attributes:nil];
            }
            else{
                _localFileDataLength = [[fileManager attributesOfItemAtPath:[self filePath] error:nil] fileSize];
                NSString *range = [NSString stringWithFormat:@"bytes=%lld-",_localFileDataLength];
                [fileRequest setValue:range forHTTPHeaderField:@"Range"];
            }
            _fileHandle = [NSFileHandle fileHandleForWritingAtPath:[self filePath]];
            [_fileHandle seekToEndOfFile];
            _receivedDataBuffer = [[NSMutableData alloc] init];
            _urlConnetion = [[NSURLConnection alloc] initWithRequest:fileRequest delegate:self startImmediately:NO];
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            [_urlConnetion scheduleInRunLoop:runLoop forMode:NSDefaultRunLoopMode];
            [_urlConnetion start];
            [runLoop run];
        }
    }
}

- (void)start
{
    if(self.isCancelled){
        [self finishWithUnStart];
    }
    else{
        [self willChangeValueForKey:@"isExecuting"];
        [self performSelector:@selector(main)];
        self.operationState = FileDownloadOperationStateExecuting;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (BOOL)isExecuting
{
    return self.operationState == FileDownloadOperationStateExecuting;
}

- (BOOL)isFinished
{
    return self.operationState == FileDownloadOperationStateFinished;
}

- (BOOL)isAsynchronous
{
    return YES;
}

#pragma mark --- NSURLConnectionDataDelegate ---

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSError *error = nil;
    _expectedDataLength = [response expectedContentLength]+_localFileDataLength;
    self.model.status = TrainFileDownloadStateDownloading;
//    self.model.totalSize = [NSString stringWithFormat:@"%llu",_expectedDataLength];
//    self.model.progress = @"0";

    NSHTTPURLResponse *httpUrlResponse = (NSHTTPURLResponse *)response;
    if(httpUrlResponse.statusCode>=400){
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"HTTP error code %ld (%@)",httpUrlResponse.statusCode,[NSHTTPURLResponse localizedStringForStatusCode:httpUrlResponse.statusCode]]};
        error = [[NSError alloc] initWithDomain:ErrorDomain code:2 userInfo:userInfo];
    }
    //_expectedDataLength=-1代表暂时不知道文件大小，只能下下来才能确定
    if([self freeDiskSpace]<_expectedDataLength && _expectedDataLength!=-1){
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"Not enough free disk space"};
        error = [[NSError alloc] initWithDomain:ErrorDomain code:3 userInfo:userInfo];
    }
    if(!error){
        _receivedDataLength = _localFileDataLength;
        self.receivedDataBuffer = [[NSMutableData alloc] init];
        if(_delegate && [_delegate respondsToSelector:@selector(fileDownloadReceiveResponse:FileSize:)]){
            [_delegate fileDownloadReceiveResponse:self.model FileSize:_expectedDataLength];
        }
    }
    else{
        if(_delegate && [_delegate respondsToSelector:@selector(fileDownloadFinish:success:error:)]){
            [_delegate fileDownloadFinish:self.model success:NO error:error];
        }
        [self cancelDownloadIfDeleteFile:NO];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedDataBuffer appendData:data];
    _receivedDataLength += data.length;
    float   progress = 0.0;
    if (_expectedDataLength > 0) {
        progress = (float)_receivedDataLength * 1.0/(float)_expectedDataLength ;
        self.model.progress =progress;
        [self.model  updateObjectsByColumnName:@[@"CHO_id"]];
        NSLog(@"---progress-%.2f",progress);
    }
    
    if(self.receivedDataBuffer.length>kBufferSize && _fileHandle){
        [_fileHandle writeData:self.receivedDataBuffer];
        self.receivedDataBuffer = [[NSMutableData alloc] init];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(fileDownloadUpdate:didReceiveData:downloadSpeed:)]){
        [_delegate fileDownloadUpdate:self.model didReceiveData:_receivedDataLength downloadSpeed:@"0"];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self changeToRealFileName];
    [self saveReceivedDataBuffer];
    [self finishOperation];
    self.model.status = TrainFileDownloadStateFinish;
    if(_delegate && [_delegate respondsToSelector:@selector(fileDownloadFinish:success:error:)]){
        [_delegate fileDownloadFinish:self.model success:YES error:nil];
    }
}

#pragma mark --- NSURLConnectionDelegate ---

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //如果是因为无网络先不结束这个线程，状态显示搜索网络，这样只会影响这一个
    [self saveReceivedDataBuffer];
    [self finishOperation];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Download fail with reason %@",error.localizedDescription]};
    NSError *downloadError = [[NSError alloc] initWithDomain:ErrorDomain code:4 userInfo:userInfo];
    if(_delegate && [_delegate respondsToSelector:@selector(fileDownloadFinish:success:error:)]){
        [_delegate fileDownloadFinish:self.model success:NO error:downloadError];
    }
}

#pragma mark --- Public Method ---

- (void)cancelDownloadIfDeleteFile:(BOOL)deleteFile
{
    if(!deleteFile){
        [self saveReceivedDataBuffer];
    }
    [self finishOperation];
}

#pragma mark --- Private Method ---

//获取磁盘剩余空间
- (uint64_t)freeDiskSpace
{
    uint64_t totalFreeSpace = 0;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *dictionary = [fileManager attributesOfFileSystemForPath:docPath error:nil];
    if(dictionary){
        totalFreeSpace = [dictionary[NSFileSystemFreeSize] unsignedLongLongValue];
    }
    return totalFreeSpace;
}

//未开始就取消
- (void)finishWithUnStart
{
    [self willChangeValueForKey:@"isFinished"];
    self.operationState = FileDownloadOperationStateFinished;
    [self didChangeValueForKey:@"isFinished"];
}

//完成或者取消
- (void)finishOperation
{
    //    if(_timer){
    //        [_timer invalidate];
    //        _timer = nil;
    //    }
    [_urlConnetion cancel];
    [_fileHandle closeFile];
    _fileHandle = nil;
    _urlConnetion = nil;
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.operationState = FileDownloadOperationStateFinished;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

//存储已经下载的数据
- (void)saveReceivedDataBuffer
{
    if(self.receivedDataBuffer.length>0 && _fileHandle){
        [_fileHandle writeData:self.receivedDataBuffer];
        self.receivedDataBuffer = [[NSMutableData alloc] init];
    }
}

////计算网速
//- (void)calculateDownloadSpeed
//{
//    float downloadSpeed = (float)_timerReceivedDataLength/1024.0/kCalculateSpeedTime;
//    if(downloadSpeed>=1024.0){
//        downloadSpeed /= 1024.0;
//        self.downloadSpeed = [NSString stringWithFormat:@"%.1fMB/s",downloadSpeed];
//    }
//    else{
//        self.downloadSpeed = [NSString stringWithFormat:@"%.1fKB/s",downloadSpeed];
//    }
//    _timerReceivedDataLength = 0;
//}

//完成了改成真正想要存储的名字
- (void)changeToRealFileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:[self filePath] isDirectory:NULL]){
        [fileManager moveItemAtPath:[self filePath] toPath:[self finishFilePath] error:NULL];
    }
}

//文件夹和临时文件拼接后的路径
- (NSString *)filePath
{
    return [self.directoryPath stringByAppendingPathComponent:self.tempFileName];
}

//文件夹和文件拼接后的路径
- (NSString *)finishFilePath
{
    return [self.directoryPath stringByAppendingPathComponent:self.model.saveFileName];
}




@end
