//
//  FixNickNameVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "FixNickNameVC.h"

@interface FixNickNameVC ()

@end

@implementation FixNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"修改暱稱");
    self.textField.text = self.model.nickname;
    [self addrighttitleString:LXSring(@"保存")];
}

- (void)rightAction
{
    
    NSDictionary *params;
    params = @{@"nickname":_textField.text};
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                
                self.model.nickname = _textField.text;
                [self.navigationController popViewControllerAnimated:YES];

                
                
            }else{    //请求失败
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

- (void)textFieldDidChange:(UITextField *)textField
{
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
