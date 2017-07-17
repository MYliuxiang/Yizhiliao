//
//  LHChatViewBaseCell.h
//  LHChatUI
//
//  Created by liuhao on 2016/12/26.
//  Copyright © 2016年 lenhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHChatBaseBubbleView.h"



@interface LHChatViewBaseCell : UITableViewCell {
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    LHChatBaseBubbleView *_bubbleView;
}

@property (nonatomic, strong) UIImageView *headImageView;       //大頭貼
@property (nonatomic, strong) UILabel *nameLabel;               //姓名（暂时不支持显示）
@property (nonatomic, strong) LHChatBaseBubbleView *bubbleView;   //内容区域

@property (nonatomic, strong) Message *messageModel;

- (id)initWithMessageModel:(Message *)model reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setupSubviewsForMessageModel:(Message *)model;

+ (NSString *)cellIdentifierForMessageModel:(Message *)model;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(Message *)model;

@end
