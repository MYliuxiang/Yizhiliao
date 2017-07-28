//
//  RechargeCount.m
//  Lliaoda
//
//  Created by 小牛 on 2017/7/28.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "RechargeCount.h"

@implementation RechargeCount
static RechargeCount *manager;
static dispatch_once_t onceToken;
+ (instancetype)sharedRecharge
{
    
    dispatch_once(&onceToken, ^{
        manager = [[RechargeCount alloc] init];
        
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mdic = [NSMutableDictionary dictionary];
    }
    return self;
}

@end
