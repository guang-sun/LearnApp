//
//  TrainDocListModel.m
//  SOHUEhr
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainDocListModel.h"

@implementation TrainDocListModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"doc_id" : @"id",
             };
}

@end
