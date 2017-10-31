//
//  VideoShowModel.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoShowModel : NSObject

/*
 nickname = Lucky;
 portrait = "http://meme-demo-public.oss-cn-beijing.aliyuncs.com/users/108/upload/media/1509420780_cover.jpg";
 uid = 207;
 url = "http://meme-demo-public.oss-cn-beijing.aliyuncs.com/users/108/upload/auth/1508917569085.239014.mp4";
 userId = 108;
 
 */

@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *portrait;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *cover;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *userId;


@end
