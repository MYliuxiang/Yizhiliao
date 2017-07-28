//
//  LHChatGiftBubbleView.h
//  Lliaoda
//
//  Created by 小牛 on 2017/7/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LHChatBaseBubbleView.h"

@interface LHChatGiftBubbleView : LHChatBaseBubbleView

@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UILabel *detailLabel;


+ (CGFloat)heightForBubbleWithObject:(Message *)object;


@end
