//
//  RechargeCount.h
//  Lliaoda
//
//  Created by 小牛 on 2017/7/28.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RechargeCount : NSObject

@property(nonatomic,retain)NSMutableDictionary *mdic;
+ (instancetype)sharedRecharge;

@end
