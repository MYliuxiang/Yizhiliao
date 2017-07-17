//
//  AcceptVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "InvitationVC.h"

@interface AcceptVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *invitationBtn;
- (IBAction)tijiaoAC:(id)sender;
- (IBAction)invitationAC:(id)sender;

@end
