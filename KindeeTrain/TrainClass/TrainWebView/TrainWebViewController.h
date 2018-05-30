//
//  TrainWebViewController.h
//   KingnoTrain
//
//  Created by apple on 16/12/2.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainBaseViewController.h"

@interface TrainWebViewController : TrainBaseViewController

@property(nonatomic,copy) NSString      *webURL;
@property(nonatomic,copy) NSString      *hourtype;
@property(nonatomic,copy) NSString      *navTitle;
@property(nonatomic,assign) BOOL        isCourse;
@property(nonatomic,copy) void      (^updataHourStatus)(NSString *status,NSString *score,NSString *exam_time);
@end
