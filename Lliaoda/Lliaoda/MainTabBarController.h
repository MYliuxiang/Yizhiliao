//
//  MainTabBarController.h
//  iCheated
//
//  Created by yunhe on 15/5/29.
//  Copyright (c) 2015年 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mymodel.h"

@interface MainTabBarController : UITabBarController

+ (instancetype)shareMainTabBarController;
@property (nonatomic,assign) BOOL iszhubo;
@property (nonatomic,retain) Mymodel *model;
- (void)zhuViewcontrollers;

@end
