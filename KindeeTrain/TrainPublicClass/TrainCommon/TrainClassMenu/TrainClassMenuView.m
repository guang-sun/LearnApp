//
//  TrainClassMenuView.m
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainClassMenuView.h"
#import "TrainClassBaseView.h"

@interface TrainClassMenuView ()
{
    NSArray          *topListArr;
    NSMutableArray   *buttonListArr;
    NSArray          *touchArr;
    NSArray          *self_collectArr;
    NSDictionary     *self_tableCollectDic;
    BOOL             self_istable;
    int              touchindex;
    
}
@property(nonatomic,strong)  UIView                 *seplineLab;
@property(nonatomic,strong)  TrainClassBaseView     *treeClassView;

@end

@implementation TrainClassMenuView

-(instancetype)initWithFrame:(CGRect)frame andArr:(NSArray *)arr{
    self =[super initWithFrame:frame];
    if (self) {
        topListArr =arr;
        self_collectArr =[NSArray new];
        self_tableCollectDic =[NSDictionary new];
        self_istable =NO;
        [self creatUI];
        
        
        
    }
    return self;
}

-(TrainClassBaseView *)treeClassView{
    if (!_treeClassView) {
        TrainClassBaseView *tree = [TrainClassBaseView shareManager];
        TrainWeakSelf(self);
        tree.hideClassView = ^(){
            [weakself dismissTopMenu];
        };
        tree.didSelectDic = ^(NSDictionary *dic){
            [weakself classMenuDidSelect:dic];
        };
        
        _treeClassView = tree;
        
    }
    return _treeClassView;
}


-(void)classMenuDidSelect:(NSDictionary  *)dic{
    if (_delegate && [_delegate respondsToSelector:@selector(TrainClassMenuSelectDic:)]) {
        [_delegate TrainClassMenuSelectDic:dic];
        for (UIButton  *topBtn in  buttonListArr) {
            topBtn.selected  =NO;
            [ UIView animateWithDuration:0.3 animations:^{
                topBtn.imageView.transform = CGAffineTransformIdentity;
            }];
            
        }
        [self dissMenu];
    }
    
}


-(UIView *)seplineLab{
    if (_seplineLab ==nil) {
        UIView *line = [[UIView alloc]init];
        line.backgroundColor =TrainMenuSelectColor;
        _seplineLab =line;
        _seplineLab.width =TrainScaleWith6(80);
        [self addSubview:_seplineLab];
    }
    return _seplineLab;
}
-(void)setCollectArr:(NSArray *)collectArr{
    self_collectArr =collectArr;
}
-(void)setTableCollectDic:(NSDictionary *)tableCollectDic{
    self_tableCollectDic =tableCollectDic;
}
-(void)setIstable:(BOOL )istable{
    self_istable =istable;
}
-(void)setSelectIndex:(int)selectIndex{
    for (UIButton  *topBtn in  buttonListArr) {
        if (topBtn.tag == selectIndex+200) {
            topBtn.cusTitleColor =TrainMenuSelectColor;
        }else{
            topBtn.cusTitleColor =[UIColor grayColor];
        }
    }
    touchindex =selectIndex;
    TrainWeakSelf(self);

    [UIView animateWithDuration:0.2 animations:^{
        weakself.seplineLab.centerX = TrainSCREENWIDTH/topListArr.count*(selectIndex)+TrainSCREENWIDTH/topListArr.count/2;
        
    }];
}
-(void)creatUI{
    touchindex = 0;
    
    buttonListArr =[NSMutableArray new];
    int  count =(int )topListArr.count;
    for (int  i =0 ;i<count;i++ ) {
        UIButton  *button =[[UIButton alloc]initCustomButton];
        button.cusTitle =topListArr[i];
        button.cusTitleColor =TrainColorFromRGB16(0x969696);
        button.cusFont =14.0f;
        button.frame =CGRectMake(TrainSCREENWIDTH/count*i, 0, TrainSCREENWIDTH/count, TrainCLASSHEIGHT-1);
        if (i == 0) {
            button.cusTitleColor =TrainMenuSelectColor;
            button.cusFont =14.f;
            
        }
        if ([topListArr[i] isEqualToString:@"分类"]||[topListArr[i] isEqualToString:@"格式"] ||[topListArr[i] isEqualToString:@"类型"]) {
            
            button.image =[UIImage imageNamed:@"Train_Select_down"];
            button.imageEdgeInsets =UIEdgeInsetsMake(0, 30, 0,  -30);
            button.titleEdgeInsets =UIEdgeInsetsMake(0, -15, 0, 15);
            
        }
        button.tag =200+i;
        [button addTarget:self action:@selector(topButtonTouch:)];
        [self addSubview:button];
        
        self.seplineLab.frame =CGRectMake(0, TrainCLASSHEIGHT-2, TrainSCREENWIDTH/count, 1);
        self.seplineLab.width =TrainScaleWith6(70);
        self.seplineLab.centerX =TrainSCREENWIDTH/topListArr.count/2;
        
        [buttonListArr addObject:button];
        
    }
    UIView  *lineV =[[UIView alloc]initWithFrame:CGRectMake(0, TrainCLASSHEIGHT-1, TrainSCREENWIDTH, 1)];
    lineV.backgroundColor =TrainColorFromRGB16(0xE8E8E8);
    [self addSubview:lineV];
    
    
}
-(void)topButtonTouch:(UIButton  *)btn{
    
    
    
    if([[btn currentTitle ] isEqualToString:@"分类"] ||[[btn currentTitle] isEqualToString:@"格式"] ||[[btn currentTitle] isEqualToString:@"类型"]){
        
    }else{
        if (touchindex == btn.tag-200) {
            return;
        }
    }
    
    touchindex =(int)btn.tag-200;
    
    if (_delegate && [_delegate respondsToSelector:@selector(TrainClassMenuSelectIndex:)]) {
        [_delegate TrainClassMenuSelectIndex:(int)btn.tag-200];
    }
    
    
    for (UIButton  *topBtn in  buttonListArr) {
        if (topBtn.tag == btn.tag) {
            
            if([[btn currentTitle ] isEqualToString:@"分类"] ||[[btn currentTitle] isEqualToString:@"格式"] ||[[btn currentTitle] isEqualToString:@"类型"]){
                btn.selected = !btn.selected;
                
                if (btn.selected) {
                    [ UIView animateWithDuration:0.3 animations:^{
                        btn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                    }];
                    [self showMenuArr:self_collectArr dic:self_tableCollectDic istable:self_istable ];
                    
                }else{
                    [self dissMenu];
                    [ UIView animateWithDuration:0.3 animations:^{
                        topBtn.imageView.transform = CGAffineTransformIdentity;
                    }];
                }
                
            }
            topBtn.cusTitleColor =TrainMenuSelectColor;
            
        }else{
            topBtn.cusTitleColor =TrainColorFromRGB16(0x969696);
            if([[btn currentTitle ] isEqualToString:@"分类"] ||[[btn currentTitle] isEqualToString:@"格式"] ||[[btn currentTitle] isEqualToString:@"类型"]){

            }else{
                [self dissMenu];
            }
            
            topBtn.selected =NO;
            [ UIView animateWithDuration:0.3 animations:^{
                topBtn.imageView.transform = CGAffineTransformIdentity;
            }];
            
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.seplineLab.centerX = TrainSCREENWIDTH/topListArr.count*(btn.tag-200)+TrainSCREENWIDTH/topListArr.count/2;
        
        
    }];
    
    
    
    
}
-(void)setCollectSelect:(NSString *)collectSelect{
    self.treeClassView.collectSelectStr =collectSelect;
}
-(void)showMenuArr:(NSArray *)listarr dic:(NSDictionary *)listDic istable:(BOOL)istable{
    
    [self.treeClassView showClass:TrainCLASSHEIGHT andArr:listarr andDic:listDic andistable:istable];
    
}
-(void)dissMenu{
    [self.treeClassView hideClass:0.1];
    self.treeClassView =nil;
}
-(void)resetTopMenu:(NSArray *)newArr{
    
    for (UIView  *view  in self.subviews) {
        [view removeFromSuperview];
    }
    _seplineLab =nil;
    [self dissMenu];
    
    topListArr =newArr;
    [self creatUI];
    
}
-(void)dismissTopMenu{
    [self dissMenu];
    for (UIButton  *button in buttonListArr) {
        button.selected=NO;
        if([[button currentTitle ] isEqualToString:@"分类"] ||[[button currentTitle] isEqualToString:@"格式"] ||[[button currentTitle] isEqualToString:@"类型"]){
            [UIView animateWithDuration:0.3 animations:^{
                button.imageView.transform =CGAffineTransformIdentity;
            }];
        }
        
    }
    
}


@end
