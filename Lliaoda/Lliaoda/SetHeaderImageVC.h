//
//  SetHeaderImageVC.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface SetHeaderImageVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *buttonBGView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
- (IBAction)cameraButtonAC:(id)sender;
- (IBAction)albumButtonAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *albumButton;

@end
