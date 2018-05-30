//
//  TrainClassBaseView.h
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainClassBaseView : UIView

@property(nonatomic,copy) NSString      *collectSelectStr;
@property(nonatomic,copy)   void        (^hideClassView)();
@property(nonatomic,copy) void          (^didSelectDic)(NSDictionary *dic);
+(id)shareManager;


-(void)showClass:(float)height andArr:(NSArray *)arr andDic:(NSDictionary *)dic andistable:(BOOL)isTable;
-(void)andArr:(NSArray *)arr andDic:(NSDictionary *)dic andistable:(BOOL)isTable;
-(void)hideClass:(float)animate;


@end
