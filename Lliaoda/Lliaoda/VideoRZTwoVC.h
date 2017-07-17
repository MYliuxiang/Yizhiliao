//
//  VideoRZTwoVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/20.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface VideoRZTwoVC : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
- (IBAction)completeAC:(id)sender;
@property(nonatomic,retain)NSDictionary *infoDic;
@property (weak, nonatomic) IBOutlet UITextField *ghuiLabel;
@property (nonatomic,retain)UIImage *capImage;
@end
