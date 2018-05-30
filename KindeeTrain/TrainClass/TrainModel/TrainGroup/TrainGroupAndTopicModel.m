//
//  TrainGroupAndTopicModel.m
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainGroupAndTopicModel.h"

@implementation TrainGroupAndTopicModel

@end
@implementation TrainGroupModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"group_id" : @"id",
             };
}

@end
@implementation TrainTopicModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{

             @"topic_id" : @"id",
             
             };
}

@end
@implementation TrainTopicCommentModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"comment_id" : @"id",
             };
}
//-(NSDictionary *)objectClassInArray
//
//{
//    
//    return @{@"child_post_list" : [TrainTopicCommentModel class]};
//    
//}
@end
