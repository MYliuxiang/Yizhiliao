//
//  SelectedModel.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/20.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LXBaseModel.h"

@interface SelectedModel : LXBaseModel

/*
 "id": "110",
 "portrait": "http://diy.qqjay.com/u/files/2012/0315/685a011d31da519ec30c0d3948a3c6d5.jpg",
 "photo": "http://img.51ztzj.com//upload/image/20160627/201606272_670x419.jpg",
 "country": 100,
 "province": 102,
 "city": 102001,
 "state": 1,
 "nickname": "暖暖的极光",
 "auth": 2,
 "charge": 1,
 "intro": "这里是一段介绍文字，我们都是看图说话的人，文字不重要。",
 "gender": 1,
 "birthday": 640593301154,
 "deposit": 99,
 "income": 10000
 
 */

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *portrait;
@property (nonatomic,copy)NSString *photo;
@property (nonatomic,assign)int country;
@property (nonatomic,assign)int province;
@property (nonatomic,assign)int city;
@property (nonatomic,assign)int state;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,assign)int auth;
@property (nonatomic,assign)int charge;
@property (nonatomic,copy)NSString *intro;
@property (nonatomic,assign)int gender;
@property (nonatomic,assign)long long birthday;
@property (nonatomic,assign)int deposit;
@property (nonatomic,assign)int income;

@property(nonatomic,assign) int like;
@property (nonatomic,retain) NSArray *charges;
@property (nonatomic,assign)BOOL selected;


@end
