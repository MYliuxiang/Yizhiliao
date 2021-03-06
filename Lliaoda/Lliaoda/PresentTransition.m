//
//  CustomViewControllerTransition.m
//  转场动画
//
//  Created by 霍文轩 on 15/10/30.
//  Copyright © 2015年 霍文轩. All rights reserved.
//

#import "PresentTransition.h"

@interface PresentTransition()
@end

@implementation PresentTransition
// 返回动画的时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.8;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * container = [transitionContext containerView];
    
    [container addSubview:toVC.view];
    [container bringSubviewToFront:fromVC.view];
    
    // 改变m34
    CATransform3D transfrom = CATransform3DIdentity;
    transfrom.m34 = -0.002;
    container.layer.sublayerTransform = transfrom;
    
    // 設定archPoint和position
    CGRect initalFrame = [transitionContext initialFrameForViewController:fromVC];
    toVC.view.frame = initalFrame;
    fromVC.view.frame = initalFrame;
    fromVC.view.layer.anchorPoint = CGPointMake(0, 0.5);
    fromVC.view.layer.position = CGPointMake(0, initalFrame.size.height / 2.0);
    
    // 添加阴影效果
    CAGradientLayer * shadowLayer = [[CAGradientLayer alloc] init];
    shadowLayer.colors =@[
                         [UIColor colorWithWhite:0 alpha:1],
                         [UIColor colorWithWhite:0 alpha:0.5],
                         [UIColor colorWithWhite:1 alpha:0.5]
                         ];
    shadowLayer.startPoint = CGPointMake(0, 0.5);
    shadowLayer.endPoint = CGPointMake(1, 0.5);
    shadowLayer.frame = initalFrame;
    
    UIView *shadow = [[UIView alloc] initWithFrame:initalFrame];
    shadow.backgroundColor = [UIColor clearColor];
    [shadow.layer addSublayer:shadowLayer];
    [fromVC.view addSubview:shadow];
    shadow.alpha = 0;
    
    // 动画
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:2 animations:^{
//        fromVC.view.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
//        shadow.alpha = 1.0;
        fromVC.view.alpha = 0.0;
        toVC.view.alpha = 1.0;
    } completion:^(BOOL finished) {
//        fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
//        fromVC.view.layer.position = CGPointMake(CGRectGetMidX(initalFrame), CGRectGetMidY(initalFrame));
//        fromVC.view.layer.transform = CATransform3DIdentity;
//        [shadow removeFromSuperview];
        
        [transitionContext completeTransition:YES];
    }];
}

@end
