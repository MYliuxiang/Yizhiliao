//
//  VideoRZCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoRZCell.h"

@implementation VideoRZCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    self.bgImgeView.layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    self.bgImgeView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.bgImgeView.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    self.bgImgeView.layer.shadowRadius = 3;//阴影半径，默认3
    
    self.bgImgeView.layer.masksToBounds = NO;
    self.bgImgeView.layer.cornerRadius = 5.f;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
