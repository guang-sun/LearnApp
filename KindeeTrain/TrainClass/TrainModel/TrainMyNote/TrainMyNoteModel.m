//
//  TrainMyNoteModel.m
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainMyNoteModel.h"

extern CGFloat maxMyNoteHeight;


@implementation TrainMyNoteModel

{
    CGFloat _lastContentWidth;
}

-(NSString *)content{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 30;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
        if (textRect.size.height > maxMyNoteHeight) {
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
