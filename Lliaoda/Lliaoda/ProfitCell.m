//
//  ProfitCell.m
//  Lliaoda
//
//  Created by 小牛 on 2017/7/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "ProfitCell.h"

@implementation ProfitCell
+ (ProfitCell *)tableView:(UITableView *)tableView
                indexPath:(NSIndexPath *)indexPath
                 delegate:(id<ProfitCellDelegate>)delegate;
{
    ProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfitCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfitCell" owner:self options:nil] firstObject];
        
    }
    
    cell.delegate = delegate;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = Color_nav;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tixianBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(btnClick:)]) {
        [_delegate btnClick:self];
    }
}
@end
