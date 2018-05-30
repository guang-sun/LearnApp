//
//  TrainClassListView.m
//  SOHUEhr
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainClassListView.h"
#import "TrainClassMenuCollectionViewCell.h"

#define CLASSWIDTH        self.frame.size.width
#define CLASSHEIGHT       (self.frame.size.height *0.7)
#define  COLLECTIONHEADER   @"COLLECTIONHEADER"
#define  COLLECTIONFOOTER   @"COLLECTIONFOOTER"
#define  COLLECTHEADERHEIGHT    40

@interface TrainClassListView ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray           *classDateList;
    NSDictionary      *classDateDic;
    NSArray           *collectHeadArr;
    NSArray           *collectCellArr;
    BOOL              isTableView;
    int               tableRow;
    NSString          *collectionCell;
    
    BOOL              isFirst;
}



@end

@implementation TrainClassListView

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self creatUI];
//        self.frame.size.height*TrainScale;
    }
    return self;
    
}
-(id)initWithFrame:(CGRect)frame WithArrar:(NSArray *)arr andDic:(NSDictionary *)dic andistable:(BOOL)istable{
    self =[super initWithFrame:frame];
    if (self) {

        classDateList = arr;
        classDateDic  = dic;
        isTableView =istable;
        _collectSelect =@"全部";
        [self creatUI];
    }
    return self;
}
-(void)setListArr:(NSArray *)listArr{
    classDateList =listArr;
    [_classTableView reloadData];
}
-(void)setListDic:(NSDictionary *)listDic{
    classDateDic =listDic;
    [_classCollectionView reloadData];
}
-(void)setIshidetable:(BOOL)ishidetable{
    isTableView =ishidetable;
    if (ishidetable) {
        if (!_classTableView) {
            [_classCollectionView removeFromSuperview];
            [self creatUI];
        }
    }else{
        [_classCollectionView removeFromSuperview];
        [_classTableView removeFromSuperview];
        _classTableView =nil;
        [self creatUI];
        
    }
}


-(void)creatUI{
    tableRow =0;
    isFirst =YES;
    collectionCell =@"CollectionCell";
    collectHeadArr =[NSArray  array];
    if (isTableView) {
        _classTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CLASSWIDTH/3, 0) style:UITableViewStylePlain];
        _classTableView.delegate =self;
        _classTableView.dataSource =self;
        _classTableView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        [_classTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _classTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _classTableView.tableFooterView =[[UIView alloc]init];
        [self addSubview:_classTableView];
        
    }
    
    UICollectionViewFlowLayout  *layout =[[UICollectionViewFlowLayout alloc]init];
    //    layout.itemSize = CGSizeMake(CLASSWIDTH/3-10, 30);
    if (isTableView) {
        layout.headerReferenceSize =CGSizeMake(CLASSWIDTH, COLLECTHEADERHEIGHT);
    }else{
        layout.headerReferenceSize =CGSizeMake(CLASSWIDTH, 25);
        layout.minimumLineSpacing = 25;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
    }
    
    layout.footerReferenceSize =CGSizeMake(CLASSWIDTH, 0.1);
    //    layout.sectionInset = UIEdgeInsetsMake(10, 5, 5, 5);
    layout.minimumInteritemSpacing =0;
    
    CGRect frame =isTableView?CGRectMake(CLASSWIDTH/3, 0, CLASSWIDTH/3*2, 0):CGRectMake(0, 0, CLASSWIDTH, 0);
    _classCollectionView =[[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    _classCollectionView.delegate =self;
    _classCollectionView.dataSource =self;
    _classCollectionView.backgroundColor =[UIColor whiteColor];
    [self addSubview:_classCollectionView];
    [_classCollectionView registerClass:[TrainClassMenuCollectionViewCell class] forCellWithReuseIdentifier:collectionCell];
    [_classCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:COLLECTIONHEADER];
    [_classCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:COLLECTIONFOOTER];
    
    [UIView animateWithDuration:0.3f animations:^{
        _classTableView.height  = CLASSHEIGHT;
        float hei ;
        if (isTableView) {
            hei =CLASSHEIGHT;
        }else{
            hei =(classDateList.count>4)?150:100;
        }
        _classCollectionView.height = hei;
    }];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return classDateList.count?classDateList.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    for (UIView  *view  in  cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (isFirst) {
        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [tableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:tableView didSelectRowAtIndexPath:firstPath];
        
    }
    UIView  *view =[[UIView alloc]initWithFrame:cell.bounds];
    view.backgroundColor =[UIColor whiteColor];
    UIView   *leftV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 2,44)];
    leftV.backgroundColor =TrainMenuSelectColor;
    [view addSubview:leftV];
    cell.selectedBackgroundView=view;
    cell.backgroundColor =TrainColorFromRGB16(0xF0F0F0);
    NSDictionary  *celldic =classDateList[indexPath.row];
    UILabel *name =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CLASSWIDTH/3, 44)];
    name.text = celldic[@"name"];
    name.highlightedTextColor =TrainMenuSelectColor;
    name.textColor =[UIColor blackColor];
    name.cusFont =14.f;
    name.textAlignment =NSTextAlignmentCenter;
    [cell.contentView addSubview:name];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 43,CLASSWIDTH/3 , 1)];
    lineV.backgroundColor =TrainLineColor;
    [cell.contentView addSubview:lineV];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    isFirst =NO;
    collectionCell =[NSString stringWithFormat:@"CollectionCell%zi",indexPath.row];
    [_classCollectionView registerClass:[TrainClassMenuCollectionViewCell class] forCellWithReuseIdentifier:collectionCell];
    tableRow =(int)indexPath.row;
    NSString *tableStr =classDateList[indexPath.row][@"name"];
    collectHeadArr =classDateDic[tableStr];
    if(indexPath.row ==0){
        NSDictionary  *dic =classDateList[indexPath.row];
        if (_classDidselect) {
            _classDidselect(dic);
        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:MENUTOUCHNOTI object:dic];
    }
    //    NSLog(@"%zi",indexPath.row);
    //    NSLog(@"%@",classDateList[indexPath.row]);
    
    
    
    [_classCollectionView reloadData];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (!isTableView) {
        return 1;
    }
    
    return collectHeadArr?collectHeadArr.count:0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!isTableView) {
        return classDateList?classDateList.count:0;
    }
    //    NSArray   *classList =[classDic allKeys];
    NSDictionary  *dic =collectHeadArr[section];
    NSString  *sectionStr =dic[@"name"];
    NSArray  *arr =classDateDic[sectionStr];
    return arr?arr.count:0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(isTableView){
        return CGSizeMake(CLASSWIDTH/9*2-3, 30);
    }
    
    return CGSizeMake(CLASSWIDTH/5, 30);
}
-(void)setCollectSelect:(NSString *)collectSelect{
    _collectSelect =collectSelect;
    [_classCollectionView reloadData];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TrainClassMenuCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    
    NSArray  *arr  ;
    if (isTableView) {
        NSDictionary  *dic =collectHeadArr[indexPath.section];
        NSString  *sectionStr =dic[@"name"];
        arr =classDateDic[sectionStr];
        
    }else{
        arr =classDateList;
    }
    cell.istable =isTableView;
    if (!isTableView) {
        cell.title =arr[indexPath.row];
        
        if ([arr[indexPath.row] isEqualToString:_collectSelect]) {
            cell.titleColor = TrainMenuSelectColor;
            cell.cusborderColor= TrainMenuSelectColor;
//            cell.labbackgroup = TrainLineColor1;
        }
    }else{
        NSDictionary  *dic=arr[indexPath.row];
        cell.title =dic[@"name"];
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSArray  *arr;
    NSDictionary *postDic;
    if (isTableView) {
        NSDictionary  *dic =collectHeadArr[indexPath.section];
        NSString  *sectionStr =dic[@"name"];
        NSArray  *arr =classDateDic[sectionStr];
        postDic =arr[indexPath.row];
        
    }else{
        
        NSString  *str =(![classDateList[indexPath.row] isEqualToString:@"IMG"])?classDateList[indexPath.row]:@"JPG";
        postDic =[NSDictionary dictionaryWithObjectsAndKeys:str,@"name", nil];
    }
    if (_classDidselect) {
        _classDidselect(postDic);
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:MENUTOUCHNOTI object:postDic];
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:COLLECTIONHEADER forIndexPath:indexPath];
        for (UIView  *view  in  headerView.subviews) {
            [view removeFromSuperview];
        }
        if (isTableView) {
            UILabel  *view =[[UILabel alloc]initWithFrame:CGRectMake(15, 0, CLASSWIDTH, COLLECTHEADERHEIGHT)];
            view.backgroundColor =[UIColor whiteColor];
            //            NSArray   *classList =[classDic allKeys];
            NSDictionary *dic =collectHeadArr[indexPath.section];
            view.text =dic[@"name"];
            view.cusFont =14.f;
            view.userInteractionEnabled =YES;
            view.tag =indexPath.section;
            view.textColor =TrainTitleColor;
            [headerView addSubview:view];
            UITapGestureRecognizer  *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectionHeaderTap:)];
            [view addGestureRecognizer:tap];
            
            UIView  *lineView = [[UIView alloc]initWithLineView];
            lineView.frame = CGRectMake(15, COLLECTHEADERHEIGHT-1, CLASSWIDTH * 2 /3 -30, 1);
            [headerView addSubview:lineView];
            
        }
        
        return headerView;
        
    }
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:COLLECTIONFOOTER forIndexPath:indexPath];
   
    return footer;
}
-(void)collectionHeaderTap:(UITapGestureRecognizer *)tap{
    NSDictionary  *dic =collectHeadArr[tap.view.tag];
    
    if (_classDidselect) {
        _classDidselect(dic);
    }

  //  [[NSNotificationCenter defaultCenter] postNotificationName:MENUTOUCHNOTI object:dic];
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _hideView();

}

@end
