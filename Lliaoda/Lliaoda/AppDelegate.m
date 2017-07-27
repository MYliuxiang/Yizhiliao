//
//  AppDelegate.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "BaseNavigationController.h"
#import "LoginVC.h"
#import "MainTabBarController.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "agorasdk.h"
#import "IQKeyboardManager.h"
#import "SelectedModel.h"
#import "PersonalVC.h"
#import  <FBSDKCoreKit/FBSDKCoreKit.h>
#import <StoreKit/StoreKit.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#define getWXTokenURL @"https://api.weixin.qq.com/sns/oauth2/access_token?"

@interface AppDelegate ()<WXApiDelegate,NetWorkManagerDelegate,AgoraRtcEngineDelegate,JPUSHRegisterDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property (nonatomic,strong)NetWorkManager *networkManager;

@end

@implementation AppDelegate

//http://itunes.apple.com/lookup?id=你的应用程序的ID

+ (instancetype)shareAppDelegate
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return app;

    //haha 
}

- (NSString *)getTheCurrentVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;

}

- (void)updataAppVersion
{

    //检查更新
    [WXDataService requestAFWithURL:@"http://itunes.apple.com/lookup?id=1255091350" params:nil httpMethod:@"POST"  isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        
        NSArray *array = result[@"results"];
        NSDictionary *dict = array.lastObject;
        NSString *itunesVersion = dict[@"version"];
        self.downAppUrl = dict[@"trackViewUrl"];
        if (itunesVersion != nil) {
            
            if (![itunesVersion isEqualToString:[self getTheCurrentVersion]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检查更新" message:@"有新版本是否更新？" delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"升级", nil];
                [alert show];
            }
            
        }
        
    } errorBlock:^(NSError *error) {
        
    }];

}

//发送心跳包
- (void)heartBeat
{
    
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_accountheartbeat params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
        if(result){
           
        }
        
    } errorBlock:^(NSError *error) {
        
    }];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    if (![LXUserDefaults boolForKey:kIsFirstLauchApp]) {
    
        [self appconfig];

    }
    [LXUserDefaults setBool:YES forKey:kIsFirstLauchApp];
    [LXUserDefaults synchronize];
    
    //fb
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
   
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"a7062123f570c9064200aa6a"
                          channel:@"AppStore"
                 apsForProduction:1
            advertisingIdentifier:nil];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;

    self.notices = [NSMutableArray array];
   
    [self initAgora];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
    
    //友盟
    //591c03d2734be417a7001131测试
    UMConfigInstance.appKey = @"591c049665b6d650c5001180";
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用設定
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //检查网络
    _networkManager = [NetWorkManager sharedManager];
    _networkManager.delegate = self;
    [_networkManager startNetWorkeWatch];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
  //
    
    //微信
    [WXApi registerApp:@"wxf86e96f49df077b8"];
//    if (![LXUserDefaults boolForKey:kIsFirstLauchApp]) {
//        
//        
//        ZYLauchMovieViewController *vc = [[ZYLauchMovieViewController alloc] init];
//        self.window.rootViewController = vc;
//        [self.window makeKeyWindow];
//        
//    }else{
    
        [self isLogin];
//    }

    
   
    
//    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
//        
//        [LXUserDefaults setBool:YES forKey:ISMEiGUO];
//        
//    }else{
//        
//        [LXUserDefaults setBool:YES forKey:ISMEiGUO];
//    }
//    [LXUserDefaults synchronize];
    [self updataFinalCallTime];
    [self.window makeKeyWindow];
    return YES;
    
}

- (void)updataFinalCallTime
{
    
    NSString *uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    
    NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@",uid];
    
    NSArray *array = [CallTime findByCriteria:criteria];
    
    if (array.count == 0) {
        return;
    }
    NSMutableArray *marray = [NSMutableArray array];
    for (CallTime *call in array) {
        
        NSDictionary *dic = @{@"channelId":@(call.channelId),@"endedAt":@(call.endedAt),@"duration":@(call.duration)};
        [marray addObject:dic];
        
    }
    
    NSDictionary *params = @{@"calls":marray};
    
    [WXDataService requestAFWithURL:Url_chatvideoreport params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                for (CallTime *call in array) {
                    [call deleteObject];
                }
                
            }else{
            }
        }
        
    } errorBlock:^(NSError *error) {
    }];
    
    
}

//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://购买成功
                [self dl_completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://购买失败
                [self dl_failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://恢复购买
                [self dl_restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing://正在处理
                break;
            default:
                break;
        }
    }
}

#pragma mark - PrivateMethod
- (void)dl_completeTransaction:(SKPaymentTransaction *)transaction {
    NSString *productIdentifier = transaction.payment.productIdentifier;
    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receipt = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符
    if ([receipt length] > 0 && [productIdentifier length] > 0) {
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
        });
        /**
         可以将receipt发给服务器进行购买验证
         */
        IAPModel *model = [[IAPModel alloc] init];
        model.receipt = receipt;
        model.uid = [LXUserDefaults objectForKey:UID];
        [model save];
        
        [self appPay];
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

- (void)appPay
{
   
    NSArray *iapArray = [IAPModel findAll];
    if (iapArray.count == 0) {
        return;
    }
    IAPModel *model = iapArray[0];
    NSString *selfID = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    if (![selfID isEqualToString:model.uid]) {
        
        return;
    }
    
    
    NSDictionary *params;
    params = @{@"receipt":model.receipt};
    [WXDataService requestAFWithURL:Url_payiappaynotify params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO  finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                [model deleteObject];
                
                NSArray *iapArray1 = [IAPModel findAll];
                NSDictionary *dic = result;
                [[NSNotificationCenter defaultCenter] postNotificationName:Notice_appPaySugerss object:nil userInfo:dic];

                
                    NSArray *arr = [OrderID findAll];
                    //    NSMutableString *str = [NSMutableString string];
                    NSMutableArray *arrs = [NSMutableArray array];
                    for (OrderID *order in arr) {
                        [arrs addObject:order.orderID];
                        //        [str appendString:[NSString stringWithFormat:@",%@", order.orderID]];
                        
                    }
                    NSString *str = [arrs componentsJoinedByString:@","];
                    NSDictionary *params = @{@"uid":str};
                    [WXDataService requestAFWithURL:Url_orderQuery params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
                        if(result){
                            if ([[result objectForKey:@"result"] integerValue] == 0) {
                                NSArray *dataArray = [result objectForKey:@"data"];
                                for (NSDictionary *dic in dataArray) {
                                    NSString *uid = [dic objectForKey:@"uid"];
                                    if ([dic[@"status"] intValue] == 1) {
                                        if (dic[@"referee"] != nil) {
                                            
                                            NSString *content = [NSString stringWithFormat:@"我已通過你的頁面充值:%@鉆", dic[@"diamonds"]];
                                            long long idate = [[NSDate date] timeIntervalSince1970]*1000;
                                            __block Message *messageModel = [Message new];
                                            messageModel.isSender = YES;
                                            messageModel.isRead = NO;
                                            messageModel.status = MessageDeliveryState_Delivering;
                                            messageModel.date = idate;
                                            messageModel.messageID = [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate];
                                            messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],dic[@"referee"]];
                                            messageModel.type = MessageBodyType_Text;
                                            messageModel.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                                            messageModel.sendUid = dic[@"referee"];
                                            messageModel.content = content;
                                            [messageModel save];
                                            
                                            
                                             NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",dic[@"referee"],[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];

                                            if ([MessageCount findFirstByCriteria:criteria]) {
                                                
                                                MessageCount *count = [MessageCount findFirstByCriteria:criteria];
                                                count.content = messageModel.content;
                                                count.count = count.count + 1;
                                                
                                                count.timeDate = idate;
                                                count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                                                count.sendUid = dic[@"referee"];
                                                [count update];
                                                
                                            }else{
                                                
                                                MessageCount *count = [[MessageCount alloc] init];
                                                count.content = messageModel.content;
                                                count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                                                count.sendUid = dic[@"referee"];
                                                count.count = 1;
                                                count.timeDate = idate;
                                                [count save];
                                            }
                                            
                                            NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                                            NSString *criteria2 = [NSString stringWithFormat:@"WHERE uid = %@",selfuid];
                                            NSArray *array = [MessageCount findByCriteria:criteria2];
                                            int count = 0;
                                            
                                            for (MessageCount *mcount in array) {
                                                count += mcount.count;
                                                
                                            }
                                            UITabBarItem *item=[[MainTabBarController shareMainTabBarController].tabBar.items objectAtIndex:[MainTabBarController shareMainTabBarController].tabBar.items.count - 2];
                                            // 显示
                                            item.badgeValue=[NSString stringWithFormat:@"%d",count];
                                            if(count == 0){
                                                
                                                item.badgeValue = nil;
                                            }
                                            

                                            
                                            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                                            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                                
                                                [SVProgressHUD dismiss];
                                            });
                                            
                                            NSDictionary *dics = @{
                                                                   @"message": @{
                                                                           @"messageID": messageModel.messageID,
                                                                           @"event": @"recharge",
                                                                           @"content": content,
                                                                           @"request": @"-3",
                                                                           @"time": [NSString stringWithFormat:@"%lld",idate]
                                                                           }
                                                                   };
                                            
                                            NSString *msgStr = [InputCheck convertToJSONData:dics];
                                            [_inst messageInstantSend:[NSString stringWithFormat:@"%@", dic[@"referee"]] uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate]];
                                        }
                                        
                                        
                                        NSString *criteria = [NSString stringWithFormat:@"WHERE orderID = '%@'",uid];
                                        OrderID *order = [OrderID findFirstByCriteria:criteria];
                                        [order deleteObject];
                                    }
                                                                       
                                }
                                
                                if (iapArray1.count == 0) {
                                    return;
                                }
                                [self appPay];
                                
                            }else{    //请求失败
                                
                                if (iapArray1.count == 0) {
                                    return;
                                }
                                [self appPay];
                            }
                        }
                        
                    } errorBlock:^(NSError *error) {
                        if (iapArray1.count == 0) {
                            return;
                        }
                        [self appPay];
                        
                    }];
                
                
               

                
            }else{    //请求失败
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        
    }];
    
    
}

- (void)dl_failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
        });
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
        });
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)dl_restoreTransaction:(SKPaymentTransaction *)transaction {
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)appconfig
{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];

    NSString *agent = [NSString stringWithFormat:@"%@,%@,ios,%@,3",[infoDictionary objectForKey:@"CFBundleDisplayName"],[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
    
    NSMutableString *mutableUrl = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"https://www.yizhiliao.tv/api/%@",Url_appconfig]];
    NSString *urlEnCode = [[mutableUrl substringToIndex:mutableUrl.length] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlEnCode]];
    [urlRequest setAllHTTPHeaderFields:@{@"user-language":@"zh-tw",@"user-agent":agent}];
    [urlRequest setHTTPMethod:@"GET"];

    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_semaphore_signal(semaphore);   //发送信号

        } else {
 
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if(result){
                            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                                BOOL paymentEnabled = [result[@"data"][@"config"][@"paymentEnabled"] boolValue];
                
                                BOOL oauthLoginEnabled = [result[@"data"][@"config"][@"oauthLoginEnabled"] boolValue];
                
                                [LXUserDefaults setBool:!oauthLoginEnabled forKey:ISMEiGUO];
                                [LXUserDefaults setBool:paymentEnabled forKey:payEnable];
                                [LXUserDefaults synchronize];
                                
                            }
                            
                
                        }


        }
        dispatch_semaphore_signal(semaphore);   //发送信号

    }];
    [dataTask resume];
    
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待

    
//    NSDictionary *params;
//    [WXDataService requestAFWithURL:Url_appconfig params:params httpMethod:@"GET" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
//        if(result){
//            if ([[result objectForKey:@"result"] integerValue] == 0) {
//                
//                BOOL paymentEnabled = [result[@"data"][@"config"][@"paymentEnabled"] boolValue];
//                
//                BOOL oauthLoginEnabled = [result[@"data"][@"config"][@"oauthLoginEnabled"] boolValue];
//
//                [LXUserDefaults setBool:!oauthLoginEnabled forKey:ISMEiGUO];
//                [LXUserDefaults setBool:paymentEnabled forKey:payEnable];
//                [LXUserDefaults synchronize];
//                
//            }
//            
//
//        }
//        
//    } errorBlock:^(NSError *error) {
//
//    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.downAppUrl]];
    }

}

- (void)initAgora
{
    _inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];
    
}

#pragma mark - NetWorkManagerDelegate
- (void)netWorkStatusWillChange:(NetworkStatus)status
{
    self.netStatus = status;
    if(status == NotReachable)
    {
        
          [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onLoginFailed object:nil];
    
    } else {
        
        if (![self.inst isOnline]) {
        
            [self loginAgoraSignaling];

        }
    }
    
}

- (void)netWorkStatusWillDisconnection
{
    // @"网络断开";
    
}

- (void)isLogin
{
    
    BaseNavigationController *baseNAV;
    NSString *expire = [LXUserDefaults objectForKey:Expire];
    if (expire == nil) {
        

        LoginVC *loginVC = [[LoginVC alloc]init];
        baseNAV = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController =baseNAV;
        return;
    }
    NSDate *expiredate = [NSDate dateWithTimeIntervalSince1970:[expire doubleValue]/ 1000.0];
    NSComparisonResult result = [expiredate compare:[NSDate date]];
    
    
    if (result == NSOrderedAscending ) {
        //設定标识
        
        LoginVC *loginVC = [[LoginVC alloc]init];
        baseNAV = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController =baseNAV;
        
       
        
    } else if(result == NSOrderedSame){
        
       
        LoginVC *loginVC = [[LoginVC alloc]init];
        baseNAV = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController =baseNAV;
        
        
    }else{
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainTabBarController *mantvc = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
        self.window.rootViewController = mantvc;
        
        self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
          
    
    }
 

}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
   

//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的訊息内容
//    
//    NSNumber *badge = content.badge;  // 推送訊息的角标
//    NSString *body = content.body;    // 推送訊息体
//    UNNotificationSound *sound = content.sound;  // 推送訊息的声音
//    NSString *subtitle = content.subtitle;  // 推送訊息的副标题
//    NSString *title = content.title;  // 推送訊息的标题
    

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];

        
        
    }
//      completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以設定

}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的訊息内容
    
//    NSNumber *badge = content.badge;  // 推送訊息的角标
//    NSString *body = content.body;    // 推送訊息体
//    UNNotificationSound *sound = content.sound;  // 推送訊息的声音
//    NSString *subtitle = content.subtitle;  // 推送訊息的副标题
//    NSString *title = content.title;  // 推送訊息的标题
    
    //后台收到通知
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        int type = [userInfo[@"type"] intValue];
        if (type == 0) {
            //視訊
        
            
        }
        if(type == 2){
            //点对点发訊息
            MainTabBarController *tab = [MainTabBarController shareMainTabBarController];
            tab.selectedIndex = 1;
            
        }
        if(type == 3){
        //用户上线
            NSString *senderId = userInfo[@"senderId"];
            SelectedModel *model = [[SelectedModel alloc] init];
            model.uid = senderId;
            PersonalVC *vc = [[PersonalVC alloc] init];
            vc.model = model;
            [[self topViewController].navigationController pushViewController:vc animated:YES];
            
        }

    }
       completionHandler();  // 系统要求执行这个方法
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


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [self.heartBeatTimer  setFireDate:[NSDate distantFuture]];
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];

    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [self.heartBeatTimer setFireDate:[NSDate distantPast]];
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


// 这个方法是用于从微信返回第三方App
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

#pragma mark - WXApiDelegate
-(void) onReq:(BaseReq*)req{
    NSLog(@"onReq");
}

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
/*
 1497602517923
 1497602517923
 1bed854d31e44d928a56935ec9896e30
 */

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
   
     if(iResCode != 0){
       [JPUSHService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
     }
}


- (void)facebookLogin:(NSString *)token
{
    NSDictionary *params;
    params = @{@"type":@"facebook",@"accessToken":token};
    [WXDataService loginAFWithURL:Url_accountLogin params:params httpMethod:@"POST" isHUD:YES finishBlock:^(id result) {
        if (result) {
            if ([result[@"result"] integerValue] == 0) {
                //成功
                NSString *str = [NSString stringWithFormat:@"%@",result[@"data"][@"appkey"]];
                [LXUserDefaults setObject:str forKey:LXAppkey];
                [LXUserDefaults setObject:result[@"data"][@"expire"] forKey:Expire];
                [LXUserDefaults setObject:result[@"data"][@"uid"] forKey:UID];
                [LXUserDefaults setObject:result[@"data"][@"token"] forKey:AGORETOKEN];
                [LXUserDefaults setObject:result[@"data"][@"nickname"] forKey:NickName];
                [LXUserDefaults setObject:result[@"data"][@"portrait"] forKey:Portrait];
                [LXUserDefaults synchronize];
                
                NSString *alias = [NSString stringWithFormat:@"%@",result[@"data"][@"uid"]];
                [JPUSHService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                
                [self loginAgoraSignaling];
                
                NSString *uid = [NSString stringWithFormat:@"%@",result[@"data"][@"uid"]];
                [MobClick profileSignInWithPUID:uid provider:@"WX"];
                [MobClick event:@"Forward"];
                
                NSDictionary *params;
                [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:YES isErrorHud:NO finishBlock:^(id result) {
                    if(result){
                        if ([[result objectForKey:@"result"] integerValue] == 0) {
                            
                            self.model = [Mymodel mj_objectWithKeyValues:result[@"data"]];
                            if (self.model.auth == 2) {
                                //是主播
                                [LXUserDefaults setObject:@"1" forKey:itemNumber];
                                [LXUserDefaults synchronize];
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                MainTabBarController *tab = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                                tab.iszhubo = YES;
                                
                                self.window.rootViewController = tab;
                                self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
                                
                            }else{
                                
                                [LXUserDefaults setObject:@"2" forKey:itemNumber];
                                [LXUserDefaults synchronize];
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                MainTabBarController *tab = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                                tab.iszhubo = NO;
                                
                                self.window.rootViewController = tab;
                                self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
                                
                            }
                            
                        } else{
                            [LXUserDefaults setObject:@"2" forKey:itemNumber];
                            [LXUserDefaults synchronize];
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            MainTabBarController *tab = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                            tab.iszhubo = NO;
                            
                            self.window.rootViewController = tab;
                            self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
                            
                        }
                    }
                    
                } errorBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                    [LXUserDefaults setObject:@"2" forKey:itemNumber];
                    [LXUserDefaults synchronize];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MainTabBarController *tab = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                    tab.iszhubo = NO;
                    
                    self.window.rootViewController = tab;
                    self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
                }];

                [[SKPaymentQueue defaultQueue] addTransactionObserver:self];


                
            }else{
                //登入失败
                
                NSLog(@"%@",result[@"message"]);
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

-(void)onResp:(BaseResp*)resp{
    //    NSLog(@"onResp:code=%d",resp.errCode);
    //微信登陆

    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *respond = (SendAuthResp*)resp;
        if (respond.errCode == 0) {

            NSDictionary *params;
            params = @{@"type":@"wechat",@"app":@"tw",@"code":respond.code};
            [WXDataService loginAFWithURL:Url_accountLogin params:params httpMethod:@"POST" isHUD:YES finishBlock:^(id result) {
                if (result) {
                if ([result[@"result"] integerValue] == 0) {
                    //成功
                    NSString *str = [NSString stringWithFormat:@"%@",result[@"data"][@"appkey"]];
                    [LXUserDefaults setObject:str forKey:LXAppkey];
                    [LXUserDefaults setObject:result[@"data"][@"expire"] forKey:Expire];
                    [LXUserDefaults setObject:result[@"data"][@"uid"] forKey:UID];
                    [LXUserDefaults setObject:result[@"data"][@"token"] forKey:AGORETOKEN];
                    [LXUserDefaults setObject:result[@"data"][@"nickname"] forKey:NickName];
                    [LXUserDefaults setObject:result[@"data"][@"portrait"] forKey:Portrait];
                    [LXUserDefaults synchronize];
                
                    NSString *alias = [NSString stringWithFormat:@"%@",result[@"data"][@"uid"]];
                    [JPUSHService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                    
                    [self loginAgoraSignaling];
                    
                    NSString *uid = [NSString stringWithFormat:@"%@",result[@"data"][@"uid"]];
                    [MobClick profileSignInWithPUID:uid provider:@"WX"];
                    [MobClick event:@"Forward"];

                    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

                    NSDictionary *params;
                    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:YES isErrorHud:NO finishBlock:^(id result) {
                        if(result){
                            if ([[result objectForKey:@"result"] integerValue] == 0) {
                                
                                self.model = [Mymodel mj_objectWithKeyValues:result[@"data"]];
                                if (self.model.auth == 2) {
                                    //是主播
                                    [LXUserDefaults setObject:@"1" forKey:itemNumber];
                                    [LXUserDefaults synchronize];
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    MainTabBarController *tab = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                                    tab.iszhubo = YES;
                                    
                                    self.window.rootViewController = tab;
                                    self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
                                    
                                }else{
                                    
                                    [LXUserDefaults setObject:@"2" forKey:itemNumber];
                                    [LXUserDefaults synchronize];
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    MainTabBarController *tab = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                                    tab.iszhubo = NO;
                                    
                                    self.window.rootViewController = tab;
                                    self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
                                    
                                }
                                
                            } else{
                                [LXUserDefaults setObject:@"2" forKey:itemNumber];
                                [LXUserDefaults synchronize];
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                MainTabBarController *tab = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                                tab.iszhubo = NO;
                                
                                self.window.rootViewController = tab;
                                self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
                                
                            }
                        }
                        
                    } errorBlock:^(NSError *error) {
                        NSLog(@"%@",error);
                        [LXUserDefaults setObject:@"2" forKey:itemNumber];
                        [LXUserDefaults synchronize];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        MainTabBarController *tab = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                        tab.iszhubo = NO;
                        
                        self.window.rootViewController = tab;
                        self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
                    }];

                }else{
                    //登入失败
                    
                    NSLog(@"%@",result[@"message"]);
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
        //登入失败
            
            [SVProgressHUD showErrorWithStatus:@"登入失败"];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
            });
                        
        }
    }
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        
        NSDictionary *dic = @{@"errCode":@(resp.errCode)};
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_weiXinPay object:nil userInfo:dic];
        
    }
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        
        NSDictionary *dic = @{@"errCode":@(resp.errCode)};
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_weiXinShare object:nil userInfo:dic];
        
    }
    
}

- (void)function:(NSTimer *)timer
{

    NSString *uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSString *token = [LXUserDefaults objectForKey:AGORETOKEN];

    [_inst login:agoreappID account:uid token:token uid:0 deviceID:nil];

}

- (void)loginAgoraSignaling
{
    NSString *uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSString *token = [LXUserDefaults objectForKey:AGORETOKEN];
    if (uid == nil || token == nil || [uid isEqualToString:@"(null)"] || [token isEqualToString:@"(null)"]) {
        return;
    }
    [_inst login:agoreappID account:uid token:token uid:0 deviceID:nil];
    
    //
    //2

//    [_inst login:agoreappID account:@"2" token:@"1:5EA6E6443C9B41FF9C785A0A4ABC7F29:1495095443:de572e3c9011209a844424139c527acc" uid:0 deviceID:nil];

//    [_inst login2:agoreappID account:uid token:token uid:0 deviceID:nil retry_time_in_s:1 retry_count:3];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onLogin object:nil];

    //登入成功
    _inst.onLoginSuccess = ^(uint32_t uid, int fd){
    
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            
            if (self.timer != nil) {
                
                self.timer = nil;
                
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onLoginSuccess object:nil];
            NSDictionary *params;
            [WXDataService requestAFWithURL:Url_chatvideoreleave params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
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
            //.....
        });
    
    };
    
    //登入失败
    _inst.onLoginFailed = ^(AgoraEcode ecode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onLoginFailed object:nil];
            
            
            if (self.netStatus != NotReachable) {
                
                _timer =  [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
                
            }
            //.....
        });

    };
   
    //当重连成功会触发此回调。重连失败会触发onLogout回调。
    _inst.onReconnected = ^(int fd) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onReconnected object:nil];
            //.....
        });
    };
    
    //退出登陸回调(onLogout)
    _inst.onLogout = ^(AgoraEcode ecode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onLogout object:nil];
            
            if (self.netStatus != NotReachable) {
                
                _timer =  [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
                
            }
            //.....
        });
       
    };
    
    //登入成功后，丢失连接触发本回调。
    _inst.onReconnecting = ^(uint32_t nretry) {
       

        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onReconnecting object:nil];
            if (self.netStatus != NotReachable) {
                
                _timer =  [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
                
            }
            
            
            //.....
        });
        
    };
    

    
    //本地收到呼叫邀请
    _inst.onInviteReceived = ^(NSString *channelID, NSString *account, uint32_t uid, NSString *extra) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            VideoCallView *video = [[VideoCallView alloc] initVideoCallViewWithChancel:channelID withUid:account withIsSend:NO];
            [video show];
            
            //.....
        });
        
    };
    
    
    //呼叫失败回调(onInviteFailed)
    _inst.onInviteFailed = ^(NSString *channelID, NSString *account, uint32_t uid, AgoraEcode ecode, NSString *extra) {
        //对方不在线；本端网络不通；服务器异常
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
             [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onInviteFailed object:nil];
            
            //.....
        });
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        });
        
    };
    
    //远端已收到呼叫回调(onInviteReceivedByPeer,
    _inst.onInviteReceivedByPeer = ^(NSString *channelID, NSString *account, uint32_t uid) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onInviteReceivedByPeer object:nil];

            
            //.....
        });
        
    };
    
    //远端已接受呼叫回调(onInviteAcceptedByPeer)
    _inst.onInviteAcceptedByPeer = ^(NSString *channelID, NSString *account, uint32_t uid, NSString *extra) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onInviteAcceptedByPeer object:nil];

            
            //.....
        });
        
    };
    
    //当呼叫被对方拒绝时触发。
    _inst.onInviteRefusedByPeer = ^(NSString *channelID, NSString *account, uint32_t uid, NSString *extra) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onInviteRefusedByPeer object:nil];
            
            //.....
        });
    };
    
    //对方已拒绝呼叫回调(onInviteEndByPeer)
    _inst.onInviteEndByPeer = ^(NSString *channelID, NSString *account, uint32_t uid, NSString *extra) {
        
    };
    
    //本地已结束呼叫回调(onInviteEndByMyself)
    _inst.onInviteEndByMyself = ^(NSString *channelID, NSString *account, uint32_t uid) {
        
    };
    
    //远端结束呼叫
    _inst.onInviteEndByPeer = ^(NSString *channelID, NSString *account, uint32_t uid, NSString *extra) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onInviteEndByPeer object:nil];
            
        });
        
    };
    
    //当加入频道成功时触发此回调。
    _inst.onChannelJoined = ^(NSString *channelID) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            //.....
        });
        
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //更新UI操作
               //        self.smallImageView.hidden = NO;
        
        //.....
    });
    
    //加入频道失败回调(onChannelJoinFailed)
    _inst.onChannelJoinFailed = ^(NSString *channelID, AgoraEcode ecode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            //            [this dismiss];
            //.....
        });
    };

    //发送訊息失败将回调 onMessageSendError
    _inst.onMessageSendError = ^(NSString *messageID, AgoraEcode ecode) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            
            if ([messageID isEqualToString:@"-1"]) {
                
                return ;
            }

            NSDictionary *dic = @{@"messageID":messageID,@"ecode":@(ecode)};
            NSString *criteria = [NSString stringWithFormat:@"WHERE messageID = '%@'",messageID];
            Message *messageModel = [Message findFirstByCriteria:criteria];
            if(messageModel == nil){
                
                return ;
            }
            messageModel.status = MessageDeliveryState_Failure;
            [messageModel update];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onMessageSendError object:nil userInfo:dic];
            //.....
        });
        
        
    };
    //发送訊息成功回调
    _inst.onMessageSendSuccess = ^(NSString *messageID) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            
            if ([messageID isEqualToString:@"-1"]) {
                
                return ;
            }
            
            NSDictionary *dic = @{@"messageID":messageID};
            NSString *criteria = [NSString stringWithFormat:@"WHERE messageID = '%@'",messageID];
            Message *messageModel = [Message findFirstByCriteria:criteria];
            if(messageModel == nil){
            
                return ;
            }
            messageModel.status = MessageDeliveryState_Delivered;
            [messageModel update];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onMessageSendSuccess object:nil userInfo:dic];
            
            
        });
        
    };
    
    //已收到訊息回调(onMessageInstantReceive)
    _inst.onMessageInstantReceive = ^(NSString *account, uint32_t uid, NSString *msg) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *dic = [InputCheck dictionaryWithJsonString:msg];
            NSString *messageID = [NSString stringWithFormat:@"%@",dic[@"message"][@"messageID"]];
            NSString *event = [NSString stringWithFormat:@"%@",dic[@"message"][@"event"]] ;
            NSDictionary *mdic = @{@"account":account,@"msg":dic[@"message"]};

            if ([messageID isEqualToString:@"-1"]) {
                
                if ([event isEqualToString:@"call-end"]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notice_noMonny object:nil userInfo:dic];
                    
                }else if([event isEqualToString:@"gift"]){
                
                     [[NSNotificationCenter defaultCenter] postNotificationName:Notice_ReceivedGift object:nil userInfo:mdic];
                
                }
                
            }else{
               
                NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",account,[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];
                NSString *timestr = [NSString stringWithFormat:@"%@",dic[@"message"][@"time"]];
                
                NSString *request = dic[@"message"][@"request"];
                NSString *event =  dic[@"message"][@"event"];
                
                if ([MessageCount findFirstByCriteria:criteria]) {
                    
                    MessageCount *count = [MessageCount findFirstByCriteria:criteria];
                    
                    if ([request isEqualToString:@"-2"]) {
                        if ([event isEqualToString:@"gift"]) {
                            
                            count.content = @"收到我送礼提醒";
                            
                        }else{
                            
                            count.content = count.content = @"收到我充值提醒";
                        }
                        
                    }else if([request isEqualToString:@"-3"]){
                        
                        if ([event isEqualToString:@"gift"]) {
                            
                            count.content = [NSString stringWithFormat:@"收到我送出的：%@",dic[@"message"][@"content"]];;
                        }else{
                            
                            count.content = [NSString stringWithFormat:@"我已通过你得页面充值:%@钻",dic[@"message"][@"content"]];
                            
                        }
                        
                        
                    }else{
                        
                        count.content = [NSString stringWithFormat:@"%@",dic[@"message"][@"content"]];
                        
                    }

                    count.count = count.count + 1;
                  
                    count.timeDate = [timestr longLongValue];
                    count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                    count.sendUid = account;
                    [count update];
                    
                }else{
                    
                    MessageCount *count = [[MessageCount alloc] init];
                    if ([request isEqualToString:@"-2"]) {
                        if ([event isEqualToString:@"gift"]) {
                            
                            count.content = @"收到我送礼提醒";
                            
                        }else{
                            
                            count.content = count.content = @"收到我充值提醒";
                        }
                        
                    }else if([request isEqualToString:@"-3"]){
                        
                        if ([event isEqualToString:@"gift"]) {
                            
                            count.content = [NSString stringWithFormat:@"收到我送出的：%@",dic[@"message"][@"content"]];;
                        }else{
                            
                            count.content = [NSString stringWithFormat:@"我已通过你得页面充值:%@钻",dic[@"message"][@"content"]];
                            
                        }
                        
                        
                    }else{
                        
                        count.content = [NSString stringWithFormat:@"%@",dic[@"message"][@"content"]];
                        
                    }
                    count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                    count.sendUid = account;
                    count.count = 1;
                    count.timeDate = [timestr longLongValue];
                    [count save];
                }
                
              
                
                Message *messageModel = [Message new];
                messageModel.isSender = NO;
                messageModel.isRead = YES;
                messageModel.status = MessageDeliveryState_Delivered;
                messageModel.date = [timestr longLongValue];
                
                if ([request isEqualToString:@"-2"]) {
                    if ([event isEqualToString:@"gift"]) {
                        
                        messageModel.content = @"收到我送礼提醒";
                        messageModel.type = MessageBodyType_Gift;

                    }else{
                        
                        messageModel.content = @"收到我充值提醒";
                        messageModel.type = MessageBodyType_ChongZhi;

                    }
                    
                }else if([request isEqualToString:@"-3"]){
                    
                    if ([event isEqualToString:@"gift"]) {
                        
                        messageModel.content = [NSString stringWithFormat:@"收到我送出的：%@",dic[@"message"][@"content"]];;
                        messageModel.type = MessageBodyType_Text;
                    }else{
                        
                        messageModel.content = [NSString stringWithFormat:@"我已通过你得页面充值:%@钻",dic[@"message"][@"content"]];
                        messageModel.type = MessageBodyType_Text;

                    }
                    
                    
                }else{
                    
                    messageModel.content = [NSString stringWithFormat:@"%@",dic[@"message"][@"content"]];
                    messageModel.type = MessageBodyType_Text;

                }

                
                messageModel.uid = account;
                messageModel.messageID = [NSString stringWithFormat:@"%@",dic[@"message"][@"messageID"]];
                messageModel.sendUid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],account];
                [messageModel save];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onMessageInstantReceive object:nil userInfo:mdic];
                
            }
            
            //.....
        });
        
    };
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    
    return  [[FBSDKApplicationDelegate sharedInstance] application:application
             
                                                           openURL:url
             
                                                 sourceApplication:sourceApplication
             
                                                        annotation:annotation
             
             ];

//        return  [WXApi handleOpenURL:url delegate:self];
    
}

//9.0后的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if([url.absoluteString hasPrefix:@"wx"]){
    
            return  [WXApi handleOpenURL:url delegate:self];

    }else{
        return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options];

    }
       
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
