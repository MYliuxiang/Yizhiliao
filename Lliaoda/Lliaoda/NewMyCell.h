//
//  NewMyCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *samallImage;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UIView *accountBGView;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end
