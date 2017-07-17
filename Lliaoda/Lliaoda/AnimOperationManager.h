//
//  AnimOperationManager.h
//  presentAnimation
//
//  Created by 许博 on 16/7/28.
//  Copyright © 2016年 许博. All rights reserved.
//  新增动画管理类



#import <UIKit/UIKit.h>
#import "GiftModel.h"

@interface AnimOperationManager : NSObject
+ (instancetype)sharedManager;
+ (void)attemptDealloc;
@property (nonatomic,strong) UIView *parentView;
@property (nonatomic,strong) GiftModel *model;
@property (nonatomic,retain) NSMutableArray *giftArray;

/// 队列1
@property (nonatomic,strong) NSOperationQueue *queue1;
/// 队列2
@property (nonatomic,strong) NSOperationQueue *queue2;

/// 操作缓存池
@property (nonatomic,strong) NSCache *operationCache;

/// 维护用户礼物信息
@property (nonatomic,strong) NSCache *userGigtInfos;

//礼物的id
@property (nonatomic,strong) NSCache *gifInfos;

@property (nonatomic,copy) NSString *oldUser;

@property (nonatomic,assign) int count;


/// 动画操作 : 需要UserID和回调
- (void)animWithUserID:(NSString *)userID model:(GiftModel *)model finishedBlock:(void(^)(BOOL result))finishedBlock;

/// 取消上一次的动画操作
- (void)cancelOperationWithLastUserID:(NSString *)userID;
@end
