//
//  ZYLauchMovieViewController.h
//  Movie
//
//  Created by 张永强 on 16/10/27.
//  Copyright © 2016年 张永强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "LoginVC.h"
#import "MainTabBarController.h"
#import "PresentTransition.h"
#import <UAProgressView.h>


@interface ZYLauchMovieViewController : AVPlayerViewController<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UAProgressView *progressView;


@end
