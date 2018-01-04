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
//    if ([lang hasPrefix:@"zh-Hant"]) {
//        NSString * path = [[NSBundle mainBundle] pathForResource:@"zh-Hant" ofType:@"lproj"];
//        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
//        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
//    }else
    if ([lang hasPrefix:@"id"]){
        NSString * path = [[NSBundle mainBundle] pathForResource:@"id-ID" ofType:@"lproj"];
        NSBundle *languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else if ([lang hasPrefix:@"ar"]){
        NSString * path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
        NSBundle *languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
//    else{
//        
//        NSString * path = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"lproj"];
//        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
//        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
//    }
   
      return s;
}

+ (NSString *)getMainUrl
{
    NSString *mainStr;
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
//    if ([lang hasPrefix:@"zh-Hant"]) {
//        mainStr = @"https://www.yizhiliao.tv/api/";
//    }else
    if ([lang hasPrefix:@"id"]){
        
        if ([LXUserDefaults boolForKey:ISMEiGUO]) {
            mainStr = @"https://aplid.yizhiliao.tv/api/";

        }else{
//            mainStr = @"https://www.yizhiliao.live/api/";
//            mainStr = @"http://demo.yizhiliao.live/api/";
            mainStr = @"http://demo1.yizhiliao.live/api/";
        }

        
    }else if ([lang hasPrefix:@"ar"]){
        
        if ([LXUserDefaults boolForKey:ISMEiGUO]) {
            
            mainStr = @"https://aplme.yizhiliao.tv/api/";
            
        }else{
//            mainStr = @"https://www.yizhiliao.net/api/";
            mainStr = @"http://demo.yizhiliao.net/api/";
        }
        
    }
//    else{
//        mainStr = @"https://www.yizhiliao.tv/api/";
//    }
    
    return mainStr;
    
}
+ (NSString *)getagoreappID
{
    
    NSString *agoreappIDStr;
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
//    if ([lang hasPrefix:@"zh-Hant"]) {
//        agoreappIDStr = @"e063233af0694b93a6639bbd7e92b26a";
//    }else
    if ([lang hasPrefix:@"id"]){
        agoreappIDStr = @"e3748ab08d4448249fc99dbaaafb53c5";
    }else if ([lang hasPrefix:@"ar"]){
        agoreappIDStr = @"a0599c58c21e4c08b5502267a09b58cf";
    }
//    else{
//        agoreappIDStr = @"e063233af0694b93a6639bbd7e92b26a";
//    }
    
    
    
    return agoreappIDStr;
}

+ (NSString *)getPayMainUrl
{
    NSString *mainUrl = @"http://demo.yizhiliao.live";
//    NSString *mainUrl = @"https://www.yizhiliao.live";
    
    return mainUrl;
}


@end
