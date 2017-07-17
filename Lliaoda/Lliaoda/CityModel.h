//
//  CityModel.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountrieModel: NSObject

@property (nonatomic,assign) int uid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,retain) NSArray *provinces;

@end

@interface ProvinceModel : NSObject

@property (nonatomic,assign) int uid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,retain) NSArray *cities;

@end

@interface CityModel : NSObject

@property (nonatomic,assign) int uid;
@property (nonatomic,copy) NSString *name;

@end
