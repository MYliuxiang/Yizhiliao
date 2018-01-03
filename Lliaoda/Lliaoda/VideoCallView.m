//
//  VideoCallView.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/27.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoCallView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Accelerate/Accelerate.h>


@implementation VideoCallView


- (instancetype)initVideoCallViewWithChancel:(NSString *)chancel withUid:(NSString *)uid withIsSend:(BOOL)isSend
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        self.clipsToBounds = YES;
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.refuse setTitle:LXSring(@"拒绝") forState:UIControlStateNormal];
        [self.acceptBtn setTitle:LXSring(@"接受") forState:UIControlStateNormal];
        self.yeLab.text = LXSring(@"账户余额");
        [self.gotoMoneyBtn setTitle:LXSring(@"去充值") forState:UIControlStateNormal];
        self.likeLab.text = LXSring(@"互相喜欢后可私信聊天");

//        NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
//        if ([lang hasPrefix:@"ar"]) {
            self.gitfButtonCenter.constant = 40;
//            self.redBtn.hidden = YES;
//        } else {
//            self.gitfButtonCenter.constant = 40;
//            self.redBtn.hidden = NO;
//        }
        
         _instMedia = [AgoraRtcEngineKit sharedEngineWithAppId:agoreappID delegate:self];
        _inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];
        _giftCharge = 0;
        self.yuvEN = [[AgoraYuvEnhancerObjc alloc] init];
        self.yuvEN.lighteningFactor = .7;
        self.yuvEN.smoothness = .6;
        [self.yuvEN turnOn];
        
        self.gifts = [NSMutableArray array];
        
        self.isfist = YES;
        self.smallImageView = [[UIImageView alloc] init];
        self.smallImageView.layer.masksToBounds = YES;
        self.smallImageView.layer.cornerRadius = 5;
        self.smallImageView.frame = CGRectMake(kScreenWidth - kScreenWidth / 750 * 200 - 5,44 + 5, kScreenWidth / 750 * 200, kScreenWidth / 750 * 200 / 200 * 356);
        self.bigImageView.contentMode = UIViewContentModeCenter;
        self.gotoMoneyBtn.layer.masksToBounds = YES;
        self.gotoMoneyBtn.layer.cornerRadius = 15;
        
        self.isBigLocal = NO;
        //添加移动的手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        pan.delaysTouchesBegan = YES;
        self.smallImageView.userInteractionEnabled = YES;
        
        [self.smallImageView addGestureRecognizer:pan];
        [self addSubview:self.smallImageView];
        
        self.xuanzhuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.xuanzhuanButton.frame = CGRectMake(kScreenWidth - 15 - 27, self.smallImageView.bottom + 15, 27, 27);
        [self.xuanzhuanButton setImage:[UIImage imageNamed:@"quan_xuanzhuan"] forState:UIControlStateNormal];
        [self.xuanzhuanButton addTarget:self action:@selector(xuanzhuanAC:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.xuanzhuanButton];
        
        self.xuanzhuanButton.hidden = YES;
        self.smallImageView.hidden = YES;
        self.timeLabelBGView.hidden = YES;
        self.timeLabelBGView1.hidden = YES;
        self.jinbiView.hidden = YES;
        self.jinbiView1.hidden = YES;
        
        self.agreeBtn.hidden = YES;
        self.refuseBtn.hidden = YES;
        self.channel = chancel;
        self.uid = uid;
        self.isSend = isSend;
        self.footerView.hidden = YES;
        self.callTime = NO;
        self.closeBtn.hidden = YES;
        self.lowMoneyView.hidden = YES;
        [self addNotice];
        [self loadAccountWithUid:uid];
        if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
            [self loadAccountWithUid1];
        }
        
        self.redBtn.hidden = YES;
        self.giftBtn.hidden = YES;
        
        self.jinbiView.layer.cornerRadius = 15;
        self.headerBGView.layer.cornerRadius = 20;
        self.avatarImageView.layer.cornerRadius = 20;
        self.timeLabelBGView.layer.cornerRadius = 15;
        
        
        [self _loadSelfData];
        
        //从budle路径下读取音频文件　　 这个文件名是你的歌曲名字,mp3是你的音频格式
        NSString *string = [[NSBundle mainBundle] pathForResource:@"start" ofType:@"wav"];
        //把音频文件转换成url格式
        NSURL *url = [NSURL fileURLWithPath:string];
        //初始化音频类 并且添加播放文件
        NSError *error;
        _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        //設定初始音量大小
        //設定音乐播放次数  -1为一直循环
        _avAudioPlayer.numberOfLoops = -1;
        //预播放
        [_avAudioPlayer prepareToPlay];
        NSLog(@"%ld",(long)error.code);
        _avAudioPlayer.volume =  1;

        NSString *endstring = [[NSBundle mainBundle] pathForResource:@"end" ofType:@"wav"];
        //把音频文件转换成url格式
        NSURL *endurl = [NSURL fileURLWithPath:endstring];
        //初始化音频类 并且添加播放文件
        NSError *error1;
        _endPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:endurl error:&error1];
        //設定初始音量大小
        //設定音乐播放次数  -1为一直循环
        _endPlayer.volume =  1;
        _endPlayer.numberOfLoops = 1;
        //预播放
        [_endPlayer prepareToPlay];
        NSLog(@"%ld",(long)error.code);
        
    }
    return self;
}

- (void)_loadSelfData
{
    
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                self.selfModel = [Mymodel mj_objectWithKeyValues:result[@"data"]];
                NSString *deposit = [NSString stringWithFormat:@"%d",self.selfModel.deposit];
                NSString *str = [NSString stringWithFormat:LXSring(@"余额:%@鑽"),deposit];
                
//                NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:str];
//                [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(3, deposit.length)];

                [self newgiftView];
                [self newredView];
                self.giftsView.elabel.text = str;
                self.redView.eLabel.text = str;
                
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


- (void)removeNotice
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_onInviteFailed object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_onInviteReceivedByPeer object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_onInviteAcceptedByPeer object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_onInviteRefusedByPeer object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_onInviteEndByPeer object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_noMonny object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_ReceivedGift object:nil];

    

}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[AppDelegate shareAppDelegate].window rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
        
    }else{
        
        return vc;
    }
    
    return nil;
}


- (void)addNotice
{
    //呼叫失败回调(onInviteFailed)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInviteFailed ) name:Notice_onInviteFailed object:nil];
    
    //远端已收到呼叫回调(onInviteReceivedByPeer,
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInviteReceivedByPeer ) name:Notice_onInviteReceivedByPeer object:nil];
    
    //远端已接受呼叫回调(onInviteAcceptedByPeer)
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInviteAcceptedByPeer ) name:Notice_onInviteAcceptedByPeer object:nil];
    
    //当呼叫被对方拒绝时触发。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInviteRefusedByPeer ) name:Notice_onInviteRefusedByPeer object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInviteEndByPeer ) name:Notice_onInviteEndByPeer object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noMonny:) name:Notice_noMonny object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedGift:) name:Notice_ReceivedGift object:nil];
    
}



- (void)sendRed:(NSTimer *)timer
{
    if (self.gifts.count == 0) {
        
        [self.giftTimer invalidate];
        self.giftTimer = nil;
        
    }else{
        
        GiftModel *giftModel = self.gifts[0];
        NSString *userId = [NSString stringWithFormat:@"%@%@",[LXUserDefaults objectForKey:UID], giftModel.giftUid];
        AnimOperationManager *manager = [AnimOperationManager sharedManager];
        manager.parentView = self.superview;
        [manager animWithUserID:userId model:giftModel finishedBlock:^(BOOL result) {
            
        }];
        [self.gifts removeObjectAtIndex:0];
        
    }
    
}


//收到礼物
- (void)receivedGift:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *account = [NSString stringWithFormat:@"%@",userInfo[@"account"]];
    if (![account isEqualToString:self.uid]) {
        
        return;
    }
    NSDictionary *params;
    NSString *giftID = [NSString stringWithFormat:@"%@",userInfo[@"msg"][@"content"]];
    params = @{@"uid":giftID};
    [WXDataService requestAFWithURL:Url_gift params:params httpMethod:@"GET" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                RecordGiftModel *model = [RecordGiftModel  mj_objectWithKeyValues:result[@"data"]];
             
               // 礼物模型
                GiftModel *giftModel = [[GiftModel alloc] init];
                if([model.uid isEqualToString:@"-1"]){
                    //是红包
                    giftModel.giftName = [NSString stringWithFormat:@"%@:%@",self.model.nickname,model.message];
                    giftModel.headImage = [UIImage imageNamed:@"红包雨02"];
                    
                }else{
                giftModel.giftName = [NSString stringWithFormat:LXSring(@"收到%@"),model.name];
                giftModel.giftImage = model.icon;

                }
                giftModel.giftCount = 1;
                giftModel.giftUid = model.uid;
                giftModel.diamonds = model.diamonds;
                
                if([model.uid isEqualToString:@"-1"]){

                    for (int i = 0; i<model.quantity; i++) {
                        [self.gifts addObject:giftModel];
                    }

                    if (self.giftTimer == nil) {
                        
                        self.giftTimer =  [NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(sendRed:) userInfo:nil repeats:YES];
                    }
                }else{
                
                    NSString *userId = [NSString stringWithFormat:@"%@%@",account,model.uid];
                    AnimOperationManager *manager = [AnimOperationManager sharedManager];
                    manager.parentView = self.superview;
                    [manager animWithUserID:userId model:giftModel finishedBlock:^(BOOL result) {
                        
                    }];
                }
                if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
                    // 主播显示金币收益（本次通话）
                    _giftCharge = giftModel.diamonds * 10 + _giftCharge;
//                    _jinbiLabel.text = [NSString stringWithFormat:@"%d", _charge];
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

- (void)noMonny:(NSNotification *)notification
{
    
    [self stop];
    [self.endPlayer play];
    NSDictionary *userInfo = notification.userInfo;
    [SVProgressHUD showWithStatus:userInfo[@"message"][@"content"]];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self dismiss];
    });
    
}

//远端呼叫结束
- (void)onInviteEndByPeer
{
    [self stop];
    self.headeLab.text = [NSString stringWithFormat:@"%@", LXSring(@"对方取消呼叫")];
    [self.endPlayer play];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self dismiss];
    });
    
    if (self.iscalling) {
        
        long long idate = [[NSDate date] timeIntervalSince1970]*1000;
        //    int idate = [date intValue];
        __block Message *messageModel = [Message new];
        messageModel.isSender = YES;
        messageModel.isRead = NO;
        messageModel.status = MessageDeliveryState_Delivered;
        messageModel.date = idate;
        messageModel.messageID = [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate];
        messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],self.uid];
        messageModel.type = MessageBodyType_Video;
        messageModel.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        messageModel.sendUid = self.uid;
        NSString *timeStr = [self timeFormatted:self.callTime];
        messageModel.content = [NSString stringWithFormat:LXSring(@"你與%@愉快地進行了通話,時長:%@"),self.model.nickname,timeStr];
        [messageModel save];
        
        NSDictionary *msg = @{@"message":@{
                                      @"messageID":[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate],
                                      @"content":messageModel.content,
                                      @"type":@(MessageBodyType_Video),
                                      @"time":[NSString stringWithFormat:@"%lld",idate],
                                      }};
        NSString *msgStr = [InputCheck convertToJSONData:msg];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_messageVideoTime object:nil userInfo:@{@"msg":messageModel}];

        NSString *criteria1 = [NSString stringWithFormat:@"WHERE channelId = %@",self.channel];
        CallTime *call = [CallTime findFirstByCriteria:criteria1];
        
        call.channelId = [self.channel intValue];
        call.endedAt = idate;
        call.duration = self.callTime * 1000;
        call.uid = [self.uid integerValue];
        
        
        NSDictionary *params = @{@"calls":@[@{@"channelId":@(call.channelId),@"endedAt":@(call.endedAt),@"duration":@(call.duration)}]};
        
        [WXDataService requestAFWithURL:Url_chatvideoreport params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    
                    [call deleteObject];
                    
                }else{
                    [call update];
                }
            }
            
        } errorBlock:^(NSError *error) {
            [call update];
        }];
        
        
    }   

}

//当呼叫被对方拒绝时触发。
- (void)onInviteRefusedByPeer
{
    [self stop];
    self.headeLab.text = LXSring(@"对方已拒绝");
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{

        if (!self.isfist) {
            return ;
        }
        self.isfist = NO;

        self.endtime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString *startTime = [NSString stringWithFormat:@"%lld",self.starttime];
        NSString *endTime = [NSString stringWithFormat:@"%lld",self.endtime];
        NSString *uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        
        NSDictionary *dict = @{@"type" : @"call", startTime : endTime,@"uid":uid,@"endtime":endTime,@"senduid":self.uid};
        [MobClick event:@"call_end" attributes:dict];
        [self stop];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        //主动发送方
            NSDictionary *params;
            params = @{@"channel":self.channel};
            [WXDataService requestAFWithURL:Url_chatvideoreend params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
                if(result){
                    if ([[result objectForKey:@"result"] integerValue] == 0) {
                        
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
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self clearAllSubViews];
        [self removeFromSuperview];
        
        //未接通
        if (self.keytimer) {
            [self.keytimer invalidate];
            self.keytimer = nil;
        }
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self removeNotice];
        if (self.longTimer) {
            [self.longTimer invalidate];
            self.longTimer = nil;
        }
              
        if (self.giftTimer) {
            [self.giftTimer invalidate];
            self.giftTimer = nil;
        }
        
        if (_instMedia) {
            
            [_instMedia stopPreview];
            [_instMedia leaveChannel:^(AgoraRtcStats *stat) {
                
            }];
            
            [self.yuvEN turnOff];
            [AgoraRtcEngineKit destroy];
        }
        
       
    });

}

//远端已接受呼叫回调(onInviteAcceptedByPeer)
- (void)onInviteAcceptedByPeer
{
    [self stop];
    NSDictionary *params;
    params = @{@"channel":self.channel};
    [WXDataService requestAFWithURL:Url_chatvideojoin params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSString *key = result[@"data"][@"key"];
                
                self.accountLabel.text = [NSString stringWithFormat:LXSring(@"%@鑽石"),result[@"data"][@"deposit"]];
                self.lowTimeLabel.text = [NSString stringWithFormat:LXSring(@"可通话时长%@分钟"),result[@"data"][@"sustain"]];
                int sustain = [[NSString stringWithFormat:@"%@",result[@"data"][@"sustain"]] intValue];
                int peerSustain = [[NSString stringWithFormat:@"%@",result[@"data"][@"peerSustain"]] intValue];
                if(peerSustain <= 2 && peerSustain != -1 && !self.islow){
                
                    self.islow = YES;
                    [SVProgressHUD showWithStatus:LXSring(@"对方余额已经不足两分钟了")];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                        
                    });

                }
                if(sustain <= 2 && sustain != -1){
                    
                    [UIView animateWithDuration:.35 animations:^{
                        self.lowMoneyView.hidden = NO;
                    } completion:^(BOOL finished) {
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [UIView animateWithDuration:.35 animations:^{
                                self.lowMoneyView.hidden = YES;
                            } completion:^(BOOL finished) {
                                
                            }];
                            
                        });
                        
                    }];
                    
                }
                
                int code = [_instMedia joinChannelByKey:key channelName:self.channel info:nil uid:[[LXUserDefaults objectForKey:UID] integerValue] joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
                    
                }];
                if (code == 0) {
                    //成功
                }else{
                    
                }

                _keytimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(keyrew:) userInfo:nil repeats:YES];

                self.closeBtn.hidden = NO;
                
            }else{    //请求失败
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    
                    if ([[result objectForKey:@"result"] integerValue] == 8) {
                        
                        long idate = [[NSDate date] timeIntervalSince1970]*1000;
                        NSDictionary *dic = @{
                            @"message": @{
                                @"messageID": [NSString stringWithFormat:@"%@_%ld",[LXUserDefaults objectForKey:UID],idate],
                                @"event": @"call-end",
                                @"content": LXSring(@"对方餘額不足"),
                                @"time": [NSString stringWithFormat:@"%ld",idate],
                            }
                            };
                        NSString *msgStr = [InputCheck convertToJSONData:dic];
                         [_inst messageInstantSend:self.uid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%ld",[LXUserDefaults objectForKey:UID],idate]];
                        
                        LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"购买鑽石") message:LXSring(@"亲，你的鑽石不足，儲值才能继续視訊通话，是否购买鑽石？") style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"取消") destructiveButtonTitle:LXSring(@"快速购买") delegate:nil];

                        lg.destructiveButtonBackgroundColor = Color_nav;
                        lg.destructiveButtonTitleColor = UIColorFromRGB(0x00ddcc);
                        lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                        lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                        lg.cancelButtonTitleColor = UIColorFromRGB(0x333333);
                        lg.cancelHandler = ^(LGAlertView * _Nonnull alertView) {

                        };
                        lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                            if ([LXUserDefaults boolForKey:ISMEiGUO]){
                                AccountVC *vc = [[AccountVC alloc] init];
                                [[self topViewController].navigationController pushViewController:vc animated:YES];
                                
                            }else{
                                NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
                                if ([lang hasPrefix:@"id"]){
                                    AccountPayTypeVC *vc = [[AccountPayTypeVC alloc] init];
                                    [[self topViewController].navigationController pushViewController:vc animated:YES];
                                    
                                } else if ([lang hasPrefix:@"ar"]){
                                    AccountVC *vc = [[AccountVC alloc] init];
                                    [[self topViewController].navigationController pushViewController:vc animated:YES];
                                }
                            }

                        };
                        [lg showAnimated:YES completionHandler:nil];
                        [self dismiss];

                    }else{
                        [self dismiss];
                    }
                });
            }
        }
        
    } errorBlock:^(NSError *error) {
        
        [self dismiss];
        
    }];

}

//远端已收到呼叫回调(onInviteReceivedByPeer,
- (void)onInviteReceivedByPeer
{
    


}


//呼叫失败回调(onInviteFailed)
- (void)onInviteFailed
{
    [self endPlayer];
    self.headeLab.text = LXSring(@"对方暂未接听");
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self dismiss];
    });

}

- (void)loadAccountWithUid:(NSString *)uid
{
    
    NSDictionary *params;
    params = @{@"uid":uid};
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
               self.model = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
                self.nickeNameLab.text = self.model.nickname;
                if (self.model.charge == -1) {
                    self.model.charge = 100;
                }
         
                [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
                
                UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                toolbar.barStyle = UIBarStyleBlackTranslucent;
                [_bigImageView addSubview:toolbar];
                
                [self setAgroe];
                
            }else{    //请求失败
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
        [self dismiss];
    }];

}

- (void)loadAccountWithUid1
{
    
    NSDictionary *params;
    params = @{@"uid":[LXUserDefaults objectForKey:UID]};
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                self.pModel = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                if (self.pModel.charge == -1) {
                    self.pModel.charge = 100;
                }
            }else{    //请求失败
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
        [self dismiss];
    }];
    
}


- (void)setAgroe
{
    if (self.isSend) {
        //主动呼叫
        self.closeBtn.hidden = NO;
        [_instMedia setChannelProfile:AgoraRtc_ChannelProfile_Communication];
        [_instMedia enableAudio];
        
        _local = [[AgoraRtcVideoCanvas alloc] init];
        _local.uid = [[LXUserDefaults objectForKey:UID] integerValue];
        _local.view = self.bigImageView;
        _local.renderMode = AgoraRtc_Render_Hidden;
        [_instMedia setupLocalVideo:_local];
        
        _remate = [[AgoraRtcVideoCanvas alloc] init];
        _remate.uid = [self.uid integerValue];
        _remate.view = self.smallImageView;
        _remate.renderMode = AgoraRtc_Render_Hidden;
        [self.instMedia setupRemoteVideo:_remate];
        [_instMedia enableVideo];
        [_instMedia setVideoProfile:AgoraRtc_VideoProfile_360P_7 swapWidthAndHeight:false];
        [_instMedia startPreview];
        
//        [AGVideoPreProcessing registerVideoPreprocessing:_instMedia];

        self.headeLab.text = [NSString stringWithFormat:LXSring(@"正在呼叫%@..."),self.model.nickname];
        [_inst channelInviteUser:self.channel account:self.uid uid:0];
        _longTime = 0;
        _longTimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(longtime:) userInfo:nil repeats:YES];
        
    }else{
        
        //被动呼叫
        self.headeLab.text = [NSString stringWithFormat:LXSring(@"%@邀请你加入視訊通話"),self.model.nickname];
        self.agreeBtn.hidden = NO;
        self.refuseBtn.hidden = NO;
        
    }

}

- (void)longtime:(NSTimer *)timer
{
    _longTime++;
    if (_longTime == 30) {
        //超时处理
        
        if(!_iscalling){
        
            [self stop];
        [self.endPlayer play];
        self.headeLab.text = LXSring(@"对方未回应");
            
        //未接通
            
            long long idate = [[NSDate date] timeIntervalSince1970]*1000;
            NSDictionary *msg = @{@"message":@{
                                          @"messageID":[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate],
                @"content":[NSString stringWithFormat:LXSring(@"你有一个来自%@的未接来电，记得回拨哟～"), [LXUserDefaults objectForKey:NickName]],
                                          @"type":@(MessageBodyType_Video),
                                          @"time":[NSString stringWithFormat:@"%lld",idate],
                                          }};
            NSString *msgStr = [InputCheck convertToJSONData:msg];
            
            [_inst messageInstantSend:self.uid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate]];
            
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
       
            [_inst channelInviteEnd:self.channel account:self.uid uid:0];
            NSDictionary *params;
            params = @{@"channel":self.channel};
            [WXDataService requestAFWithURL:Url_chatvideorecancel params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
                if(result){
                    if ([[result objectForKey:@"result"] integerValue] == 0) {
                        
                        
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
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
        [self clearAllSubViews];
        if (self.keytimer) {
                [self.keytimer invalidate];
                self.keytimer = nil;
        }
        if (self.timer) {
            
            [self.timer invalidate];
            self.timer = nil;
        }
        if (self.longTimer) {
            
            [self.longTimer invalidate];
            self.longTimer = nil;
        }
            if (self.giftTimer) {
                [self.giftTimer invalidate];
                self.giftTimer = nil;
            }
        [self removeNotice];
            
        [_instMedia stopPreview];
        [_instMedia leaveChannel:^(AgoraRtcStats *stat) {
                
        }];
        [self.yuvEN turnOff];
        [AgoraRtcEngineKit destroy];
        [self removeFromSuperview];

    }
    }

}

- (void)layoutSubviews
{
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 20;
    
    
}

#pragma mark -触摸事件监听
-(void)locationChange:(UIPanGestureRecognizer*)p
{
    CGFloat HEIGHT = self.smallImageView.height;
    CGFloat WIDTH = self.smallImageView.width;
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(p.state == UIGestureRecognizerStateBegan)
    {
        
    }
    else if (p.state == UIGestureRecognizerStateEnded)
    {
        
    }
    if(p.state == UIGestureRecognizerStateChanged)
    {
               self.smallImageView.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        
      if(panPoint.x <= kScreenWidth/2)
        {
            //在左边
            if(panPoint.y <= 40 + HEIGHT/2 && panPoint.x >= 20+WIDTH/2)
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.smallImageView.center = CGPointMake(panPoint.x, HEIGHT/2+15);
                }];
            }
            else if(panPoint.y >= kScreenHeight-HEIGHT/2-40 && panPoint.x >= 20+WIDTH/2)
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.smallImageView.center = CGPointMake(panPoint.x, kScreenHeight-HEIGHT/2 - 15);
                }];
            }
            else if (panPoint.x <= WIDTH/2+15 && panPoint.y >= kScreenHeight-HEIGHT/2)
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.smallImageView.center = CGPointMake(WIDTH/2+15, kScreenHeight-HEIGHT/2-15);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y < HEIGHT/2  ? HEIGHT/2 + 15 :panPoint.y;
                [UIView animateWithDuration:0.15f animations:^{
                    self.smallImageView.center = CGPointMake(WIDTH/2+15, pointy);
                }];
            }
        }
        else if(panPoint.x > kScreenWidth/2)
        {
            if(panPoint.y <= 40+HEIGHT/2 && panPoint.x < kScreenWidth-WIDTH/2-20 )
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.smallImageView.center = CGPointMake(panPoint.x, HEIGHT/2 + 15);
                }];
            }
            else if(panPoint.y >= kScreenHeight-40-HEIGHT/2 && panPoint.x < kScreenWidth-WIDTH/2-20)
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.smallImageView.center = CGPointMake(panPoint.x, kScreenHeight-HEIGHT/2 - 15);
                }];
            }
            else if (panPoint.x >= kScreenWidth-WIDTH/2 - 15 && panPoint.y <= HEIGHT/2)
            {
                [UIView animateWithDuration:0.15f animations:^{
                    self.smallImageView.center = CGPointMake(kScreenWidth-WIDTH/2 - 15, HEIGHT/2 + 15);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y > kScreenHeight- HEIGHT/2 ? kScreenHeight- HEIGHT/2 - 15:panPoint.y;
                [UIView animateWithDuration:0.15f animations:^{
                    self.smallImageView.center = CGPointMake(kScreenWidth-WIDTH/2 - 15, pointy);
                }];
            }
        }
    }
}

- (void)show
{
    
    
    [self play];
    self.starttime = [[NSDate date] timeIntervalSince1970] * 100;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [[AppDelegate shareAppDelegate].window addSubview:self];
    
    for (UIView *view in [AppDelegate shareAppDelegate].window.subviews) {
        
        [view endEditing:YES];
    }
                          
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished){
        
    }];

}

//播放
-(void)play{
    
    [_avAudioPlayer play];
    
}
//停止
-(void)stop{
    _avAudioPlayer.currentTime = 0;  //当前播放时间設定为0
    [_avAudioPlayer stop];
    
}

- (void)dismiss
{
    
    if (self.iscalling) {
        
        long long idate = [[NSDate date] timeIntervalSince1970]*1000;
        //    int idate = [date intValue];
        __block Message *messageModel = [Message new];
        messageModel.isSender = YES;
        messageModel.isRead = NO;
        messageModel.status = MessageDeliveryState_Delivered;
        messageModel.date = idate;
        messageModel.messageID = [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate];
        messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],self.uid];
        messageModel.type = MessageBodyType_Video;
        messageModel.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        messageModel.sendUid = self.uid;
        NSString *timeStr = [self timeFormatted:self.callTime];
        messageModel.content = [NSString stringWithFormat:LXSring(@"你與%@愉快地進行了通話,時長:%@"),self.model.nickname,timeStr];
        [messageModel save];
        
        NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",self.uid,[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];
        
        if ([MessageCount findFirstByCriteria:criteria]) {
            
            MessageCount *count = [MessageCount findFirstByCriteria:criteria];
            count.content = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:LXSring(@"你與%@愉快地進行了通話,時長:%@"),self.model.nickname,timeStr]];
            count.count = count.count + 1;
            
            count.timeDate = idate;
            count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
            count.sendUid = self.uid;
            [count update];
            
        }else{
            
            MessageCount *count = [[MessageCount alloc] init];
            count.content = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:LXSring(@"你與%@愉快地進行了通話,時長:%@"),self.model.nickname,timeStr]];
            count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
            count.sendUid = self.uid;
            count.count = 1;
            count.timeDate = idate;
            [count save];
        }

        NSString *criteria1 = [NSString stringWithFormat:@"WHERE channelId = %@",self.channel];
        CallTime *call = [CallTime findFirstByCriteria:criteria1];
        call.channelId = [self.channel intValue];
        call.endedAt = idate;
        call.duration = self.callTime * 1000;
        call.uid = [self.uid intValue];
        
        NSDictionary *params = @{@"calls":@[@{@"channelId":@(call.channelId),@"endedAt":@(call.endedAt),@"duration":@(call.duration)}]};
        
        [WXDataService requestAFWithURL:Url_chatvideoreport params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    [call deleteObject];
                    
                }else{
                    [call update];
                }
            }
            
        } errorBlock:^(NSError *error) {
            [call update];
        }];
        

        
        NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        NSString *itemcriteria = [NSString stringWithFormat:@"WHERE uid = %@ order by timeDate DESC",selfuid];
        NSArray *array = [MessageCount findByCriteria:criteria];
        NSMutableArray *marray = [NSMutableArray arrayWithArray:array];
        int count = 0;
        for (MessageCount *mcount in marray) {
            count += mcount.count;
        }
        
        UITabBarItem *item=[[MainTabBarController shareMainTabBarController].tabBar.items objectAtIndex:[MainTabBarController shareMainTabBarController].tabBar.items.count - 2];
        // 显示
        item.badgeValue=[NSString stringWithFormat:@"%d",count];
        if(count == 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onMessageNoData object:nil];
            item.badgeValue = nil;
        }

        
        
        
        NSDictionary *msg = @{@"message":@{
                                      @"messageID":[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate],
                                      @"content":messageModel.content,
                                      @"type":@(MessageBodyType_Video),
                                      @"time":[NSString stringWithFormat:@"%lld",idate],
                                      }};
        NSString *msgStr = [InputCheck convertToJSONData:msg];

        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_messageVideoTime object:nil userInfo:@{@"msg":messageModel}];

    }
    if (!self.isfist) {
        
        return;
    }
    
    self.isfist = NO;
    self.endtime = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *startTime = [NSString stringWithFormat:@"%lld",self.starttime];
    NSString *endTime = [NSString stringWithFormat:@"%lld",self.endtime];
    NSString *uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];

    NSDictionary *dict = @{@"type" : @"call", startTime : endTime,@"uid":uid,@"endtime":endTime,@"senduid":self.uid};
    [MobClick event:@"call_end" attributes:dict];
    [self stop];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //主动发送方
    
  
    
    if(self.isSend && !_iscalling){
        
        
            [_inst channelInviteEnd:self.channel account:self.uid uid:0];
            NSDictionary *params;
            params = @{@"channel":self.channel};
            [WXDataService requestAFWithURL:Url_chatvideorecancel params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
                if(result){
                    if ([[result objectForKey:@"result"] integerValue] == 0) {
                        
                        
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
        }else{
    
    NSDictionary *params;
    params = @{@"channel":self.channel};
    [WXDataService requestAFWithURL:Url_chatvideoreend params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
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

    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
        [self clearAllSubViews];
        [self removeFromSuperview];
    
    AnimOperationManager *manager = [AnimOperationManager sharedManager];
    [AnimOperationManager attemptDealloc];
    
    if (self.keytimer) {
        [self.keytimer invalidate];
        self.keytimer = nil;
    }
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self removeNotice];
    if (self.longTimer) {
        [self.longTimer invalidate];
        self.longTimer = nil;
    }
    if (self.giftTimer) {
        [self.giftTimer invalidate];
        self.giftTimer = nil;
    }
    if (_instMedia) {
        
        [_instMedia stopPreview];
        [_instMedia leaveChannel:^(AgoraRtcStats *stat) {
            
        }];
        
        [self.yuvEN turnOff];
        [AgoraRtcEngineKit destroy];
    }
    

}

- (void)clearAllSubViews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


- (IBAction)likeAC:(id)sender {
    
}

- (IBAction)closeVideo:(id)sender {
    
    if(self.iscalling){
        
        LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"確定退出") message:LXSring(@"確定退出視訊通話吗？") style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"取消") destructiveButtonTitle:LXSring(@"確定") delegate:nil];
        lg.destructiveButtonBackgroundColor = [UIColor whiteColor];
        lg.destructiveButtonTitleColor = UIColorFromRGB(0x00ddcc);
        lg.destructiveButtonFont = [UIFont systemFontOfSize:16];

        lg.cancelButtonFont = [UIFont systemFontOfSize:16];
        lg.cancelButtonBackgroundColor = [UIColor whiteColor];
        lg.cancelButtonTitleColor = UIColorFromRGB(0x333333);
        lg.cancelHandler = ^(LGAlertView * _Nonnull alertView) {
            
        };
        
        lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
            
            
            [self dismiss];
        };
        [lg showAnimated:YES completionHandler:nil];
        
        return;
    }
    
    long long idate = [[NSDate date] timeIntervalSince1970]*1000;
    NSDictionary *msg = @{@"message":@{
                                  @"messageID":[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate],
                                  @"content":[NSString stringWithFormat:LXSring(@"你有一个来自%@的未接来电，记得回拨哟～"), [LXUserDefaults objectForKey:NickName]],
                                  @"type":@(MessageBodyType_Video),
                                  @"time":[NSString stringWithFormat:@"%lld",idate],
                                  }};
    NSString *msgStr = [InputCheck convertToJSONData:msg];
    
    [_inst messageInstantSend:self.uid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate]];
    
    
    [self dismiss];
}

- (IBAction)refuseAC:(id)sender {
    
    [self play];
    NSDictionary *params;
    params = @{@"channel":self.channel};
    [WXDataService requestAFWithURL:Url_chatvideorefuse params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                [_inst channelInviteRefuse:self.channel account:self.uid uid:0 extra:nil];
                self.headeLab.text = [NSString stringWithFormat:@"%@", LXSring(@"您已拒绝")];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self dismiss];
                });
                
            }else{    //请求失败
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
        [self dismiss];
        
    }];
    
}

- (IBAction)agreeAC:(id)sender {
    
    self.closeBtn.hidden = NO;
    [self stop];
    [_inst channelInviteAccept:self.channel account:self.uid uid:0];
    self.refuseBtn.hidden = YES;
    self.agreeBtn.hidden = YES;
    [self.instMedia setChannelProfile:AgoraRtc_ChannelProfile_Communication];
    [self.instMedia enableAudio];
    _local = [[AgoraRtcVideoCanvas alloc] init];
    _local.uid = [[LXUserDefaults objectForKey:UID] integerValue];
    _local.view = self.bigImageView;
    _local.renderMode = AgoraRtc_Render_Hidden;
    [self.instMedia setupLocalVideo:_local];
    
    _remate = [[AgoraRtcVideoCanvas alloc] init];
    
    _remate.uid = [self.uid integerValue];
    _remate.view = self.smallImageView;
    _remate.renderMode = AgoraRtc_Render_Hidden;
    [self.instMedia setupRemoteVideo:_remate];
    [self.instMedia enableVideo];
    
    [self.instMedia setVideoProfile:AgoraRtc_VideoProfile_720P_3 swapWidthAndHeight:false];
    [self.instMedia startPreview];
    
    NSDictionary *params;
    params = @{@"channel":self.channel};
    [WXDataService requestAFWithURL:Url_chatvideojoin params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSLog(@"%@",result);
                NSString *key = result[@"data"][@"key"];
                self.accountLabel.text = [NSString stringWithFormat:LXSring(@"%@鑽石"),result[@"data"][@"deposit"]];
                self.lowTimeLabel.text = [NSString stringWithFormat:LXSring(@"可通话时长%@分钟"),result[@"data"][@"sustain"]];
                int sustain = [[NSString stringWithFormat:@"%@",result[@"data"][@"sustain"]] intValue];
                int peerSustain = [[NSString stringWithFormat:@"%@",result[@"data"][@"peerSustain"]] intValue];
                
                if(peerSustain <= 2 && peerSustain != -1 && !self.islow){
                    
                    self.islow = YES;
                    [SVProgressHUD showWithStatus:LXSring(@"对方余额已经不足两分钟了")];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                        
                    });
                    
                }
                
                if(sustain <= 2 && sustain != -1){
                    
                    
                    [UIView animateWithDuration:.35 animations:^{
                        self.lowMoneyView.hidden = NO;
                    } completion:^(BOOL finished) {
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [UIView animateWithDuration:.35 animations:^{
                                self.lowMoneyView.hidden = YES;
                            } completion:^(BOOL finished) {
                                
                            }];
                            
                        });
                        
                    }];
                }
                
                int code = [_instMedia joinChannelByKey:key channelName:self.channel info:nil uid:[[LXUserDefaults objectForKey:UID] integerValue] joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
                    
                }];
                
                _keytimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(keyrew:) userInfo:nil repeats:YES];
                self.headeLab.text = LXSring(@"正在加入");
                
            }else{    //请求失败
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    if ([[result objectForKey:@"result"] integerValue] == 8) {
                        
                        long idate = [[NSDate date] timeIntervalSince1970]*1000;
                        NSDictionary *dic = @{
                                              @"message": @{
                                                      @"messageID": [NSString stringWithFormat:@"-1"],
                                                      @"event": @"call-end",
                                                      @"content": LXSring(@"对方餘額不足"),
                                                      @"time": [NSString stringWithFormat:@"%ld",idate],
                                                      }
                                              };
                        NSString *msgStr = [InputCheck convertToJSONData:dic];
                        [_inst messageInstantSend:self.uid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%ld",[LXUserDefaults objectForKey:UID],idate]];
                        
                        LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"购买鑽石") message:LXSring(@"亲，你的鑽石不足，儲值才能继续視訊通话，是否购买鑽石？") style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"取消") destructiveButtonTitle:LXSring(@"快速购买") delegate:nil];
                        lg.destructiveButtonBackgroundColor = Color_nav;
                        lg.destructiveButtonTitleColor = UIColorFromRGB(0x00ddcc);
                        lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                        lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                        lg.cancelButtonTitleColor = UIColorFromRGB(0x333333);
                        lg.cancelHandler = ^(LGAlertView * _Nonnull alertView) {

                        };
                        lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                            if ([LXUserDefaults boolForKey:ISMEiGUO]){
                                AccountVC *vc = [[AccountVC alloc] init];
                                [[self topViewController].navigationController pushViewController:vc animated:YES];
                                
                            }else{
                                NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
                                if ([lang hasPrefix:@"id"]){
                                    AccountPayTypeVC *vc = [[AccountPayTypeVC alloc] init];
                                    [[self topViewController].navigationController pushViewController:vc animated:YES];
                                    
                                } else if ([lang hasPrefix:@"ar"]){
                                    AccountVC *vc = [[AccountVC alloc] init];
                                    [[self topViewController].navigationController pushViewController:vc animated:YES];
                                }
                            }
                            
                        };
                        [lg showAnimated:YES completionHandler:nil];
                        [self dismiss];

                    }else{
                    
                        [self dismiss];
                    }
                });
            }
        }
        
    } errorBlock:^(NSError *error) {
        
        [self dismiss];
        
    }];
    
}


- (void)keyrew:(NSTimer *)timer
{

    self.keyTime++;
    if (_keyTime != 60) {
        
        return;
    }
    
    NSString *timeStr = [self timeFormatted:self.callTime];
    self.timeLab.text = timeStr;
    
    if (self.timeLabelBGView.hidden) {
        self.timeLabelBGView.hidden = NO;
        self.timeLabelBGView1.hidden = NO;
        if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
            // 主播显示金币收益（本次通话）
            self.jinbiView.hidden = NO;
            self.jinbiView1.hidden = NO;
            int charges = 0;
            for (Charge *mo in self.pModel.charges) {
                if (mo.uid == self.pModel.charge) {
                    charges = mo.value;
                }
            }
            int time1 = self.callTime / 60;
            int time2 = self.callTime % 60;
            if (time2 != 0) {
                _charge = charges * (time1 + 1) * 10 + _giftCharge;
            } else {
                _charge = charges * time1 * 10 + _giftCharge;
            }
            _jinbiLabel.text = [NSString stringWithFormat:@"%d", _charge];
        }
    }
    
    
    
    
    self.keyTime = 0;
    NSDictionary *params;
    params = @{@"channel":self.channel};
    [WXDataService requestAFWithURL:Url_chatvideorenew params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSString *key = result[@"data"][@"key"];
                self.accountLabel.text = [NSString stringWithFormat:LXSring(@"%@鑽石"),result[@"data"][@"deposit"]];
                self.lowTimeLabel.text = [NSString stringWithFormat:LXSring(@"可通话时长%@分钟"),result[@"data"][@"sustain"]];
                int sustain = [[NSString stringWithFormat:@"%@",result[@"data"][@"sustain"]] intValue];
                int peerSustain = [[NSString stringWithFormat:@"%@",result[@"data"][@"peerSustain"]] intValue];
                
                //礼物的余额界面
                NSString *deposit = [NSString stringWithFormat:@"%@",result[@"data"][@"deposit"]];
                NSString *str = [NSString stringWithFormat:LXSring(@"余额:%@鑽"),deposit];
//                NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:str];
//                [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(3, deposit.length)];
                
                [self newgiftView];
                [self newredView];
                self.giftsView.elabel.text = str;
                self.redView.eLabel.text = str;

                
                if(peerSustain <= 2 && peerSustain != -1 && !self.islow){
                    self.islow = YES;
                    [SVProgressHUD showWithStatus:LXSring(@"对方余额已经不足两分钟了")];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                        
                    });
                    
                }
                
                if(sustain <= 2 && sustain != -1){
                    
                    [UIView animateWithDuration:.35 animations:^{
                        self.lowMoneyView.hidden = NO;
                    } completion:^(BOOL finished) {
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [UIView animateWithDuration:.35 animations:^{
                                self.lowMoneyView.hidden = YES;
                            } completion:^(BOOL finished) {
                                
                            }];
                            
                        });
                        
                    }];
                }
                
                
            }else{    //请求失败
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    [self dismiss];
                    
                });
            }
        }
    } errorBlock:^(NSError *error) {
        
        [self dismiss];
        
    }];
    

    

}

#pragma mark ------AgoraRtcEngineDelegate--------

//发生错误回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraRtcErrorCode)errorCode
{


}

//发生警告回调 (didOccurWarning)
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurWarning:(AgoraRtcWarningCode)warningCode
{

    
}

//加入频道成功回调 (didJoinChannel)
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{


}

//重新加入频道回调 (didRejoinChannel)
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed
{


}


//用户加入回调 (didJoinedOfUid)
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:
(NSUInteger)uid elapsed:(NSInteger)elapsed
{
 
    if(uid == [self.uid integerValue]){
        NSLog(@"%@", [LXUserDefaults objectForKey:itemNumber]);
        if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
            // 是主播
            self.redBtn.hidden = NO;
            self.gitfButtonCenter.constant = 40;
        } else {
            // 是用户
            self.redBtn.hidden = YES;
            self.gitfButtonCenter.constant = 0;
        }
        
        self.giftBtn.hidden = NO;
        self.iscalling = YES;

        UITapGestureRecognizer *hidRandG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRenandGift)];
        [self.bigImageView addGestureRecognizer:hidRandG];
        self.xuanzhuanButton.hidden = NO;
        self.smallImageView.hidden = NO;
        
        [self.instMedia setChannelProfile:AgoraRtc_ChannelProfile_Communication];
        [self.instMedia enableAudio];
        _local = [[AgoraRtcVideoCanvas alloc] init];
        _local.uid = [[LXUserDefaults objectForKey:UID] integerValue];
        _local.view = self.smallImageView;
        _local.renderMode = AgoraRtc_Render_Hidden;
        [self.instMedia setupLocalVideo:_local];
        _remate = [[AgoraRtcVideoCanvas alloc] init];
        _remate.uid = [self.uid integerValue];
        _remate.view = self.bigImageView;
        _remate.renderMode = AgoraRtc_Render_Hidden;
        [self.instMedia setupRemoteVideo:_remate];
        [self.instMedia enableVideo];
        [self.instMedia setVideoProfile:AgoraRtc_VideoProfile_360P_7 swapWidthAndHeight:false];
        [self.instMedia startPreview];
        
        
        
        self.headeLab.text = [NSString stringWithFormat:LXSring(@"与 %@ 通话"),self.model.nickname];
        self.callTime = 0;
        _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
    }

}

- (void)function:(NSTimer *)timer
{
    self.callTime ++;
    if (self.callTime == 5) {
       
        [UIView animateWithDuration:1.0 animations:^{
            
            self.footerView.hidden = YES;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    NSString *timeStr = [self timeFormatted:self.callTime];
    self.timeLab.text = timeStr;
    
    if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
        if (self.timeLabelBGView.hidden) {
            self.timeLabelBGView.hidden = NO;
            self.timeLabelBGView1.hidden = NO;
            // 主播显示金币收益（本次通话）
            self.jinbiView.hidden = NO;
            self.jinbiView1.hidden = NO;
        }
        
        int charges = 0;
        for (Charge *mo in self.pModel.charges) {
            if (mo.uid == self.pModel.charge) {
                charges = mo.value;
            }
        }
        int time1 = self.callTime / 60;
        int time2 = self.callTime % 60;
        if (time2 != 0) {
            _charge = charges * (time1 + 1) * 10 + _giftCharge;
        } else {
            _charge = charges * time1 * 10 + _giftCharge;
        }
        _jinbiLabel.text = [NSString stringWithFormat:@"%d", _charge];
    }
    
    
    
    if (self.callTime % 30 == 0) {
        
        [AGVideoProcessing registerVideoPreprocessing:_instMedia withchanel:self.channel];
    }

    long long idate = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *criteria = [NSString stringWithFormat:@"where channelId = %@",self.channel];
    
    CallTime *call = [CallTime findFirstByCriteria:criteria];
    if (call == nil) {
        
        call = [[CallTime alloc] init];
        call.channelId = [self.channel intValue];
        call.endedAt = idate;
        call.duration = self.callTime * 1000;
        call.uid = [self.uid intValue];
        [call save];
        
    }else{
        
        call.channelId = [self.channel intValue];
        call.endedAt = idate;
        call.duration = self.callTime * 1000;
        call.uid = [self.uid intValue];
        [call update];
        
    }


}

//用户离线回调 (didOfflineOfUid)
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:
(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason
{
    
    if(uid == [self.uid integerValue]){
    self.headeLab.text = [NSString stringWithFormat:LXSring(@"%@已离开"),self.model.nickname];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        if (!self.isfist) {
            return ;
        }
        self.isfist = NO;
        self.endtime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString *startTime = [NSString stringWithFormat:@"%lld",self.starttime];
        NSString *endTime = [NSString stringWithFormat:@"%lld",self.endtime];
        NSString *uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        NSDictionary *dict = @{@"type" : @"call", startTime : endTime,@"uid":uid,@"endtime":endTime,@"senduid":self.uid};
        [MobClick event:@"call_end" attributes:dict];
        [self stop];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        //主动发送方
            NSDictionary *params;
            params = @{@"channel":self.channel};
            [WXDataService requestAFWithURL:Url_chatvideoreend params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
                if(result){
                    if ([[result objectForKey:@"result"] integerValue] == 0) {
                        
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
        
        long long idate = [[NSDate date] timeIntervalSince1970]*1000;
        __block Message *messageModel = [Message new];
        messageModel.isSender = YES;
        messageModel.isRead = NO;
        messageModel.status = MessageDeliveryState_Delivered;
        messageModel.date = idate;
        messageModel.messageID = [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate];
        messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],self.uid];
        messageModel.type = MessageBodyType_Video;
        messageModel.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        messageModel.sendUid = self.uid;
        NSString *timeStr = [self timeFormatted:self.callTime];
        messageModel.content = [NSString stringWithFormat:LXSring(@"你與%@愉快地進行了通話,時長:%@"),self.model.nickname,timeStr];
        [messageModel save];
        
        
        
        NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",self.uid,[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];
        
        if ([MessageCount findFirstByCriteria:criteria]) {
            
            MessageCount *count = [MessageCount findFirstByCriteria:criteria];
            count.content = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:LXSring(@"你與%@愉快地進行了通話,時長:%@"),self.model.nickname,timeStr]];
            count.count = count.count + 1;
            
            count.timeDate = idate;
            count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
            count.sendUid = self.uid;
            [count update];
        
            
        }else{
            
            MessageCount *count = [[MessageCount alloc] init];
            count.content = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:LXSring(@"你與%@愉快地進行了通話,時長:%@"),self.model.nickname,timeStr]];
            count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
            count.sendUid = self.uid;
            count.count = 1;
            count.timeDate = idate;
            [count save];
        }

        
        NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        NSString *itemcriteria = [NSString stringWithFormat:@"WHERE uid = %@ order by timeDate DESC",selfuid];
        NSArray *array = [MessageCount findByCriteria:criteria];
        NSMutableArray *marray = [NSMutableArray arrayWithArray:array];
        int count = 0;
        for (MessageCount *mcount in marray) {
            count += mcount.count;
        }
        
        UITabBarItem *item=[[MainTabBarController shareMainTabBarController].tabBar.items objectAtIndex:[MainTabBarController shareMainTabBarController].tabBar.items.count - 2];
        // 显示
        item.badgeValue=[NSString stringWithFormat:@"%d",count];
        if(count == 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onMessageNoData object:nil];
            item.badgeValue = nil;
        }

        NSDictionary *msg = @{@"message":@{
                                      @"messageID":[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate],
                                      @"content":messageModel.content,
                                      @"type":@(MessageBodyType_Video),
                                      @"time":[NSString stringWithFormat:@"%lld",idate],
                                      }};
        NSString *msgStr = [InputCheck convertToJSONData:msg];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_messageVideoTime object:nil userInfo:@{@"msg":messageModel}];

        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self clearAllSubViews];
        [self removeFromSuperview];
        
        AnimOperationManager *manager = [AnimOperationManager sharedManager];
        [AnimOperationManager attemptDealloc];
        if (self.keytimer) {
            [self.keytimer invalidate];
            self.keytimer = nil;
        }
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self removeNotice];
        if (self.longTimer) {
            [self.longTimer invalidate];
            self.longTimer = nil;
        }
        if (self.giftTimer) {
            [self.giftTimer invalidate];
            self.giftTimer = nil;
        }
        if (_instMedia) {
            
            [_instMedia stopPreview];
            [_instMedia leaveChannel:^(AgoraRtcStats *stat) {
                
            }];
            
            [self.yuvEN turnOff];
            [AgoraRtcEngineKit destroy];
        }
        
    });
    }

}

//网络连接中断回调 (rtcEngineConnectionDidInterrupted)
- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit *)engine
{
    
}

//网络连接丢失回调 (rtcEngineConnectionDidLost)
- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine
{
    self.headeLab.text = LXSring(@"网络连接失败，请检查网络!");
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{

        [self dismiss];
    
    });

}

//Channel Key过期回调(rtcEngineRequestChannelKey)
- (void)rtcEngineRequestChannelKey:(AgoraRtcEngineKit *)engine
{
    
    NSDictionary *params;
    params = @{@"channel":self.channel};
    [WXDataService requestAFWithURL:Url_chatvideorenew params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSString *key = result[@"data"][@"key"];
                self.accountLabel.text = [NSString stringWithFormat:LXSring(@"%@鑽石"),result[@"data"][@"deposit"]];
                self.lowTimeLabel.text = [NSString stringWithFormat:LXSring(@"可通话时长%@分钟"),result[@"data"][@"sustain"]];
                int sustain = [[NSString stringWithFormat:@"%@",result[@"data"][@"sustain"]] intValue];
                int peerSustain = [[NSString stringWithFormat:@"%@",result[@"data"][@"peerSustain"]] intValue];
                if(peerSustain <= 2 && peerSustain != -1 && !self.islow){
                    self.islow = YES;
                        [SVProgressHUD showWithStatus:LXSring(@"对方余额已经不足两分钟了")];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                            
                        });
                        
                    }
                
                if(sustain <= 2 && sustain != -1){
                    
                    [UIView animateWithDuration:.35 animations:^{
                        self.lowMoneyView.hidden = NO;
                    } completion:^(BOOL finished) {
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [UIView animateWithDuration:.35 animations:^{
                                self.lowMoneyView.hidden = YES;
                            } completion:^(BOOL finished) {
                                
                            }];
                            
                        });
                        
                    }];
                }
                
                
               int i =  [_instMedia renewChannelKey:key];
               NSLog(@"%d",i);
                
            }else{    //请求失败
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    [self dismiss];
                    
                });
            }
        }
    } errorBlock:^(NSError *error) {
        
        [self dismiss];
        
    }];
        

}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (hours == 0) {
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


- (IBAction)gotoMoneyAC:(id)sender {
    if ([LXUserDefaults boolForKey:ISMEiGUO]){
        AccountVC *vc = [[AccountVC alloc] init];
        self.hidden = YES;
        vc.isCall = YES;
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        vc.clickBlock = ^{
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            self.hidden = NO;
        };
        [[self topViewController].navigationController pushViewController:vc animated:YES];
        
    }else{
        NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
        if ([lang hasPrefix:@"id"]){
            AccountPayTypeVC *vc = [[AccountPayTypeVC alloc] init];
            self.hidden = YES;
            vc.isCall = YES;
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            vc.clickBlock = ^{
                [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
                self.hidden = NO;
            };
            [[self topViewController].navigationController pushViewController:vc animated:YES];
            
        } else if ([lang hasPrefix:@"ar"]){
            AccountVC *vc = [[AccountVC alloc] init];
            self.hidden = YES;
            vc.isCall = YES;
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            vc.clickBlock = ^{
                [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
                self.hidden = NO;
            };
            [[self topViewController].navigationController pushViewController:vc animated:YES];
        }
    }
    
    
}
- (IBAction)giftAC:(id)sender {
    
    [self newgiftView];
    self.giftsView.pmodel = self.model;
    self.giftsView.isCall = YES;
    [UIView animateWithDuration:.35 animations:^{
        
        self.giftsView.top = kScreenHeight - 300;
        
    } completion:^(BOOL finished) {
        
    }];
}


//
//- (UIBlurEffect *)effectView{
//
//    if (_effectView == nil) {
//
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        //必须给effcetView的frame赋值,因为UIVisualEffectView是一个加到UIIamgeView上的子视图.
//        effectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth / 750 * 450);
//        [self.bigImageView addSubview:effectView];
//
//    }
//    return _effectView;
//}

- (UIVisualEffectView *)effectView {
    if (_effectView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        //必须给effcetView的frame赋值,因为UIVisualEffectView是一个加到UIIamgeView上的子视图.
        _effectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.bigImageView addSubview:_effectView];
    }
    return _effectView;
}

- (UIVisualEffectView *)smallEffectView {
    if (_smallEffectView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _smallEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        //必须给effcetView的frame赋值,因为UIVisualEffectView是一个加到UIIamgeView上的子视图.
        _smallEffectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.smallImageView addSubview:_smallEffectView];
    }
    return _smallEffectView;
}

- (IBAction)redAC:(id)sender {
    
//    [self newredView];
//    self.redView.pmodel = self.model;
//    [UIView animateWithDuration:.35 animations:^{
//        
//        self.redView.top = kScreenHeight - 316;
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
    UIButton *button = sender;
    button.selected = !button.selected;
    if (!self.isBigLocal) {
        if (button.selected) {
            //蔗渣
            self.effectView.hidden = YES;
            
        }else{
            //开启
            self.effectView.hidden = NO;
        }
    } else {
        if (button.selected) {
            //蔗渣
            self.smallEffectView.hidden = YES;
            
        }else{
            //开启
            self.smallEffectView.hidden = NO;
        }
    }
    
        
}

- (void)newredView{

    if (self.redView == nil) {
        
        self.redView = [[VideoCallRedView alloc] initVideoCallRedView];
    }

    [self addSubview:self.redView];

}

- (void)newgiftView{
    
    if (self.giftsView == nil) {
        
        self.giftsView = [[GiftsView alloc] initGiftsView];
    }
    
    [self addSubview:self.giftsView];
    
}

- (void)hideRenandGift
{
    if (self.redView.top != kScreenHeight) {
        
        [self.redView endEditing:YES];
        [UIView animateWithDuration:.35 animations:^{
            
            self.redView.top = kScreenHeight;
            
        } completion:^(BOOL finished) {
            
        }];
    }
   
    if (self.giftsView.top != kScreenHeight) {


    [UIView animateWithDuration:.35 animations:^{
        
        self.giftsView.top = kScreenHeight;
        
    } completion:^(BOOL finished) {
        
    }];
    }

}


#pragma mark - 切换
- (void)xuanzhuanAC:(UIButton *)button {
    button.selected = !button.selected;
    [self.instMedia stopPreview];
    if (button.selected) {
//        _local.view = self.smallImageView;
//        _remate.view = self.bigImageView;
        self.isBigLocal = YES;
        [self.instMedia setChannelProfile:AgoraRtc_ChannelProfile_Communication];
        [self.instMedia enableAudio];
        _local.uid = [[LXUserDefaults objectForKey:UID] integerValue];
        _local.view = self.bigImageView;
        _local.renderMode = AgoraRtc_Render_Hidden;
        [self.instMedia setupLocalVideo:_local];
        
        _remate.uid = [self.uid integerValue];
        _remate.view = self.smallImageView;
        _remate.renderMode = AgoraRtc_Render_Hidden;
        [self.instMedia setupRemoteVideo:_remate];
        [self.instMedia enableVideo];
        [self.instMedia setVideoProfile:AgoraRtc_VideoProfile_360P_7 swapWidthAndHeight:false];
        [self.instMedia startPreview];
        
        if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
            // 是主播
            if (self.effectView.hidden) {
                self.smallEffectView.hidden = YES;
            } else {
                self.effectView.hidden = YES;
                self.smallEffectView.hidden = NO;
            }
        } else {
            // 是用户
            self.effectView.hidden = YES;
            self.smallEffectView.hidden = YES;
        }
        
        
        
    } else {
//        _local.view = self.bigImageView;
//        _remate.view = self.smallImageView;
        self.isBigLocal = NO;
        [self.instMedia setChannelProfile:AgoraRtc_ChannelProfile_Communication];
        [self.instMedia enableAudio];
        _local.uid = [[LXUserDefaults objectForKey:UID] integerValue];
        _local.view = self.smallImageView;
        _local.renderMode = AgoraRtc_Render_Hidden;
        [self.instMedia setupLocalVideo:_local];

        _remate.uid = [self.uid integerValue];
        _remate.view = self.bigImageView;
        _remate.renderMode = AgoraRtc_Render_Hidden;
        [self.instMedia setupRemoteVideo:_remate];
        [self.instMedia enableVideo];
        [self.instMedia setVideoProfile:AgoraRtc_VideoProfile_360P_7 swapWidthAndHeight:false];
        [self.instMedia startPreview];
        if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
            // 是主播
            if (self.smallEffectView.hidden) {
                self.effectView.hidden = YES;
            } else {
                self.smallEffectView.hidden = YES;
                self.effectView.hidden = NO;
            }
        } else {
            // 是用户
            self.effectView.hidden = YES;
            self.smallEffectView.hidden = YES;
        }
    }
}


@end
