//
//  PersonCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "PersonCell.h"

@implementation PersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.label = @"簽名檔";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
