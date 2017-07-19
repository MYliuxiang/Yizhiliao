//
//  AccountModel.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject
@property(nonatomic,copy)NSString *uid;	//商品Id
@property(nonatomic,copy)NSString *name;	//商品名称
@property(nonatomic,assign)int price;	//商品价格，分，前端格式化显示
@property(nonatomic,copy)NSString *icon;	//商品展示的图标地址
@property(nonatomic,assign)int bonus;	//商品价格，分，前端格式化显示
@property (nonatomic, assign) int vipDays; // 赠送的VIP天数
@property (nonatomic, assign) int isVipForFirstTopUp; // 是否首冲
@end
