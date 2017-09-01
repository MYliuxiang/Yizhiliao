//
//  PayWebViewVC.h
//  Lliaoda
//
//  Created by 小牛 on 2017/9/1.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface PayWebViewVC : BaseViewController<UIWebViewDelegate>
{
    UIActivityIndicatorView *_actView;  //风火轮视图
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSString *urlString;

@end
