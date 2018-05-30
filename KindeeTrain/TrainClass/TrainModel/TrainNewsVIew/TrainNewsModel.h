//
//  TrainNewsModel.h
//   KingnoTrain
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import "TrainBaseModel.h"

@interface TrainNewsModel : TrainBaseModel


@property(nonatomic,copy) NSString  *title;
@property(nonatomic,copy) NSString  *send_time;
@property(nonatomic,copy) NSString  *content;
@property(nonatomic,copy) NSString  *attachment_id;
@property(nonatomic,copy) NSString  *news_id;
@property(nonatomic,copy) NSString  *my_message_id;
@property(nonatomic,copy) NSString  *totPage;
@property(nonatomic,copy) NSString       *type;

@end
