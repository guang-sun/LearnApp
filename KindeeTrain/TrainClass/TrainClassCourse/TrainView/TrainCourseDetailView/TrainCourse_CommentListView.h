//
//  TrainCourse_CommentListView.h
//  SOHUEhr
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainCourseDetailModel.h"
#import "TrainMacroDefine.h"


typedef  void (^commentLineTouch)(TrainCourseDiscussListModel  *model);
typedef  void (^commentNameTouch)(NSString  *str);

@interface TrainCourse_CommentListView : UIView

@property(nonatomic,copy) commentLineTouch   commentLine;
@property(nonatomic,copy) commentNameTouch   commentName;

- (void)setupWithcommentItemsArray:(NSArray *)commentItemsArray;
@end
