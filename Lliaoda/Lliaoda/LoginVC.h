//
//  LoginVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "AgreementVC.h"

@interface LoginVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *logoBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tongYiBtn;

- (IBAction)tongyiAC:(id)sender;
- (IBAction)tap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *noWeixinBtn;
- (IBAction)noweixinLoginAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *noweixinView;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
- (IBAction)noweiXinTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
- (IBAction)faceBookLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *candyTalkLabel;
@property (weak, nonatomic) IBOutlet UIView *languageBGView;
@property (weak, nonatomic) IBOutlet UIButton *chineseButton;
@property (weak, nonatomic) IBOutlet UIButton *indonesiaButton;
- (IBAction)chineseButtonAC:(id)sender;
- (IBAction)indonesiaButtonAC:(id)sender;


@end
