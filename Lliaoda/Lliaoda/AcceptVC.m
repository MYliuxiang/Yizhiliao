//
//  AcceptVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AcceptVC.h"

@interface AcceptVC ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;



@end

@implementation AcceptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"输入邀請碼");
    self.tijiaoBtn.layer.cornerRadius = 22;
    self.tijiaoBtn.layer.masksToBounds = YES;
    
    self.invitationBtn.layer.cornerRadius = 22;
    self.invitationBtn.layer.masksToBounds = YES;
    self.invitationBtn.layer.borderWidth = 1;
    self.invitationBtn.layer.borderColor = Color_Text_origin.CGColor;
    self.label1.text = LXSring(@"邀請碼");
    self.label2.text = LXSring(@"填入好友分享的邀請碼，即可獲得獎勵");
    self.textField.placeholder = LXSring(@"請輸入5位邀請碼，即可獲得獎勵");
    [self.tijiaoBtn setTitle:LXSring(@"提交") forState:UIControlStateNormal];
    [self.invitationBtn setTitle:LXSring(@"我要去邀請") forState:UIControlStateNormal];


}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tijiaoAC:(id)sender{

    
    if (self.textField.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"请填写验证码！") delegate:nil cancelButtonTitle:nil otherButtonTitles:LXSring(@"確定"), nil];
        [alert show];
        return;
    }
    NSDictionary *params;
    params = @{@"code":self.textField.text};
    [WXDataService requestAFWithURL:Url_accountshareactivate params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                [SVProgressHUD showSuccessWithStatus:LXSring(@"激活成功")];
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
