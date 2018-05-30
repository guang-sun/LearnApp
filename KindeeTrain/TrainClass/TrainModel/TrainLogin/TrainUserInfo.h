//
//  TrainUserInfo.h
//   KingnoTrain
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainBaseModel.h"


@interface TrainUserInfo : TrainBaseModel<NSCoding>

@property(nonatomic,assign) BOOL        isRemember;
@property(nonatomic,assign) BOOL        isLogin;
@property(nonatomic,strong) NSString    *emp_id;
@property(nonatomic,strong) NSString    *msg;
@property(nonatomic,strong) NSString    *photo;
@property(nonatomic,strong) NSString    *full_name;
@property(nonatomic,strong) NSString    *user_id;
@property(nonatomic,strong) NSString    *username;
@property(nonatomic,strong) NSString    *password;
@property(nonatomic,strong) NSString    *site;

+(instancetype)sharedTrainUserInfo;
//读取归档
+(TrainUserInfo*)getEncodeData;
//存入归档
+(void)archVierWithData:(TrainUserInfo*)userinfo;
//重置归档数据
+(void)ResetData:(TrainUserInfo*)data;

@end
