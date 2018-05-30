//
//  TrainLocalLearnRecord.h
//  KindeeTrain
//
//  Created by admin on 2018/5/5.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainBaseModel.h"

@interface TrainLocalLearnRecord : TrainBaseModel
@property (nonatomic, copy) NSString         *c_id; //课程id
@property (nonatomic, copy) NSString         *cw_id; ///培训课程id ==object_id
@property (nonatomic, assign) NSInteger      go_num;//课程学习次数 (只有退出课程算1次，传1 ，其余值保存时间的传0)
@property (nonatomic, assign) NSInteger      last_time; //该课时的最后学习时间
@property (nonatomic, copy) NSString         *lh_id;    //课时id
@property (nonatomic, copy) NSString         *object_id;  //培训课程id
@property (nonatomic, copy) NSString         *s_status;  //课时状态
@property (nonatomic, assign) NSInteger      time;   //课时本次学习时间
@property (nonatomic, copy) NSString         *user_id; //当前学习用户id

@end
