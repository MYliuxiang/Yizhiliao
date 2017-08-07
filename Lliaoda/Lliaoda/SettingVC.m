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
    self.text = DTLocalizedString(@"设置", nil);
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
    
    
//    _maskView.hidden = NO;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:DTLocalizedString(@"退出登陸", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        _maskView.hidden = YES;

        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:DTLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        _maskView.hidden = YES;
        
    }];
    
    [cancelAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
    [defaultAction setValue:Color_nav forKey:@"_titleTextColor"];
       
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    LGAlertView *alert = [[LGAlertView alloc] initWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[DTLocalizedString(@"退出登陸", nil)] cancelButtonTitle:DTLocalizedString(@"取消", nil) destructiveButtonTitle:nil delegate:self];
    
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
    
    alert.buttonsTitleColor = Color_nav;
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



@end







