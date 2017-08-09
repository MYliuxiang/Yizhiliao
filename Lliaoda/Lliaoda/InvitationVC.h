//
//  InvitationVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@protocol JSObjcDelegate <JSExport>

- (void)test;
- (void)getTest:(NSString *)shareString;
- (void)Ajax;

- (void)callback:(NSString *)backString;

- (void)call;
- (void)getCall:(NSString *)callString;

@end
@interface InvitationVC : BaseViewController<UIWebViewDelegate,JSObjcDelegate,FBSDKSharingDelegate>
{
    UIWebView *_webView;
    UIActivityIndicatorView *_actView;  //风火轮视图
}
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (nonatomic,retain) Mymodel *model;
@property (nonatomic,copy) NSString *app;
@property (nonatomic, strong) JSContext *jsContext;



@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)copyAC:(id)sender;
- (IBAction)weixinAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *yaoBtn;
- (IBAction)yaoAC:(id)sender;
- (IBAction)facebooShare:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *idShareView;
@property (weak, nonatomic) IBOutlet UILabel *idshareLabel;
@property (weak, nonatomic) IBOutlet UIButton *idCancel;
- (IBAction)idCancelAC:(id)sender;
- (IBAction)idFBShareAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *idcopyBtn;
- (IBAction)idCopyAC:(id)sender;

- (IBAction)pengAC:(id)sender;
- (IBAction)cancleAC:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (nonnull,retain) UIView *maskView;
@property (nonatomic,copy) NSString *code;
@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *friendButton;
@property (nonatomic,retain) UIView *myShareView;
@property (nonatomic,assign) float height;

@end
