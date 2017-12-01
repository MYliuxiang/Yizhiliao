//
//  SelectSexVC.h
//  Lliaoda
//
//  Created by 小牛 on 2017/12/1.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectSexVC : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *manImageView;
@property (weak, nonatomic) IBOutlet UIImageView *womanImageView;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
- (IBAction)manButtonAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
- (IBAction)womanButtonAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
