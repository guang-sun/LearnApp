//
//  TrainIntegralMoel.h
//   KingnoTrain
//
//  Created by apple on 16/12/6.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainBaseModel.h"

@interface TrainIntegralMoel : TrainBaseModel



@property(nonatomic,copy) NSString *create_date ;           //创建时间
@property(nonatomic,copy) NSString *rule_explain;           //规则说明
@property(nonatomic,copy) NSString *rule_key;               //规则key
@property(nonatomic,copy) NSString *score;                  //积分
@property(nonatomic,copy) NSString *totPage;
@property(nonatomic,copy) NSString *user_id;

@end
@interface TrainIntegarlRuleModel : TrainBaseModel



@property(nonatomic,copy) NSString *rule;           //规则： unlimited 不限制，limit限制， onlyonce 仅一次， everyday 每天， everyweek 每周， everymonth 每月， everyyear 每年
@property(nonatomic,copy) NSString *rule_frequency; //规则对应获得积分次数
@property(nonatomic,copy) NSString *rule_is_use;    //规则是否被使用 0未使用 1已使用
@property(nonatomic,copy) NSString *rule_is_valid;  //规则是否有效
@property(nonatomic,copy) NSString *rule_name;      //规则名称
@property(nonatomic,copy) NSString *rule_score;     //规则分数
@property(nonatomic,copy) NSString *rule_type;      //规则类型：奖励 up, 扣除 down



@end

@interface TrainIntegarlLevelModel : TrainBaseModel



@property(nonatomic,copy) NSString *curPage;
@property(nonatomic,copy) NSString *end;
@property(nonatomic,copy) NSString *goPage;
@property(nonatomic,copy) NSString *level_id;       //积分id
@property(nonatomic,copy) NSString *level_name;     //积分等级名称
@property(nonatomic,copy) NSString *level_num;      //积分等级
@property(nonatomic,copy) NSString *level_remark;   //积分等级备注
@property(nonatomic,copy) NSString *level_score;    //积分等级对应分数
@property(nonatomic,copy) NSString *pageSize;
@property(nonatomic,copy) NSString *start;
@property(nonatomic,copy) NSString *totCount;
@property(nonatomic,copy) NSString *totPage;





@end
