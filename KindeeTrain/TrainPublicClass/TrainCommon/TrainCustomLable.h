//
//  TrainCustomLable.h
//   KingnoTrain
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年  Kingno. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TrainVerticalAlignmentTop = 0, // default
    TrainVerticalAlignmentMiddle,
    TrainVerticalAlignmentBottom,
} TrainVerticalAlignment;


@interface TrainCustomLable : UILabel

@property (nonatomic,assign)  TrainVerticalAlignment verticalAlignment;

@end
