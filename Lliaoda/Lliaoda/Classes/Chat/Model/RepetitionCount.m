//
//  RepetitionCount.m
//  Lliaoda
//
//  Created by 小牛 on 2017/7/28.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "RepetitionCount.h"

@implementation RepetitionCount

static RepetitionCount *manager;
static dispatch_once_t onceToken;
+ (instancetype)sharedRepetition
{
    
    dispatch_once(&onceToken, ^{
        manager = [[RepetitionCount alloc] init];
        
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
