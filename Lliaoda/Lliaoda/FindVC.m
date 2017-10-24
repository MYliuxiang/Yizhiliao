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

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageInstantReceive:) name:Notice_onMessageInstantReceive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageInstantReceive:) name:Notice_onMessageNoData object:nil];
    
    self.text = LXSring(@"發現");
//    self.isShowMessageButton = YES;
    self.colors = @[[MyColor colorWithHexString:@"#E84969"],[MyColor colorWithHexString:@"#F1B534"],[MyColor colorWithHexString:@"#6AE8BB"],[MyColor colorWithHexString:@"#40B2F2"],[MyColor colorWithHexString:@"#6AE7BD"],[MyColor colorWithHexString:@"#F6BF33"],[MyColor colorWithHexString:@"#A753EA"]];
    [self.rechargeBtn setTitle:LXSring(@"快速儲值") forState:UIControlStateNormal];
    self.label1.text = LXSring(@"正在為您尋找有緣人");
    self.label2.text = LXSring(@"點擊任意大頭照可以進入Ta的主頁喔！");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findAC:) name:@"findVC" object:nil];
    self.pointsModels = [NSMutableArray array];
//    self.finBtn.layer.cornerRadius = 22;
//    self.finBtn.layer.masksToBounds = YES;
    UIImage *image = [[UIImage imageNamed:@"tishitankuang"] stretchableImageWithLeftCapWidth:12  topCapHeight:5];
    [self.finBtn setBackgroundImage:image forState:UIControlStateNormal];
//    [self.finBtn setTitle:LXSring(@"發現有緣人") forState:UIControlStateNormal];
    [self.finBtn setTitle:LXSring(@"点击圆形按钮，开始匹配~") forState:UIControlStateNormal];
    self.finBtn.userInteractionEnabled = NO;
    self.stateView.layer.cornerRadius = 3;
    self.stateView.layer.masksToBounds = YES;
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

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted|| authStatus == AVAuthorizationStatusDenied) {
        
        // 获取摄像头失败
        
    }else{
        
        // 获取摄像头成功
        [session addInput:newVideoInput];

    }
    
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
                    
                }
            }
            
        } errorBlock:^(NSError *error) {
            
        }];
        
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

                NSArray *arr = result[@"data"];
                if (arr.count) {
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
                    
                    NSArray *charges = result[@"data"][@"charges"];
                    NSMutableArray *mc = [NSMutableArray array];
                    for (NSDictionary *subDic in charges) {
                        Charge *model = [Charge mj_objectWithKeyValues:subDic];
                        [mc addObject:model];
                    }
                    
                    self.charges = mc;
                    for (int i = 0; i < self.pointsModels.count; i++) {
                        SelectedModel *model = self.pointsModels[i];
                        if (model.selected) {
                            
                            if (self.pointsModels.count> 8) {
                                
                                [self.pointsModels exchangeObjectAtIndex:i withObjectAtIndex:7];
                            }else{
                                
                                [self.pointsModels exchangeObjectAtIndex:i withObjectAtIndex:self.pointsModels.count - 1];
                            }
                            
                            
                            
                        }
                    }
                    
                    
                    for (JXRadarPointView *item in self.pointsViewArray) {
                        [item removeFromSuperview];
                    }
                    [self.pointsViewArray removeAllObjects];
                    
                    self.colorIndex = arc4random()%7;
                    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(showPoint:) userInfo:nil repeats:YES];
                }
                
                
                
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
        
        
        if (_time == self.pointsModels.count) {
            
            if (timer) {
                
                [self disaplayFindCard:self.displayModel];
                [_timer invalidate];
                _timer = nil;
                _time = 0;
            }
            
        }
        
    }else{
        
        if (_time == 8) {
            
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

    JXRadarPointView *pointView = [[JXRadarPointView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    pointView.tag = _time;
    pointView.userInteractionEnabled = YES;
    pointView.model = self.pointsModels[_time];
    
    int index = self.colorIndex % 7;
    pointView.sendBordColor = self.colors[index];
    self.colorIndex++;

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
    
    if (cdistance < 70) {
        return YES;
    }
    
    for (JXRadarPointView *item in self.pointsViewArray) {
        
        CGPoint p1 = pointView.center;
        CGPoint p2 = item.center;

        float distance = sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2));

        if (distance < 70) {
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
    LxPersonVC *vc = [[LxPersonVC alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)disaplayFindCard:(SelectedModel *)model
{
    
    [self.thumbImage sd_setImageWithURL:[NSURL URLWithString:model.portrait]];
    
    self.rechargeBtn.hidden = YES;
    self.displayModel = model;
    self.tishiLabel.text = LXSring(@"已為您匹配到一位有緣人\n3秒後將發起視訊通話");
    self.nickLabel.text = model.nickname;
   
    self.placelabel.text = [[CityTool sharedCityTool] getCityWithCountrieId:model.country WithprovinceId:model.province WithcityId:model.city];
    
    
    if (model.gender == 0) {
        
        self.stateImage.image = [UIImage imageNamed:@"nansheng"];
        
        //男
    }else{
        
        self.stateImage.image = [UIImage imageNamed:@"nvsheng"];
        
    }
    
    self.statelabel.text = [InputCheck dateToOld:[NSDate dateWithTimeIntervalSince1970:model.birthday/ 1000]];
    
    if (self.placelabel.text.length == 0) {
        
        self.mapImage.hidden = YES;
    }
    
    Charge *charge;
    for (Charge *mo in self.charges) {
        if (mo.uid == model.charge) {
            charge = mo;
        }
    }
    if ([LXUserDefaults boolForKey:ISMEiGUO]){
        self.priceLabel.hidden = YES;
        self.zuanshiImageView.hidden = YES;
        
    }else{
        self.priceLabel.hidden = NO;
        self.zuanshiImageView.hidden = NO;
        self.priceLabel.text = charge.name;
    }
   
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
    
    self.tishiLabel.text = LXSring(@"正在發起通話…");
    SelectedModel *model = self.displayModel;
    
    if ([AppDelegate shareAppDelegate].netStatus == NotReachable) {
       
        
        [SVProgressHUD showWithStatus:LXSring(@"当前网络不可用，请检查您的网络設定")];
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
        
        
        [SVProgressHUD showWithStatus:LXSring(@"当前用户正在忙碌")];
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
        
        [SVProgressHUD showWithStatus:LXSring(@"您正处于离线状态")];
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
                self.findBgView.hidden = YES;
                
                NSString *channel = [NSString stringWithFormat:@"%@",result[@"data"][@"channel"]];
                VideoCallView *video = [[VideoCallView alloc] initVideoCallViewWithChancel:channel withUid:model.uid withIsSend:YES];
                [video show];
                
            }else{    //请求失败
                
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

                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    
                    if ([[result objectForKey:@"result"] integerValue] == 8) {
                        
                        //提示充值
                    self.tishiLabel.text = LXSring(@"啊噢...你的餘額不足\n儲值后立刻发起通话!");
                    self.rechargeBtn.hidden = YES;
                       
                        
                        LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"购买鑽石") message:LXSring(@"亲，你的鑽石不足，儲值才能继续視訊通话，是否购买鑽石？") style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"取消") destructiveButtonTitle:LXSring(@"快速购买") delegate:nil];
                        
                        lg.destructiveButtonBackgroundColor = Color_nav;
                        lg.destructiveButtonTitleColor = UIColorFromRGB(0x00ddcc);
                        lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                        lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                        lg.cancelButtonTitleColor = UIColorFromRGB(0x333333);
                        lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                            
                            if ([LXUserDefaults boolForKey:ISMEiGUO]){
                                AccountVC *vc = [[AccountVC alloc] init];
                                vc.isCall = YES;
                                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                                vc.clickBlock = ^{
                                    [self call];
                                };
                                [self.navigationController pushViewController:vc animated:YES];
                                
                            }else{
                                NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
                                if ([lang hasPrefix:@"id"]){
                                    AccountPayTypeVC *vc = [[AccountPayTypeVC alloc] init];
                                    vc.isCall = YES;
                                    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                                    vc.clickBlock = ^{
                                        [self call];
                                    };
                                    [self.navigationController pushViewController:vc animated:YES];
                                } else if ([lang hasPrefix:@"ar"]){
                                    AccountVC *vc = [[AccountVC alloc] init];
                                    vc.isCall = YES;
                                    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                                    vc.clickBlock = ^{
                                        [self call];
                                    };
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }
                            
                            
                            
                        };
                        [lg showAnimated:YES completionHandler:nil];
                        
                    }
                    
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
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

    }];
}



- (IBAction)rechargeAC:(id)sender {
    if ([LXUserDefaults boolForKey:ISMEiGUO]){
        AccountVC *vc = [[AccountVC alloc] init];
        vc.isCall = YES;
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        vc.clickBlock = ^{
            [self call];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
        if ([lang hasPrefix:@"id"]){
            AccountPayTypeVC *vc = [[AccountPayTypeVC alloc] init];
            vc.isCall = YES;
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            vc.clickBlock = ^{
                [self call];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([lang hasPrefix:@"ar"]){
            AccountVC *vc = [[AccountVC alloc] init];
            vc.isCall = YES;
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            vc.clickBlock = ^{
                [self call];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
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
    TJPTabBarController *tab = [TJPTabBarController shareInstance];
    tab.button2.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeFind" object:nil];
    [_radarView stopAnimation];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setBool:NO forKey:@"IsFind"];
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

#pragma mark - LeftView红点判断
- (void)onMessageInstantReceive:(NSNotification *)notification
{
    NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@",selfuid];
    NSArray *array = [MessageCount findByCriteria:criteria];
    int count = 0;
    
    for (MessageCount *mcount in array) {
        count += mcount.count;
        
    }
    [self widthString:[NSString stringWithFormat:@"%d", count]];
    
    
}

- (void)widthString:(NSString *)string {
    int value = [string intValue];
    if (value <= 0) {
//        self.messageCountLabel.hidden = YES;
    } else {
//        self.messageCountLabel.hidden = NO;
        if (value > 0 && value < 10) {
//            self.messageCountLabel.frame = CGRectMake(self.messageButton.right - 20, 0, 15, 15);
        } else if (value >= 10 && value < 100) {
            CGSize size = [self setWidth:300 height:15 font:10 content:string];
//            self.messageCountLabel.frame = CGRectMake(self.messageButton.right - 20, 0, size.width + 6, 15);
        } else if (value >= 100) {
            string = @"99+";
            CGSize size = [self setWidth:300 height:15 font:10 content:string];
//            self.messageCountLabel.frame = CGRectMake(self.messageButton.right - 20, 0, size.width + 6, 15);
        }
//        self.messageCountLabel.text = string;
    }
}

- (void)onMessageNoData:(NSNotification *)notification {
//    self.messageCountLabel.text = @"0";
//    self.messageCountLabel.hidden = YES;
}

#pragma mark - 根据文本内容确定label的大小
- (CGSize) setWidth:(CGFloat)width height:(CGFloat)height font:(CGFloat)font content:(NSString *)content{
    UIFont *fonts = [UIFont systemFontOfSize:font];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName, nil];
    CGSize size1 = [content boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size1;
}
@end
