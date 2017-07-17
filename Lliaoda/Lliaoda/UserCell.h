//
//  UserCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/22.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "LHChatVC.h"

@interface UserCell : UITableViewCell


@property (nonatomic,retain)UserModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *heagImage;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
- (IBAction)callAC:(id)sender;
- (IBAction)videoAC:(id)sender;

@end
