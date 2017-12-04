//
//  VideoRZVC2.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface VideoRZVC2 : BaseViewController
@property (nonatomic, strong) NSDictionary *info;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UILabel *unionLabel;
@property (weak, nonatomic) IBOutlet UITextField *unionTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
- (IBAction)confirmButtonAC:(id)sender;
@property (nonatomic, assign) BOOL isFirst;

@end
