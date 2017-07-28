//
//  GiftModel.h
//  presentAnimation
//
//  Created by 许博 on 16/7/15.
//  Copyright © 2016年 许博. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GiftModel : NSObject
@property (nonatomic,strong) UIImage *headImage; // 大頭貼
@property (nonatomic,copy) NSString *giftImage; // 礼物
@property (nonatomic,copy) NSString *name; // 送禮物者
@property (nonatomic,copy) NSString *giftName; // 礼物名称
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic,copy)NSString *giftUid;//礼物id
@property (nonatomic,assign)int diamonds;//礼物价格


@end
