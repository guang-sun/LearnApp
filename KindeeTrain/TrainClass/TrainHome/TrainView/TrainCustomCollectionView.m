//
//  TrainCustomCollectionView.m
//  SOHUEhr
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCustomCollectionView.h"
//#import <AudioToolbox/AudioToolbox.h>

typedef NS_ENUM(NSUInteger, TrainCustomCollectionViewScrollDirection) {
    TrainCustomCollectionViewScrollDirectionNone = 0,
    TrainCustomCollectionViewScrollDirectionLeft,
    TrainCustomCollectionViewScrollDirectionRight,
    TrainCustomCollectionViewScrollDirectionUp,
    TrainCustomCollectionViewScrollDirectionDown
};

@interface TrainCustomCollectionView ()

@property (nonatomic, strong) NSIndexPath *originalIndexPath;
@property (nonatomic, strong) NSIndexPath *moveIndexPath;
@property (nonatomic, weak) UIView *tempMoveCell;
@property (nonatomic, weak) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) CADisplayLink *edgeTimer;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) TrainCustomCollectionViewScrollDirection scrollDirection;


@end



@implementation TrainCustomCollectionView

@dynamic delegate;
@dynamic dataSource;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout andistap:(BOOL)tap
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initdefault];
        if (tap) {
            [self addGesture];
        }
        
    }
    return self;
}

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        [self initdefault];
//        [self addGesture];
//    }
//    return self;
//}

- (void)initdefault{
    _minimumPressDuration = 0.5f;
    _edgeScrollEable = YES;
    self.backgroundColor =[UIColor whiteColor];
    
}
- (void)addGesture{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    _longPressGesture = longPress;
    longPress.minimumPressDuration = _minimumPressDuration;
    [self addGestureRecognizer:longPress];
}
- (void)longPressed:(UILongPressGestureRecognizer *)longPressGesture{
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        [self gestureBegan:longPressGesture];
    }
    if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        [self gestureChange:longPressGesture];
    }
    if (longPressGesture.state == UIGestureRecognizerStateCancelled ||
        longPressGesture.state == UIGestureRecognizerStateEnded){
        [self gestureEndOrCancle:longPressGesture];
    }
}

- (void)gestureBegan:(UILongPressGestureRecognizer *)longPressGesture{
    //获取手指所在的cell
    _originalIndexPath = [self indexPathForItemAtPoint:[longPressGesture locationOfTouch:0 inView:longPressGesture.view]];
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:_originalIndexPath];
    UIView *tempMoveCell = [cell snapshotViewAfterScreenUpdates:NO];
    cell.hidden = YES;
    _tempMoveCell = tempMoveCell;
    _tempMoveCell.frame = cell.frame;
    [self addSubview:_tempMoveCell];
    //开启边缘滚动定时器
    [self xwp_setEdgeTimer];
    _lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
    [self showCurrentCell];
    //通知代理
    if ([self.delegate respondsToSelector:@selector(TrainCustomCollectionView:cellWillBeginMoveAtIndexPath:)]) {
        [self.delegate TrainCustomCollectionView:self cellWillBeginMoveAtIndexPath:_originalIndexPath];
    }
}
/**
 *  手势拖动
 */
- (void)gestureChange:(UILongPressGestureRecognizer *)longPressGesture{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(TrainCustomCollectionViewCellisMoving:)]) {
        [self.delegate TrainCustomCollectionViewCellisMoving:self];
    }
    CGFloat tranX = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].x - _lastPoint.x;
    CGFloat tranY = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].y - _lastPoint.y;
    [self showCurrentCell];
    _tempMoveCell.center = CGPointApplyAffineTransform(_tempMoveCell.center, CGAffineTransformMakeTranslation(tranX, tranY));
    _lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
    for (UICollectionViewCell *cell in [self visibleCells]) {
        if ([self indexPathForCell:cell] == _originalIndexPath) {
            continue;
        }
        //计算中心距
        CGFloat space = sqrtf(pow(_tempMoveCell.center.x - cell.center.x, 2) + powf(_tempMoveCell.center.y - cell.center.y, 2));
        if (space <= _tempMoveCell.bounds.size.width / 2) {
            _moveIndexPath = [self indexPathForCell:cell];
            //更新数据源
            [self updateDataSource];
            //移动
          //  [self reloadData];
            [self moveItemAtIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
            //通知代理
            if ([self.delegate respondsToSelector:@selector(TrainCustomCollectionView:moveCellFromIndexPath:toIndexPath:)]) {
                [self.delegate TrainCustomCollectionView:self moveCellFromIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
            }
            //设置移动后的起始indexPath
            _originalIndexPath = _moveIndexPath;
            break;
        }
    }
}

/**
 *  手势取消或者结束
 */
- (void)gestureEndOrCancle:(UILongPressGestureRecognizer *)longPressGesture{
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:_originalIndexPath];
    self.userInteractionEnabled = NO;
    [self xwp_stopEdgeTimer];
    //通知代理
    if ([self.delegate respondsToSelector:@selector(TrainCustomCollectionViewCellEndMoving:)]) {
        [self.delegate TrainCustomCollectionViewCellEndMoving:self];
    }
    [UIView animateWithDuration:0.4 animations:^{
        _tempMoveCell.center = cell.center;
        _tempMoveCell.transform =CGAffineTransformScale(CGAffineTransformIdentity, 1.0,1.0);
    } completion:^(BOOL finished) {
        //        [self stopShakeAllCell];
        [_tempMoveCell removeFromSuperview];
        cell.hidden = NO;
        self.userInteractionEnabled = YES;
    }];
}

#pragma mark - setter methods

- (void)setMinimumPressDuration:(NSTimeInterval)minimumPressDuration{
    _minimumPressDuration = minimumPressDuration;
    _longPressGesture.minimumPressDuration = minimumPressDuration;
}


#pragma mark - timer methods

- (void)xwp_setEdgeTimer{
    if (!_edgeTimer && _edgeScrollEable) {
        _edgeTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(edgeScroll)];
        [_edgeTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)xwp_stopEdgeTimer{
    if (_edgeTimer) {
        [_edgeTimer invalidate];
        _edgeTimer = nil;
    }
}


#pragma mark - private methods

/**
 *  更新数据源
 */
- (void)updateDataSource{
    NSMutableArray *temp = @[].mutableCopy;
    //获取数据源
    if ([self.dataSource respondsToSelector:@selector(dataSourceArrayOfCollectionView:)]) {
        [temp addObjectsFromArray:[self.dataSource dataSourceArrayOfCollectionView:self]];
    }
    //判断数据源是单个数组还是数组套数组的多section形式，YES表示数组套数组
    BOOL dataTypeCheck = ([self numberOfSections] != 1 || ([self numberOfSections] == 1 && [temp[0] isKindOfClass:[NSArray class]]));
    if (dataTypeCheck) {
        for (int i = 0; i < temp.count; i ++) {
            [temp replaceObjectAtIndex:i withObject:[temp[i] mutableCopy]];
        }
    }
    if (_moveIndexPath.section == _originalIndexPath.section) {
        NSMutableArray *orignalSection = dataTypeCheck ? temp[_originalIndexPath.section] : temp;
        if (_moveIndexPath.item > _originalIndexPath.item) {
            for (NSUInteger i = _originalIndexPath.item; i < _moveIndexPath.item ; i ++) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
            }
        }else{
            for (NSUInteger i = _originalIndexPath.item; i > _moveIndexPath.item ; i --) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
            }
        }
    }else{
        NSMutableArray *orignalSection = temp[_originalIndexPath.section];
        NSMutableArray *currentSection = temp[_moveIndexPath.section];
        [currentSection insertObject:orignalSection[_originalIndexPath.item] atIndex:_moveIndexPath.item];
        [orignalSection removeObject:orignalSection[_originalIndexPath.item]];
    }
    
    if ([self.delegate respondsToSelector:@selector(TrainCustomCollectionView:newDataArrayAfterMove:)]) {
        [self.delegate TrainCustomCollectionView:self newDataArrayAfterMove:temp.copy];
    }
}

- (void)edgeScroll{
    [self setScrollDirection];
    switch (_scrollDirection) {
        case TrainCustomCollectionViewScrollDirectionLeft:{
            //这里的动画必须设为NO
            [self setContentOffset:CGPointMake(self.contentOffset.x - 4, self.contentOffset.y) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x - 4, _tempMoveCell.center.y);
            _lastPoint.x -= 4;
            
        }
            break;
        case TrainCustomCollectionViewScrollDirectionRight:{
            [self setContentOffset:CGPointMake(self.contentOffset.x + 4, self.contentOffset.y) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x + 4, _tempMoveCell.center.y);
            _lastPoint.x += 4;
            
        }
            break;
        case TrainCustomCollectionViewScrollDirectionUp:{
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - 4) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y - 4);
            _lastPoint.y -= 4;
        }
            break;
        case TrainCustomCollectionViewScrollDirectionDown:{
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + 4) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y + 4);
            _lastPoint.y += 4;
        }
            break;
        default:
            break;
    }
    
}

- (void)showCurrentCell{
    
    if (![_tempMoveCell.layer animationForKey:@"shake"]) {
        [UIView animateWithDuration:0.4 animations:^{
            _tempMoveCell.transform =CGAffineTransformScale(CGAffineTransformIdentity, 1.4,1.4);
        }];
        
    }
}

- (void)stopShakeAllCell{
    [UIView animateWithDuration:0.4 animations:^{
        _tempMoveCell.transform =CGAffineTransformScale(CGAffineTransformIdentity, 1.0,1.0);
    }];
}

- (void)setScrollDirection{
    _scrollDirection = TrainCustomCollectionViewScrollDirectionNone;
    if (self.bounds.size.height + self.contentOffset.y - _tempMoveCell.center.y < _tempMoveCell.bounds.size.height / 2 && self.bounds.size.height + self.contentOffset.y < self.contentSize.height) {
        _scrollDirection = TrainCustomCollectionViewScrollDirectionDown;
    }
    if (_tempMoveCell.center.y - self.contentOffset.y < _tempMoveCell.bounds.size.height / 2 && self.contentOffset.y > 0) {
        _scrollDirection = TrainCustomCollectionViewScrollDirectionUp;
    }
    if (self.bounds.size.width + self.contentOffset.x - _tempMoveCell.center.x < _tempMoveCell.bounds.size.width / 2 && self.bounds.size.width + self.contentOffset.x < self.contentSize.width) {
        _scrollDirection = TrainCustomCollectionViewScrollDirectionRight;
    }
    
    if (_tempMoveCell.center.x - self.contentOffset.x < _tempMoveCell.bounds.size.width / 2 && self.contentOffset.x > 0) {
        _scrollDirection = TrainCustomCollectionViewScrollDirectionLeft;
    }
}


#pragma mark - overWrite methods

/**
 *  重写hitTest事件，判断是否应该相应自己的滑动手势，还是系统的滑动手势
 */

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    _longPressGesture.enabled = [self indexPathForItemAtPoint:point];
    return [super hitTest:point withEvent:event];
}


@end
