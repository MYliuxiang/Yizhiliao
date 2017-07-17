//
//  LXCachNetWorking.h
//  Community
//
//  Created by 刘翔 on 16/6/24.
//  Copyright © 2016年 李江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCache.h"


typedef NS_ENUM(NSInteger, NetType) {
    
    NONetWork,
    NetWork
};

typedef void (^SuccessBlock)(id result);
typedef void (^FailureBlock)(NSError *error);
typedef void (^NetBlock)(NSInteger netType);


@interface LXCachNetWorking : NSObject


+(void)getRequestCacheUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock )success failure:(FailureBlock)failure netBlock:(NetBlock)nettype;

+(void)postREquestCacheUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock )success failure:(FailureBlock)failure netBlock:(NetBlock)nettype;

@end




