//
//  TrainMovieDetailDelegate.h
//  KindeeTrain
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#ifndef TrainMovieDetailDelegate_h
#define TrainMovieDetailDelegate_h

#import "TrainCourseDetailModel.h"

@protocol TrainMovieDetailDelegate <NSObject>

// 主要是 课程详情目录 点击 课时时 更换movie;
-(void)WMTableviewSelect:(TrainCourseDirectoryModel *)hourModel;

//-(void)WMTableCommentSelectWith:(BOOL)isbecomeResponder;

// 获取在滑动停止时 scroll 的偏移
-(void)scrollDidScrollStop:(CGFloat)off_y ;




@end


#endif /* TrainMovieDetailDelegate_h */
