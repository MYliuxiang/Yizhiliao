//
//  MessageCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/27.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCount.h"
#import "PersonModel.h"

@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic,retain) MessageCount *count;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
