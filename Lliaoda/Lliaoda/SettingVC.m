//
//  SettingVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = @"設置";
    [self.checkoutButton setTitle:LXSring(@"切換語言") forState:UIControlStateNormal];
    [self.aboutButton setTitle:LXSring(@"關於我們") forState:UIControlStateNormal];
    [self.loginoutButton setTitle:LXSring(@"退出登陸") forState:UIControlStateNormal];
    
    self.checkoutButton.layer.cornerRadius = 5;
    self.checkoutButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.checkoutButton.layer.shadowRadius = 5.f;
    self.checkoutButton.layer.shadowOpacity = .3f;
    self.checkoutButton.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.aboutButton.layer.cornerRadius = 5;
    self.aboutButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.aboutButton.layer.shadowRadius = 5.f;
    self.aboutButton.layer.shadowOpacity = .3f;
    self.aboutButton.layer.shadowOffset = CGSizeMake(0, 0);
    
//    self.loginoutButton.layer.cornerRadius = 5;
//    self.loginoutButton.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.loginoutButton.layer.shadowRadius = 5.f;
//    self.loginoutButton.layer.shadowOpacity = .3f;
//    self.loginoutButton.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.disturbBGView.layer.cornerRadius = 5;
    self.disturbBGView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.disturbBGView.layer.shadowRadius = 5.f;
    self.disturbBGView.layer.shadowOpacity = .3f;
    self.disturbBGView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.disturbLabel.text = LXSring(@"免打扰");
    if (self.isDND == 1) {
        self.disturbButton.selected = YES;
    } else {
        self.disturbButton.selected = NO;
    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    _maskView.hidden = YES;
    [self.view addSubview:_maskView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)loginout:(id)sender {
    
    //测试
//    VideoPlayVC *vc = [[VideoPlayVC alloc] init];
//    //播放視訊
//    vc.videoUrl = [NSURL URLWithString:@"http://meme-demo-public.oss-cn-beijing.aliyuncs.com/users/7/upload/auth/1497499721001_7.mp4"];
//    //    [self.vc.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
//    return;
    
//    _maskView.hidden = NO;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:LXSring(@"退出登陸") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        _maskView.hidden = YES;

        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LXSring(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        _maskView.hidden = YES;
        
    }];
    
    [cancelAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
    [defaultAction setValue:Color_nav forKey:@"_titleTextColor"];
       
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    LGAlertView *alert = [[LGAlertView alloc] initWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[@"退出登陸"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil delegate:self];
    
    alert.actionHandler = ^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title){
        
        NSDictionary *params;
        [WXDataService requestAFWithURL:Url_logout params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    
                    [[AppDelegate shareAppDelegate].heartBeatTimer invalidate];
                    [AppDelegate shareAppDelegate].heartBeatTimer = nil;
                    
                    AgoraAPI *inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];
                    [inst logout];

                    LoginVC *loginVC = [[LoginVC alloc]init];
                    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
                    [self presentViewController:nav animated:YES completion:nil];
                    [LXUserDefaults setObject:nil forKey:LXAppkey];
                    [LXUserDefaults setObject:nil forKey:UID];
                    [LXUserDefaults setObject:nil forKey:Expire];
                    [LXUserDefaults setObject:nil forKey:NickName];
                    [LXUserDefaults setObject:nil forKey:Portrait];
                    [LXUserDefaults setBool:NO forKey:IsLogin];

                    [LXUserDefaults synchronize];
                    
                    
                } else{     //请求失败
                
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                    });
                    
                }
            }
            
        } errorBlock:^(NSError *error) {
            NSLog(@"%@",error);
                      
        }];
        
    
    };
    
    alert.buttonsTitleColor = Color_Text_origin;
    alert.cancelButtonTitleColor = Color_Text_lightGray;
    alert.tintColor = [UIColor whiteColor];
    [alert showAnimated:YES completionHandler:^{
        
    }];
    
    
}

- (IBAction)aboutAC:(id)sender {
    
    AboutVC *vc = [[AboutVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----LGAlertViewDelegate-----
- (void)alertViewWillDismiss:(LGAlertView *)alertView
{
    _maskView.hidden = YES;

}

- (void)alertViewWillShow:(LGAlertView *)alertView
{

    _maskView.hidden = NO;
}



- (IBAction)checkoutButtonAC:(id)sender {
    LanguageVC *vc = [[LanguageVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)disturbBtnAC:(id)sender {
    _disturbButton.selected = !_disturbButton.selected;
    if (_disturbButton.selected) {
        // 设置免打扰
        [self unDisturb:1];
    } else {
        // 解除免打扰
        [self unDisturb:0];
    }
}
- (void)unDisturb:(BOOL)isDnD {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@(isDnD), @"isDND", nil];
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSDictionary *resultDic = result;
                NSDictionary *data = resultDic[@"data"];
                int isDND = [data[@"isDND"] intValue];
                if (isDND != 1 && isDND != 0) {
                    self.disturbButton.selected = !self.disturbButton.selected;
                }
                
            } else{
                self.disturbButton.selected = !self.disturbButton.selected;
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
            }
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}
@end







