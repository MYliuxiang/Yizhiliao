//
//  AppDelegate.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkManager.h"
#import "agorasdk.h"
#import "ZYLauchMovieViewController.h"
#import "UMMobClick/MobClick.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "IAPModel.h"
#import "Mymodel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) AgoraAPI *inst;
@property (nonatomic,retain) AgoraRtcEngineKit *instMedia;
@property (nonatomic,assign) NetworkStatus netStatus;
@property (nonatomic,copy) NSString *downAppUrl;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,retain) NSMutableArray *notices;
@property (nonatomic,retain) NSTimer *heartBeatTimer;
@property (nonatomic, retain) NSTimer *robotTimer; // 机器消息
@property (nonatomic,retain) Mymodel *model;

- (void)isLogin;

+ (instancetype)shareAppDelegate;

- (void)loginAgoraSignaling;

- (void)facebookLogin:(NSString *)token;

- (void)appPay;




@end

