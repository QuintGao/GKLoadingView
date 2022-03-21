//
//  CircleView.m
//  GKLoadingView
//
//  Created by gaokun on 2018/7/19.
//  Copyright © 2018年 QuintGao. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

//先都写在这个构造方法里面吧
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        UIView *circleView=[[UIView alloc]init];
        circleView.frame=CGRectMake(0, 0,frame.size.width,frame.size.height);
        circleView.backgroundColor=[UIColor clearColor];
        [self addSubview: circleView];
        
        UIColor *color = [UIColor colorWithRed:(252 / 255.0) green:(104 / 255.0) blue:(86 / 255.0) alpha:1.0f];
        
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)color.CGColor];
        gradientLayer.locations = @[@0.2,@1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [circleView.layer insertSublayer:gradientLayer atIndex:0];
        
        CAShapeLayer *layer=[[CAShapeLayer alloc]init];
        CGMutablePathRef pathRef=CGPathCreateMutable();
        CGPathAddRelativeArc(pathRef, nil,frame.size.width/2.0,frame.size.height/2.0,frame.size.width<frame.size.height?frame.size.width/2.0-20:frame.size.height/2.0-20,0, 2*M_PI);
        layer.path=pathRef;
        layer.lineWidth=3;
        layer.fillColor=[UIColor clearColor].CGColor;
        layer.strokeColor=[UIColor blackColor].CGColor;
        CGPathRelease(pathRef);
        circleView.layer.mask=layer;
        
        CABasicAnimation *animation=[CABasicAnimation     animationWithKeyPath:@"transform.rotation.z"]; ;
        // 设定动画选项
        animation.duration = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount =HUGE_VALF;
        // 设定旋转角度
        animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
        animation.toValue = [NSNumber numberWithFloat:2 * M_PI]; // 终止角度
        [circleView.layer addAnimation:animation forKey:@"rotate-layer"];
        
        UIButton *btn = [UIButton new];
        [btn setImage:[UIImage imageNamed:@"player_btn_play"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, frame.size.width + 60, frame.size.height + 60);
        btn.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self addSubview:btn];
    }
    return self;
}
























@end
