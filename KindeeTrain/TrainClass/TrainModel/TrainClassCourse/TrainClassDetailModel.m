//
//  TrainClassUserModel.m
//   KingnoTrain
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainClassDetailModel.h"

@implementation TrainClassDetailModel


@end

@implementation TrainClassUserModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"Detali_id" : @"id",
             
             };
}

@end



@implementation TrainClassCourseModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ClassCourse_id" : @"id",
             
             };
}
@end




extern CGFloat maxClassHeight;
@implementation TraingailanDatelisModel
{
    CGFloat _lastContentWidth;
}

-(NSString *)content{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 30;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:TrainTitleFont]} context:nil];
        if (textRect.size.height > maxClassHeight) {
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
