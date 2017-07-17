//
//  GiftCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "GiftCell.h"

@implementation GiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.giftImage.hidden = YES;
    self.countLabel.hidden = YES;
    self.nameLabel.hidden = YES;
    self.zuanImage.hidden = YES;
}

- (void)setModel:(MGiftModel *)model
{
    _model = model;
    if (_model == nil) {
        self.giftImage.hidden = YES;
        self.countLabel.hidden = YES;
        self.nameLabel.hidden = YES;
        self.zuanImage.hidden = YES;
        
    }else{
    
        self.giftImage.hidden = NO;
        self.countLabel.hidden = NO;
        self.nameLabel.hidden = NO;
        self.zuanImage.hidden = NO;
        [self.giftImage sd_setImageWithURL:[NSURL URLWithString:model.icon]];
        self.countLabel.text = [NSString stringWithFormat:@"%d",_model.diamonds];
        self.nameLabel.text = _model.name;
    }
   

}

@end
