//
//  LxPersonHeader.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LxPersonHeader.h"

@implementation LxPersonHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.seletedView.layer.cornerRadius = 45 / 2.0;
    self.seletedView.layer.masksToBounds = YES;
    self.button1.layer.cornerRadius = 41 / 2.0;
    self.button1.layer.masksToBounds = YES;
    self.button2.layer.cornerRadius = 41 / 2.0;
    self.button2.layer.masksToBounds = YES;
    self.button1.titleLabel.textColor = [UIColor whiteColor];
    self.type = 0;

    [_button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button2 setTitleColor:[MyColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.sView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, kScreenWidth / 2 - 15 - 2, 41)];
    self.sView.layer.cornerRadius = 41 / 2.0;
    self.sView.layer.masksToBounds = YES;

    self.sView.backgroundColor = Color_Tab;
    [self.seletedView insertSubview:self.sView atIndex:0];

}

- (IBAction)buttonAC:(UIButton *)sender {
    if (self.type == 0) {
        
        return;
    }
    [UIView animateWithDuration:.35 animations:^{
        
        self.sView.left = 2;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button2 setTitleColor:[MyColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        
    } completion:^(BOOL finished) {
        
        self.type = 0;
        self.oneAction(_type);

    }];
    
    
}

- (IBAction)buttonACTwo:(UIButton *)sender {
    
    if (self.type == 1) {
        
        return;
    }
    [UIView animateWithDuration:.35 animations:^{
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button1 setTitleColor:[MyColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];

        self.sView.left = 2 + kScreenWidth / 2.0 - 15 - 2;
        
    } completion:^(BOOL finished) {
        self.type = 1;
        self.oneAction(_type);
        
    }];
    
}
@end
