//
//  InviteProfitCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/12/11.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntiveProfitModel.h"
@interface InviteProfitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (nonatomic, strong) IntiveProfitModel *model;
+ (InviteProfitCell *)tableView:(UITableView *)tableView
                      indexPath:(NSIndexPath *)indexPath
                          model:(IntiveProfitModel *)model;
@end
