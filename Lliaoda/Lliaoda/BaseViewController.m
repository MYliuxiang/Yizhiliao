//
//  BaseViewController.m
//  Familysystem
//
//  Created by 李立 on 15/8/21.
//  Copyright (c) 2015年 LILI. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "MainTabBarController.h"
@interface BaseViewController ()<UIAlertViewDelegate>
{
    
}

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if ([[NetWorkManager sharedManager] checkNowNetWorkStatus] == 0) {
//        [MBProgressHUD showError:NetWorkString toView:[UIApplication sharedApplication].keyWindow];
//    }
   

}



- (void)NotNetWorkString:(NSNotification *)notification
{


}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //关闭系统右滑返回
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.navbarHiden = NO;
    self.view.backgroundColor = Color_bg;
    [self _initnav];
   

}


- (void)_initnav
{
    _nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 63)];
    _nav.backgroundColor = Color_nav;
    [self.view addSubview:_nav];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 64)];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    [self.nav addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [view addGestureRecognizer:tap];
    _backButtton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButtton.frame = CGRectMake(0, 20, 44, 44);
    [_backButtton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_backButtton setImage:[UIImage imageNamed:@"back_hei"] forState:UIControlStateNormal];
//    [_backButtton setTitle:LXSring(@"返回") forState:UIControlStateNormal];
//    [_backButtton setTitleColor:Color_blue forState:UIControlStateNormal];
    _backButtton.titleLabel.font =[UIFont systemFontOfSize:16];
    _backButtton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _backButtton.backgroundColor = [UIColor clearColor];
    [_nav addSubview:_backButtton];
    if (self.navigationController.viewControllers.count > 1) {
        //有
        self.isBack = YES;
        
    }else{
        
        //没有
        self.isBack = NO;
    }
    
    
    _titleLable = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 50, 100)];
    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.textColor= [UIColor blackColor];
    [_titleLable setFont:[UIFont systemFontOfSize:17]];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    [self.nav addSubview:_titleLable];
    

    _rightChargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightChargeButton.frame = CGRectMake(kScreenWidth - 100 - 15, 20 + (self.nav.height - 20 - 50 / 2.0) / 2.0 , 100, 50 / 2.0);
    [_rightChargeButton setBackgroundColor:[UIColor clearColor]];
    [_rightChargeButton setTitleColor:UIColorFromRGB(0xFFC001) forState:UIControlStateNormal];
    [_rightChargeButton setTitle:@"Top up manual" forState:UIControlStateNormal];
    _rightChargeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_rightChargeButton addTarget:self action:@selector(rightChargeButtonAC) forControlEvents:UIControlEventTouchUpInside];
    [self.nav addSubview:_rightChargeButton];
    self.isRight = NO;
    
//    [self addrighttitleString:@"Top up manual"];
}

- (void)rightAction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"Untuk top up manual, mohon hubungi line:  CS.SugarTalk" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
    [alert show];

}


- (void)setText:(NSString *)text
{
    _text = text;
    [_titleLable setText:_text];
    [_titleLable sizeToFit];
    _titleLable.center = CGPointMake(kScreenWidth / 2.0, 42);
    
    
}

- (void)setIsBack:(BOOL)isBack
{
    _isBack = isBack;
    _backButtton.hidden = !_isBack;
    
}

- (void)setNavbarHiden:(BOOL)navbarHiden
{
    _navbarHiden = navbarHiden;
    if (_navbarHiden) {
        _nav.hidden = YES;
    }else{
        
        _nav.hidden = NO;
    }
}



- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightChargeButtonAC {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"Untuk top up manual, mohon hubungi line: CandyTalk" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Salin ID", nil];
    [alert show];
}

- (void)addrightImage:(NSString *)imageString
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 0, 70, 64)];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    [self.nav addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction)];
    [view addGestureRecognizer:tap];
    _rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightbutton.frame = CGRectMake(kScreenWidth - 50 / 2.0 - 15, 20 + (self.nav.height - 20 - 50 / 2.0) / 2.0 , 50 / 2.0, 50 / 2.0);
//    _rightbutton.backgroundColor = [UIColor redColor];
    [_rightbutton setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [_rightbutton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nav addSubview:_rightbutton];
    
}

- (void)addrighttitleString:(NSString *)titleString
{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 0, 70, 64)];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    [self.nav addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction)];
    [view addGestureRecognizer:tap];
    _rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightbutton.frame = CGRectMake(kScreenWidth - 70, 20 + (self.nav.height - 20 - 50 / 2.0) / 2.0 , 70 , 50 / 2.0);
    [_rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightbutton setTitle:titleString forState:UIControlStateNormal];
    _rightbutton.titleLabel.font =[UIFont systemFontOfSize:16];
     _rightbutton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_rightbutton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nav addSubview:_rightbutton];

}

- (void)addlefttitleString:(NSString *)titleString
{
    
   
    _leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftbutton.frame = CGRectMake(15 , 20 + (self.nav.height - 20 - 50 / 2.0) / 2.0 , 100 , 50 / 2.0);
    [_leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftbutton setTitle:titleString forState:UIControlStateNormal];
    _leftbutton.titleLabel.font =[UIFont systemFontOfSize:16];
    //     _rightbutton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_leftbutton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nav addSubview:_leftbutton];
    
}


//- (void)rightAction
//{
//    
//}

- (void)leftAction
{
    
}

- (void)setIsRight:(BOOL)isRight {
    if (isRight) {
        self.rightChargeButton.hidden = NO;
    } else {
        self.rightChargeButton.hidden = YES;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 複製賬號
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *urlStr = @"CandyTalk";
        pasteboard.string = urlStr;
    }
}


@end
