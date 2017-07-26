//
//  LHChatGiftBubbleView.m
//  Lliaoda
//
//  Created by 小牛 on 2017/7/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LHChatGiftBubbleView.h"
//#import "YYLabel.h"r
CGFloat const LABEL_FONT_SIZE1 = 15.0f;
@implementation LHChatGiftBubbleView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, BUBBLE_VIEW_PADDING, 150, 15)];
        _remindLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE1];
        _remindLabel.textColor = UIColorFromRGB(0x1d1d1d);
        [self addSubview:_remindLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, 0, 40, 40)];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, _remindLabel.bottom + 5, 150, 20);
        _detailButton.backgroundColor = [UIColor redColor];
        [_detailButton setTitleColor:UIColorFromRGB(0xfa3575) forState:UIControlStateNormal];
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_detailButton];
    }
    return self;
}

- (void)setMessageModel:(Message *)messageModel {
    
    [super setMessageModel:messageModel];
    
    self.backgroundColor = [UIColor redColor];
    _remindLabel.text = @"收到我的送禮提醒";
    _imageView.image = [UIImage imageNamed:@"liwu"];
    [_detailButton setTitle:@"點擊查看禮物詳情" forState:UIControlStateNormal];
    
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.messageModel.isRead) {
        
        
    }else{
    
        
    
    }
}


+ (CGFloat)heightForBubbleWithObject:(Message *)object {
    
    return 80 + 20;
    
}


@end
