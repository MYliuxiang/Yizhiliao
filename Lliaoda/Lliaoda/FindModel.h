//
//  FindModel.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/5.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindModel : NSObject

@property(nonatomic,copy)NSString *nickname;	//String	主播暱稱
@property(nonatomic,assign)int charge;	//Int	主播收費設定，返回标识，前端决定显示内容
@property(nonatomic,copy)NSString *portrait;	//String[url]	主播大頭貼地址
@property(nonatomic,copy)NSString *uid;	//String	主播暱稱

@property(nonatomic,assign)int state;	//Int	主播状态
@property(nonatomic,assign)int country;	//Int	国家
@property(nonatomic,assign)int province;	//Int	省份、区
@property(nonatomic,assign)int city;	//Int	城市
@property(nonatomic,copy)NSString *intro;	//String	个人简介，200字上限
@property(nonatomic,assign)int gender;	//Int	性别
@property(nonatomic,copy)NSString *birthday;	//String[date]	出生日期，公历，返回毫秒数，前端转化

@property(nonatomic,assign)int like;

@property (nonatomic,retain) NSArray *charges;

@property (nonatomic,assign)BOOL selected;

@end
