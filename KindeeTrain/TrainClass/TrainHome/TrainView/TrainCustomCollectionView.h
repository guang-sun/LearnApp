//
//  TrainCustomCollectionView.h
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>
@class TrainCustomCollectionView;

@protocol  TrainCustomCollectionViewDelegate<UICollectionViewDelegate>

@required
/**
 *  当数据源更新的到时候调用，必须实现，需将新的数据源设置为当前tableView的数据源(例如 :_data = newDataArray)
 *  @param newDataArray   更新后的数据源
 */
- (void)TrainCustomCollectionView:(TrainCustomCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray;

@optional

/**
 *  某个cell将要开始移动的时候调用
 *  @param indexPath      该cell当前的indexPath
 */
- (void)TrainCustomCollectionView:(TrainCustomCollectionView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  某个cell正在移动的时候
 */
- (void)TrainCustomCollectionViewCellisMoving:(TrainCustomCollectionView *)collectionView;
/**
 *  cell移动完毕，并成功移动到新位置的时候调用
 */
- (void)TrainCustomCollectionViewCellEndMoving:(TrainCustomCollectionView *)collectionView;
/**
 *  成功交换了位置的时候调用
 *  @param fromIndexPath    交换cell的起始位置
 *  @param toIndexPath      交换cell的新位置
 */
- (void)TrainCustomCollectionView:(TrainCustomCollectionView *)collectionView moveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end

@protocol  TrainCustomCollectionViewDataSource<UICollectionViewDataSource>


@required
/**
 *  返回整个CollectionView的数据，必须实现，需根据数据进行移动后的数据重排
 */
- (NSArray *)dataSourceArrayOfCollectionView:(TrainCustomCollectionView *)collectionView;

@end

@interface TrainCustomCollectionView : UICollectionView

@property (nonatomic, assign) id<TrainCustomCollectionViewDelegate>   delegate;
@property (nonatomic, assign) id<TrainCustomCollectionViewDataSource>  dataSource;

/**长按多少秒触发拖动手势，默认1秒，如果设置为0，表示手指按下去立刻就触发拖动*/
@property (nonatomic, assign) NSTimeInterval minimumPressDuration;
/**是否开启拖动到边缘滚动CollectionView的功能，默认YES*/
@property (nonatomic, assign) BOOL edgeScrollEable;
/**
 *  成功交换了位置的时候调用
 *  @param frame    大小
 *  @param layout   collection的布局方式
 *  @param tap      是否可以移动
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout andistap:(BOOL)tap;

@end
