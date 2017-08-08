//
//  LocalizationUtils.m
//  Checkme Mobile
//
//  Created by 李乾 on 15/3/5.
//  Copyright (c) 2015年 VIATOM. All rights reserved.
//

#import "LocalizationUtils.h"

@implementation LocalizationUtils

//处理默认语言
+ (NSString *)DPLocalizedString:(NSString *)translation_key {
    
    NSString *s = NSLocalizedString(translation_key, nil);
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"zh-hant"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"zh-Hant" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else if ([lang hasPrefix:@"id"]){
        NSString * path = [[NSBundle mainBundle] pathForResource:@"id-ID" ofType:@"lproj"];
        NSBundle *languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else{
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
   
      return s;
}

+ (NSString *)getMainUrl
{
    NSString *mainStr;
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"zh-hant"]) {
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
    if ([lang hasPrefix:@"zh-hant"]) {
        agoreappIDStr = @"e063233af0694b93a6639bbd7e92b26a";
    }else if ([lang hasPrefix:@"id"]){
        agoreappIDStr = @"e3748ab08d4448249fc99dbaaafb53c5";
    }else{
        agoreappIDStr = @"e063233af0694b93a6639bbd7e92b26a";
    }
    
    
    
    return agoreappIDStr;
}


@end
