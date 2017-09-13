//
//  MessageCount.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/5.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "JKDBModel.h"

@interface MessageCount : JKDBModel

@property (nonatomic,assign) int count; //消息列表未读数
@property (nonatomic,copy) NSString *content; //消息的最后一条内容
@property (nonatomic,assign) long long timeDate; //最后一条的时间
@property (nonatomic,copy) NSString *uid; //自己的uid
@property (nonatomic,copy) NSString *sendUid; //发送的id
@property (nonatomic,copy) NSString *draft;
@property (nonatomic, copy) NSString *request;
@end
