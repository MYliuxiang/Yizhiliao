//
//  NewMyVideoCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMyVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (weak, nonatomic) IBOutlet UIButton *playButton1;
@property (weak, nonatomic) IBOutlet UIButton *playButton2;
@property (weak, nonatomic) IBOutlet UIButton *playButton3;
@property (weak, nonatomic) IBOutlet UIButton *playButton4;

@property (weak, nonatomic) IBOutlet UIView *addBGView;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)videoPlayAC:(id)sender;

@property (nonatomic, strong) NSArray *videoArray;

@property (nonatomic, strong) NSArray *videosArray;

@end
