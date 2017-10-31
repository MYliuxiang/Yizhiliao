//
//  WebVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()

@end

@implementation WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navbarHiden = NO;
    [self _initViews];
    self.isBack = YES;
}

- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)_initViews
{
    
    _actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    //設定代理对象
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:_urlStr];
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

@end
