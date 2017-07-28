//
//  LHChatChongZhiBubbleView.m
//  Lliaoda
//
//  Created by 小牛 on 2017/7/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LHChatChongZhiBubbleView.h"
CGFloat const LABEL_FONT_SIZE2 = 15.0f;

CGFloat const CZLABEL_MAX_WIDTH = 180.0f;
static CGSize CZiftBoundingSize;

@implementation LHChatChongZhiBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, BUBBLE_VIEW_PADDING, SCREEN_W - 120 - BUBBLE_RIGHT_LEFT_CAP_WIDTH * 2 - 40, 15)];
        _remindLabel.numberOfLines = 0;
        _remindLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE2];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.textColor = UIColorFromRGB(0x1d1d1d);
        [self addSubview:_remindLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_remindLabel.right, _remindLabel.top, 40, 40)];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, _remindLabel.bottom, _remindLabel.width, 30)];
        _detailLabel.textColor = UIColorFromRGB(0xfa3575);
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.numberOfLines = 0;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.userInteractionEnabled = YES;
        [self addSubview:_detailLabel];
        
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton.frame = CGRectZero;
        _detailButton.backgroundColor = [UIColor clearColor];
        [self addSubview:_detailButton];
    }
    return self;
}

- (CGFloat)heightForText:(NSString *)text fontSize:(CGFloat)fontSize
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [text boundingRectWithSize:CGSizeMake(SCREEN_W - 120 - BUBBLE_RIGHT_LEFT_CAP_WIDTH * 2 - 40, 100) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.height;
}


+ (CGFloat)heightForBubbleWithObject:(Message *)object {
    
    NSLog(@"%@",object.content);
    
    CGRect tempRect;
    CGRect tempRect1;
    if ([object.uid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        
        
        tempRect = [object.content  boundingRectWithSize:CGSizeMake(CZLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}context:nil];
        
        tempRect1 = [@"對方點擊提醒可去到充值頁"  boundingRectWithSize:CGSizeMake(CZLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}context:nil];
        
    }
    
    if ([object.sendUid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        //        _remindLabel.text = ;
        //        _detailLabel.text = ;
        
        tempRect = [@"收到我的儲值提醒"  boundingRectWithSize:CGSizeMake(CZLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}context:nil];
        
        tempRect1 = [@"點擊前往充值頁面"  boundingRectWithSize:CGSizeMake(CZLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}context:nil];
    }
    
    CZiftBoundingSize = CGSizeMake(MAX(tempRect.size.width, tempRect1.size.width) + 40+BUBBLE_VIEW_PADDING, tempRect.size.height + tempRect1.size.height);
    
    return  2 * BUBBLE_VIEW_PADDING + CZiftBoundingSize.height + 20;
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    
    CGFloat height = 60;
    if (2*BUBBLE_VIEW_PADDING + CZiftBoundingSize.height > height) {
        height = 2*BUBBLE_VIEW_PADDING + CZiftBoundingSize.height;
    }
    
    
    CGFloat width = CZiftBoundingSize.width + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING;
    if (width < 46.5) {
        width = 46.5;
    }
    
    return CGSizeMake(width, height);
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //自己
    
    CGRect tempRect;
    CGRect tempRect1;
    if ([self.messageModel.uid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        
        tempRect = [self.messageModel.content  boundingRectWithSize:CGSizeMake(CZLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}context:nil];
        
        tempRect1 = [@"對方點擊提醒可去到充值頁"  boundingRectWithSize:CGSizeMake(CZLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}context:nil];
        
        _remindLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, BUBBLE_VIEW_PADDING, tempRect.size.width, tempRect.size.height);
        _detailLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, _remindLabel.bottom, tempRect1.size.width, tempRect1.size.height);
        _imageView.frame = CGRectMake(CZiftBoundingSize.width  - 40 + BUBBLE_VIEW_PADDING, (CZiftBoundingSize.height - 40) / 2.0 + BUBBLE_VIEW_PADDING, 40, 40);
        
    }
    
    if ([self.messageModel.sendUid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        
        tempRect = [@"收到我的儲值提醒"  boundingRectWithSize:CGSizeMake(CZLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}context:nil];
        
        tempRect1 = [@"點擊前往充值頁面"  boundingRectWithSize:CGSizeMake(CZLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}context:nil];
        _remindLabel.frame = CGRectMake(19 + 40, BUBBLE_VIEW_PADDING, tempRect.size.width, tempRect.size.height);
        _detailLabel.frame = CGRectMake(_remindLabel.left, _remindLabel.bottom, tempRect1.size.width, tempRect1.size.height);
        _imageView.frame = CGRectMake(19 , (CZiftBoundingSize.height - 40) / 2.0 + BUBBLE_VIEW_PADDING, 40, 40);
        
        
    }
    
    
}



- (void)setMessageModel:(Message *)messageModel {
    [super setMessageModel:messageModel];
    _detailButton.frame = CGRectMake(0, 0, self.width, self.height);
    [_detailButton addTarget:self action:@selector(clickToRechargeVC) forControlEvents:UIControlEventTouchUpInside];
    if ([messageModel.uid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        _detailButton.enabled = NO;
        _remindLabel.text = messageModel.content;
        _imageView.image = [UIImage imageNamed:@"chongzhi"];
        
        CGFloat height1 = [self heightForText:messageModel.content fontSize:LABEL_FONT_SIZE2];
        _remindLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, BUBBLE_VIEW_PADDING, 130, height1);
        _imageView.frame = CGRectMake(_remindLabel.right, _remindLabel.top, 40, 40);
        _remindLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _remindLabel.textColor = [UIColor whiteColor];
        _detailLabel.textColor = [UIColor whiteColor];
        
        CGFloat height2 = [self heightForText:@"對方點擊提醒可去到充值頁" fontSize:12];
        _detailLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, _remindLabel.bottom, _remindLabel.width, height2);
        _detailLabel.text = @"對方點擊提醒可去到充值頁";
        _detailButton.enabled = NO;
        
    }
    if ([messageModel.sendUid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        _detailButton.enabled = YES;
        _remindLabel.text = @"收到我的儲值提醒";
        _imageView.image = [UIImage imageNamed:@"chongzhi"];
        _remindLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, BUBBLE_VIEW_PADDING, 130, 15);
        _imageView.frame = CGRectMake(_remindLabel.right, _remindLabel.top, 40, 40);
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.textColor = UIColorFromRGB(0x1d1d1d);
        _detailLabel.textColor = UIColorFromRGB(0xfa3575);
        _detailLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, _remindLabel.bottom + 12, _remindLabel.width, 13);
        _detailLabel.text = @"點擊前往充值頁面";
        _detailButton.enabled = YES;
    }
}

- (void)clickToRechargeVC {
    [self routerEventWithName:kRouterEventRechargeBubbleLongTapEventName
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


