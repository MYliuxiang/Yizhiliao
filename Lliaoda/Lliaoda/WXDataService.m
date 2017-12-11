//
//  WXDataService.m
//  MyWeibo
//
//  Created by zsm on 14-3-5.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WXDataService.h"
#import <AdSupport/AdSupport.h>
@implementation WXDataService

- (BOOL)isConnected {
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

//-(void)Reachability {
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"%@",[NSThread currentThread]);
//        switch (status) {
//            case AFNetworkReachabilityStatusNotReachable:
//            {
//                NSLog(LXSring(@"无网络"));
//                self.isNotReachable = NO;
//            }
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//            {
//                NSLog(LXSring(@"有网络"));
//                //isuse = LXSring(@"有网络");
//                 self.isNotReachable = YES;
//            }
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//            {
//                NSLog(@"有网络wifi");
//                 self.isNotReachable = YES;
//            }
//                break;
//            default:
//                break;
//        }
//    }];
//}

+ (AFHTTPSessionManager *)loginAFWithURL:(NSString *)url
                                  params:(NSDictionary *)params
                              httpMethod:(NSString *)httpMethod
                                   isHUD:(BOOL)ishud
                             finishBlock:(FinishBlock)finishBlock
                              errorBlock:(ErrorBlock)errorBlock
{
    if (ishud) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
    }
    
    NSString *urlStr;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer= [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString *agent = [NSString stringWithFormat:@"%@,%@,ios,%@,301",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
    
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
//    if ([lang hasPrefix:@"zh-Hant"]) {
//        agent = [NSString stringWithFormat:@"%@,%@,ios,%@,301",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
//        urlStr = [NSString stringWithFormat:@"%@%@",MAINURL,url];
//    }else
    if ([lang hasPrefix:@"id"]){
        agent = [NSString stringWithFormat:@"%@,%@,ios,%@,402",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
        urlStr = [NSString stringWithFormat:@"%@%@",MAINURL,url];
    }else if ([lang hasPrefix:@"ar"]){
        agent = [NSString stringWithFormat:@"%@,%@,ios,%@,403",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
        urlStr = [NSString stringWithFormat:@"%@%@",MAINURL,url];
    }else{
        agent = [NSString stringWithFormat:@"%@,%@,ios,%@,301",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
        urlStr = [NSString stringWithFormat:@"%@%@",MAINURL,url];
    }

    
    [manager.requestSerializer setValue:agent forHTTPHeaderField:@"User-Agent"];

    
    RequestType1 type;
    if ([httpMethod isEqualToString:@"GET"])
    {
        type = RequestGetType1;
    }else{
        type = RequestPostType1;
        
    }
    
      switch (type) {
        case RequestGetType1:
        {
            
            [manager GET:urlStr parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (finishBlock != nil) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    finishBlock(result);
                }
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Error: %@", [error localizedDescription]);
                
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                
                if (errorBlock != nil) {
                    
                    errorBlock(error);
                    [SVProgressHUD showErrorWithStatus:LXSring(@"网络失败")];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                    });

                }
                
            }];
            
            
        }
            break;
        case RequestPostType1:
        {
           
            [manager POST:urlStr parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (finishBlock != nil) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                   
                    finishBlock(result);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (errorBlock != nil) {
                    
                    errorBlock(error);
                    [SVProgressHUD showErrorWithStatus:LXSring(@"网络失败")];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                    });

                }
            }];
            
        }
            break;
        default:
            break;
    }
    
    return manager;

    

}

+ (AFHTTPSessionManager *)requestAFWithURL:(NSString *)url
                                    params:(NSDictionary *)params
                                httpMethod:(NSString *)httpMethod
                                     isHUD:(BOOL)ishud
                                isErrorHud:(BOOL)isErrorHud
                               finishBlock:(FinishBlock)finishBlock
                                errorBlock:(ErrorBlock)errorBlock
{
    
    if (ishud) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            //            [this dismiss];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];

            //.....
        });
        
    }

    NSString *urlStr ;
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer= [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *appkey = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:LXAppkey]];
    [manager.requestSerializer setValue:appkey forHTTPHeaderField:@"appkey"];
    [manager.requestSerializer setValue:@"zh-tw" forHTTPHeaderField:@"user-language"];
    [manager.requestSerializer setValue:adId forHTTPHeaderField:@"device-id"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString *agent;
    
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
//    if ([lang hasPrefix:@"zh-Hant"]) {
//        agent = [NSString stringWithFormat:@"%@,%@,ios,%@,301",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
//        urlStr = [NSString stringWithFormat:@"%@%@",MAINURL,url];
//    }else
    
    if ([lang hasPrefix:@"id"]){
        agent = [NSString stringWithFormat:@"%@,%@,ios,%@,402",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
        urlStr = [NSString stringWithFormat:@"%@%@",MAINURL,url];
    }else if ([lang hasPrefix:@"ar"]){
        agent = [NSString stringWithFormat:@"%@,%@,ios,%@,403",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
        urlStr = [NSString stringWithFormat:@"%@%@",MAINURL,url];
    }
    else{
        agent = [NSString stringWithFormat:@"%@,%@,ios,%@,301",@"talktome",[infoDictionary objectForKey:@"CFBundleShortVersionString"],phoneVersion];
        urlStr = [NSString stringWithFormat:@"%@%@",MAINURL,url];
    }

    
    
    [manager.requestSerializer setValue:agent forHTTPHeaderField:@"User-Agent"];

    RequestType1 type;
    if ([httpMethod isEqualToString:@"GET"])
    {
        type = RequestGetType1;
    }else{
        type = RequestPostType1;
    
    }
    
   
    
    switch (type) {
        case RequestGetType1:
        {
            
            [manager GET:urlStr parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (finishBlock != nil) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    
                    finishBlock(result);
                    
                    if([[result objectForKey:@"result"] integerValue] == 2 ){
                        
                        [LXUserDefaults setObject:nil forKey:LXAppkey];
                        [LXUserDefaults setObject:nil forKey:Expire];
                        [LXUserDefaults synchronize];

                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            LoginVC *loginVC = [[LoginVC alloc]init];
                            BaseNavigationController *baseNAV = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
                            [AppDelegate shareAppDelegate].window.rootViewController =baseNAV;
                            
                            [[AppDelegate shareAppDelegate].heartBeatTimer invalidate];
                            [AppDelegate shareAppDelegate].heartBeatTimer = nil;
                            
                            AgoraAPI *inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];
                            [inst logout];
                            
                            [LXUserDefaults setObject:nil forKey:LXAppkey];
                            [LXUserDefaults setObject:nil forKey:UID];
                            [LXUserDefaults setObject:nil forKey:Expire];
                            [LXUserDefaults setObject:nil forKey:NickName];
                            [LXUserDefaults setObject:nil forKey:Portrait];
                            [LXUserDefaults setBool:NO forKey:IsLogin];

                            [LXUserDefaults synchronize];
                            
                        });
                        
                    }
                    if([[result objectForKey:@"result"] integerValue] == 24 ){
                        
                        NSString *str = [NSString stringWithFormat:@"时长：%@,原因：%@",result[@"data"][@"durationInHours"],result[@"data"][@"reason"]];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"账号被封") message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:LXSring(@"确定"), nil];
                        [alert show];
                    }

                    
                }

                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Error: %@", [error localizedDescription]);

                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (errorBlock != nil) {

                    errorBlock(error);
                    if (isErrorHud) {
                        
                        [SVProgressHUD showErrorWithStatus:LXSring(@"網絡失敗")];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                        });
                    }

                }

            }];
            
 
        }
            break;
        case RequestPostType1:
        {
            
            [manager POST:urlStr parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (finishBlock != nil) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    finishBlock(result);
                    
                    if([[result objectForKey:@"result"] integerValue] == 2 ){
                        
                        [LXUserDefaults setObject:nil forKey:LXAppkey];
                        [LXUserDefaults setObject:nil forKey:Expire];
                        [LXUserDefaults synchronize];

                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            LoginVC *loginVC = [[LoginVC alloc]init];
                            BaseNavigationController *baseNAV = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
                            [AppDelegate shareAppDelegate].window.rootViewController =baseNAV;
                            [[AppDelegate shareAppDelegate].heartBeatTimer invalidate];
                            [AppDelegate shareAppDelegate].heartBeatTimer = nil;
                        });
                                                
                    }
                    if([[result objectForKey:@"result"] integerValue] == 24 ){
                        
                        NSString *str = [NSString stringWithFormat:@"时长：%@,原因：%@",result[@"data"][@"durationInHours"],result[@"data"][@"reason"]];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"账号被封") message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:LXSring(@"确定"), nil];
                        [alert show];
                    }
                    
                }

            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (errorBlock != nil) {

                    errorBlock(error);
                    
                    if (isErrorHud) {
                        
                        [SVProgressHUD showErrorWithStatus:LXSring(@"網絡失敗")];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                        });
                    }


                }
            }];
            
        }
            break;
        default:
            break;
    }

    return manager;


}

+ (AFHTTPSessionManager *)postMP3:(NSString *)url
                           params:(NSDictionary *)params
                         fileData:(NSData *)fileData
                      finishBlock:(FinishBlock)finishBlock
                       errorBlock:(ErrorBlock)errorBlock
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:fileData name: fileName:[NSString stringWithFormat:@"uploadfile%d",i] mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:fileData name:@"recoder" fileName:@"recoder.mp3" mimeType:@"mp3"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (finishBlock != nil) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            finishBlock(result);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (errorBlock != nil) {
            
            errorBlock(error);
        }

    }];
    
    return manager;

    
    
}

+ (AFHTTPSessionManager *)postImage:(NSString *)url
                             params:(NSDictionary *)params
                          imageName:(NSString *)imagename
                           fileData:(NSData *)fileData
                        finishBlock:(FinishBlock)finishBlock
                         errorBlock:(ErrorBlock)errorBlock
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer= [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"text/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:fileData name:imagename fileName:@"my.png" mimeType:@"image/jpeg"];
//        [formData appendPartWithFileData:fileData name:@"recoder" fileName:@"recoder.mp3" mimeType:@"mp3"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (finishBlock != nil) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            finishBlock(result);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (errorBlock != nil) {
            
            errorBlock(error);
        }
        
    }];
    
    return manager;
    



}

+ (AFHTTPSessionManager *)syncrequestAFWithURL:(NSString *)url
                                    params:(NSDictionary *)params
                                httpMethod:(NSString *)httpMethod
                               finishBlock:(FinishBlock)finishBlock
                                errorBlock:(ErrorBlock)errorBlock
{
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    RequestType1 type;
    if ([httpMethod isEqualToString:@"GET"])
    {
        type = RequestGetType1;
    }else{
        type = RequestPostType1;
        
    }
    switch (type) {
        case RequestGetType1:
        {
            
            [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (finishBlock != nil) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    finishBlock(result);
                }
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Error: %@", [error localizedDescription]);
                
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (errorBlock != nil) {
                    
                    errorBlock(error);
                }
                
            }];
            
            
        }
            break;
        case RequestPostType1:
        {
            
            [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (finishBlock != nil) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    finishBlock(result);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                if (errorBlock != nil) {
                    
                    errorBlock(error);
                }
            }];
            
        }
            break;
        default:
            break;
    }
    
    return manager;
    
}



@end
