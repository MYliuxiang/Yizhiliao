//
//  AgreementVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/2.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface AgreementVC : BaseViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    
    UIActivityIndicatorView *_actView;  //风火轮视图
    
    
}


@end
