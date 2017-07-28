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
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, BUBBLE_VIEW_PADDING, 130, 40)];
        _remindLabel.numberOfLines = 0;
        _remindLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE1];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.textColor = UIColorFromRGB(0x1d1d1d);
        [self addSubview:_remindLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_remindLabel.right, _remindLabel.top, 40, 40)];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
//        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _detailButton.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, _remindLabel.bottom + 12, _remindLabel.width, 15);
//        _detailButton.backgroundColor = [UIColor clearColor];
//        [_detailButton setTitleColor:UIColorFromRGB(0xfa3575) forState:UIControlStateNormal];
//        _detailButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self addSubview:_detailButton];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, _remindLabel.bottom, _remindLabel.width, 30)];
        _detailLabel.textColor = UIColorFromRGB(0xfa3575);
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.numberOfLines = 0;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.userInteractionEnabled = YES;
        [self addSubview:_detailLabel];
    }
    return self;
}

- (CGFloat)heightForText:(NSString *)text fontSize:(CGFloat)fontSize
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [text boundingRectWithSize:CGSizeMake(130, 100) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.height;
}

- (void)setMessageModel:(Message *)messageModel {
    
    [super setMessageModel:messageModel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToGiftView)];
    [_detailLabel addGestureRecognizer:tap];
//    [_detailButton addTarget:self action:@selector(clickToGiftView) forControlEvents:UIControlEventTouchUpInside];
    if ([messageModel.uid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        _remindLabel.text = messageModel.content;
        _imageView.image = [UIImage imageNamed:@"liwu"];
//        [_detailButton setTitle:@"對方點擊提醒可查看送禮頁" forState:UIControlStateNormal];
//        _detailButton.enabled = NO;
        CGFloat height1 = [self heightForText:messageModel.content fontSize:LABEL_FONT_SIZE1];
        _remindLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, BUBBLE_VIEW_PADDING, 130, height1);
        
        CGFloat height2 = [self heightForText:@"對方點擊提醒可查看送禮頁" fontSize:12];
        _detailLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, _remindLabel.bottom, _remindLabel.width, height2);
        _detailLabel.text = @"對方點擊提醒可查看送禮頁";
        _detailLabel.userInteractionEnabled = NO;
    }
    
    if ([messageModel.sendUid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        _remindLabel.text = @"收到我的送禮提醒";
        _imageView.image = [UIImage imageNamed:@"liwu"];
//        [_detailButton setTitle:@"點擊查看禮物詳情" forState:UIControlStateNormal];
//        _detailButton.enabled = YES;
        
        _detailLabel.text = @"點擊查看禮物詳情";
        _detailLabel.userInteractionEnabled = YES;
    }
//    _detailLabel.textColor = [UIColor redColor];
//    if ([[NSString stringWithFormat:@"%@", messageModel.uid] isEqualToString:[NSString stringWithFormat:@"%@", [LXUserDefaults objectForKey:UID]]]) {
//        _remindLabel.text = messageModel.content;
//        _imageView.image = [UIImage imageNamed:@"liwu"];
//        [_detailButton setTitle:@"對方點擊提醒可查看送禮頁" forState:UIControlStateNormal];
//        _detailButton.enabled = NO;
//    }
//    if ([[NSString stringWithFormat:@"%@", messageModel.sendUid] isEqualToString:[LXUserDefaults objectForKey:UID]]) {
//        _remindLabel.text = @"收到我的送禮提醒";
//        _imageView.image = [UIImage imageNamed:@"liwu"];
//        [_detailButton setTitle:@"點擊查看禮物詳情" forState:UIControlStateNormal];
//        _detailButton.enabled = YES;
//    }
    
}

- (void)clickToGiftView {
    [self routerEventWithName:kRouterEventGiftBubbleLongTapEventName
                     userInfo:@{kMessageKey : self.messageModel}];
}

- (void)longPress:(UILongPressGestureRecognizer *)longp
{
    if (longp.state == UIGestureRecognizerStateEnded) {
        [self becomeFirstResponder];
        //
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(myDelete:)];
        UIMenuItem *item3 = [[UIMenuItem alloc]initWithTitle:@"更多..." action:@selector(myMore:)];
        menu.menuItems = @[item2,item3];
        
        [menu setTargetRect:self.bounds inView:self];
        [menu setMenuVisible:YES animated:YES];
        //
        
    }
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    
//    CGSize retSize = CGSizeMake(self.messageModel.width, self.messageModel.height);//self.messageModel.size;
//    if (retSize.width == 0 || retSize.height == 0) {
//        retSize.width = 200;
//        retSize.height = 30 + 24 + 15 + 30;
//    }
//    return retSize;
    return CGSizeMake(200 , 30 + 24 + 15 + 20);
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.messageModel.isRead) {
        
        
    }else{
    
        
    
    }
}

- (void)myDelete:(UIMenuController *) menu
{
    
    [self routerEventWithName:kRouterEventBubbleMenuDelete
                     userInfo:@{kMessageKey : self.messageModel}];
    
}

- (void)myMore:(UIMenuController *) menu
{
    
    [self routerEventWithName:kRouterEventBubbleMenuMore
                     userInfo:@{kMessageKey : self.messageModel}];
}

+ (CGFloat)heightForBubbleWithObject:(Message *)object {
    
    return 80 + 20;
    
}

//是否可以成为第一相应
-(BOOL)canBecomeFirstResponder{
    
    return YES;
    
}

//是否可以接收某些菜单的某些交互操作
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action == @selector(myDelete:)||action == @selector(myMore:)) {
        return YES;
    }
    return NO;
}
@end
