//
//  ProfitCell3.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "ProfitCell3.h"

@implementation ProfitCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView1.layer.cornerRadius = 5;
    self.bgView2.layer.cornerRadius = 5;
    self.bgView3.layer.cornerRadius = 5;
    self.leftLabel.text = LXSring(@"累計提現");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
