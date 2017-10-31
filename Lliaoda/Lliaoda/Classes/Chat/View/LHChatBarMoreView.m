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
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    NSArray *nameArr;
    NSArray *imageNameArr;
    if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
        nameArr = @[LXSring(@"視頻通訊"),@"語音通話", LXSring(@"提示用戶\n送禮"), LXSring(@"提示用戶\n儲值")];
        imageNameArr = @[@"shipinliaotian",@"yuyintonghua", @"songlitixing", @"chongzhi"];
    } else {
        nameArr = @[LXSring(@"視頻通訊"),@"語音通話", LXSring(@"送禮物"), LXSring(@"儲值")];
        imageNameArr = @[@"shipinliaotian",@"yuyintonghua", @"songliwu", @"chongzhi"];

    }
    

    for (int i = 0; i < nameArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        [self addSubview:button];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        [button addTarget:self action:@selector(chatMoreAC:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(5 + (kScreenWidth / 4 - 30 + 30) * i, 25, kScreenWidth / 4 - 30, 60);
        label.frame = CGRectMake(button.x, button.bottom + 5, kScreenWidth / 4 - 30, 30);
        label.numberOfLines = 2;
       
            label.text = nameArr[i];
            [button setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
    }
}

#pragma mark - action

- (void)chatMoreAC:(UIButton *)btn
{
    int index = (int)btn.tag - 100;
    switch (index) {
        case 0:
            
            if(_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCall:)]){
                [_delegate moreViewVideoCall:self];
            }
            break;
            
        case 1:
            
            if (_delegate && [_delegate respondsToSelector:@selector(moreViewVioceCallAction:)]) {
                [_delegate moreViewVioceCallAction:self];
            }
            break;
            
        case 2:
            
            if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
                
                if (_delegate && [_delegate respondsToSelector:@selector(moreViewGiftPrompt:)]) {
                    [_delegate moreViewGiftPrompt:self];
                }
            }else{
                
                if (_delegate && [_delegate respondsToSelector:@selector(moreViewGiftAction:)]) {
                    [_delegate moreViewGiftAction:self];
                }
                
            }
            
            break;
            
        case 3:
            
            if (_delegate && [_delegate respondsToSelector:@selector(moreViewChongZhiAction:)]) {
                [_delegate moreViewChongZhiAction:self];
            }
            
            break;
            
            
            
        default:
            break;
    }
    
}


@end
