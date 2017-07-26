//
//  Message.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/28.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "JKDBModel.h"

/*!
 @enum
 @brief 聊天类型
 @constant MessageBodyType_Text 文本类型
 @constant MessageBodyType_Image 图片类型
 @constant MessageBodyType_Video 視訊类型
 @constant MessageBodyType_Location 位置类型
 @constant MessageBodyType_Voice 语音类型
 @constant MessageBodyType_File 文件类型
 @constant MessageBodyType_Command 命令类型
 @constant MessageBodyType_Gift 禮物類型
 @constant MessageBodyType_Gift 充值類型
 */
typedef enum {
    MessageBodyType_Text = 1,
    MessageBodyType_Image,
    MessageBodyType_Video,
    MessageBodyType_Location,
    MessageBodyType_Voice,
    MessageBodyType_File,
    MessageBodyType_Command,
    MessageBodyType_Gift,
    MessageBodyType_ChongZhi
}MessageBodyType;


/*!
 @enum
 @brief 聊天訊息发送状态
 @constant MessageDeliveryState_Pending 待发送
 @constant MessageDeliveryState_Delivering 正在发送
 @constant MessageDeliveryState_Delivered 已发送, 成功
 @constant MessageDeliveryState_Failure 已发送, 失败
 */
typedef enum {
    MessageDeliveryState_Pending = 0,
    MessageDeliveryState_Delivering,
    MessageDeliveryState_Delivered,
    MessageDeliveryState_Failure
}MessageDeliveryState;

@interface Message : JKDBModel

/** 是否是发送者 */
@property (nonatomic, assign) BOOL isSender;
/** 是否已读 */
@property (nonatomic) BOOL isRead;
/** 是否是群聊 */
@property (nonatomic) BOOL isChatGroup;

@property (nonatomic,copy) NSString *uid; //发送者id

@property (nonatomic,copy) NSString *sendUid; //接收者id

@property (nonatomic, assign) MessageBodyType type;
@property (nonatomic, assign) MessageDeliveryState status;
@property (nonatomic, assign) long long date;
@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, copy)   NSString *chancelID;


/** text */
@property (nonatomic, strong) NSString *content;

/** image */
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSURL *imageRemoteURL;


@end
