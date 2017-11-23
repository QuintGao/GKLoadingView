//
//  GKLoadingView.m
//  GKLoadingView
//
//  Created by QuintGao on 2017/11/23.
//  Copyright © 2017年 QuintGao. All rights reserved.
//

#import "GKLoadingView.h"

@interface GKLoadingView()<CAAnimationDelegate>

// 动画layer
@property (nonatomic, strong) CAShapeLayer *animatedLayer;

// 半径layer
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

/** 加载方式 */
@property (nonatomic, assign) GKLoadingStyle loadingStyle;

@property (nonatomic, copy) void(^completion)(GKLoadingView *loadingView, BOOL finished);

@end

@implementation GKLoadingView

+ (instancetype)loadingViewWithFrame:(CGRect)frame style:(GKLoadingStyle)style {
    return [[self alloc] initWithFrame:frame loadingStyle:style];
}

- (instancetype)initWithFrame:(CGRect)frame loadingStyle:(GKLoadingStyle)loadingStyle {
    if (self = [super initWithFrame:frame]) {
        self.loadingStyle = loadingStyle;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self layoutAnimatedLayer];
    }else {
        [self.animatedLayer removeFromSuperlayer];
        self.animatedLayer = nil;
    }
}

- (void)layoutAnimatedLayer {
    CALayer *layer = self.animatedLayer;
    [self.layer addSublayer:layer];
    
    CGFloat widthDiff = CGRectGetWidth(self.bounds) - CGRectGetWidth(layer.bounds);
    CGFloat heightDiff = CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds);
    
    CGFloat positionX = CGRectGetWidth(self.bounds) - CGRectGetWidth(layer.bounds) / 2 - widthDiff / 2;
    CGFloat positionY = CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds) / 2 - heightDiff / 2;
    
    layer.position = CGPointMake(positionX, positionY);
    
    if (self.backgroundLayer) {
        self.backgroundLayer.position = layer.position;
    }
}

- (CAShapeLayer *)animatedLayer {
    if (!_animatedLayer) {
        CGFloat centerXY = self.radius + self.lineWidth * 0.5 + 5;
        
        if (self.loadingStyle == GKLoadingStyleIndeterminate) {
            CGPoint arcCenter = CGPointMake(centerXY, centerXY);
            UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:self.radius startAngle:(CGFloat)(M_PI * 3 / 2) endAngle:(CGFloat)(M_PI / 2 + M_PI * 5) clockwise:YES];
            
            _animatedLayer = [CAShapeLayer layer];
            _animatedLayer.contentsScale = [UIScreen mainScreen].scale;
            _animatedLayer.frame = CGRectMake(0.0f, 0.0f, arcCenter.x * 2, arcCenter.y * 2);
            _animatedLayer.fillColor   = [UIColor clearColor].CGColor;
            _animatedLayer.strokeColor = self.trackColor.CGColor;
            _animatedLayer.lineWidth   = self.lineWidth;
            _animatedLayer.lineCap     = kCALineCapRound;
            _animatedLayer.lineJoin    = kCALineJoinBevel;
            _animatedLayer.path        = smoothedPath.CGPath;
            
            CALayer *maskLayer = [CALayer layer];
            
            maskLayer.contents = (__bridge id)[[UIImage imageNamed:@"angle-mask"] CGImage];
            maskLayer.frame = _animatedLayer.bounds;
            _animatedLayer.mask = maskLayer;
            
            NSTimeInterval animationDuration = 1;
            CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            animation.fromValue           = (id) 0;
            animation.toValue             = @(M_PI * 2);
            animation.duration            = animationDuration;
            animation.timingFunction      = linearCurve;
            animation.removedOnCompletion = NO;
            animation.repeatCount         = INFINITY;
            animation.fillMode            = kCAFillModeForwards;
            animation.autoreverses        = NO;
            [_animatedLayer.mask addAnimation:animation forKey:@"rotate"];
            
            CAAnimationGroup *animationGroup    = [CAAnimationGroup animation];
            animationGroup.duration             = animationDuration;
            animationGroup.repeatCount          = INFINITY;
            animationGroup.removedOnCompletion  = NO;
            animationGroup.timingFunction       = linearCurve;
            
            CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
            strokeStartAnimation.fromValue = @0.015;
            strokeStartAnimation.toValue   = @0.515;
            
            CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            strokeEndAnimation.fromValue = @0.485;
            strokeEndAnimation.toValue   = @0.985;
            
            animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
            [_animatedLayer addAnimation:animationGroup forKey:@"progress"];
        }else {
            CGPoint arcCenter = CGPointMake(centerXY, centerXY);
            UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:self.radius startAngle:(CGFloat)-M_PI_2 endAngle:(CGFloat)(M_PI + M_PI_2) clockwise:YES];
            
            [self.layer addSublayer:self.backgroundLayer];
            
            _animatedLayer = [CAShapeLayer layer];
            _animatedLayer.contentsScale = [UIScreen mainScreen].scale;
            _animatedLayer.frame         = CGRectMake(0.0f, 0.0f, arcCenter.x * 2, arcCenter.y * 2);
            _animatedLayer.fillColor     = [UIColor clearColor].CGColor;
            _animatedLayer.strokeColor   = self.progressColor.CGColor;
            _animatedLayer.lineWidth     = self.lineWidth;
            _animatedLayer.lineCap       = kCALineCapRound;
            _animatedLayer.lineJoin      = kCALineJoinBevel;
            _animatedLayer.path          = smoothedPath.CGPath;
            _animatedLayer.strokeEnd     = 0.0f;
        }
    }
    return _animatedLayer;
}

- (CAShapeLayer *)backgroundLayer {
    if (!_backgroundLayer) {
        
        CGFloat centerXY = self.radius + self.lineWidth * 0.5 + 5;
        
        CGPoint arcCenter = CGPointMake(centerXY, centerXY);
        UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:self.radius startAngle:(CGFloat)-M_PI_2 endAngle:(CGFloat)(M_PI + M_PI_2) clockwise:YES];
        
        _backgroundLayer               = [CAShapeLayer layer];
        _backgroundLayer.contentsScale = [UIScreen mainScreen].scale;
        _backgroundLayer.frame         = CGRectMake(0.0f, 0.0f, arcCenter.x * 2, arcCenter.y * 2);
        _backgroundLayer.fillColor     = [UIColor clearColor].CGColor;
        _backgroundLayer.strokeColor   = self.trackColor.CGColor;
        _backgroundLayer.lineWidth     = self.lineWidth;
        _backgroundLayer.lineCap       = kCALineCapRound;
        _backgroundLayer.lineJoin      = kCALineJoinBevel;
        _backgroundLayer.path          = smoothedPath.CGPath;
        _backgroundLayer.strokeEnd     = 1.0f;
    }
    return _backgroundLayer;
}

- (void)setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(frame, super.frame)) {
        [super setFrame:frame];
        
        if (self.superview) {
            [self layoutAnimatedLayer];
        }
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    self.animatedLayer.lineWidth = lineWidth;
    self.backgroundLayer.lineWidth = lineWidth;
}

- (void)setRadius:(CGFloat)radius {
    if (radius != _radius) {
        _radius = radius;
        
        [self.animatedLayer removeFromSuperlayer];
        self.animatedLayer = nil;
        
        [self.backgroundLayer removeFromSuperlayer];
        self.backgroundLayer = nil;
        
        if (self.superview) {
            [self layoutAnimatedLayer];
        }
    }
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    
    if (self.loadingStyle == GKLoadingStyleIndeterminate) {
        self.animatedLayer.strokeColor = trackColor.CGColor;
    }else {
        self.backgroundLayer.strokeColor = trackColor.CGColor;
    }
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    
    if (self.loadingStyle == GKLoadingStyleDeterminate) {
        self.animatedLayer.strokeColor = progressColor.CGColor;
    }
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.animatedLayer.strokeEnd = progress;
    !self.progressChange ? : self.progressChange(self, progress);
    [CATransaction commit];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake((self.radius + self.lineWidth / 2 + 5) * 2, (self.radius + self.lineWidth / 2 + 5) * 2);
}

- (void)startLoadingWithDuration:(NSTimeInterval)duration completion:(void (^)(GKLoadingView *, BOOL))completion {
    self.completion = completion;
    
    self.progress = 1.0;
    
    CABasicAnimation *pathAnimation     = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration              = duration;
    pathAnimation.fromValue             = @(0.0);
    pathAnimation.toValue               = @(1.0);
    pathAnimation.removedOnCompletion   = YES;
    pathAnimation.delegate              = self;
    [self.animatedLayer addAnimation:pathAnimation forKey:nil];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    !self.completion ? : self.completion(self, flag);
}

@end
