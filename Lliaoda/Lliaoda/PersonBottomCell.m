//
//  PersonBottomCell.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "PersonBottomCell.h"

@implementation PersonBottomCell
+ (PersonBottomCell *)tableView:(UITableView *)tableView
                      indexPath:(NSIndexPath *)indexPath
{
    PersonBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonBottomCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonBottomCell" owner:self options:nil] firstObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.borderWidth = 1;
    _bgView.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
