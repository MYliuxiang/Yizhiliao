//
//  SuggestFeedbackVC.m
//  Lliaoda
//
//  Created by 小牛 on 2017/10/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "SuggestFeedbackVC.h"

@interface SuggestFeedbackVC ()

@end

@implementation SuggestFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nav.hidden = NO;
    self.title = @"反饋";
    [self addrighttitleString:@"提交"];
    
}
#pragma mark - 提交
- (void)rightAction {
    
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
        
    } else {
        self.placeHolderLabel.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)typeButtonAC:(id)sender {
    UIButton *button = sender;
    if (button == _typeButton1) {
        _typeButton1.selected = YES;
        _typeButton2.selected = NO;
        _typeButton3.selected = NO;
    } else if (button == _typeButton2) {
        _typeButton1.selected = NO;
        _typeButton2.selected = YES;
        _typeButton3.selected = NO;
    } else if (button == _typeButton3) {
        _typeButton1.selected = NO;
        _typeButton2.selected = NO;
        _typeButton3.selected = YES;
    }
}
@end
