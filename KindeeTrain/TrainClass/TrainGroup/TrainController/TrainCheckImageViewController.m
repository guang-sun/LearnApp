//
//  TrainCheckImageViewController.m
//  SOHUEhr
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCheckImageViewController.h"
#import "TrainCheckImageCollectionViewCell.h"

@interface TrainCheckImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    BOOL _isHideNaviBar;
    
    //    BOOL _isLoc;
    NSMutableArray     *_ImageArr;
    UIImageView *_numberImageView;
    UILabel *_numberLable;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLable;
}


@end

@implementation TrainCheckImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton  *deleteBtn =[UIButton buttonWithType: UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(TrainSCREENWIDTH - 4, 0, 30, 44);
    [deleteBtn setImage:[UIImage imageSizeWithName:@"Train_Topic_Delete"] forState:UIControlStateNormal];
//    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
//    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteArr)];
//    [self.navBar creatRightBarItem:deleteBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];

    
    _isHideNaviBar =NO;
    [self configCollectionView];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.width) * _currentIndex, 0) animated:NO];
    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.returnNewPhotoArrBlock) {
        self.returnNewPhotoArrBlock(_ImageArr);
    }
    
}
-(void)back{
   
    [self.navigationController popViewControllerAnimated:YES];
    if (self.returnNewPhotoArrBlock) {
        self.returnNewPhotoArrBlock(_ImageArr);
    }
}
-(void)deleteArr{
    
    
    if (_ImageArr.count >= _currentIndex) {
        [_ImageArr removeObjectAtIndex:_currentIndex];
        if (_ImageArr.count  == _currentIndex) {
            _currentIndex = _currentIndex - 1;
        }
        
    }
    
    if (_ImageArr.count == 0) {
        [self back];
        return;
    }
    [_collectionView reloadData];
    [self refreshNaviBarAndBottomBarState];
}

-(void)setPhotoArr:(NSArray *)photoArr{
    _ImageArr = [NSMutableArray arrayWithArray:photoArr];
    [_ImageArr removeLastObject];
}


- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT-TrainNavHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.view.width * _ImageArr.count, self.view.height);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TrainCheckImageCollectionViewCell class] forCellWithReuseIdentifier:@"ReadImageCell"];
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    _currentIndex = offSet.x / self.view.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self refreshNaviBarAndBottomBarState];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _ImageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrainCheckImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReadImageCell" forIndexPath:indexPath];
    
    if ([_ImageArr[indexPath.row] isKindOfClass:[NSData class]]) {
        cell.locImage = [UIImage imageWithData:_ImageArr[indexPath.row]];
    }
    return cell;
}

#pragma mark - Private Method

- (void)refreshNaviBarAndBottomBarState {
    
    self.navigationItem.title = [NSString  stringWithFormat:@"预览 %zi / %zi",_currentIndex + 1,_ImageArr.count];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
