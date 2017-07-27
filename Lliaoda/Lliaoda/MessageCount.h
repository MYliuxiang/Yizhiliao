//
//  MessageCount.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/5.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "JKDBModel.h"

@interface MessageCount : JKDBModel

@property (nonatomic,assign) int count;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) long long timeDate;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *sendUid;
@property (nonatomic,copy) NSString *draft;
@property (nonatomic, copy) NSString *event;
@property (nonatomic, copy) NSString *request;
@end
