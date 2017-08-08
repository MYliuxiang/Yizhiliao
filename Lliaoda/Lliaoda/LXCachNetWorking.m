//
//  LXCachNetWorking.m
//  Community
//
//  Created by 刘翔 on 16/6/24.
//  Copyright © 2016年 李江. All rights reserved.
//

#import "LXCachNetWorking.h"

NSString * const LXHttpCache = @"SPHttpCache";

// 请求方式
typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeGet,
    RequestTypePost,
    RequestTypeUpLoad,
    RequestTypeDownload
};

@implementation LXCachNetWorking


+(void)postREquestCacheUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure netBlock:(NetBlock)nettype
{
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
//    [[self alloc] requestWithUrl:urlStr withDic:parameters requestType:RequestTypePost isCache:YES cacheKey:urlStr imageKey:nil withData:nil  success:^(id result) {
//        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
//
//        success(result);
//    } failure:^(NSString *errorInfo) {
//        
//        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
//        failure(errorInfo);
//    }
//     ];
    
    [[self alloc] requestWithUrl:urlStr withDic:parameters requestType:RequestTypePost isCache:YES  imageKey:nil withData:nil success:^(id result) {
        
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                success(result);
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
    } netBlock:^(NSInteger netType) {
        
        nettype(netType);
    }];
}

+(void)getRequestCacheUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock )success failure:(FailureBlock)failure netBlock:(NetBlock)nettype
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];

    [[self alloc] requestWithUrl:urlStr withDic:parameters requestType:RequestTypeGet isCache:YES  imageKey:nil withData:nil success:^(id result) {
        
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        success(result);
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
    } netBlock:^(NSInteger netType) {
        
        nettype(netType);
    }];

}


#pragma mark -- 网络请求统一处理
-(void)requestWithUrl:(NSString *)url withDic:(NSDictionary *)parameters requestType:(RequestType)requestType  isCache:(BOOL)isCache   imageKey:(NSString *)attach withData:(NSData *)data  success:(SuccessBlock)success failure:(FailureBlock)failure netBlock:(NetBlock)nettype
{
    
    //处理中文和空格问题
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //拼接
    NSString *cacheUrl = [self urlDictToStringWithUrlStr:url WithDict:parameters];
    
    //設定YYCache属性
    YYCache *cache = [[YYCache alloc] initWithName:LXHttpCache];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    
    id cacheData;
    if (isCache) {
        
        //根据网址从Cache中取数据
        cacheData = [cache objectForKey:cacheUrl];
        if (cacheData != 0){
            
            //将数据统一处理
            [self returnDataWithRequestData:cacheData Success:^(id requestDic) {
                success(requestDic);
                
            } failure:^(NSError *error) {
            }];
            
        }
    }
    
    //进行网络检查
    if ([[NetWorkManager sharedManager] checkNowNetWorkStatus] == NotReachable ) {
    
        NSLog(LXSring(@"没有网络"));
        nettype(NONetWork);
        return;
    }
    nettype(NetWork);

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    session.requestSerializer.timeoutInterval =  10;
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    //get请求
    if (requestType == RequestTypeGet) {
        
        [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
                      
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }

    if (requestType == RequestTypePost) {

    //post请求
    [session POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dealWithResponseObject:responseObject cacheUrl:cacheUrl cacheData:cacheData isCache:isCache cache:cache cacheKey:cacheUrl success:^(id responseObject) {
            
            success(responseObject);
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);

    }];
    }
    
}

#pragma mark  统一处理请求到的数据
-(void)dealWithResponseObject:(NSData *)responseData cacheUrl:(NSString *)cacheUrl cacheData:(id)cacheData isCache:(BOOL)isCache cache:(YYCache*)cache cacheKey:(NSString *)cacheKey success:(SuccessBlock)success failure :(FailureBlock)failure
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器
    });
    
    NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    dataString = [self deleteSpecialCodeWithStr:dataString];
    NSData *requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    if (isCache) {
        //
        [cache setObject:requestData forKey:cacheKey];
        
    }
    //如果不缓存 或者 数据不相同 从网络请求
    if (!isCache || ![cacheData isEqual:requestData]) {
        
        [self returnDataWithRequestData:requestData Success:^(id requestDic) {
            
            success(requestDic);

        } failure:^(NSError *error){
            
        }];
    }
    
    
}


#pragma mark --根据返回的数据进行统一的格式处理  ----requestData 网络或者是缓存的数据----
- (void)returnDataWithRequestData:(NSData *)requestData Success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];

    id myResult = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
    
    success(myResult);

    
//    //判断是否为字典
//    if ([myResult isKindOfClass:[NSDictionary  class]]) {
//        NSDictionary *requestDic = (NSDictionary *)myResult;
//        
//        
//
//        //根据返回的接口内容来变
//        NSString *succ = requestDic[@"status"];
//        if ([succ isEqualToString:@"success"]){
//            success(requestDic[@"result"],requestDic[@"msg"]);
//        }else{
//            
//            failure(requestDic[@"msg"]);
//        }
//        
//    }
    
}


-(NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters
{
    if (!parameters) {
        return urlStr;
    }
    
    
    NSMutableArray *parts = [NSMutableArray array];
    //enumerateKeysAndObjectsUsingBlock会遍历dictionary并把里面所有的key和value一组一组的展示给你，每组都会执行这个block 这其实就是传递一个block到另一个方法，在这个例子里它会带着特定参数被反复调用，直到找到一个ENOUGH的key，然后就会通过重新赋值那个BOOL *stop来停止运行，停止遍历同时停止调用block
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //接收key
        NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //接收值
        NSString *finalValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        
        NSString *part =[NSString stringWithFormat:@"%@=%@",finalKey,finalValue];
        
        [parts addObject:part];
        
    }];
    
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    
    queryString = queryString ? [NSString stringWithFormat:@"?%@",queryString] : @"";
    
    NSString *pathStr = [NSString stringWithFormat:@"%@?%@",urlStr,queryString];
    
    return pathStr;
    
}




#pragma mark -- 处理json格式的字符串中的换行符、回车符
- (NSString *)deleteSpecialCodeWithStr:(NSString *)str {
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    return string;
}


@end
