//
//  LanguageVC.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/7.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface LanguageVC : BaseViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *chineseButton;
- (IBAction)chineseButtonAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *indonesiaButton;
- (IBAction)indonesiaButtonAC:(id)sender;
@property (nonatomic,assign) int index;
    @property (weak, nonatomic) IBOutlet UIButton *arabicButton;
- (IBAction)arabicButtonAC:(id)sender;

@end
