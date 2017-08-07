//
//  FixintroduceVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "FixintroduceVC.h"

@interface FixintroduceVC ()

@end

@implementation FixintroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = DTLocalizedString(@"簽名檔", nil);
    [self addrighttitleString:DTLocalizedString(@"保存", nil)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.text = self.model.intro;
}

- (void)rightAction
{
    
    NSDictionary *params;
    params = @{@"intro":_textView.text};
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                
                self.model.intro = _textView.text;
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


- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
