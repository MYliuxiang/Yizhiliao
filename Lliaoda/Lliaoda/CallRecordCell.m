//
//  CallRecordCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "CallRecordCell.h"

@implementation CallRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.thumb.layer.cornerRadius = 25;
    self.thumb.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
