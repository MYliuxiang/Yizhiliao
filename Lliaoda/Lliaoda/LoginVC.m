//
//  LoginVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LoginVC.h"
#import "WXApi.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UILabel *label;



@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    BOOL isFirstLaunch = [LXUserDefaults boolForKey:@"firstLaunch"];
    if (isFirstLaunch) {
        [self initViews];
        self.languageBGView.hidden = YES;


    } else {
        
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
//        if([currentLanguage hasPrefix:@"zh-Hant"] || [currentLanguage hasPrefix:@"zh-Hans"]){
//            self.languageBGView.hidden = YES;
//            [LXUserDefaults setObject:@"zh-Hant" forKey:@"appLanguage"];
//            [LXUserDefaults setBool:YES forKey:@"firstLaunch"];
//            [LXUserDefaults synchronize];
//
//        }else
        if ([currentLanguage hasPrefix:@"id"]){
            self.languageBGView.hidden = YES;
            [LXUserDefaults setObject:@"id" forKey:@"appLanguage"];
            [LXUserDefaults setBool:YES forKey:@"firstLaunch"];
            [LXUserDefaults synchronize];

        } else if ([currentLanguage hasPrefix:@"ar"]) {
            self.languageBGView.hidden = YES;
            [LXUserDefaults setObject:@"ar" forKey:@"appLanguage"];
            [LXUserDefaults setBool:YES forKey:@"firstLaunch"];
            [LXUserDefaults synchronize];
            
        } else {
            
            self.languageBGView.hidden = NO;
        }

    }
    
    
    
    self.chineseButton.layer.cornerRadius = 22;
    self.chineseButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.chineseButton.layer.borderWidth = 1;
    
    self.arabicButton.layer.cornerRadius = 22;
    self.arabicButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.arabicButton.layer.borderWidth = 1;
    
    self.indonesiaButton.layer.cornerRadius = 22;
    self.indonesiaButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.indonesiaButton.layer.borderWidth = 1;

    self.logoBtn.layer.masksToBounds = YES;
    self.logoBtn.layer.cornerRadius = 5;
    
    self.loginBtn.layer.cornerRadius = 22;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginBtn.layer.borderWidth = 1;
    
    self.faceBtn.layer.cornerRadius = 22;
    self.faceBtn.layer.masksToBounds = YES;
    self.faceBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.faceBtn.layer.borderWidth = 1;
    
    self.noWeixinBtn.layer.masksToBounds = YES;
    self.noWeixinBtn.layer.cornerRadius = 5;
    
    self.noWeixinBtn.layer.cornerRadius = 22;
    self.noWeixinBtn.layer.masksToBounds = YES;
    self.noWeixinBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.noWeixinBtn.layer.borderWidth = 1;
    self.tongYiBtn.selected = NO;
    self.logoBtn.selected = YES;
    self.logoBtn.userInteractionEnabled = NO;
    
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"id"]){

        self.loginBtn.hidden = YES;

    }else{
        if ([lang hasPrefix:@"ar"]) {
            self.loginBtn.hidden = YES;
        } else {
            if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
                self.loginBtn.hidden = NO;

            }else{

                self.loginBtn.hidden = YES;
            }
        }
    }

    if ([LXUserDefaults boolForKey:ISMEiGUO]){

        self.noweixinView.hidden = NO;
        self.faceBtn.hidden = YES;

    }else{

        self.noweixinView.hidden = YES;
        self.faceBtn.hidden = NO;
    }
//    self.noweixinView.hidden = YES;
//    self.faceBtn.hidden = NO;
    
    NSString *data = [[NSBundle mainBundle] pathForResource:@"2" ofType:nil];
    NSData *da = [NSData dataWithContentsOfFile:data];
    
    NSString *data1 = [[NSBundle mainBundle] pathForResource:@"3" ofType:nil];
    NSData *da1 = [NSData dataWithContentsOfFile:data1];

    self.loginBtn.hidden = YES;
    LxCache *lxcache = [LxCache sharedLxCache];
    [lxcache.cache setObject:da forKey:Url_recommend];
    [lxcache.cache setObject:da1 forKey:CityCache];
    self.navbarHiden = YES;
    

}

- (void)initViews {
    
    self.label.text = LXSring(@"已閱讀並同意用戶使用協定");
    [self.loginBtn setTitle:LXSring(@"WeChat登入") forState:UIControlStateNormal];
    [self.faceBtn setTitle:LXSring(@"Facebook登入") forState:UIControlStateNormal];
    [self.noWeixinBtn setTitle:LXSring(@"登入") forState:UIControlStateNormal];
    self.accountLabel.text = LXSring(@"账号");
    self.passwordLabel.text = LXSring(@"密码");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAC:(id)sender {
    
    //判断是否有微信
    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
        //有微信
        [self weixinClick];
        
    }else{
        
        [self setupAlertController];

    }

}

#pragma mark - 設定弹出提示语
- (void)setupAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LXSring(@"温馨提示") message:LXSring(@"请先安装微信客户端") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:LXSring(@"確定") style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 微信登入
- (void)weixinClick
{
    
    
    if (!self.tongYiBtn.selected) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"请同意用户使用协议") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    [WXApi registerApp:@"wxf86e96f49df077b8"];
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq訊息结构
    [WXApi sendReq:req];
    
    //fb登陆
    
    
    
}

- (IBAction)tongyiAC:(id)sender {
    
    self.tongYiBtn.selected = !self.tongYiBtn.selected;
//    AgreementVC *vc = [[AgreementVC alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)tap:(id)sender {
    
    AgreementVC *vc = [[AgreementVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)noweixinLoginAC:(id)sender {
    
    if (self.userTextField.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"请填写账号！") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.passTextField.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"请填写密码") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    if (!self.tongYiBtn.selected) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"请同意用户使用协议") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    

    NSLog(@"%@",MAINURL);
    
    NSDictionary *params;
    params = @{@"type":@"username",@"username":self.userTextField.text,@"password":self.passTextField.text};
    [WXDataService loginAFWithURL:Url_accountLogin params:params httpMethod:@"POST" isHUD:YES finishBlock:^(id result) {
        if (result) {
            if ([result[@"result"] integerValue] == 0) {
                //成功
                NSString *str = [NSString stringWithFormat:@"%@",result[@"data"][@"appkey"]];
                [LXUserDefaults setObject:str forKey:LXAppkey];
                [LXUserDefaults setObject:result[@"data"][@"expire"] forKey:Expire];
                [LXUserDefaults setObject:result[@"data"][@"uid"] forKey:UID];
                [LXUserDefaults setObject:result[@"data"][@"token"] forKey:AGORETOKEN];
                [LXUserDefaults setObject:result[@"data"][@"nickname"] forKey:NickName];
                [LXUserDefaults synchronize];
                
                //写入缓存
                
                
                AppDelegate *delegate = [AppDelegate shareAppDelegate];
                [delegate loginAgoraSignaling];
                
                NSString *uid = [NSString stringWithFormat:@"%@",result[@"data"][@"uid"]];
                [MobClick profileSignInWithPUID:uid provider:@"WX"];
                [MobClick event:@"Forward"];
                
                TJPTabBarController *rootVC = [[TJPTabBarController alloc] init];
                
                delegate.window.rootViewController = rootVC;
                
            }else{
                
                //登入失败
                NSLog(@"%@",result[@"message"]);
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
    }];
    
}

- (IBAction)noweiXinTap:(id)sender {
    
    [self.view endEditing:YES];
}
- (IBAction)faceBookLogin:(id)sender {
    
    if (!self.tongYiBtn.selected) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"请同意用户使用协议") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
        [login logOut];//这个一定要写，不然会出现换一个帐号就无法获取信息的错误
    
        [login
    
         logInWithReadPermissions: @[@"public_profile",@"email",@"user_about_me"]
    
         fromViewController:self
    
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    
             if (error) {
    
                 NSLog(@"Process error");
    
    
             } else if (result.isCancelled) {
    
                 NSLog(@"Cancelled");
    
    
             } else {
        
    
                 [[AppDelegate shareAppDelegate] facebookLogin:result.token.tokenString];
                
             }
         }];

}
- (IBAction)chineseButtonAC:(id)sender {
    [UIView animateWithDuration:.35 animations:^{
        self.languageBGView.hidden = YES;

    } completion:^(BOOL finished) {
        
    }];
    [LXUserDefaults setObject:@"zh-Hant" forKey:@"appLanguage"];
    [LXUserDefaults synchronize];
    
    [LXUserDefaults setBool:YES forKey:@"firstLaunch"];
    [LXUserDefaults synchronize];
    
}

- (IBAction)indonesiaButtonAC:(id)sender {
    [UIView animateWithDuration:.35 animations:^{
        self.languageBGView.hidden = YES;
        
    } completion:^(BOOL finished) {
        
    }];

    [LXUserDefaults setObject:@"id" forKey:@"appLanguage"];
    [LXUserDefaults synchronize];
    
    [LXUserDefaults setBool:YES forKey:@"firstLaunch"];
    [LXUserDefaults synchronize];
    [self initViews];
//    [self initAgora];
}

- (IBAction)arabicButtonAC:(id)sender {
    [UIView animateWithDuration:.35 animations:^{
        self.languageBGView.hidden = YES;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [LXUserDefaults setObject:@"ar" forKey:@"appLanguage"];
    [LXUserDefaults synchronize];
    
    [LXUserDefaults setBool:YES forKey:@"firstLaunch"];
    [LXUserDefaults synchronize];
    [self initViews];
//    [self initAgora];
}

- (void)initAgora
{
    _inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];
}
@end
