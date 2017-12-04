//
//  VideoRZVC1.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface VideoRZVC1 : BaseViewController
@property (nonatomic, strong) NSDictionary *info;
@property (weak, nonatomic) IBOutlet UIView *approvingBGView;
@property (weak, nonatomic) IBOutlet UIImageView *approvingVideoImageView;
@property (weak, nonatomic) IBOutlet UIButton *approvingVideoPlayButton;
- (IBAction)approvingVideoPlayButtonAC:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *approvingDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *approvingUploadButton;
- (IBAction)approvingUploadButtonAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *approvingView;
@property (nonatomic, assign) BOOL isFirst;
@end
