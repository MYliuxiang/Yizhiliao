//
//  AccountHeaderView.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AccountHeaderView.h"

@implementation AccountHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _inviteButton.layer.cornerRadius = 5;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    [_inviteButton setTitle:LXSring(@"邀请送钻") forState:UIControlStateNormal];
    
}

@end
