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
CGFloat const GIFTLABEL_MAX_WIDTH = 180.0f;
static CGSize kGiftBoundingSize;

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
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
//        
//        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _detailButton.frame = CGRectMake(0, 0, _remindLabel.width, 15);
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
    return [text boundingRectWithSize:CGSizeMake(130, 100) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.height;
}

- (void)setMessageModel:(Message *)messageModel {
    
    [super setMessageModel:messageModel];
    _imageView.image = [UIImage imageNamed:@"liwu"];
    [_detailButton addTarget:self action:@selector(clickToGiftView) forControlEvents:UIControlEventTouchUpInside];
    if ([messageModel.uid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        _remindLabel.text = messageModel.content;
        _remindLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _remindLabel.textColor = [UIColor whiteColor];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.text = LXSring(@"對方點擊提醒可查看送禮頁");
        _detailButton.enabled = NO;
    }
    
    if ([messageModel.sendUid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        _remindLabel.text = LXSring(@"收到我的送禮提醒");
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.textColor = UIColorFromRGB(0x1d1d1d);
        _detailLabel.textColor = UIColorFromRGB(0xfa3575);
        _detailLabel.text = LXSring(@"點擊查看禮物詳情");
        _detailButton.enabled = YES;
    }
    
    
    
}

+ (CGFloat)heightForBubbleWithObject:(Message *)object {
    
    NSLog(@"%@",object.content);
    
    CGRect tempRect;
    CGRect tempRect1;
    if ([object.uid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        
        
       
        
         tempRect = [object.content  boundingRectWithSize:CGSizeMake(GIFTLABEL_MAX_WIDTH-40,2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}context:nil];
        
        tempRect1 = [LXSring(@"對方點擊提醒可查看送禮頁")  boundingRectWithSize:CGSizeMake(GIFTLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}context:nil];
        
    }
    
    if ([object.sendUid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
//        _remindLabel.text = ;
//        _detailLabel.text = ;
        
        tempRect = [LXSring(@"收到我的送禮提醒")  boundingRectWithSize:CGSizeMake(GIFTLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}context:nil];
        
        tempRect1 = [LXSring(@"點擊查看禮物詳情")  boundingRectWithSize:CGSizeMake(GIFTLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}context:nil];
    }

    kGiftBoundingSize = CGSizeMake(MAX(tempRect.size.width, tempRect1.size.width) + 40 + BUBBLE_VIEW_PADDING, tempRect.size.height + tempRect1.size.height);
    
    return  2 * BUBBLE_VIEW_PADDING + kGiftBoundingSize.height + 20;
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    
    CGFloat height = 60;
    if (2*BUBBLE_VIEW_PADDING + kGiftBoundingSize.height > height) {
        height = 2*BUBBLE_VIEW_PADDING + kGiftBoundingSize.height;
    }
    
    
    CGFloat width = kGiftBoundingSize.width + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING;
    if (width < 46.5) {
        width = 46.5;
    }
    
    return CGSizeMake(width, height);
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    //自己
    _detailButton.frame = CGRectMake(0, 0, self.width, self.height);

    
    CGRect tempRect;
    CGRect tempRect1;
    if ([self.messageModel.uid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        
        tempRect = [self.messageModel.content  boundingRectWithSize:CGSizeMake(GIFTLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}context:nil];
        
        tempRect1 = [LXSring(@"對方點擊提醒可查看送禮頁")  boundingRectWithSize:CGSizeMake(GIFTLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}context:nil];
        
        _remindLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, BUBBLE_VIEW_PADDING, tempRect.size.width, tempRect.size.height);
        _detailLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, _remindLabel.bottom, tempRect1.size.width, tempRect1.size.height);
        _imageView.frame = CGRectMake(kGiftBoundingSize.width  - 40 + BUBBLE_VIEW_PADDING, (kGiftBoundingSize.height - 40) / 2.0 + BUBBLE_VIEW_PADDING, 40, 40);

    }
    
    if ([self.messageModel.sendUid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
        
        tempRect = [LXSring(@"收到我的送禮提醒")  boundingRectWithSize:CGSizeMake(GIFTLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}context:nil];
        
        tempRect1 = [LXSring(@"點擊查看禮物詳情")  boundingRectWithSize:CGSizeMake(GIFTLABEL_MAX_WIDTH-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}context:nil];
        _remindLabel.frame = CGRectMake(19 + 40 + 10, BUBBLE_VIEW_PADDING, tempRect.size.width, tempRect.size.height);
        _detailLabel.frame = CGRectMake(_remindLabel.left, _remindLabel.bottom, tempRect1.size.width, tempRect1.size.height);
        _imageView.frame = CGRectMake(19 , (kGiftBoundingSize.height - 40) / 2.0 + BUBBLE_VIEW_PADDING, 40, 40);


    }
    
    
//    if ([self.messageModel.uid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
//        CGFloat height1 = [self heightForText:self.messageModel.content fontSize:LABEL_FONT_SIZE1];
//        _remindLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, BUBBLE_VIEW_PADDING, 130, height1);
//        CGFloat height2 = [self heightForText:LXSring(@"對方點擊提醒可查看送禮頁") fontSize:12];
//        _detailLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, _remindLabel.bottom, _remindLabel.width, height2);
//    }
//    
//    if ([self.messageModel.sendUid integerValue] == [[LXUserDefaults objectForKey:UID] integerValue]) {
//        _remindLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, BUBBLE_VIEW_PADDING, 130, 15);
//        _detailLabel.frame = CGRectMake(BUBBLE_RIGHT_LEFT_CAP_WIDTH, _remindLabel.bottom + 12, _remindLabel.width, 13);
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
        
        UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:LXSring(@"删除") action:@selector(myDelete:)];
        UIMenuItem *item3 = [[UIMenuItem alloc]initWithTitle:LXSring(@"更多...") action:@selector(myMore:)];
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
