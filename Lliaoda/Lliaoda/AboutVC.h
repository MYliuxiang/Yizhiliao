//
//  AboutVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/13.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface AboutVC : BaseViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    
    UIActivityIndicatorView *_actView;  //风火轮视图
    
    
}



@end
