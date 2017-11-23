//
//  GKLoadingView.h
//  GKLoadingView
//
//  Created by QuintGao on 2017/11/23.
//  Copyright © 2017年 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GKLoadingStyle) {
    GKLoadingStyleIndeterminate,  // 不明确的加载方式
    GKLoadingStyleDeterminate     // 明确的加载方式--进度条
};

@interface GKLoadingView : UIView

+ (instancetype)loadingViewWithFrame:(CGRect)frame style:(GKLoadingStyle)style;

@property (nonatomic, strong) UIButton *centerButton;

/** 线条宽度 */
@property (nonatomic, assign) CGFloat lineWidth;

/** 圆弧半径 */
@property (nonatomic, assign) CGFloat radius;

/** 圆弧的填充路径颜色 */
@property (nonatomic, strong) UIColor *trackColor;

/** 进度的颜色 */
@property (nonatomic, strong) UIColor *progressColor;

/** 进度，loadingStyle为GKLoadingStyleDeterminate时使用 */
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) void (^progressChange)(GKLoadingView *loadingView, CGFloat progress);

// 在duration时间内加载，
- (void)startLoadingWithDuration:(NSTimeInterval)duration completion:(void (^)(GKLoadingView *loadingView, BOOL finished))completion;

@end
