//
//  TrainLocalData.h
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainLocalData : NSObject


+(NSDictionary *)returnMainDic;
+(NSArray *)returnMainMenuArr;
+(NSArray  *)returnMainArr;
/**
 课程  菜单数组
 */
+(NSArray *)returnCourseClassMenu;
/**
 课程  菜单类型数组
 */
+(NSArray *)returnCourseChooseClass;

/**
 文库  格式菜单数组
 */
+(NSArray *)returnChooseDocClass;
/**
 文库  菜单数组
 */
+(NSArray *)returnDocClassMenu;



/**
 文库  文库格式图片 name
 */

+(NSString *)returnDocImage:(NSString *)str;


/**
 课程的菜单
 */
+(NSArray *)returnCourseDetailMenu;

/**
 班级课程的菜单
 */
+(NSArray *)returnClassDetailMenu;


@end
