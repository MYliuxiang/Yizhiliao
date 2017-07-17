//
//  CityTool.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "CityTool.h"

static CityTool *_instance;

@implementation CityTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self loadData];
        
    }
    return self;
}
+ (instancetype)sharedCityTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (void)loadData
{
    LxCache *lxcache = [LxCache sharedLxCache];
    
    id cacheData;
    cacheData = [lxcache getCacheDataWithKey:CityCache];
    
    if (cacheData != 0) {
        //将数据统一处理
        NSArray *array = cacheData[@"data"][@"countries"];
        NSMutableArray *marray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            
            CountrieModel *model = [CountrieModel mj_objectWithKeyValues:dic];
            [marray addObject:model];
            
        }
        self.countrys = marray;
    }
    
    [WXDataService requestAFWithURL:Url_cities params:nil httpMethod:@"GET" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
        if(result){
        if ([result[@"result"] integerValue] == 0) {
            
            NSArray *array = result[@"data"][@"countries"];
            NSMutableArray *marray = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                
                CountrieModel *model = [CountrieModel mj_objectWithKeyValues:dic];
                [marray addObject:model];
                
            }
            self.countrys = marray;
            LxCache *lxcache = [LxCache sharedLxCache];
            [lxcache setCacheData:result WithKey:CityCache];
            
        }else{    //请求失败
            
        }
        }
        
    } errorBlock:^(NSError *error) {
        
    }];
    
}

//单独显示身份
- (NSString *)getAdressWithCountrieId:(int)countrieId
                       WithprovinceId:(int)provinceId
                           WithcityId:(int)cityId
{
    NSMutableString *adress = [NSMutableString string];

    for (CountrieModel *model in self.countrys) {
        
        if (model.uid == countrieId) {
            
            
            for (ProvinceModel *pmodel in model.provinces) {
                if (pmodel.uid == provinceId) {
                    [adress appendString:pmodel.name];
                    
                    for (CityModel *cmodel in pmodel.cities) {
                        if (cmodel.uid == cityId) {
//                            [adress appendFormat:@" %@",cmodel.name];
                            
                        }
                    }
                }
            }
        }
        
    }
    
    return adress;

}

//显示整体
- (NSString *)getCityWithCountrieId:(int)countrieId
                       WithprovinceId:(int)provinceId
                           WithcityId:(int)cityId
{
    NSMutableString *adress = [NSMutableString string];
    
    for (CountrieModel *model in self.countrys) {
        
        if (model.uid == countrieId) {
            
            for (ProvinceModel *pmodel in model.provinces) {
                if (pmodel.uid == provinceId) {
                    [adress appendString:pmodel.name];
                    
                    for (CityModel *cmodel in pmodel.cities) {
                        if (cmodel.uid == cityId) {
                          
                            
                        }
                    }
                    
                }
            }
            
        }
        
    }
   
    return adress;
    
}


@end












