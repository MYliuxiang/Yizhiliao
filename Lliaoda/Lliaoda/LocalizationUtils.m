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
    
    NSString * s = NSLocalizedString(translation_key, nil);
    NSString *lang = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:Language]];
    if (![lang isEqual:@"1"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else{
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    
   
    return s;
}

@end
