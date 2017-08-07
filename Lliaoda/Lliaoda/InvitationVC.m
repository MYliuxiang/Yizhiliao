//
//  InvitationVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "InvitationVC.h"



@interface InvitationVC ()

@end

@implementation InvitationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = DTLocalizedString(@"邀請有獎", nil);
    self.yaoBtn.layer.cornerRadius = 22;
    self.yaoBtn.layer.masksToBounds = YES;
    self.isBack = YES;
    
    self.yaoBtn.hidden =YES;
    
    [self.btn1 setTitle:DTLocalizedString(@"复制链接", nil) forState:UIControlStateNormal];
    [self.cancelBtn setTitle:DTLocalizedString(@"取消", nil) forState:UIControlStateNormal];

    
    [self loadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiXinShare:) name:Notice_weiXinShare object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_weiXinShare object:nil];
    
}


- (void)weiXinShare:(NSNotification *)notification
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    NSDictionary *userInfo = notification.userInfo;
    int errcode = [userInfo[@"errCode"] intValue];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    
    switch (errcode) {
        case 0:
            //payResoult = @"支付结果：成功！";
            [SVProgressHUD showWithStatus:DTLocalizedString(@"分享成功", nil)];
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
            });
            
            break;
        case -1:
            //payResoult = @"支付结果：失败！";
            [SVProgressHUD showWithStatus:DTLocalizedString(@"分享失败", nil)];
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
            });
            break;
        case -2:
            //payResoult = @用户已经退出支付！;
            [SVProgressHUD showWithStatus:@"用户已经退出分享！"];
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
            });
            break;
        default:
            //                payResoult = [NSString stringWithFormat:@支付结果：失败！retcode = %d, retstr = %@, resp.errCode,resp.errStr];
            break;
    }
    
    
}


- (void)tap
{

    [UIView animateWithDuration:.35 animations:^{
        
        self.maskView.hidden = YES;
        self.shareView.y = kScreenHeight;
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];

}
//分享
- (void)rightAction
{

    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_accountshare params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                _code = [NSString stringWithFormat:@"%@",result[@"data"][@"code"]];
                
                NSString *str = [NSString stringWithFormat:@"记得提醒好友下载注册以后填写邀請碼: %@",_code];
                NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str];
                [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(19, _code.length)];
                self.shareLabel.attributedText = alertControllerStr;
            
                
                [UIView animateWithDuration:.35 animations:^{
                    
                    self.maskView.hidden = NO;
                    self.shareView.y = kScreenHeight - 260;
                } completion:^(BOOL finished) {
                  
                    
                }];
                
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

- (void)_initViews
{
    
    
    _actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 63, kScreenWidth, kScreenHeight - 63 - 60)];
    //設定代理对象
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSString *urlstring;
    urlstring = [NSString stringWithFormat:@"https://www.yizhiliao.tv/pages/zh-tw/share-result.html?auth=%d",self.model.auth];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSURLRequest *resquest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:resquest];
    
   
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //开始加载
    [_actView startAnimating];
    //开启状态上的加载提示
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //结束加载
    [_actView stopAnimating];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //关闭状态上的加载提示
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
////    self.jsContext[@"test"]=self;
//    
////    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
////        context.exception = exceptionValue;
////        NSLog(@"异常信息：%@", exceptionValue);
////    };
////    JSValue *call = self.jsContext[@"test"];
////    [call callWithArguments:nil];
//    
//    self.jsContext[@"tianbai"] = self;
//    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//        context.exception = exceptionValue;
//        NSLog(@"异常信息：%@", exceptionValue);
//    };
    
    NSString *str = [NSString stringWithFormat:@"callback(\'%@\')",self.app];
    [_webView stringByEvaluatingJavaScriptFromString:str];
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    self.maskView.hidden = YES;
    [self.view addSubview:self.maskView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.maskView addGestureRecognizer:tap];
    
    self.shareView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 260);
    [self.view addSubview:self.shareView];
    
    [self addrightImage:@"fenxiang"];

    self.yaoBtn.hidden = NO;
    
   

}

- (void)loadData{
    
      NSDictionary *params;
      [WXDataService requestAFWithURL:Url_apiaccountshare params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
          NSError *parseError = nil;
          NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&parseError];
          NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
          self.app = [self deleteSpecialCodeWithStr:dataString];
          [self _initViews];
          
       } errorBlock:^(NSError *error) {
           NSLog(@"%@",error);
    
       }];
    
}

- (NSString *)deleteSpecialCodeWithStr:(NSString *)str {
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    return string;
}


#pragma mark - JSObjcDelegate

- (void)Ajax
{
    

}

- (void)test{
    // 获取到照片之后在回调js的方法picCallback把图片传出去
    JSValue *picCallback = self.jsContext[@"test"];
    [picCallback callWithArguments:@[@"photos"]];
}

- (void)getTest:(NSString *)shareString {
    NSLog(@"share:%@", shareString);
    // 分享成功回调js的方法shareCallback
    JSValue *shareCallback = self.jsContext[@"test"];
    [shareCallback callWithArguments:nil];
}

- (void)callback:(NSString *)backString
{


}

- (void)call{
    NSLog(@"call");
    // 之后在回调js的方法Callback把内容传出去
    JSValue *Callback = self.jsContext[@"Callback"];
    //传值给web端
    [Callback callWithArguments:@[@"唤起本地OC回调完成"]];
}


- (void)getCall:(NSString *)callString{
    NSLog(@"Get:%@", callString);
    // 成功回调js的方法Callback
    JSValue *Callback = self.jsContext[@"alerCallback"];
    [Callback callWithArguments:nil];
    
    //    直接添加提示框
        NSString *str = @"alert('OC添加JS提示成功')";
        [self.jsContext evaluateScript:str];
    
    
    
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    NSString *urlString = request.URL.absoluteString;
//    if ([urlString rangeOfString:@"test()"].location != NSNotFound) {
////        
//        
//        NSLog(@"hehe");
//        return NO;
//    }
    
    
//    NSMutableURLRequest *mutableRequest = [request mutableCopy];
//    NSDictionary *requestHeaders = request.allHTTPHeaderFields;
//    // 判断请求头是否已包含，如果不判断该字段会导致webview加载时死循环
//    if (requestHeaders[@"appkey"]) {
//        
//        return YES;
//        
//    } else {
//        
//    NSString *appkey = [LXUserDefaults objectForKey:LXAppkey];
//
//        [mutableRequest setValue:appkey forHTTPHeaderField:@"appkey"];
//        request = [mutableRequest copy];
//        [webView loadRequest:request];
//        
//        return NO;
//        
//    }
    
    return YES;
    
}


- (IBAction)copyAC:(id)sender {
    
    [UIView animateWithDuration:.35 animations:^{
        
        self.maskView.hidden = YES;
        self.shareView.y = kScreenHeight;
    } completion:^(BOOL finished) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
         NSString *urlStr = [NSString stringWithFormat:@"https://www.yizhiliao.tv/pages/zh-tw/share.html?code=%@",_code];
        pasteboard.string = urlStr;
        
    }];
    
}

- (IBAction)weixinAC:(id)sender {
    

    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
        
        
    }else{
        
        //没有微信
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:DTLocalizedString(@"温馨提示", nil) message:DTLocalizedString(@"请先安装微信客户端", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:DTLocalizedString(@"確定", nil) style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionConfirm];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    
    [UIView animateWithDuration:.35 animations:^{
        
        self.maskView.hidden = YES;
        self.shareView.y = kScreenHeight;
    } completion:^(BOOL finished) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
                           //.....
        });

        NSString *urlStr = [NSString stringWithFormat:@"https://www.yizhiliao.tv/pages/zh-tw/share.html?code=%@",_code];
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"\"Candy Talk\"，邀您一起嗨聊";
        message.description = @"最美主播統統入住，立刻下載，贏得獎勵";
        [message setThumbImage:[UIImage imageNamed:@"dengluicon"]];
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = urlStr;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
       
        [WXApi sendReq:req];
        
    }];
}

- (IBAction)yaoAC:(id)sender {
    
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_accountshare params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                _code = [NSString stringWithFormat:@"%@",result[@"data"][@"code"]];
                
                NSString *str = [NSString stringWithFormat:@"记得提醒好友下载注册以后填写邀請碼: %@",_code];
                NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str];
                [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(19, _code.length)];
                self.shareLabel.attributedText = alertControllerStr;
                
                
                [UIView animateWithDuration:.35 animations:^{
                    
                    self.maskView.hidden = NO;
                    self.shareView.y = kScreenHeight - 260;
                } completion:^(BOOL finished) {
                    
                    
                }];
                
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

- (IBAction)facebooShare:(id)sender {
    
    
    NSString *urlStr = [NSString stringWithFormat:@"https://www.yizhiliao.tv/pages/zh-tw/share.html?code=%@",_code];
//     @"最美主播統統入駐，立刻下載，贏得獎勵";
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:urlStr];
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:self];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
     dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
   
    
        [SVProgressHUD showWithStatus:DTLocalizedString(@"分享成功", nil)];

    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
    });

}


- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    [SVProgressHUD showWithStatus:DTLocalizedString(@"分享失败", nil)];
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
    });
}


- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    [SVProgressHUD showWithStatus:DTLocalizedString(@"取消分享", nil)];
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
    });

}

- (IBAction)pengAC:(id)sender {
    
    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
        
        
    }else{
        
        //没有微信
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:DTLocalizedString(@"温馨提示", nil) message:DTLocalizedString(@"请先安装微信客户端", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:DTLocalizedString(@"確定", nil) style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionConfirm];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }

    
    [UIView animateWithDuration:.35 animations:^{
        
        self.maskView.hidden = YES;
        self.shareView.y = kScreenHeight;
        
    } completion:^(BOOL finished) {
        
         NSString *urlStr = [NSString stringWithFormat:@"https://www.yizhiliao.tv/pages/zh-tw/share.html?code=%@",_code];
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"\"Candy Talk\"，邀您一起嗨聊";;
        message.description = @"最美主播統統入駐，立刻下載，贏得獎勵";
        [message setThumbImage:[UIImage imageNamed:@"dengluicon"]];
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = urlStr;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
        
    }];

}

- (IBAction)cancleAC:(id)sender {
    
    [UIView animateWithDuration:.35 animations:^{
        
        self.maskView.hidden = YES;
        self.shareView.y = kScreenHeight;
    } completion:^(BOOL finished) {
        
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end











