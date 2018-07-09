//
//  TrainClassMatesTableViewCell.m
//  KindeeTrain
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainClassMatesTableViewCell.h"
#import "TrainMatesCollectionViewCell.h"


@interface TrainClassMatesTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView  *mateCollectionView ;

@property (nonatomic, strong) UIButton  *allMatesButton ;


@end

@implementation TrainClassMatesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone ;

    // Initialization code

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self rzAddSubview];
        [self rzAddLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone ;

    }
    return  self ;
}

- (void)rzAddSubview {
    
    [self.contentView addSubview:self.mateCollectionView];
    [self.contentView addSubview:self.allMatesButton];

}
- (void)rzAddLayout {
    
    [self.mateCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.equalTo(self.contentView).offset(TrainMarginWidth);
        make.right.equalTo(self.contentView).offset(- TrainMarginWidth);
        make.height.mas_equalTo(100);
    }];
    [self.allMatesButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.mateCollectionView.mas_bottom);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.contentView);
    }];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section  {
    
    return _gradeArr.count  ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TrainMatesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TrainMatesCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell rzUpdateMatesInfoWithmodel:_gradeArr[indexPath.row]];
    
    return cell ;
    
}

- (void)setGradeArr:(NSArray *)gradeArr {
    
    _gradeArr = gradeArr ;
    
    if (gradeArr.count > 5) {
        _gradeArr = [gradeArr subarrayWithRange:NSMakeRange(0, 5)];
    }
    [self.mateCollectionView reloadData];

}

- (void)rzallMates {
    
    if (_rzgetMoreMatesblock) {
        self.rzgetMoreMatesblock() ;
    }
    
}

- (UICollectionView *)mateCollectionView {
    if (!_mateCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        
        CGFloat  width = (TrainSCREENWIDTH - 4 *TrainMarginWidth ) /5.f ;
        layout.itemSize = CGSizeMake(width, 90) ;
        
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collectView.backgroundColor = [UIColor whiteColor];
        UINib *nib = [UIView loadNibNamed:NSStringFromClass([TrainMatesCollectionViewCell class])];
        
        [collectView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([TrainMatesCollectionViewCell class])];
        
        collectView.delegate = self;
        collectView.dataSource = self;
        
        
        _mateCollectionView = collectView;
    }
    return _mateCollectionView;
}

- (UIButton *)allMatesButton {
    if (!_allMatesButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"查看所有同学" forState:UIControlStateNormal];
        [button setTitleColor:TrainColorFromRGB16(0x259B24) forState:UIControlStateSelected];
        [button setTitleColor:TrainColorFromRGB16(0x259B24) forState:UIControlStateNormal];
        button .titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [button addTarget:self action:@selector(rzallMates)];
        
        _allMatesButton = button ;
    }
    return _allMatesButton ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
