//
//  ViewController.m
//  GKLoadingView
//
//  Created by QuintGao on 2017/11/23.
//  Copyright © 2017年 QuintGao. All rights reserved.
//

#import "ViewController.h"
#import "GKLoadingView.h"
#import "CircleView.h"
#import "AYAudioLoadingButton.h"

@interface ViewController ()

@property (nonatomic, strong) GKLoadingView *loadingView1;
@property (nonatomic, strong) GKLoadingView *loadingView2;
@property (nonatomic, strong) GKLoadingView *loadingView3;
@property (nonatomic, strong) GKLoadingView *loadingView4;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat progress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initLoadingView];
    
//    CircleView *circleView = [[CircleView alloc] initWithFrame:CGRectMake(100 ,100, 100, 100)];
//    [self.view addSubview:circleView];
    
    AYAudioLoadingButton *btn = [AYAudioLoadingButton new];
    btn.frame = CGRectMake(200, 200, btn.frame.size.width, btn.frame.size.height);
    [self.view addSubview:btn];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)initLoadingView {
    CGRect loadingFrame = CGRectMake(100, 100, 100, 100);
    
    self.loadingView1 = [GKLoadingView loadingViewWithFrame:loadingFrame style:GKLoadingStyleIndeterminate];
    self.loadingView1.bgColor       = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.loadingView1.strokeColor   = [UIColor whiteColor];
    self.loadingView1.lineWidth     = 4;
    self.loadingView1.radius        = 30;
    [self.view addSubview:self.loadingView1];
    [self.loadingView1.centerButton setImage:[UIImage imageNamed:@"dzq"] forState:UIControlStateNormal];
    [self.loadingView1 startLoading];
    self.loadingView1.backgroundColor = [UIColor redColor];
    
    loadingFrame.origin.y += 100;
    
    self.loadingView2 = [GKLoadingView loadingViewWithFrame:loadingFrame style:GKLoadingStyleDeterminate];
    self.loadingView2.bgColor       = [UIColor grayColor];
    self.loadingView2.strokeColor   = [UIColor whiteColor];
    self.loadingView2.lineWidth     = 4;
    self.loadingView2.radius        = 30;
    [self.view addSubview:self.loadingView2];
    [self.loadingView2.centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loadingView2.progressChange = ^(GKLoadingView *loadingView, CGFloat progress) {
        NSString *text = [NSString stringWithFormat:@"%.f%%", progress * 100];
        [loadingView.centerButton setTitle:text forState:UIControlStateNormal];
    };
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    loadingFrame.origin.y    += 100;
    
    self.loadingView3 = [GKLoadingView loadingViewWithFrame:loadingFrame style:GKLoadingStyleDeterminate];
    self.loadingView3.bgColor       = [UIColor redColor];
    self.loadingView3.strokeColor   = [UIColor whiteColor];
    self.loadingView3.lineWidth     = 4;
    self.loadingView3.radius        = 30;
    
    [self.view addSubview:self.loadingView3];
    [self.loadingView3.centerButton setTitle:@"跳过" forState:UIControlStateNormal];
    [self.loadingView3.centerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.loadingView3.centerButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    
    [self.loadingView3 startLoadingWithDuration:5.0 completion:^(GKLoadingView *loadingView, BOOL finished) {
        [loadingView.centerButton setTitle:@"完成" forState:UIControlStateNormal];
    }];
    
    loadingFrame.origin.x += 100;
    self.loadingView4 = [GKLoadingView loadingViewWithFrame:loadingFrame style:GKLoadingStyleIndeterminateMask];
    self.loadingView4.lineWidth   = 4.0f;
    self.loadingView4.radius      = 50.0f;
    self.loadingView4.bgColor     = [UIColor clearColor];
    self.loadingView4.strokeColor = [UIColor redColor];
    [self.loadingView4.centerButton setImage:[UIImage imageNamed:@"dzq"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.loadingView4];

    [self.loadingView4 startLoading];
}

- (void)timerAction {
    self.progress += 0.01;
    
    if (self.progress >= 1.0) {
        self.progress = 1.0;
        
        [self.timer invalidate];
        self.timer = nil;
        
        // 1.0秒后重复
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progress = 0.0f;
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        });
    }
    
    self.loadingView2.progress = self.progress;
}

@end
