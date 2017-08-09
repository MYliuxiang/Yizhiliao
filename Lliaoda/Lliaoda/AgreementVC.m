//
//  AgreementVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/2.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AgreementVC.h"

@interface AgreementVC ()

@end

@implementation AgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"用户协议");
    self.navbarHiden = NO;
    [self _initViews];
    self.isBack = YES;
}

- (void)back
{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)_initViews
{
    
    _actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    //設定代理对象
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSString *urlstring;
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"zh-Hant"]) {
        urlstring = @"https://static.yizhiliao.tv/pages/zh-tw/agreement.html";
     }else if ([lang hasPrefix:@"id"]){
      urlstring = @"https://sugar-public.oss-ap-southeast-1.aliyuncs.com/pages/id-id/agreement.html";
    }else{
       urlstring = @"https://static.yizhiliao.tv/pages/zh-tw/agreement.html";
    }

    
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
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //结束加载
    [_actView stopAnimating];
    
    //关闭状态上的加载提示
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
