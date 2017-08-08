//
//  LanguageVC.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/7.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LanguageVC.h"

@interface LanguageVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation LanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.text = LXSring(@"更換語言");
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chineseButtonAC:(id)sender {
    self.chineseButton.selected = YES;
    self.indonesiaButton.selected = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"語言變更提示") message:LXSring(@"更換語言後，將退回登錄頁面重新登陸即可") delegate:self cancelButtonTitle:LXSring(@"更換語言後，將退回登錄頁面重新登陸即可") otherButtonTitles:LXSring(@"更換語言後，將退回登錄頁面重新登陸即可"), nil];
    [alert show];
    
    
    [LXUserDefaults setObject:@"zh-hant" forKey:@"userLanguage"];
    [LXUserDefaults synchronize];

}
- (IBAction)indonesiaButtonAC:(id)sender {
    self.chineseButton.selected = NO;
    self.indonesiaButton.selected = YES;
    [LXUserDefaults setObject:@"id" forKey:@"userLanguage"];
    [LXUserDefaults synchronize];

}
@end
