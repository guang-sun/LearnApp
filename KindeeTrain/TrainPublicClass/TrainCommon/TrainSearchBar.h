//
//  TrainSearchBar.h
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TrainSearchBarStyleDefault,
    TrainSearchBarStyleProminent,
    TrainSearchBarStyleMinimal
}TrainSearchBarStyle;

@interface TrainSearchBar : UISearchBar

@property(nonatomic,assign)  TrainSearchBarStyle    trainSearchBarStyle;

@property(nonatomic,strong)  UIColor                 *textfileBackgroupColor;

@property(nonatomic,strong)  NSString                *customPlaceholder;

@property(nonatomic,assign)  float                   textfileRadius;

@property(nonatomic,strong)  UIColor                 *searchBackgroupColor;


@end
