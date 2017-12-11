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
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.portrait]];
    self.nameLabel.text = model.nickname;
    long timeSp = model.createdAt;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    NSString *string = [formatter stringFromDate:date];
    self.timeLabel.text = string;
    
    if (model.categoryId == 0) {
        // 邀请
        _detailLabel.textColor = UIColorFromRGB(0x666666);
        _detailLabel.text = [NSString stringWithFormat:@"你邀请的%@已经注册登陆，你已获得：", model.nickname];
    } else {
        // 充值
        _detailLabel.textColor = UIColorFromRGB(0xfe707d);
        _detailLabel.text = [NSString stringWithFormat:@"你邀请的%@充值%d钻，你已获得：", model.nickname, model.value];
    }
    self.countLabel.text = model.score;
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
