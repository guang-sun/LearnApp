//
//  TrainCircleView.m
//  SOHUEhr
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainCircleView.h"


#define circleWidth     self.frame.size.width
#define circleHeight    self.frame.size.height
#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

@interface TrainCircleView ()
@property (nonatomic, strong) CAShapeLayer *bottomLayer; // 进度条底色
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer; // 渐变进度条
@property (nonatomic, strong) UILabel *commentLabel; // 中间文字label
@property (nonatomic, strong) UIImageView *bgImageView; // 背景图片

@property (nonatomic, assign) CGFloat circelRadius; //圆直径
@property (nonatomic, assign) CGFloat stareAngle; // 开始角度
@property (nonatomic, assign) CGFloat endAngle; // 结束角度
@property (nonatomic, assign) TraincircleMode    mode;



@end

@implementation TrainCircleView

#pragma mark - Life cycle

-(instancetype)initWithFrame:(CGRect)frame andcircleMode:(TraincircleMode)mode{
    self =[super initWithFrame:frame];
    if (self) {
        
        self.bgImageView =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];
        [self addSubview:_bgImageView];
        
        self.circelRadius = self.frame.size.width - 10.f;
        self.lineWidth = 2.f;
        if (mode == TraincircleModeArc ) {
            self.stareAngle = -225.f;
            self.endAngle = 45;
        }else {
            self.stareAngle = -90;
            self.endAngle = 270;
        }
        mode =mode;
        [self initSubView];
    }
    return  self;
    
}
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.bottomLayer.lineWidth = _lineWidth;
    self.progressLayer.lineWidth = _lineWidth+1;
    
    
}
-(void)initSubView{
    
    UIBezierPath *path = [UIBezierPath
                          bezierPathWithArcCenter:CGPointMake(circleWidth / 2, circleHeight/ 2)
                          radius:(self.circelRadius - self.lineWidth) / 2
                          startAngle:degreesToRadians(self.stareAngle)
                          endAngle:degreesToRadians(self.endAngle)
                          clockwise:YES];
    // 底色
    self.bottomLayer = [CAShapeLayer layer];
    self.bottomLayer.frame = self.bounds;
    self.bottomLayer.fillColor = [[UIColor clearColor] CGColor]; //内部填充
    self.bottomLayer.strokeColor = [[UIColor  grayColor] CGColor];  //线
    self.bottomLayer.opacity = 0.5;
    self.bottomLayer.lineCap = kCALineCapRound;
    self.bottomLayer.lineWidth = self.lineWidth;
    self.bottomLayer.path = [path CGPath];
    [self.layer addSublayer:self.bottomLayer];
    
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    self.progressLayer.strokeColor  = [[UIColor whiteColor] CGColor];
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.lineWidth = self.lineWidth+1;
    self.progressLayer.path = [path CGPath];
    self.progressLayer.strokeEnd = 0;
    [self.bottomLayer setMask:self.progressLayer];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    [self.gradientLayer setColors:@[(id)TrainNavColor.CGColor,(id)TrainNavColor.CGColor]];
    //    [self.gradientLayer setLocations:@[@1]];
    [self.gradientLayer setStartPoint:CGPointMake(0, 0)];
    [self.gradientLayer setEndPoint:CGPointMake(1, 0)];
    [self.gradientLayer setMask:self.progressLayer];
    
    [self.layer addSublayer:self.gradientLayer];
    
}

#pragma mark - Animation

- (void)circleAnimation { // 弧形动画
    //
    //    // 复原
    //        [CATransaction begin];
    //        [CATransaction setDisableActions:NO];
    //        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    //        [CATransaction setAnimationDuration:0];
    //        self.progressLayer.strokeEnd = 0;
    //        [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0.7f];
    
    self.progressLayer.strokeEnd = _percent / 100.0;
    [CATransaction commit];
}

#pragma mark - Setters / Getters

- (void)setPercent:(CGFloat)percent {
    [self setPercent:percent animated:YES];
}
-(void)setProgressColor:(UIColor *)progressColor{
    [self.gradientLayer setColors:@[(id)progressColor.CGColor,(id)progressColor.CGColor]];
}
-(void)setCircleBgLineColor:(UIColor *)circleBgLineColor{
    self.bottomLayer.strokeColor = [circleBgLineColor CGColor];
}
- (void)setPercent:(CGFloat)percent animated:(BOOL)animated {
    
    _percent = percent;
    [ self circleAnimation];
}
- (void)setText:(NSString *)text {
    
    _text = text;
    self.commentLabel.text = text;
}
- (UILabel *)commentLabel {
    
    if (nil == _commentLabel) {
        UILabel  *lable=[[UILabel alloc]initWithFrame:CGRectMake(circleWidth/4, circleHeight/4, circleWidth/2, circleHeight/4)];
        lable.textColor =[UIColor whiteColor];
        lable.font = [UIFont  systemFontOfSize:16.0f];
        lable.textAlignment =NSTextAlignmentCenter;
        lable.text =@"当前积分:";
        [self addSubview:lable];
        
        UIView  *line =[[UIView alloc]initWithFrame:CGRectMake(circleWidth/5, circleHeight/2, circleWidth*3/5, 0.5)];
        line.backgroundColor =[UIColor colorWithWhite:1 alpha:0.7];
        [self addSubview:line];
        
        _commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(circleWidth/4, circleHeight/2+1, circleWidth/2, circleHeight/4)];
        _commentLabel.font =[UIFont systemFontOfSize:35.0f];
        _commentLabel.textColor =[UIColor whiteColor];
        
        _commentLabel.textAlignment =NSTextAlignmentCenter;
        [self addSubview:_commentLabel];
    }
    return _commentLabel;
}
-(void)setBgImage:(UIImage *)bgImage{
    _bgImageView.image =bgImage;
}


@end
