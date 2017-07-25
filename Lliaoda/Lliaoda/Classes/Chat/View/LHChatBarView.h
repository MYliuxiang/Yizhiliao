//
//  LHChatInputView.h
//  LHChatUI
//
//  Created by lenhart on 2016/12/22.
//  Copyright © 2016年 lenhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardEmojiTextView.h"


@protocol LHChatBarViewDelegate <NSObject>

@required
- (void)videoCall;

- (void)giftGive;

- (void)chongZhi;
@end


@class LHContentModel;

@interface LHChatBarView : UIView

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) KeyboardEmojiTextView *textView;
@property (nonatomic, strong) void(^sendContent)(LHContentModel *content);
@property (nonatomic,assign)id<LHChatBarViewDelegate> delegate;
- (void)hideKeyboard;

@end
