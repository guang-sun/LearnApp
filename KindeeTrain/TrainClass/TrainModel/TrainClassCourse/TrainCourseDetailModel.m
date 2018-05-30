//
//  TrainCourseDetailModel.m
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCourseDetailModel.h"

@implementation TrainCourseDetailModel

@end

//@implementation TrainCourseIntroductionModel
//
//@end


@implementation TrainCourseDirectoryModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"list_id" : @"id",
             @"list_init_file" : @"init_file",
             
             };
}
@end


extern CGFloat maxCourseNoteHei;

@implementation TrainCourseNoteModel

{
    CGFloat _lastNoteContentWidth;
}

-(NSString *)content{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 30;
    if (contentW != _lastNoteContentWidth) {
        _lastNoteContentWidth = contentW;
        CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
        if (textRect.size.height > maxCourseNoteHei) {
            _isShowButton = YES;
        } else {
            _isShowButton = NO;
        }
    }
    
    return _content;
}
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"note_id" : @"id",
             };
}
- (void)setIsOpen:(BOOL)isOpen
{
    if (!_isShowButton) {
        _isOpen = NO;
    } else {
        _isOpen = isOpen;
    }
}


@end



@implementation TrainCourseDiscussModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"discuss_id" : @"id",
             
             };
}
@end

@implementation TrainCourseDiscussListModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"discuss_id" : @"id",
             };
}
@end



extern CGFloat maxAppraiseHeight;

@implementation TrainCourseAppraiseModel

{
    CGFloat _lastContentWidth;
}
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"app_id" : @"id",
             };
}
-(NSString *)content{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 80;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
        if (textRect.size.height > maxAppraiseHeight) {
            _isShowButton = YES;
        } else {
            _isShowButton = NO;
        }
    }
    
    return _content;
}

- (void)setIsOpen:(BOOL)isOpen
{
    if (!_isShowButton) {
        _isOpen = NO;
    } else {
        _isOpen = isOpen;
    }
}

@end
