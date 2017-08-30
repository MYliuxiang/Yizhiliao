//
//  AccountPayTypeCell.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AccountPayTypeCell.h"

@implementation AccountPayTypeCell
+ (AccountPayTypeCell *)tableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                         delegate:(id<AccountPayTypeCellDelegate>)delegate
{
    AccountPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountPayTypeCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountPayTypeCell" owner:self options:nil] firstObject];
        
    }
    cell.delegate = delegate;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _payTypeLabel.text = LXSring(@"支付方式");
    _unipinLabel.text = LXSring(@"UniPin");
    _huafeiLabel.text = LXSring(@"话费充值");
    _appleLabel.text = LXSring(@"Apple In-App Purchase");
    _kefuLabel.text = LXSring(@"客服帮忙(更多优惠哦)");
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowRadius = 5.f;
    self.bgView.layer.shadowOpacity = .3f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)unipinBtnAC:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(unipinAC)]) {
        [_delegate unipinAC];
    }
}

- (IBAction)huafeiBtnAC:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(huafeiAC)]) {
        [_delegate huafeiAC];
    }
}

- (IBAction)appleBtnAC:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(appleAC)]) {
        [_delegate appleAC];
    }
}

- (IBAction)kefuBtnAC:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(kefuAC)]) {
        [_delegate kefuAC];
    }
}
@end
