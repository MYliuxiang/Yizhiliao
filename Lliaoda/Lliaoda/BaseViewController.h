//
//  BaseViewController.h
//  Familysystem
//
//  Created by 李立 on 15/8/21.
//  Copyright (c) 2015年 LILI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

@interface BaseViewController : UIViewController


@property(nonatomic,retain)UIView *nav;
@property(nonatomic,retain)UIButton *backButtton;
@property (assign,nonatomic) BOOL navbarHiden;
@property(assign,nonatomic)BOOL isBack;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,retain)UILabel *titleLable;
@property(nonatomic,retain)UIButton *rightbutton;
@property(nonatomic,retain)UIButton *leftbutton;


- (void)back;

- (void)addrightImage:(NSString *)imageString;

- (void)addrighttitleString:(NSString *)titleString;

- (void)rightAction;

-(void) addlefttitleString:(NSString *)titleString;

- (void)leftAction;

@end
