//
//  FixIndustryVC.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/22.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface FixIndustryVC : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveButtonAC:(id)sender;
@property (nonatomic,retain) Mymodel *model;
@end
