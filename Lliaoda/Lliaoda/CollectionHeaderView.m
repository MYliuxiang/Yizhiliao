//
//  CollectionHeaderView.m
//  Lliaoda
//
//  Created by 小牛 on 2017/7/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView

- (void)awakeFromNib {

    [super awakeFromNib];

    self.label1.text = LXSring(@"賬戶餘額(鑽石)");

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
