//
//  InputCheck.h
//  icontact4ios
//
//  Created by simon on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NUMBERSPERIOD @"0123456789." 

@interface InputCheck : NSObject
+(BOOL) isNumber:(NSString *)string;
+(BOOL) isPhone:(NSString *)string;
+(BOOL) isEmail:(NSString *)string;
+(BOOL) inputNum:(NSString *)string;

+(BOOL)isMobileNumber:(NSString *)mobileNum;


+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString
                          withDateFormat:(NSString *)dateFormat
;

//字典转json处理訊息字段
+ (NSString*)convertToJSONData:(id)infoDict;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//星座算法
+ (NSString *)getXingzuo:(NSDate *)in_date;
+ (NSArray *)getpreferOptions;

//处理活跃时间
+ (NSString *)handleActiveWith:(NSString *)times;

@end
