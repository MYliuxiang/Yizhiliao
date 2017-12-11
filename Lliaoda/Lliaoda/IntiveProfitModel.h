//
//  IntiveProfitModel.h
//  Lliaoda
//
//  Created by 小牛 on 2017/12/11.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LXBaseModel.h"

@interface IntiveProfitModel : LXBaseModel
@property (nonatomic, assign) int categoryId;    // 收益类型，0 表示邀请，1 表示充值
@property (nonatomic, assign) long createdAt;    // 充值时间
@property (nonatomic, copy) NSString *nickname;  // 昵称
@property (nonatomic, assign) int pid;           // pid
@property (nonatomic, copy) NSString *portrait;  // 头像
@property (nonatomic, copy) NSString *score;     // 收益
@property (nonatomic, copy) NSString *sourceId;  // 用户ID
@property (nonatomic, assign) int value;         // 对方充钻石数目

@end
