//
//  AboutVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/13.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.text = LXSring(@"");
    self.navbarHiden = NO;
    [self _initViews];
    self.isBack = YES;
}


- (void)_initViews
{
    _actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    //設定代理对象
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
    NSString *urlstring;
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"zh-hant"]) {
        urlstring = [NSString stringWithFormat:@"https://static.yizhiliao.tv/pages/zh-tw/aboutus.html?v=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    }else if ([lang hasPrefix:@"id"]){

        urlstring = [NSString stringWithFormat:@"http://sugar-public.oss-ap-southeast-1.aliyuncs.com/pages/id-id/aboutus.html?v=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];  }else{
        urlstring = [NSString stringWithFormat:@"https://static.yizhiliao.tv/pages/zh-tw/aboutus.html?v=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
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
