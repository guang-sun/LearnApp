//
//  TrainNewClassModel.m
//  KindeeTrain
//
//  Created by admin on 2018/6/16.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainNewClassModel.h"

@implementation TrainNewClassModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"class_id" : @"id"
             };
}

@end
