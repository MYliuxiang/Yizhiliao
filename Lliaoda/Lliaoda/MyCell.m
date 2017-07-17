//
//  MyCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([LXUserDefaults boolForKey:ISMEiGUO]) {
        self.profitBtn.hidden = YES;
        self.profitLabel.hidden = YES;
        self.fengeImage.hidden = YES;
        self.profitBtnI.hidden = YES;

    }else{
    
        self.profitBtn.hidden = NO;
        self.profitLabel.hidden = NO;
        self.fengeImage.hidden = NO;
        self.profitBtnI.hidden = NO;

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)accoutAC:(id)sender {
}
@end
