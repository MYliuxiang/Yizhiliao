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
        NSString * path = [[NSBundle mainBundle] pathForResource:@"zh-Hant" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
//    }else
//    if ([lang hasPrefix:@"id"]){
//        NSString * path = [[NSBundle mainBundle] pathForResource:@"id-ID" ofType:@"lproj"];
//        NSBundle *languageBundle = [NSBundle bundleWithPath:path];
//        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
//    }else if ([lang hasPrefix:@"ar"]){
//        NSString * path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
//        NSBundle *languageBundle = [NSBundle bundleWithPath:path];
//        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
//    }
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
//    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];

    if ([LXUserDefaults boolForKey:ISMEiGUO]) {
        mainStr = @"https://apl.yizhiliao.tv/api/";

    }else{
        mainStr = @"https://liao.yizhiliao.live/api/";
    }

    return mainStr;
    
}



+ (NSString *)getagoreappID
{
    
    NSString *agoreappIDStr;
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];

    if ([lang hasPrefix:@"id"]){
        agoreappIDStr = @"e3748ab08d4448249fc99dbaaafb53c5";
    }else if ([lang hasPrefix:@"ar"]){
        agoreappIDStr = @"a0599c58c21e4c08b5502267a09b58cf";
    }
    agoreappIDStr = @"e3748ab08d4448249fc99dbaaafb53c5";


    
    return agoreappIDStr;
    
}

+ (NSString *)getPayMainUrl
{
//    NSString *mainUrl = @"http://demo.yizhiliao.live";
    NSString *mainUrl = @"https://www.yizhiliao.live";
    
    return mainUrl;
}


@end
