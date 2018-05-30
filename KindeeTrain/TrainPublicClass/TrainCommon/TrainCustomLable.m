//
//  TrainCustomLable.m
//   KingnoTrain
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import "TrainCustomLable.h"

@implementation TrainCustomLable


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = TrainVerticalAlignmentMiddle;
    }
    return self;
}

- (void)setVerticalAlignment:(TrainVerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case TrainVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case TrainVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case TrainVerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}


@end
