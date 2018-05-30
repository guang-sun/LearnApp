//
//  TrainSearchBar.m
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainSearchBar.h"
#import "TrainMacroDefine.h"

@interface TrainSearchBar ()

@end

@implementation TrainSearchBar

-(instancetype)initWithFrame:(CGRect)frame{
    
    self =[super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.trainSearchBarStyle    = TrainSearchBarStyleDefault;
        self.customPlaceholder      = @"";
        self.tintColor              = [UIColor blueColor];
    }
    return self;
}


//-(void)creatUI{
//    
//   
//}
-(void)setTrainSearchBarStyle:(TrainSearchBarStyle)TrainSearchBarStyle{
    switch (TrainSearchBarStyle) {
        case TrainSearchBarStyleDefault:
            self.searchBarStyle =UISearchBarStyleDefault;
            break;
        case TrainSearchBarStyleMinimal:
            self.searchBarStyle =UISearchBarStyleMinimal;
            break;
        case TrainSearchBarStyleProminent:
            self.searchBarStyle =UISearchBarStyleProminent;
            break;
            
        default:
            break;
    }
}
-(void)setCustomPlaceholder:(NSString *)customPlaceholder{
    self.placeholder =customPlaceholder;
    
}
-(void)setSearchBackgroupColor:(UIColor *)searchBackgroupColor{
    if ([self respondsToSelector:@selector(barTintColor)]) {
        if (TrainIOS7)
        {
            [[[[self.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [self setBackgroundColor:searchBackgroupColor];
        }
        else
        {
//            [self setBarTintColor:searchBackgroupColor];
            [self setBackgroundColor:searchBackgroupColor];
        }
    }
    else
    {
        [[self.subviews objectAtIndex:0] removeFromSuperview];
        [self setBackgroundColor:searchBackgroupColor];
    }
    
}

-(void)setTextfileBackgroupColor:(UIColor *)textfileBackgroupColor{
    
    UIView *searchTextField = nil;
    if (TrainIOS7)
    {
        // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
        self.barTintColor = [UIColor whiteColor];
        searchTextField = [[[self.subviews firstObject] subviews] lastObject];
    } else
    { // iOS6以下版本searchBar内部子视图的结构不一样
        for (UIView *subView in self.subviews)
        {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
            {
                searchTextField = subView;
            }
        }
    }
    searchTextField.tintColor =[UIColor blackColor];
    searchTextField.backgroundColor = textfileBackgroupColor;
}
-(void)setTextfileRadius:(float)textfileRadius{
    UIView *searchTextField = nil;
    if (TrainIOS7)
    {
        self.barTintColor = [UIColor whiteColor];
        searchTextField = [[[self.subviews firstObject] subviews] lastObject];
    } else
    {
        for (UIView *subView in self.subviews)
        {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
            {
                searchTextField = subView;
            }
        }
    }
    searchTextField.layer.borderWidth =1.0f;
    searchTextField.layer.borderColor =[UIColor whiteColor].CGColor;
    searchTextField.layer.masksToBounds =YES;
    searchTextField.layer.cornerRadius =textfileRadius;
    
    
}

@end
