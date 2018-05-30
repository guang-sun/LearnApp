
//  TrainUserInfo.m
//   KingnoTrain
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainUserInfo.h"

@implementation TrainUserInfo

MJCodingImplementation

TrainSimpleM(TrainUserInfo)

-(id)init{
    
    self=[super init];
    if(self){
        
//        self = [TrainUserInfo getEncodeData];
        
        NSData  *data =[TrainUserDefault objectForKey:TrainLoginRemember];
        if (data.length > 0) {
            
            self = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
        }else {
            
            self.emp_id = @"";
            self.photo = @"";
            self.msg = @"";
            self.full_name = @"";
            self.user_id = @"";
            self.username = @"";
            self.password = @"";
            self.site = @"";

        }
    }
    return self;
}


//读取归档
+(TrainUserInfo*)getEncodeData{
    
    
    NSData  *data =[TrainUserDefault objectForKey:TrainLoginRemember];
    if (data.length > 0) {
        
        TrainUserInfo *userInfo = nil;
        userInfo= [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        return userInfo;
    }else{
        TrainUserInfo *userInfo = [TrainUserInfo sharedTrainUserInfo];
        return userInfo;
    }
    
    }

//存入归档
+(void)archVierWithData:(TrainUserInfo *)userinfo{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userinfo];
        [TrainUserDefault setObject:data forKey:TrainLoginRemember];
        [TrainUserDefault synchronize];
    });
   
    
}



//重置归档数据
+(void)ResetData:(TrainUserInfo *)data{
    
    if ( !data.isRemember) {
//        data.isRemember = NO;
//        data.emp_id     = @"";
//        data.msg        = @"";
//        data.photo      = @"";
//        data.full_name  = @"";
//        data.user_id    = @"";
//        data.username   = @"";
//        data.site       = @"";
        data.password   = @"";

    }
    data.isLogin    = NO;
    
    [TrainUserInfo archVierWithData:data];
}

//FIXME: 读存档 添加个人资料
//打开序列化文档


@end
