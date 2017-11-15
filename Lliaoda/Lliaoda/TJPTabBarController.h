//
//  TJPTabBarController.h
//  TJPYingKe
//
//  Created by Walkman on 2016/12/7.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJPTabBarController : UITabBarController


@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;

@property (nonatomic,retain) NSArray *buttonArray;
/**
 获取单例对象

 @return TabBarController
 */
+ (instancetype)shareInstance;

- (void)initViewController;
/**
 添加子控制器的block

 @param addVCBlock 添加代码块
 @return TabBarController
 */
+ (instancetype)tabBarControllerWitnAddChildVCBlock:(void(^)(TJPTabBarController *tabBarVC))addVCBlock;

@end
