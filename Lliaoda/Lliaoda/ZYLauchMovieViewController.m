//
//  ZYLauchMovieViewController.m
//  Movie
//
//  Created by 张永强 on 16/10/27.
//  Copyright © 2016年 张永强. All rights reserved.
//

#import "ZYLauchMovieViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"


@interface ZYLauchMovieViewController ()
/** 播放开始之前的图片 */
@property (nonatomic , strong)UIImageView *startPlayerImageView;
/** 播放中断时的图片 */
@property (nonatomic , strong)UIImageView *pausePlayerImageView;
/** 定时器 */
@property (nonatomic , strong)NSTimer *timer;
/** 结束按钮 */
@property (nonatomic , strong)UIButton *enterMainButton;


@end

@implementation ZYLauchMovieViewController
- (BOOL)shouldAutorotate {
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   // 設定界面
    [self setupView];
    //添加监听
    [self addNotification];
    //初始化視訊
    [self prepareMovie];
    
    self.progressView = [[UAProgressView alloc] initWithFrame:CGRectMake(kScreenWidth - 60,20, 40, 40)];
    self.progressView.tintColor = Color_nav;
    self.progressView.lineWidth = 1.0;
    self.progressView.progress = 0;
    [self.view addSubview:self.progressView];
    
    __weak ZYLauchMovieViewController *this = self;
    self.progressView.didSelectBlock = ^(UAProgressView *progressView) {
        
        [this enterMain];
    };
    
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _textLabel.font = [UIFont systemFontOfSize:12];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = self.progressView.tintColor;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.text = @"15秒";
    self.progressView.centralView = _textLabel;
    
    [self addProgressObserver];
}

-(void)addProgressObserver{
    AVPlayerItem *playerItem=self.player.currentItem;
    //这里設定每秒执行一次
    __weak ZYLauchMovieViewController *this = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([playerItem duration]);
        _textLabel.text = [NSString stringWithFormat:@"%.0f秒",total - current];
        NSLog(@"当前已经播放%.2fs.",current);
        if (current){
            
            [this.progressView setProgress:current / total animated:YES];
        }
    }];
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
    self.timer = nil;
    self.player = nil;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

#pragma mark -- 初始化視訊
- (void)prepareMovie {
    //首次运行
    NSString *filePath = nil;
    if (![self isFirstLauchApp]) {
        //第一次安装
        filePath = [[NSBundle mainBundle] pathForResource:@"v1.0版本启动动画定版.mp4.m4v" ofType:nil];
        [self setIsFirstLauchApp:YES];
    }else {
          filePath = [[NSBundle mainBundle] pathForResource:@"v1.0版本启动动画定版.mp4.m4v" ofType:nil];
    }
   //初始化player
    self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
    self.showsPlaybackControls = NO;
    //播放視訊
    [self.player play];
    
}


#pragma mark -- 初始化视图逻辑
- (void)setupView {
    self.startPlayerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lauch"]];
    _startPlayerImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.contentOverlayView addSubview:_startPlayerImageView];
    //是否是第一次进入視訊
//    if (![self isFirstLauchApp]) {
        //設定进入主界面的按钮
//        [self setupEnterMainButton];
//    }
}
- (void)setupEnterMainButton {
    self.enterMainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _enterMainButton.frame = CGRectMake(24, kScreenHeight - 32 - 48, kScreenWidth - 48, 48);
    _enterMainButton.layer.borderWidth =1;
    _enterMainButton.layer.cornerRadius = 24;
    _enterMainButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
    _enterMainButton.hidden = YES;
    [self.view addSubview:_enterMainButton];
    [_enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    //設定定时器当視訊播放到第三秒时 展示进入应用
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showEnterMainButton) userInfo:nil repeats:YES];
    
}

#pragma mark -- 进入应用和显示进入按钮
- (void)enterMainAction:(UIButton *)btn {
    //視訊暂停
    [self.player pause];
    self.pausePlayerImageView = [[UIImageView alloc] init];
    _pausePlayerImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.contentOverlayView addSubview:_pausePlayerImageView];
    self.pausePlayerImageView.contentMode = UIViewContentModeScaleAspectFit;
    //获取当前暂停时的截图
    [self getoverPlayerImage];
}

- (void)getoverPlayerImage {
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:self.player.currentItem.asset];
    gen.appliesPreferredTrackTransform = YES;
    NSError *error = nil;
    CMTime actualTime;
    CMTime now = self.player.currentTime;
    [gen setRequestedTimeToleranceAfter:kCMTimeZero];
    [gen setRequestedTimeToleranceBefore:kCMTimeZero];
    CGImageRef image = [gen copyCGImageAtTime:now actualTime:&actualTime error:&error];
    if (!error) {
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        self.pausePlayerImageView.image = thumb;
    }
    NSLog(@"%f , %f",CMTimeGetSeconds(now),CMTimeGetSeconds(actualTime));
    NSLog(@"%@",error);
    //視訊播放结束
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self moviePlaybackComplete];
    });
    
}
//显示进入按钮
- (void)showEnterMainButton {
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:self.player.currentItem.asset];
    gen.appliesPreferredTrackTransform = YES;
    NSError *error = nil;
    CMTime actualTime;
    CMTime now = self.player.currentTime;
    [gen setRequestedTimeToleranceAfter:kCMTimeZero];
    [gen setRequestedTimeToleranceBefore:kCMTimeZero];
    [gen copyCGImageAtTime:now actualTime:&actualTime error:&error];
    NSInteger currentPlayBackTime = (NSInteger)CMTimeGetSeconds(actualTime);
    if (currentPlayBackTime >= 3) {
        self.enterMainButton.hidden = NO;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.enterMainButton.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.enterMainButton.alpha = 1;
            } completion:nil];
        });
    }
    if (currentPlayBackTime > 5) {
        //防止没有显现出来
        self.enterMainButton.alpha = 1;
        self.enterMainButton.hidden = NO;
        [self.timer invalidate];
        self.timer = nil;
    }
}
//进入主界面
- (void)enterMain {
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    UIViewController *main = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
//    delegate.window.rootViewController = main;
//    [delegate.window makeKeyWindow];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.transitioningDelegate = self;
        LoginVC *loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
        loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        loginVC.transitioningDelegate = self;
        [self presentViewController:loginVC animated:YES completion:^{
            
            [self.player pause];
            self.player = nil;
            
        }];
    
//    [self isLogin];
}

// present动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[PresentTransition alloc] init];
}



- (void)isLogin
{
    
    UIWindow *window = [AppDelegate shareAppDelegate].window;
    BaseNavigationController *baseNAV;
    NSString *expire = [LXUserDefaults objectForKey:Expire];
    if (expire == nil) {
        
        //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        MainTabBarController *mantvc = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
        //        self.window.rootViewController = mantvc;
        //
        //        return;
        LoginVC *loginVC = [[LoginVC alloc]init];
        baseNAV = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        window.rootViewController =baseNAV;
        return;
    }
    NSDate* expiredate = [NSDate dateWithTimeIntervalSince1970:[expire doubleValue]/ 1000.0];
    NSComparisonResult result = [expiredate compare:[NSDate date]];
    
    
    if (result == NSOrderedAscending ) {
        //設定标识
        
        LoginVC *loginVC = [[LoginVC alloc]init];
        baseNAV = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        window.rootViewController =baseNAV;
        
        
        
    } else if(result == NSOrderedSame){
        
        
        LoginVC *loginVC = [[LoginVC alloc]init];
        baseNAV = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        window.rootViewController =baseNAV;
        
        
    }else{
        
        //        [self loginAgoraSignaling];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainTabBarController *mantvc = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
        window.rootViewController = mantvc;
        
    }
    
    
}


#pragma mark -- 监听以及实现方法
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];//进入前台
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    if ([self isFirstLauchApp]) {
        //第二次进入app視訊需要直接结束
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];//視訊播放结束
    }else {
        //第一次进入app視訊需要轮播
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];//視訊播放结束
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackStart) name:AVPlayerItemTimeJumpedNotification object:nil];//播放开始
}

-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self.player play];
        }
    }
    
    //    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    //        NSLog(@"%@:%@",key,obj);
    //    }];
}

//再一次播放視訊
- (void)moviePlaybackAgain {
    self.startPlayerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lauchAgain"]];
    _startPlayerImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.contentOverlayView addSubview:_startPlayerImageView];
    [self.pausePlayerImageView removeFromSuperview];
    self.pausePlayerImageView = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"v1.0版本启动动画定版.mp4.m4v" ofType:nil];
    //初始化player
    self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
    self.showsPlaybackControls = NO;
    //播放視訊
    [self.player play];
}
//开始播放
- (void)moviePlaybackStart {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.startPlayerImageView removeFromSuperview];
        self.startPlayerImageView = nil;
    });
}
//視訊播放完成
- (void)moviePlaybackComplete {
    //发送推送之后就删除  否则 界面显示有问题
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
    [UIView animateWithDuration:.35 animations:^{
        
        self.startPlayerImageView.alpha = 0;
        self.pausePlayerImageView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.startPlayerImageView removeFromSuperview];
        self.startPlayerImageView = nil;
        [self.pausePlayerImageView removeFromSuperview];
        self.pausePlayerImageView = nil;

    }];
    
    
    if (self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    //进入主界面
    [self enterMain];
}

- (void)viewWillEnterForeground
{
    NSLog(@"app enter foreground");
    if (!self.player) {
        
        
    }
    //播放視訊
    [self.player play];
}

#pragma mark -- 是否第一次进入app
- (BOOL)isFirstLauchApp {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsFirstLauchApp];
}

- (void)setIsFirstLauchApp:(BOOL)isFirstLauchApp
{
    [[NSUserDefaults standardUserDefaults] setBool:isFirstLauchApp forKey:kIsFirstLauchApp];
}


@end
