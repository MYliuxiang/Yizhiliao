//
//  LxCache.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LxCache.h"

NSString *const LXCache = @"LXCache";
static LxCache *_instance;

@implementation LxCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        YYCache *cache = [[YYCache alloc] initWithName:LXCache];
        cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
        _cache = cache;
        
    }
    return self;
}
+ (instancetype)sharedLxCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (id)getCacheDataWithKey:(NSString *)cacheKey
{

    id cacheData;
    cacheData = [self.cache objectForKey:cacheKey];
    id myResult;
    if (cacheData != 0) {
        
    myResult = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return myResult;

}

#pragma mark -- 处理json格式的字符串中的换行符、回车符
- (NSString *)deleteSpecialCodeWithStr:(NSString *)str {
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    return string;
}

- (void)setCacheData:(NSDictionary *)data WithKey:(NSString *)cacheKey
{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dataString = [self deleteSpecialCodeWithStr:dataString];
    NSData *requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [self.cache setObject:requestData forKey:cacheKey];

}

- (void)removeCacheDataWithKey:(NSString *)cacheKey
{
    [self.cache removeObjectForKey:cacheKey];

}

@end








