//
//  NewMyCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "NewMyCell.h"

@implementation NewMyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)accountBtnAC:(id)sender {
    UIButton *button = sender;
    if (_delegate && [_delegate respondsToSelector:@selector(accountButtonClick:)]) {
        [_delegate accountButtonClick:button];
    }
}
@end
