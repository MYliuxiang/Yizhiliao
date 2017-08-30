//
//  FixIndustryVC.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/22.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "FixIndustryVC.h"

@interface FixIndustryVC ()

@end

@implementation FixIndustryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"修改行業");
    self.textField.delegate = self;
    self.textField.text = self.model.domain;
    self.textField.placeholder = LXSring(@"填寫行業，找到更多志同道合的朋友");
    [self.saveButton setTitle:LXSring(@"保存") forState:UIControlStateNormal];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self addrighttitleString:LXSring(@"保存")];
    self.saveButton.layer.cornerRadius = 5;
    self.bgView.layer.cornerRadius = 5;
    
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowRadius = 5.f;
    self.bgView.layer.shadowOpacity = .3f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 10) {
        textField.text = [textField.text substringToIndex:10];
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == self.textField) {
//        if (textField.text.length > 10) return NO;
//    }
//    
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)saveButtonAC:(id)sender {
//    [self rightAction];
    NSDictionary *params;
    params = @{@"domain":_textField.text};
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                
                self.model.domain = _textField.text;
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
@end
