//
//  YuvToJpg.h
//  OpenVideoCall
//
//  Created by andy on 17/6/9.
//  Copyright © 2017年 Agora. All rights reserved.
//

#ifndef YuvToJpg_h
#define YuvToJpg_h
#import "AGVideoProcessing.h"
#import "VideoCallView.h"

@interface YuvToJpg : NSObject


+ (void) yuv_to_jpg;

+ (void) test:(unsigned char *)y ubuf:(unsigned char *)u vbuf:(unsigned char *)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height chanel:(NSString *)chanel;
+ (void)yuv420p_to_nv12:(unsigned char*) yuv420p nv12:(unsigned char*)nv12 width: (int)width  height: (int)height;

@end


#endif /* YuvToJpg_h */
