//
//  TrainDBHelper.h
//   KingnoTrain
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface TrainDBHelper : NSObject
@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (TrainDBHelper *)shareInstance;

+ (NSString *)dbPath;

@end
