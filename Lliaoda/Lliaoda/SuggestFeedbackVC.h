//
//  SuggestFeedbackVC.h
//  Lliaoda
//
//  Created by 小牛 on 2017/10/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface SuggestFeedbackVC : BaseViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *typeButton1;
@property (weak, nonatomic) IBOutlet UIButton *typeButton2;
@property (weak, nonatomic) IBOutlet UIButton *typeButton3;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)typeButtonAC:(id)sender;

@end
