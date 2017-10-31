//
//  LxPersonNewCell3.m
//  Lliaoda
//
//  Created by 小牛 on 2017/10/27.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LxPersonNewCell3.h"

@implementation LxPersonNewCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)getGiftBtnAC:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(giftBtnClick)]) {
        [_delegate giftBtnClick];
    }
}

- (IBAction)getMoneyBtnAC:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(chargeBtnClick)]) {
        [_delegate chargeBtnClick];
    }
}
@end
