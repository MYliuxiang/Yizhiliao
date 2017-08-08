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
    
    NSString *lang = [LXUserDefaults valueForKey:@"userLanguage"];
    if ([lang hasPrefix:@"zh-hant"]) {
       
        self.chineseButton.selected = YES;
        self.indonesiaButton.selected = NO;
        self.index = 0;

        
    }else if ([lang hasPrefix:@"id"]){
        
        self.chineseButton.selected = NO;
        self.indonesiaButton.selected = YES;
        self.index = 1;

    }else{
        
        self.chineseButton.selected = YES;
        self.indonesiaButton.selected = NO;
        self.index = 0;

    }

    
}


- (IBAction)chineseButtonAC:(id)sender {
    if (self.index == 0) {
        return;
    }
    self.index = 0;
    self.chineseButton.selected = YES;
    self.indonesiaButton.selected = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"語言變更提示") message:LXSring(@"更換語言後，將退回登錄頁面重新登陸即可") delegate:self cancelButtonTitle:LXSring(@"是") otherButtonTitles:LXSring(@"否"), nil];
    alert.tag = 100;
    [alert show];
    
    
 
}
- (IBAction)indonesiaButtonAC:(id)sender {
    if (self.index == 1) {
        return;
    }
    self.index = 1;
    self.chineseButton.selected = NO;
    self.indonesiaButton.selected = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"語言變更提示") message:LXSring(@"更換語言後，將退回登錄頁面重新登陸即可") delegate:self cancelButtonTitle:LXSring(@"否") otherButtonTitles:LXSring(@"是"), nil];
    alert.tag = 101;
    [alert show];
   

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        return;
    }
    if (alertView.tag == 100) {
        
        [LXUserDefaults setObject:@"zh-hant" forKey:@"userLanguage"];
        [LXUserDefaults synchronize];

    }else{
    
        [LXUserDefaults setObject:@"id" forKey:@"userLanguage"];
        [LXUserDefaults synchronize];
    }
    
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

}

@end























