//
//  WebVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@protocol JSbjDelegate <JSExport>

- (void)linkTo:(NSString *)type;

@end
@interface WebVC : BaseViewController<UIWebViewDelegate, JSbjDelegate>
{
    UIWebView *_webView;
    UIActivityIndicatorView *_actView;  //风火轮视图    
}
@property(nonatomic,copy)NSString *urlStr;
@property (nonatomic, assign) int deposit;
@end
