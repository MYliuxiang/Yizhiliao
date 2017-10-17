//
//  SettingVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginVC.h"
#import "BaseNavigationController.h"
#import "AboutVC.h"
#import "LanguageVC.h"

@interface SettingVC : BaseViewController<LGAlertViewDelegate>
@property (nonatomic,retain) UIView *maskView;
- (IBAction)loginout:(id)sender;
- (IBAction)aboutAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
- (IBAction)checkoutButtonAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginoutButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIView *disturbBGView;
@property (weak, nonatomic) IBOutlet UIButton *disturbButton;
- (IBAction)disturbBtnAC:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *disturbLabel;
@property (nonatomic, assign) int isDND;
@end
