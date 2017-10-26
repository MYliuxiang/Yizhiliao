//
//  TJPTabBarController.m
//  TJPYingKe
//
//  Created by Walkman on 2016/12/7.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import "TJPTabBarController.h"
#import "NewMyVC.h"
#import "OnlineUserVC.h"
#import "RankingListVC.h"
#import "VideoShowVC.h"

@interface TJPTabBarController ()<UINavigationControllerDelegate>
{
    UIView *tabBarView;
   
    
}
@end

@implementation TJPTabBarController

+ (instancetype)shareInstance
{
    static TJPTabBarController *tabBarC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBarC = [[TJPTabBarController alloc] init];
    });
    return tabBarC;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    self.selectedIndex = 0;
    [self setupTabBar];
    [self initViewController];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupTabBar
{

    
    tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 49, SCREEN_W, 49)];
    tabBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tabBarView];
    
    NSArray *narray = @[@"duanshipin_n",@"jingxuan_n",@"faxian_n",@"paihang_n",@"me_n"];
    NSArray *sarray = @[@"duanshipin_h",@"jingxuan_h",@"faxian_h",@"paihang_h",@"me_h"];
    for (int i =0 ; i< 5; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(i*SCREEN_W / 5, 0, SCREEN_W / 5, 49);
        if (i == 2) {
            btn.height = 80;
            btn.top = 49 - 5 - 80;
        }
        
       
        [btn setImage:[UIImage imageNamed:narray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:sarray[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarView addSubview:btn];
        
        if (i == 1) {
            btn.selected = YES;
        }
        
    }
    

    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef boolForKey:@"ToEdit"]) {
        [userDef setBool:NO forKey:@"ToEdit"];
        self.selectedIndex = 2;
        if (self.selectedIndex == 1){
            _button1.selected = NO;
            _button2.selected = YES;
            _button3.selected = NO;
        }else if (self.selectedIndex == 2){
            _button1.selected = NO;
            _button2.selected = NO;
            _button3.selected = YES;
            
        } else {
            _button1.selected = YES;
            _button2.selected = NO;
            _button3.selected = NO;
        }
    } else {
        if (self.selectedIndex == 1){
            _button1.selected = NO;
            _button2.selected = YES;
            _button3.selected = NO;
        }else if (self.selectedIndex == 2){
            _button1.selected = NO;
            _button2.selected = NO;
            _button3.selected = YES;
            
        } else {
            _button1.selected = YES;
            _button2.selected = NO;
            _button3.selected = NO;
        }
    }
    
    
}

- (void)initViewController {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSArray *vcs;
    
    VideoShowVC  *videovc = [[VideoShowVC alloc] init];
    
    RankingListVC *rlistVC = [[RankingListVC alloc] init];
    
    SelectedVC *managementVC = [storyBoard instantiateViewControllerWithIdentifier:@"SelectedVC"];

    FindVC *findVC = [storyBoard instantiateViewControllerWithIdentifier:@"FindVC"];
    
    NewMyVC *myVC = [[NewMyVC alloc] init];
    
    OnlineUserVC *onlineVC = [[OnlineUserVC alloc] init];
    if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
        vcs = @[videovc,managementVC, onlineVC,rlistVC, myVC];
    } else {
        
        vcs = @[videovc,managementVC, findVC, rlistVC,myVC];
    }
    //创建一个存储导航控制器的数组
    NSMutableArray *navCtrls = [[NSMutableArray alloc] init];
    for (int i = 0; i < vcs.count; i++) {
        //创建导航控制器
        BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:vcs[i]];
        
        //设置导航控制器的代理对象
        baseNav.delegate = self;
        //导航控制器添加到数组中
        [navCtrls addObject:baseNav];
        
        //释放导航控制器
    }
    self.viewControllers = navCtrls;
    self.selectedIndex = 1;
}
- (void)buttonClick:(UIButton *)button {
    
    for (UIButton *btn in tabBarView.subviews) {
        btn.selected = NO;
    }
    button.selected = YES;
    
    if (button.tag == 2) {
        
        if (self.selectedIndex == 2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"findVC" object:nil userInfo:nil];
            _button2.userInteractionEnabled = NO;
        } else {
            self.selectedIndex = 2;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeFind) name:@"closeFind" object:nil];
        }
    }
    self.selectedIndex = button.tag;
    
   
}
- (void)closeFind {
    
    self.button2.userInteractionEnabled = YES;
    
}
#pragma mark - UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.tabBar.hidden = YES;
//    self.hidesBottomBarWhenPushed = YES;
    //判断当前导航控制器将要导航到第几个控制器
    if (navigationController.viewControllers.count == 1) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.35];
        if (tabBarView == nil) {
            [self setupTabBar];
        }
        [UIView commitAnimations];
    } else if (navigationController.viewControllers.count >= 2) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.35];
        [tabBarView removeFromSuperview];
        tabBarView = nil;
        [UIView commitAnimations];
    }
}

@end
