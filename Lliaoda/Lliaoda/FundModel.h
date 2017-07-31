//
//  FundModel.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundModel : NSObject
@property(nonatomic,assign)int deposit;	//Int	賬戶餘額，鑽石数量
@property(nonatomic,assign)int income;	//Int	账户总收益，积分
@property(nonatomic,assign)int extractable;	//Int	可提取的账户收益
@property(nonatomic,assign)int settled;	//Int	已结算的积分收益
@property(nonatomic,assign)int video;	//Int	已结算的积分收益
@property(nonatomic,assign)int gift;	//Int	已结算的积分收益
@property(nonatomic,assign)int share;	//Int	已结算的积分收益
@property(nonatomic,assign)int order;

@end
