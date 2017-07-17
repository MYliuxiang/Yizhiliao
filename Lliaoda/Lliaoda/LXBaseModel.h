//
//  LXBaseModel.h
//  XINRUE
//
//  Created by yunhe on 14/12/9.
//  Copyright (c) 2014年 yunhe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LXBaseModel : NSObject


-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串


@end
