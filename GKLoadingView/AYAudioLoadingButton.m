//
//  AYAudioLoadingButton.m
//  aiyinsitanfm
//
//  Created by gaokun on 2018/7/19.
//  Copyright © 2018年 aiyinsitanfm. All rights reserved.
//

#import "AYAudioLoadingButton.h"

@implementation AYAudioLoadingButton

- (instancetype)init {
    if (self = [super init]) {
        [self setImage:[UIImage imageNamed:@"player_btn_pause"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"player_btn_play"] forState:UIControlStateSelected];
        
        [self sizeToFit];
        
        UIView *circleView = [UIView new];
        circleView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        circleView.backgroundColor = [UIColor clearColor];
        [self addSubview:circleView];
        
        UIColor *firstColor = [UIColor colorWithRed:(252 / 255.0) green:(104 / 255.0) blue:(86 / 255.0) alpha:0.2f];
        
        UIColor *color = [UIColor colorWithRed:(252 / 255.0) green:(104 / 255.0) blue:(86 / 255.0) alpha:1.0f];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)firstColor.CGColor, (__bridge id)color.CGColor];
        gradientLayer.locations = @[@0.2, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [circleView.layer insertSublayer:gradientLayer atIndex:0];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGPathAddRelativeArc(pathRef, nil, self.frame.size.width / 2.0f, self.frame.size.height / 2.0f, self.frame.size.width < self.frame.size.height ? self.frame.size.width / 2.0f - 16 : self.frame.size.height / 2.0f - 16, 0, 2 * M_PI);
        layer.path = pathRef;
        layer.lineWidth = 2;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor blackColor].CGColor;
        CGPathRelease(pathRef);
        circleView.layer.mask = layer;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        // 设定动画选项
        animation.duration = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = HUGE_VALF;
        // 设定旋转角度
        animation.fromValue = @0.0f;  // 起始角度
        animation.toValue = @(2 * M_PI); // 终止角度
        [circleView.layer addAnimation:animation forKey:@"rotate-layer"];
    }
    return self;
}

@end
