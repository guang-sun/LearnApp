//
//  TrainCustomTextView.m
//  SOHUEhr
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCustomTextView.h"


@interface TrainCustomTextView ()<UITextViewDelegate>
{
    bool        isCreat;
}

/**
 *  占位文字View: 为什么使用UITextView，这样直接让占位文字View = 当前textView,文字就会重叠显示
 */
@property (nonatomic, weak) UITextView *placeholderView;

/**
 *  文字高度
 */
@property (nonatomic, assign) NSInteger textH;

/**
 *  文字最大高度
 */
@property (nonatomic, assign) NSInteger maxTextH;

@end

@implementation TrainCustomTextView

- (UITextView *)placeholderView
{
    if (_placeholderView == nil) {
        UITextView *placeholderView = [[UITextView alloc] init];
        _placeholderView = placeholderView;
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textColor = [UIColor colorWithWhite:0.7 alpha:0.8f];
        _placeholderView.backgroundColor = [UIColor clearColor];
        [self addSubview:placeholderView];
    }
    return _placeholderView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        isCreat = YES;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.scrollsToTop = NO;
    self.isAutolayoutHeight = NO;
    self.scrollEnabled = ( ! self.isAutolayoutHeight)?YES:NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = TrainNavColor.CGColor;
    
    
//    self addObserver:<#(nonnull NSObject *)#> forKeyPath:@"text" options:<#(NSKeyValueObservingOptions)#> context:<#(nullable void *)#>
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];

    
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    _maxNumberOfLines = maxNumberOfLines;
    // 计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
    
}

- (void)setCornerRadius:(NSUInteger)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}
-(void)setTrainTextHeightChangeBlock:(void (^)(CGFloat))trainTextHeightChangeBlock{
    _trainTextHeightChangeBlock = trainTextHeightChangeBlock;
    if (isCreat) {
        isCreat = NO;
        return;
    }
    [self textDidChange];

}


- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderView.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;

    self.placeholderView.text = placeholder;
    [self layoutSubviews];
}
- (void)textDidChange
{
    // 占位文字是否显示
  
    self.placeholderView.hidden = self.text.length > 0;
    if (_textViewChangeBlock) {
        _textViewChangeBlock(self.text);
    }
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    
    if (_textH != height) { // 高度不一样，就改变了高度
        
        // 最大高度，可以滚动
        if (_isAutolayoutHeight) {
            
            self.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        }
        
        _textH = height;
        
        if (_trainTextHeightChangeBlock && (_isAutolayoutHeight && self.scrollEnabled == NO) ) {
            _trainTextHeightChangeBlock(height);
            [self.superview layoutIfNeeded];
            self.placeholderView.frame = self.bounds;
        }
    }
}


-(void)layoutSubviews{
    self.placeholderView.frame = self.bounds;
    self.placeholderView.hidden = self.text.length > 0;
    [self layoutIfNeeded];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
