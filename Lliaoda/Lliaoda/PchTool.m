//
//  PchTool.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/8.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "PchTool.h"

@implementation PchTool
+ (NSString *)getMainUrl
{
    NSString *mainStr;
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"zh-Hant"]) {
        mainStr = @"https://www.yizhiliao.tv/api/";
    }else if ([lang hasPrefix:@"id"]){
        mainStr = @"https://www.yizhiliao.live/api/";
    }else{
        mainStr = @"https://www.yizhiliao.tv/api/";
    }

    return mainStr;

}
+ (NSString *)getagoreappID
{

    NSString *agoreappIDStr;
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"zh-Hant"]) {
        agoreappIDStr = @"e063233af0694b93a6639bbd7e92b26a";
    }else if ([lang hasPrefix:@"id"]){
        agoreappIDStr = @"e3748ab08d4448249fc99dbaaafb53c5";
    }else{
        agoreappIDStr = @"e063233af0694b93a6639bbd7e92b26a";
    }

    

    return agoreappIDStr;
}

+ (NSString *)getPayMainUrl
{
    NSString *mainUrl = @"http://demo.yizhiliao.live";
    
    return mainUrl;
}
@end
