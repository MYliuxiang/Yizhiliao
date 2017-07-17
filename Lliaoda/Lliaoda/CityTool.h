//
//  CityTool.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"

@interface CityTool : NSObject

+ (instancetype)sharedCityTool;

@property (nonatomic, strong)NSArray *countrys;//

- (NSString *)getAdressWithCountrieId:(int)countrieId
                       WithprovinceId:(int)provinceId
                           WithcityId:(int)cityId;
- (NSString *)getCityWithCountrieId:(int)countrieId
                     WithprovinceId:(int)provinceId
                         WithcityId:(int)cityId;

@end
