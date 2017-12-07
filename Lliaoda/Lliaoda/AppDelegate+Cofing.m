//
//  AppDelegate+Cofing.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AppDelegate+Cofing.h"

@implementation AppDelegate (Cofing)


- (void)appconfig
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *agent;
    NSString *mutableUrl;
//    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    
    agent = [NSString stringWithFormat:@"%@,%@,ios,%@,501",@"youliao",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
    mutableUrl = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"https://liao.yizhiliao.live/api/%@",Url_appconfig]];
    //    if ([lang hasPrefix:@"zh-Hant"]) {
    //        agent = [NSString stringWithFormat:@"%@,%@,ios,%@,301",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
    //        mutableUrl = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"https://www.yizhiliao.tv/api/%@",Url_appconfig]];
    //    }else
//    if ([lang hasPrefix:@"id"]){
//        agent = [NSString stringWithFormat:@"%@,%@,ios,%@,402",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
//        mutableUrl = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"https://www.yizhiliao.live/api/%@",Url_appconfig]];
//    } else {
//        agent = [NSString stringWithFormat:@"%@,%@,ios,%@,403",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
//        mutableUrl = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"https://www.yizhiliao.net/api/%@",Url_appconfig]];
//    }
//
    
    NSString *urlEnCode = [[mutableUrl substringToIndex:mutableUrl.length] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlEnCode]];
    [urlRequest setAllHTTPHeaderFields:@{@"user-language":@"zh-tw",@"User-Agent":agent}];
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
    
    
    
}

- (void)updataAppVersion
{
    //检查更新
    [WXDataService requestAFWithURL:@"http://itunes.apple.com/lookup?id=1275434834" params:nil httpMethod:@"POST"  isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        
        NSArray *array = result[@"results"];
        NSDictionary *dict = array.lastObject;
        NSString *itunesVersion = dict[@"version"];
        self.downAppUrl = dict[@"trackViewUrl"];
        if (itunesVersion != nil) {
            
            if (![itunesVersion isEqualToString:[self getTheCurrentVersion]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"检查更新") message:LXSring(@"有新版本是否更新？") delegate:self cancelButtonTitle:LXSring(@"暂不升级") otherButtonTitles:LXSring(@"升级"), nil];
                [alert show];
            }
            
        }
        
    } errorBlock:^(NSError *error) {
        
    }];
    
}

- (NSString *)getTheCurrentVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
    
}

- (void)updataFinalCallTime
{
    
    NSString *uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    
    NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@ and upload = 0",uid];
    
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
                    call.type = 1;
                    [call update];
                }
                
            }else{
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

@end
