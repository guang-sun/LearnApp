//
//  TrainDownloader.h
//   KingnoTrain
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainDownloadModel.h"

#import "TrainDownloadHeader.h"



@protocol TrainFileDownloadDelegate <NSObject>

- (void)fileDownloadStart:(TrainDownloadModel *)download hasDownloadComplete:(BOOL)downloadComplete;
- (void)fileDownloadReceiveResponse:(TrainDownloadModel *)download FileSize:(uint64_t)totalLength;
- (void)fileDownloadUpdate:(TrainDownloadModel *)download didReceiveData:(uint64_t)receiveLength downloadSpeed:(NSString *)downloadSpeed;
- (void)fileDownloadFinish:(TrainDownloadModel *)download success:(BOOL)downloadSuccess error:(NSError *)error;

@end
@interface TrainDownloader : NSOperation

@property (nonatomic, strong) TrainDownloadModel  *model;

@property (assign, nonatomic) id<TrainFileDownloadDelegate>delegate;

- (id)initWithDownLoadModel:(TrainDownloadModel *)downModel delegate:(id<TrainFileDownloadDelegate>)delegate;

- (void)cancelDownloadIfDeleteFile:(BOOL)deleteFile;

@end
