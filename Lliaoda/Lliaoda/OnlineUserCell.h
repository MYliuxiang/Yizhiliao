//
//  OnlineUserCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/28.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@interface OnlineUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
- (IBAction)chatButtonAC:(id)sender;
- (IBAction)videoButtonAC:(id)sender;
@property (nonatomic, strong) UserModel *model;

+ (OnlineUserCell *)tableView:(UITableView *)tableView model:(UserModel *)model indexPath:(NSIndexPath *)indexPath;
@end
