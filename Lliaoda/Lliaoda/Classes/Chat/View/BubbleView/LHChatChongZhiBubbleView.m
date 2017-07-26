//
//  LHChatChongZhiBubbleView.m
//  Lliaoda
//
//  Created by 小牛 on 2017/7/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LHChatChongZhiBubbleView.h"
CGFloat const LABEL_FONT_SIZE2 = 15.0f;
@implementation LHChatChongZhiBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 15)];
        _remindLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE2];
        _remindLabel.textColor = UIColorFromRGB(0x1d1d1d);
        [self addSubview:_remindLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, 0, 40, 40)];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton.frame = CGRectMake(0, _remindLabel.bounds.origin.y + 5, 150, 20);
        _detailButton.backgroundColor = [UIColor clearColor];
        [_detailButton setTitleColor:UIColorFromRGB(0xfa3575) forState:UIControlStateNormal];
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_detailButton];
    }
    return self;
}

- (void)setMessageModel:(Message *)messageModel {
    [super setMessageModel:messageModel];
    _remindLabel.text = @"收到我的充值提醒";
    _imageView.image = [UIImage imageNamed:@"chongzhi"];
    [_detailButton setTitle:@"點擊查看充值詳情" forState:UIControlStateNormal];
}

+ (CGFloat)heightForBubbleWithObject:(Message *)object {
    return 15 + 15 + 16 + 20 + 15;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
