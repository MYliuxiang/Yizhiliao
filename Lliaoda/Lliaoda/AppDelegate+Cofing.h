//
//  AppDelegate+Cofing.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Cofing)
//版本更新开关
- (void)appconfig;
//检查更新版本自动更新
- (void)updataAppVersion;

- (void)updataFinalCallTime;

//发送心跳包
- (void)heartBeat;

- (UIViewController *)topViewController;

@end
