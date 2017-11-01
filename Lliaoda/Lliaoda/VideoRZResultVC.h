//
//  VideoRZResultVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/20.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "VideoRZVC.h"

@interface VideoRZResultVC : BaseViewController
{
    NSString *url;
}
@property (weak, nonatomic) IBOutlet UIImageView *resultImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateTextLabel;
@property (weak, nonatomic) IBOutlet UIView *sucuressView;
@property (weak, nonatomic) IBOutlet UIImageView *successImageView;
@property (nonatomic,assign) BOOL sucuress;
- (IBAction)playAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *failBtn;
- (IBAction)againVideoRZAC:(id)sender;

@end
