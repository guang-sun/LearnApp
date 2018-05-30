//
//  TrainClassBaseView.m
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainClassBaseView.h"

#import "TrainClassListView.h"


@interface TrainClassBaseView ()

@property(nonatomic,strong) TrainClassListView *listView;

@end

@implementation TrainClassBaseView

+(TrainClassBaseView *)shareManager{
    static  TrainClassBaseView  *baseView;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        baseView =[[TrainClassBaseView alloc]init];
    });
    return baseView;
}

-(void)showClass:(float)height andArr:(NSArray *)arr andDic:(NSDictionary *)dic andistable:(BOOL)isTable{
    
    UIWindow  *keywindow =[UIApplication sharedApplication].keyWindow;
    
    self.listView.frame =CGRectMake(0, 64+height, TrainSCREENWIDTH, TrainSCREENHEIGHT-64-height);
    [keywindow addSubview: self.listView];
    
    __strong  typeof(_hideClassView)Stronghide =_hideClassView;
    __strong  typeof(_didSelectDic)StrongSelect =_didSelectDic;
    self.listView.hideView = ^(){
        if (Stronghide) {
            Stronghide();
        }
    };
    self.listView.classDidselect = ^(NSDictionary  *dic){
        if (StrongSelect) {
            StrongSelect(dic);
        }
        
    };
    
    [self andArr:arr andDic:dic andistable:isTable];
    
    
}

-(TrainClassListView *)listView{
    if ( _listView == nil) {
        TrainClassListView  *classView = [[TrainClassListView alloc]init];
        classView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
        _listView = classView;
    }
    return _listView;
}

-(void)andArr:(NSArray *)arr andDic:(NSDictionary *)dic andistable:(BOOL)isTable{
    self.listView.listArr  =arr;
    self.listView.listDic =dic;
    self.listView.ishidetable =isTable;
}
-(void)setCollectSelectStr:(NSString *)collectSelectStr{
    if (collectSelectStr==nil || [collectSelectStr isEqualToString:@""]) {
        collectSelectStr =@"全部";
    }
    self.listView.collectSelect =collectSelectStr;
}
-(void)hideClass:(float)animate{
    
    [UIView animateWithDuration:animate animations:^{
        
        self.listView.classTableView.height =1;
        self.listView.classCollectionView.height=1;
        
    } completion:^(BOOL finished) {
        [self.listView removeFromSuperview];
        self.listView = nil;
    }];
}

//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [self hideClass:0.3];
//    
//}

@end
