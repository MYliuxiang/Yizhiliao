//
//  LHChatBarMoreView.m
//  LHChatUI
//
//  Created by lenhart on 2016/12/23.
//  Copyright © 2016年 lenhart. All rights reserved.
//

#import "LHChatBarMoreView.h"

const NSInteger CHAT_BUTTON_SIZE = 55;
const NSInteger INSETS = 8;

@interface LHChatBarMoreView ()

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *giftButton;
@property (nonatomic, strong) UIButton *chongzhiButton;

@end

@implementation LHChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lh_colorWithHex:0xf2f2f6];
    }
    return self;
}

- (void)setIsZhubo:(BOOL)isZhubo
{
    _isZhubo =  isZhubo;
    [self setupSubviews];

}

- (void)setupSubviews {
//    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    CGFloat width = self.frame.size.width;
    NSArray *nameArr;
    if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
        nameArr = @[LXSring(@"視頻通訊"), LXSring(@"提示用戶送禮"), LXSring(@"提示用戶儲值")];
    } else {
        nameArr = @[LXSring(@"視頻通訊"), LXSring(@"送禮物"), LXSring(@"儲值")];
        
    }
//    if (self.isZhubo) { // 是主播
//        nameArr = @[LXSring(@"視頻通訊"), LXSring(@"提示用戶送禮"), LXSring(@"提示用戶儲值")];
//    } else { // 是用户
//        nameArr = @[LXSring(@"視頻通訊"), LXSring(@"送禮物"), LXSring(@"儲值")];
//        
//    }
    
    NSArray *imageNameArr = @[@"shipinliaotian", @"songlitixing", @"chongzhitixing"];
    NSArray *imageNameArr1 = @[@"shipinliaotian", @"songliwu", @"chuzhi"];
//    NSArray *imageNameArr = @[@"shipin_01", @"liwu_01", @"chongzhi_01"];
//    NSArray *selectImageNameArr = @[@"shipin_02",@"liwu_02", @"chongzhi_02"];
    for (int i = 0; i < nameArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        
//        [button setImage:[UIImage imageNamed:selectImageNameArr[i]] forState:UIControlStateHighlighted];
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:12];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        
        if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
            [button setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
            if (i == 0) {
                [button addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(30, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
                
            } else if (i == 1) {
                [button addTarget:self action:@selector(giftAction) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake((width - CHAT_BUTTON_SIZE) / 2, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
                
            } else {
                [button addTarget:self action:@selector(chongzhiAction) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(width - 30 - CHAT_BUTTON_SIZE, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
            }
        } else { // 是用户
            [button setImage:[UIImage imageNamed:imageNameArr1[i]] forState:UIControlStateNormal];
            if (i == 0) {
                [button addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(30, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
                
            } else if (i == 1) {
                [button addTarget:self action:@selector(giftAction) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake((width - CHAT_BUTTON_SIZE) / 2, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
                
            } else {
                [button addTarget:self action:@selector(chongzhiAction) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(width - 30 - CHAT_BUTTON_SIZE, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
            }
        }
//        if (_isZhubo) { // 是主播
//            if (i == 0) {
//                [button addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
//                button.frame = CGRectMake(30, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
//                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
//                
//            } else if (i == 1) {
//                [button addTarget:self action:@selector(giftAction) forControlEvents:UIControlEventTouchUpInside];
//                button.frame = CGRectMake((width - CHAT_BUTTON_SIZE) / 2, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
//                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
//                
//            } else {
//                [button addTarget:self action:@selector(chongzhiAction) forControlEvents:UIControlEventTouchUpInside];
//                button.frame = CGRectMake(width - 30 - CHAT_BUTTON_SIZE, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
//                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
//            }
//        } else { // 是用户
//            if (i == 0) {
//                [button addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
//                button.frame = CGRectMake(30, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
//                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
//                
//            } else if (i == 1) {
//                [button addTarget:self action:@selector(giftAction) forControlEvents:UIControlEventTouchUpInside];
//                button.frame = CGRectMake((width - CHAT_BUTTON_SIZE) / 2, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
//                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
//                
//            } else {
//                [button addTarget:self action:@selector(chongzhiAction) forControlEvents:UIControlEventTouchUpInside];
//                button.frame = CGRectMake(width - 30 - CHAT_BUTTON_SIZE, 25, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE);
//                label.frame = CGRectMake(button.x - CHAT_BUTTON_SIZE / 2, button.bottom + 10, CHAT_BUTTON_SIZE * 2, 15);
//            }
//        }
    }
}

#pragma mark - action

- (void)takePicAction {
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)giftAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewGiftAction:)]) {
        [_delegate moreViewGiftAction:self];
    }
}

- (void)chongzhiAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewChongZhiAction:)]) {
        [_delegate moreViewChongZhiAction:self];
    }
}

@end
