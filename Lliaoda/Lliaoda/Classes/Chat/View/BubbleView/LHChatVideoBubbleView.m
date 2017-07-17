//
//  LHChatVideoBubbleView.m
//  LHChatUI
//
//  Created by liuhao on 2016/12/26.
//  Copyright © 2016年 lenhart. All rights reserved.
//

#import "LHChatVideoBubbleView.h"
CGFloat const MAXVideo_SIZE = 120.0f;

@implementation LHChatVideoBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 14;
        _imageView.layer.masksToBounds= YES;
        _imageView.userInteractionEnabled = YES;
        _imageView.frame = CGRectMake(0, 0, 40, 40);
        [self addSubview:_imageView];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.width -= 2;
    frame = CGRectInset(frame, 2, BUBBLE_VIEW_PADDING);
    if (self.messageModel.isSender) {
        frame.origin.x = BUBBLE_VIEW_PADDING;
    }else{
        frame.origin.x = BUBBLE_VIEW_PADDING + BUBBLE_ARROW_WIDTH;
    }
    
    frame.origin.y = BUBBLE_VIEW_PADDING;
    [self.imageView setFrame:frame];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize retSize = CGSizeMake(self.messageModel.width, self.messageModel.height);//self.messageModel.size;
    if (retSize.width == 0 || retSize.height == 0) {
        retSize.width = 60;
        retSize.height = 40;
    }
    
    return CGSizeMake(retSize.width , retSize.height);
}


#pragma mark - setter

- (void)setMessageModel:(Message *)messageModel {
    [super setMessageModel:messageModel];
    
    UIImage *image = [UIImage imageNamed:@"weixin"];
    _imageView.image = image;
}


#pragma mark - public
+ (CGFloat)heightForBubbleWithObject:(Message *)object {
       return 40;
}



@end
