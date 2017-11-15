//
//  Mymodel.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LXBaseModel.h"
#import "Charge.h"

@interface Mymodel : LXBaseModel
@property(nonatomic,copy)NSString *uid;	//String	主播暱稱
@property(nonatomic,copy)NSString *nickname;	//String	主播暱稱
@property (nonatomic,assign) int auth; //认证状态，0是未认证，1是认证中，2是認證成功，-1是認證失敗
@property(nonatomic,assign)int charge;	//Int	收費設定，返回标识
@property (nonatomic, assign) int chargeAudio; // 语音收费设定
@property(nonatomic,copy)NSString *portrait;	//String[url]大頭貼地址
@property(nonatomic,copy)NSString *photo;	//展示图片的地址，以后存在多张的情况，返回第一张
@property(nonatomic,assign)int country;	//Int	国家
@property(nonatomic,assign)int province;	//Int	省份、区
@property(nonatomic,assign)int city;	//Int	城市

@property(nonatomic,assign)int preferOfflineOption;
@property(nonatomic,assign)int preferOnlineOption;
@property(nonatomic,copy)NSString *intro;	//String	个人简介，200字上限
@property(nonatomic,assign)int activated;
@property(nonatomic,assign)int gender;	//Int	性别
@property(nonatomic,assign)long birthday;	//String[date]	出生日期，公历，返回毫秒数，前端转化
@property(nonatomic,assign)int deposit;	//Int	賬戶餘額，鑽石数量
@property(nonatomic,assign)int income;	//Int	账户总收益，积分

@property (nonatomic, assign) long vipEndTime; // vip到期时间
@property (nonatomic, assign) int totalInpour; // 总儲值的鑽石数量
@property (nonatomic,retain) NSArray *charges;
@property (nonatomic, copy) NSString *domain;  // 行业
@property (nonatomic, assign) int isDND; // 是否设置了免打扰 1已设置
@property (nonatomic, assign) int likeCount; // 喜欢的数量
@end
