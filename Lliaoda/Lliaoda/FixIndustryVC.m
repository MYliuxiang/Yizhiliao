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
    self.textField.text = self.model.nickname;
    [self.saveButton setTitle:LXSring(@"保存") forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)saveButtonAC:(id)sender {
    [self rightAction];
}
@end
