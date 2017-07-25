//
//  LHChatVC.h
//  LHChatUI
//
//  Created by lenhart on 2016/12/22.
//  Copyright © 2016年 lenhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MessageCount.h"

@interface LHChatVC : BaseViewController<UIGestureRecognizerDelegate>

@property (nonatomic,copy) NSString *channelId;

@property (nonatomic,copy) NSString *sendUid;

@property (nonatomic,retain) AgoraAPI *inst;

@property (nonatomic,retain) PersonModel *pmodel;

@property (nonatomic,retain) MessageCount *count;

@property (nonatomic,retain) NSMutableArray *deltedArray;

@property (nonatomic,retain) GiftsView *giftsView;
@end
