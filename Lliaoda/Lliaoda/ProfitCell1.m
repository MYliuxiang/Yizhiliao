//
//  ProfitCell1.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/22.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "ProfitCell1.h"

@implementation ProfitCell1
+ (ProfitCell1 *)tableView:(UITableView *)tableView
                 indexPath:(NSIndexPath *)indexPath
                  delegate:(id<ProfitCell1Delegate>)delegate;
{
    ProfitCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfitCell1"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfitCell1" owner:self options:nil] firstObject];
    }
    cell.delegate = delegate;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cashButton.layer.cornerRadius = 22;
    [self.cashButton setTitle:LXSring(@"提現") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cashBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cashButtonAC)]) {
        [_delegate cashButtonAC];
    }
}
@end
