//
//  LxCache.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCache.h"


@interface LxCache : NSObject

@property(nonatomic,retain)YYCache *cache;

+ (instancetype)sharedLxCache;

- (id)getCacheDataWithKey:(NSString *)cacheKey;

- (void)setCacheData:(NSDictionary *)data WithKey:(NSString *)cacheKey;

- (void)removeCacheDataWithKey:(NSString *)cacheKey;


@end
