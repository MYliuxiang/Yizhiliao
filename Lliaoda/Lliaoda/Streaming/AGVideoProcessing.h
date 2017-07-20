//
//  AGVideoProcessing.h
//  Agora-client-side-AV-capturing-for-streaming-iOS
//
//  Created by GongYuhua on 2017/4/5.
//  Copyright © 2017 Agora.io All rights reserved.
//

#import "VideoCallView.h"
@class AgoraRtcEngineKit;

@interface AGVideoProcessing : NSObject

+ (int) registerVideoPreprocessing: (AgoraRtcEngineKit*) kit withchanel:(NSString *)chanel;
+ (int)deregisterVideoPreprocessing:(AgoraRtcEngineKit*) kit;
//@property (nonatomic,copy) NSString *channel;
@end
