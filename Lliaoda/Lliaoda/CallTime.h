//
//  CallTime.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/7/13.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "JKDBModel.h"

@interface CallTime : JKDBModel

@property (nonatomic, assign) int channelId;
@property (nonatomic, assign) long long endedAt;
@property (nonatomic, assign) long long duration;
@property (nonatomic, assign)  int uid;
@property (nonatomic,assign) int type;//0視頻1語音
@property (nonatomic,assign) int upload;//0為上傳1上傳



@end
