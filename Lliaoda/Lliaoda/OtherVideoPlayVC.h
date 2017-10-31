//
//  OtherVideoPlayVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftsView.h"

@interface OtherVideoPlayVC : UIViewController
@property (nonatomic, strong) NSURL *videoUrl;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
- (IBAction)giftAC:(id)sender;
- (IBAction)closeVideoAC:(id)sender;
@property (nonatomic,retain) PersonModel *model;
@property (nonatomic,strong) GiftsView *giftsView;
@property (weak, nonatomic) IBOutlet UIView *backView;


@end
