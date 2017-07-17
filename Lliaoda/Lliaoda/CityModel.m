//
//  CityModel.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "CityModel.h"

@implementation CountrieModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"provinces" : @"ProvinceModel",
             };
}

@end

@implementation ProvinceModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"cities" : @"CityModel",
             };
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
             
             };
}

@end


@implementation CityModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
             
             };
}

@end






