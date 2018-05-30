//
//  TrainHomeCollectionViewCell.h
//   KingnoTrain
//
//  Created by apple on 16/12/2.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainHomeModel.h"

@interface TrainHomeCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) TrainHomeModel  *model;

@property(nonatomic,copy) NSString          *title;
@property(nonatomic,copy) NSString          *image;
@end
