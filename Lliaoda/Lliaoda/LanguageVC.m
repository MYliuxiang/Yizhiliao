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
    
    self.text = DTLocalizedString(DTLocalizedString(@"更換語言", nil), nil);
    
    
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
