//
//  UIViewController+TrainNavigationExtension.m
//  KindeeTrain
//
//  Created by apple on 17/2/13.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import "UIViewController+TrainNavigationExtension.h"

#import <objc/runtime.h>

@implementation UIViewController (TrainNavigationExtension)

- (BOOL)Train_fullScreenPopGestureEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTrain_fullScreenPopGestureEnabled:(BOOL)fullScreenPopGestureEnabled {
    objc_setAssociatedObject(self, @selector(Train_fullScreenPopGestureEnabled), @(fullScreenPopGestureEnabled), OBJC_ASSOCIATION_ASSIGN);
}


-(BOOL)Train_PopGestureEnabled{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)setTrain_PopGestureEnabled:(BOOL)popGestureEnabled{

    objc_setAssociatedObject(self, @selector(Train_PopGestureEnabled), @(popGestureEnabled), OBJC_ASSOCIATION_ASSIGN);

}

- (TrainNavigationController *)Train_navigationController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTrain_navigationController:(TrainNavigationController *)navigationController {
    objc_setAssociatedObject(self, @selector(Train_navigationController), navigationController, OBJC_ASSOCIATION_ASSIGN);
}

@end
