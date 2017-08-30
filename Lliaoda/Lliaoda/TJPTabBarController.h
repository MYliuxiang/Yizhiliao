//
//  TJPTabBarController.h
//  TJPYingKe
//
//  Created by Walkman on 2016/12/7.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxBarItem.h"

@interface TJPTabBarController : UITabBarController


@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
/**
 获取单例对象

 @return TabBarController
 */
+ (instancetype)shareInstance;


/**
 添加子控制器的block

 @param addVCBlock 添加代码块
 @return TabBarController
 */
+ (instancetype)tabBarControllerWitnAddChildVCBlock:(void(^)(TJPTabBarController *tabBarVC))addVCBlock;


/**
 *  根据参数, 创建并添加对应的子控制器
 *
 *  @param vc                需要添加的控制器(会自动包装导航控制器)
 *  @param isRequired             标题
 *  @param normalImageName   一般图片名称
 *  @param selectedImageName 选中图片名称
 */
- (void)addChildVC:(UIViewController *)vc normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName isRequiredNavController:(BOOL)isRequired;

- (void)addCenterChildVC:(UIViewController *)vc normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName isRequiredNavController:(BOOL)isRequired;

@end
