//
//  AccountChargeCell.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AccountChargeCell.h"

@implementation AccountChargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _bigBGView.layer.cornerRadius = 5;
    _bgView.layer.cornerRadius = 5;
    _chargeButton.layer.cornerRadius = 15;
//    _chargeButton.layer.borderWidth = 1;
//    _chargeButton.layer.borderColor = UIColorFromRGB(0x00DDCC).CGColor;
    
//    _bigBGView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _bigBGView.layer.shadowRadius = 5.f;
//    _bigBGView.layer.shadowOpacity = .3f;
//    _bigBGView.layer.shadowOffset = CGSizeMake(0, 0);
}

- (IBAction)chargeButtonAC:(id)sender {
}
@end
