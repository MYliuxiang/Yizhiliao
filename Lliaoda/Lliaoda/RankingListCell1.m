//
//  RankingListCell1.m
//  Lliaoda
//
//  Created by 小牛 on 2017/10/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "RankingListCell1.h"

@implementation RankingListCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _bottomImage.layer.cornerRadius = 42;
    _headerImageView.layer.cornerRadius = 40;
//    _headerImageView.layer.borderColor = UIColorFromRGB(0xf7db00).CGColor;
//    _headerImageView.layer.borderWidth = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
