//
//  TrainMessageModel.m
//   KingnoTrain
//
//  Created by apple on 17/1/4.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import "TrainMessageModel.h"

@implementation TrainMessageModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"message_id" : @"id",
             
             };
}
@end
