//
//  AcceptVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AcceptVC.h"

@interface AcceptVC ()

@end

@implementation AcceptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = @"输入邀請碼";
    self.tijiaoBtn.layer.cornerRadius = 22;
    self.tijiaoBtn.layer.masksToBounds = YES;
    
    self.invitationBtn.layer.cornerRadius = 22;
    self.invitationBtn.layer.masksToBounds = YES;
    self.invitationBtn.layer.borderWidth = 1;
    self.invitationBtn.layer.borderColor = Color_nav.CGColor;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tijiaoAC:(id)sender{

    if (self.textField.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写验证码！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"確定", nil];
        [alert show];
        return;
    }
    NSDictionary *params;
    params = @{@"code":self.textField.text};
    [WXDataService requestAFWithURL:Url_accountshareactivate params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                [SVProgressHUD showSuccessWithStatus:@"激活成功"];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [SVProgressHUD dismiss];
                });

                
                
            } else{
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
- (IBAction)invitationAC:(id)sender
{
    InvitationVC *vc = [[InvitationVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
