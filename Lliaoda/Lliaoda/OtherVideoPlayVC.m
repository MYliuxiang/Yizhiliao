//
//  OtherVideoPlayVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "OtherVideoPlayVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface OtherVideoPlayVC ()
@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;
@property (nonatomic, strong) NSString *from;

@property (nonatomic, strong) UIImage *videoCover;
@property (nonatomic, assign) NSTimeInterval enterTime;
@property (nonatomic, assign) BOOL hasRecordEvent;
@property (nonatomic,strong) UIImageView *hidenImageView;
@end

@implementation OtherVideoPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.backView addGestureRecognizer:tap];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.videoPlayer = [[MPMoviePlayerController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayer];
    
    [self.videoPlayer.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    self.videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.videoPlayer.view atIndex:0];
    [self.videoPlayer prepareToPlay];
    self.videoPlayer.controlStyle = MPMovieControlStyleNone;
    self.videoPlayer.shouldAutoplay = YES;
    self.videoPlayer.repeatMode = MPMovieRepeatModeNone;
    self.videoPlayer.scalingMode = MPMovieScalingModeAspectFill;
    self.title = NSLocalizedString(@"PreView", nil);
    
    
    self.videoPlayer.contentURL = self.videoUrl;
    [self.videoPlayer play];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    [self buildNavUI];
    _enterTime = [[NSDate date] timeIntervalSince1970];
    
}

- (void)tap
{
    if (self.giftsView.top != kScreenHeight) {
        
        
        [UIView animateWithDuration:.35 animations:^{
            
            self.backView.hidden = YES;
            self.giftsView.top = kScreenHeight;
            
        } completion:^(BOOL finished) {
            
        }];
    }

}

- (void)buildNavUI
{
    
    self.hidenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        self.hidenImageView.image = [self coverIamgeAtTime:1];
        
    });
    [self.view addSubview:self.hidenImageView];
    
    UIView *imageView = [[UIView alloc] init];
    imageView.frame = CGRectMake(0, 0, kScreenWidth, 64);
    imageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    imageView.backgroundColor = [UIColor clearColor];
    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
//    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
//    cancelBtn.frame = CGRectMake(10, 20, 44, 44);
//    [imageView addSubview:cancelBtn];
//    
//    UIButton *Done = [UIButton buttonWithType:UIButtonTypeCustom];
//    [Done addTarget:self action:@selector(doneAc) forControlEvents:UIControlEventTouchUpInside];
//    [Done setTitle:LXSring(@"確定") forState:UIControlStateNormal];
//    Done.frame = CGRectMake(kScreenWidth - 54, 20, 44, 44);
//    [imageView addSubview:Done];
//    [self.view addSubview:imageView];
    
    self.headerView.layer.cornerRadius = 15;
    self.headerView.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 15;
    self.headerImage.layer.masksToBounds = YES;
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:_model.portrait]];
    self.nickLabel.text = _model.nickname;
    
}

- (void)setModel:(PersonModel *)model
{
    _model = model;

}

- (void)commit
{
    
}

#pragma mark - notification
#pragma state
- (void)stateChanged
{
    switch (self.videoPlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            self.hidenImageView.hidden = YES;
            [SVProgressHUD dismiss];
            break;
        case MPMoviePlaybackStatePaused:
            
            [SVProgressHUD showWithStatus:@"Loading..."];
            break;
        case MPMoviePlaybackStateStopped:
            [SVProgressHUD dismiss];
            
            break;
        default:
            break;
    }
}


-(void)videoFinished:(NSNotification*)aNotification{
    int value = [[aNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (value == MPMovieFinishReasonPlaybackEnded) {   // 視訊播放结束
        //        [self DoneAction];
        [SVProgressHUD dismiss];
        
    }
}


- (void)trackPreloadingTime
{
    
}

- (void)dismissAction
{
    [self.videoPlayer stop];
    self.videoPlayer = nil;
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)doneAc
{
    [self.videoPlayer stop];
    self.videoPlayer = nil;
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)DoneAction
{
    [self.videoPlayer stop];
    self.videoPlayer = nil;
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.videoPlayer pause];
    [SVProgressHUD dismiss];

//    self.videoPlayer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.videoPlayer play];

    
}



- (void)captureImageAtTime:(float)time
{
    [self.videoPlayer requestThumbnailImagesAtTimes:@[@(time)] timeOption:MPMovieTimeOptionNearestKeyFrame];
}

- (void)captureFinished:(NSNotification *)notification
{
    self.videoCover = notification.userInfo[MPMoviePlayerThumbnailImageKey];
    if (self.videoCover == nil) {
        self.videoCover = [self coverIamgeAtTime:1];
    }
}


- (UIImage*)coverIamgeAtTime:(NSTimeInterval)time {
    
    [self.videoPlayer requestThumbnailImagesAtTimes:@[@(time)] timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : [UIImage new];
    
    return thumbnailImage;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (IBAction)giftAC:(id)sender {
    
    [self newgiftView];
    [self _loadData1];
    self.giftsView.pmodel = self.model;
    self.giftsView.isVideoBool = NO;
    [UIView animateWithDuration:.35 animations:^{
        self.giftsView.top = kScreenHeight - 300;
        self.backView.hidden = NO;

    } completion:^(BOOL finished) {
        
    }];
    
    [self.giftsView.chonBtn addTarget:self action:@selector(chongAC:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)chongAC:(UIButton *)sender
{
    
    
}

#pragma mark - 获取用户钻石数量
- (void)_loadData1
{
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSString *deposit = [NSString stringWithFormat:@"%@",result[@"data"][@"deposit"]];
                NSString *str = [NSString stringWithFormat:LXSring(@"余额:%@鑽"),deposit];
                //                NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:str];
                //                [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(3, deposit.length)];
                //                [self newgiftView];
                self.giftsView.elabel.text = str;
                NSLog(@"%@", self.giftsView.elabel.text);
            } else{
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
            }
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

- (void)newgiftView{
    
    if (self.giftsView == nil) {
        
        self.giftsView = [[GiftsView alloc] initGiftsView];
    }
    
    [self.view addSubview:self.giftsView];
    
}




- (IBAction)closeVideoAC:(id)sender {
    
    [self.videoPlayer stop];
    self.videoPlayer = nil;
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
