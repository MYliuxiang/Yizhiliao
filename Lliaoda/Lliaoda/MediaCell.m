//
//  MediaCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/7.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MediaCell.h"

@implementation MediaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
                        _effectView.frame = CGRectMake(0, 0, (kScreenWidth - 45) / 4.0, (kScreenWidth - 45) / 4.0);
    _effectView.alpha = .7;
        [self.contentView addSubview:_effectView];
    
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:_effectView.bounds];
        imageV.image = [UIImage imageNamed:@"diandian_fen"];
    imageV.contentMode = UIViewContentModeCenter;
        [_effectView addSubview:imageV];

    
}

- (void)setRow:(int)row
{
    _row = row;
    if (_row == 3) {
        
        self.effectView.hidden = NO;
        
    }else{
        
        self.effectView.hidden = YES;
    }
    


}

@end
