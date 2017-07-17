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

@interface SettingVC : BaseViewController<LGAlertViewDelegate>
@property (nonatomic,retain) UIView *maskView;
- (IBAction)loginout:(id)sender;
- (IBAction)aboutAC:(id)sender;

@end
