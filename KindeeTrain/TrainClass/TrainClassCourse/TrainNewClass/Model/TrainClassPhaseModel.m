//
//  TrainClassPhaseModel.m
//  KindeeTrain
//
//  Created by admin on 2018/6/18.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainClassPhaseModel.h"

@implementation TrainClassPhaseModel

@end



@implementation TrainClassResModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"res_id":@"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"attemptList" :[TrainClassExamModel class]
             };
}

+ (NSArray *)mj_ignoredPropertyNames {
    
    return @[@"resList",@"isOpen"];
}

@end

@implementation TrainClassExamModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"record_id":@"id"
             };
}



@end
