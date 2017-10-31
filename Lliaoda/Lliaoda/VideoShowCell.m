//
//  VideoShowCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoShowCell.h"

@implementation VideoShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatrImage.layer.masksToBounds = YES;
    self.avatrImage.layer.cornerRadius = 11;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
}

- (void)setModel:(VideoShowModel *)model
{
    _model = model;
    [self.avatrImage sd_setImageWithURL:[NSURL URLWithString:_model.portrait]];
    [self.tumbImage sd_setImageWithURL:[NSURL URLWithString:_model.cover]];
    self.nameLabel.text = _model.nickname;

    
}

@end
