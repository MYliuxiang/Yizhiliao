//
//  FindVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "FindVC.h"

@interface FindVC ()<AVCaptureMetadataOutputObjectsDelegate,CAAnimationDelegate>//用于处理采集信息的代理
{
    AVCaptureSession *session;//输入输出的中间桥梁
    AVCaptureDevice *device;
}

@property(nonatomic, strong) NSMutableArray *circleArray;
@property (nonatomic,retain) WKFRadarView *radarView;
@property (nonatomic, strong) UIView *pointsView;
@property (nonatomic, strong) NSMutableArray *pointsViewArray;
@property (nonatomic,retain) NSMutableArray *pointsModels;
@property (nonatomic,retain) SelectedModel *displayModel;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,retain) NSTimer *threeTimer;
@property (nonatomic,assign) int time;
@property (nonatomic,retain) NSTimer *callTimer;


@end

@implementation FindVC

- (UIView *)pointsView{
    if (_pointsView == nil) {
        _pointsView = [[UIView alloc]initWithFrame:CGRectMake(0, 63 + 30, kScreenWidth, kScreenWidth)];
        
        [self.view addSubview:_pointsView];
    }
    return _pointsView;
}

- (NSMutableArray *)pointsViewArray{
    if (_pointsViewArray == nil) {
        _pointsViewArray = [NSMutableArray array];
    }
    return _pointsViewArray;
}


- (NSMutableArray *)circleArray{
    if (_circleArray == nil) {
        _circleArray = [NSMutableArray array];
    }
    return _circleArray;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device2 in devices) {
        if ([device2 position] == position) {
            return device2;
        }
    }
    return nil;
}


- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.text = @"發現";
    
    self.pointsModels = [NSMutableArray array];
    self.finBtn.layer.cornerRadius = 22;
    self.finBtn.layer.masksToBounds = YES;
    //获取摄像设备
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //設定代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    AVCaptureDeviceInput *newVideoInput;
    newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:nil];

    [session addInput:newVideoInput];
//    [session addOutput:output];
    //設定扫码支持的编码格式(如下設定条形码和二维码兼容)
//    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    self.time = 0;
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame=CGRectMake(0, 63, kScreenWidth,kScreenHeight - 63 - 49);
    [self.view.layer insertSublayer:layer above:0];
    [self.view addSubview:self.finBtn];
    //开始捕获
    [session startRunning];
    
    _findView.frame = CGRectMake(0, 63, kScreenWidth, kScreenHeight - 64 - 48);
    _findView.hidden = YES;
    [self.view addSubview:_findView];
    
    UIToolbar *toolbar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _findView.frame.size.width, _findView.frame.size.height)];
    toolbar1.barStyle = UIBarStyleDefault;
    [_findView insertSubview:toolbar1 atIndex:0];
    
    _findBgView.frame = CGRectMake(0, 63, kScreenWidth, kScreenHeight - 64 - 48);
    _findBgView.hidden = YES;
    [self.view addSubview:_findBgView];
    
    self.findCardView.layer.borderColor = [MyColor colorWithHexString:@"#ffffff"].CGColor;
    self.findCardView.layer.borderWidth = 3;
    self.findCardView.layer.masksToBounds = YES;
    self.findCardView.layer.cornerRadius = 5;
    self.rechargeBtn.layer.masksToBounds = YES;
    self.rechargeBtn.layer.cornerRadius = 22;
    
    NSString *labelText = self.tishiLabel.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(5)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.tishiLabel.attributedText = attributedString;

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [session stopRunning];
    [_radarView stopAnimation];
    for (JXRadarPointView *item in self.pointsViewArray) {
        [item removeFromSuperview];
    }
    [self.pointsViewArray removeAllObjects];
    if(_callTimer){
        [_callTimer invalidate];
        _callTimer = nil;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_threeTimer) {
        [_threeTimer invalidate];
        _threeTimer = nil;
    }

    if (!self.first) {
        NSDictionary *params;
        params = @{@"action":@(1)};
        [WXDataService requestAFWithURL:Url_behavior params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    
                    
                }else{    //请求失败
                    //                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                    //                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    //                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    //                        [SVProgressHUD dismiss];
                    //                    });
                    
                }
            }
            
        } errorBlock:^(NSError *error) {
            
            
        }];
        
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [session startRunning];
    
    self.findBgView.hidden = YES;
    if (!self.findView.hidden) {
        [self getMatchUser];
        [_radarView startAnimation];

    }
    
    self.first = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)findAC:(id)sender {
    
    if (self.radarView != nil) {
        [self.radarView removeFromSuperview];
        self.radarView = nil;
    }
    [UIView animateWithDuration:.35 animations:^{
        self.findView.hidden = NO;
    } completion:^(BOOL finished) {
        
        NSString *urlstr = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:Portrait]];
        _radarView = [[WKFRadarView alloc]initWithFrame:CGRectMake(0, 63 + 10, kScreenWidth, kScreenWidth) andThumbnail:urlstr];
        [self.findView addSubview:_radarView];
        [_radarView startAnimation];
        [self getMatchUser];
    }];
    
   
}

- (void)getMatchUser
{
    NSDictionary *params;
    params = @{@"first":@(self.first)};

    [WXDataService requestAFWithURL:Url_match params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                self.first = NO;

                NSMutableArray *marray = [NSMutableArray array];
                NSArray *array = result[@"data"][@"broadcasters"];
                for (NSDictionary *subDic in array) {
                    SelectedModel *model = [SelectedModel mj_objectWithKeyValues:subDic];
                    [marray addObject:model];
                    if (model.selected) {
                        self.displayModel = model;
                    }
                }

                self.pointsModels = marray;
                
                for (JXRadarPointView *item in self.pointsViewArray) {
                    [item removeFromSuperview];
                }
                [self.pointsViewArray removeAllObjects];
                
                 _timer =  [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(showPoint:) userInfo:nil repeats:YES];
                
                
            }else{    //请求失败
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
        
    }];

}

- (void)showPoint:(NSTimer *)timer
{

    if (self.pointsModels.count < 8) {
        
        if (_time == 8) {
            
            if (timer) {
                
                [self disaplayFindCard:self.displayModel];
                [_timer invalidate];
                _timer = nil;
                _time = 0;
            }
            
        }
    }else{
        
        if (_time == self.pointsModels.count) {
            
            if (timer) {
                
                [self disaplayFindCard:self.displayModel];
                [_timer invalidate];
                _timer = nil;
                _time = 0;
            }
            
        }
    }
    
    
    if (_time > self.pointsModels.count) {
        
        return;
    }
    
    if(self.pointsViewArray.count == 3){
            JXRadarPointView *dismisspointView = self.pointsViewArray[0];
        
       
        
        // 6.动画延迟时间
       [UIView animateWithDuration:1.5 animations:^{
           dismisspointView.alpha = 0;
       } completion:^(BOOL finished) {
          
       }];
        [dismisspointView removeFromSuperview];
        [self.pointsViewArray removeObject:dismisspointView];
        
    }

    JXRadarPointView *pointView = [[JXRadarPointView alloc]initWithFrame:CGRectMake(0, 0, 96, 96)];
    pointView.tag = _time;
    pointView.userInteractionEnabled = YES;
    pointView.model = self.pointsModels[_time];
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [pointView addGestureRecognizer:tap];
    CGPoint center;
    
    do {
        
        // 2.随机角度
        NSString *jiaodu = [NSString stringWithFormat:@"%d",arc4random()%360];
        // 计算半径
        int radarradius = kScreenWidth * 0.5 - 48 - 45 - 48;
        int banban = (arc4random()%radarradius) + 45 + 48;
        NSString *banjing = [NSString stringWithFormat:@"%d",banban];
        
        pointView.pointAngle = jiaodu;
        pointView.pointRadius = banjing;
        //方向(角度)
        int posDirection = jiaodu.intValue;
        //距离(半径)
        int posDistance = banjing.intValue;
        
        // 4.计算坐标点
        center = CGPointMake(kScreenWidth / 2.0 +posDistance * cos(posDirection * M_PI / 180), kScreenWidth / 2.0 + posDistance * sin(posDirection * M_PI /180));
        pointView.center = center;
        
    } while ([self itemFrameIntersectsInOtherItem:pointView]);
    
    
    
    // 5.展示动画
    pointView.alpha = 0.0;
    CGAffineTransform fromTransform =
    CGAffineTransformScale(pointView.transform, 0.1, 0.1);
    [pointView setTransform:fromTransform];
    
    CGAffineTransform toTransform = CGAffineTransformConcat(pointView.transform,  CGAffineTransformInvert(pointView.transform));
    
    // 6.动画延迟时间
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    pointView.alpha = 1.0;
    [pointView setTransform:toTransform];
    [UIView commitAnimations];

    [self.pointsView addSubview:pointView];
    [self.pointsViewArray addObject:pointView];

    _time++;
    

}

-(BOOL)itemFrameIntersectsInOtherItem:(JXRadarPointView *)pointView
{
    
    CGPoint p = self.pointsView.center;
    float cdistance = sqrt(pow((pointView.center.x - p.x), 2) + pow((pointView.center.y - p.y), 2));
    
    if (cdistance < 93) {
        return YES;
    }
    
    for (JXRadarPointView *item in self.pointsViewArray) {
        
        CGPoint p1 = pointView.center;
        CGPoint p2 = item.center;

        float distance = sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2));

        if (distance < 96) {
            return YES;
        }
    }
    return NO;
}

- (void)tap:(UITapGestureRecognizer *)tap{
    
    JXRadarPointView *pointView = (JXRadarPointView *)tap.view;
    //    [self disaplayFindCard:model];
    
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
        _time = 0;
        
    }
    
    SelectedModel *model = self.pointsModels[pointView.tag];
    PersonalVC *vc = [[PersonalVC alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)disaplayFindCard:(SelectedModel *)model
{
    
    [self.thumbImage sd_setImageWithURL:[NSURL URLWithString:model.portrait]];
    
    self.rechargeBtn.hidden = YES;
    self.displayModel = model;
    self.tishiLabel.text = @"已為您匹配到一位有緣人\n3秒後將發起視訊通話";
    self.nickLabel.text = model.nickname;
   
    self.placelabel.text = [[CityTool sharedCityTool] getCityWithCountrieId:model.country WithprovinceId:model.province WithcityId:model.city];
    
    if (self.placelabel.text.length == 0) {
        
        self.mapImage.hidden = YES;
    }
    
    Charge *charge;
    for (Charge *mo in model.charges) {
        if (mo.uid == model.charge) {
            charge = mo;
        }
    }
    self.priceLabel.text = charge.name;
   
    [self.view bringSubviewToFront:self.findBgView];
    [UIView animateWithDuration:1 animations:^{
        self.findBgView.hidden = NO;
    } completion:^(BOOL finished) {
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.fillMode = kCAFillModeBoth;
        animationGroup.duration = .35;        animationGroup.repeatCount = 1;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fromValue = [NSNumber numberWithDouble:0 ];
        scaleAnimation.toValue = [NSNumber numberWithDouble:1];
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:0.1],[NSNumber numberWithDouble:0.2],[NSNumber numberWithDouble:0.35]];
        opacityAnimation.keyTimes = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:0.25],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:1.0]];
        animationGroup.animations = @[scaleAnimation,opacityAnimation];
        
        [self.findCardView.layer addAnimation:animationGroup forKey:@"pulsing"];
    }];
    
   _threeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(call) userInfo:nil repeats:NO];

}

- (void)call
{
    self.tishiLabel.text = @"正在发起通话…";
    SelectedModel *model = self.displayModel;
    
    if (_threeTimer) {
        [_threeTimer invalidate];
        _threeTimer = nil;
    }
    [UIView animateWithDuration:.35 animations:^{
        self.findBgView.hidden = YES;
    } completion:^(BOOL finished) {
        
        [self getMatchUser];
        
    }];

    
    if ([AppDelegate shareAppDelegate].netStatus == NotReachable) {
       
        
        [SVProgressHUD showWithStatus:@"当前网络不可用，请检查您的网络設定"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIView animateWithDuration:.35 animations:^{
                self.findBgView.hidden = YES;
            } completion:^(BOOL finished) {
                
                [self getMatchUser];
                
            }];
            
        });

    
               return;
    }
    
    if (model.state == 2) {
        
        
        [SVProgressHUD showWithStatus:@"当前用户正在忙碌"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIView animateWithDuration:.35 animations:^{
                self.findBgView.hidden = YES;
            } completion:^(BOOL finished) {
                
                [self getMatchUser];
                
            }];
            
        });

               return;
    }
    AppDelegate *app = [AppDelegate shareAppDelegate];
    if(![app.inst isOnline]){
        
        [SVProgressHUD showWithStatus:@"您正处于离线状态"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIView animateWithDuration:.35 animations:^{
                self.findBgView.hidden = YES;
            } completion:^(BOOL finished) {
                
                [self getMatchUser];
                
            }];
            
        });

        return;
    }
    [self videoCallAC:model];

}

- (void)videoCallAC:(SelectedModel *)model
{
    NSDictionary *params;
    params = @{@"uid":model.uid};
    [WXDataService requestAFWithURL:Url_chatvideocall params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSString *channel = [NSString stringWithFormat:@"%@",result[@"data"][@"channel"]];
                VideoCallView *video = [[VideoCallView alloc] initVideoCallViewWithChancel:channel withUid:model.uid withIsSend:YES];
                [video show];
                
            }else{    //请求失败
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    
                    if ([[result objectForKey:@"result"] integerValue] == 8) {
                        
                    self.tishiLabel.text = @"啊噢...你的餘額不足\n儲值后立刻发起通话!";
                    self.rechargeBtn.hidden = NO;
                        
                    }
                    
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
    }];
}



- (IBAction)rechargeAC:(id)sender {
    
    AccountVC *vc = [[AccountVC alloc] init];
    vc.isCall = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    vc.clickBlock = ^{
        
        [self call];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
- (IBAction)closeAC:(id)sender {
    
    
    if (_threeTimer) {
        [_threeTimer invalidate];
        _threeTimer = nil;
    }
       [UIView animateWithDuration:.35 animations:^{
           self.findBgView.hidden = YES;
       } completion:^(BOOL finished) {
           
           [self getMatchUser];
           
       }];
    
    
}

- (IBAction)closeMatch:(id)sender {
    
    [_radarView stopAnimation];
    for (JXRadarPointView *item in self.pointsViewArray) {
        [item removeFromSuperview];
    }
    [self.pointsViewArray removeAllObjects];
    if(_callTimer){
        [_callTimer invalidate];
        _callTimer = nil;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_threeTimer) {
        [_threeTimer invalidate];
        _threeTimer = nil;
    }
    self.findView.hidden = YES;
}
@end
