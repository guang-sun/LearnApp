//
//  UISegmentedControl+Train.m
//   KingnoTrain
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "UISegmentedControl+Train.h"

@implementation UISegmentedControl (Train)


-(instancetype)initWithTitleItems:(NSArray *)items {
    
    self = [super init];
    if (self) {
        
            self.tintColor =[UIColor whiteColor];
        
            if (items.count > 0) {
            
                [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                    [self insertSegmentWithTitle:obj atIndex: idx animated: NO ];
                }];
            }
            self.layer.borderWidth =1.0f;
            self.layer.borderColor =[UIColor whiteColor].CGColor;
            self.selectedSegmentIndex =0;

    }
    return self;
}



@end
