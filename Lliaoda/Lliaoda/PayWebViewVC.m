//
//  PayWebViewVC.m
//  Lliaoda
//
//  Created by 小牛 on 2017/9/1.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "PayWebViewVC.h"

@interface PayWebViewVC ()

@end

@implementation PayWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

#pragma mark - UIWebViewDelegate
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
