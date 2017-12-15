//
//  InviteProfitCell.m
//  Lliaoda
//
//  Created by 小牛 on 2017/12/11.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "InviteProfitCell.h"

@implementation InviteProfitCell
+ (InviteProfitCell *)tableView:(UITableView *)tableView
                      indexPath:(NSIndexPath *)indexPath
                          model:(IntiveProfitModel *)model
{
    InviteProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteProfitCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InviteProfitCell" owner:self options:nil] firstObject];
        cell.backgroundView = nil;
    }
    cell.model = model;
    return cell;
}

- (void)setModel:(IntiveProfitModel *)model {
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"headerImage.jpg"]];
    long timeSp = model.createdAt;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    NSString *string = [formatter stringFromDate:date];
    
    NSString *testStr = [NSString stringWithFormat:@"%@ %@", model.nickname, string];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:testStr];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x00ddcc) range:NSMakeRange(0,model.nickname.length)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(model.nickname.length, string.length + 1)];
    self.nameLabel.attributedText = str;
    
    
    
//    self.nameLabel.text = model.nickname;
    
    self.timeLabel.text = string;
    //    "已经注册登陆，你已获得："  =  "已经注册登陆，你已获得：";
    //    "已充值%d钻，你获得："  =  "已充值%d钻，你获得：";
    if (model.categoryId == 0) {
        // 邀请
        _detailLabel.textColor = UIColorFromRGB(0x666666);
        _detailLabel.text = LXSring(@"已经注册登陆，你已获得：");
    } else {
        // 充值
        _detailLabel.textColor = UIColorFromRGB(0xfe707d);
        _detailLabel.text = [NSString stringWithFormat:LXSring(@"已充值%d钻，你获得："), model.value];
    }
    self.countLabel.text = model.score;
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
  
    self.headerImage.layer.cornerRadius = 25;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
