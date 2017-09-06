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
#import "TJPTabBar.h"

@interface TJPTabBarController ()<UINavigationControllerDelegate>
{
    UIView *tabBarView;
    UIView *tabBarView1;
    UIView *tabBarView2;
    UIView *tabBarView3;
    
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

//+ (instancetype)tabBarControllerWitnAddChildVCBlock:(void (^)(TJPTabBarController *))addVCBlock
//{
//    TJPTabBarController *tabBarVC = [[TJPTabBarController alloc] init];
//    if (addVCBlock) {
//        addVCBlock(tabBarVC);
//    }
//    return tabBarVC;
//}
//
//
//- (void)addChildVC:(UIViewController *)vc normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName isRequiredNavController:(BOOL)isRequired
//{
//    if (isRequired) {
//        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
//        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:normalImageName] selectedImage:[UIImage imageNamed:selectedImageName]];
//        nav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//
//        [self addChildViewController:nav];
//    }else {
//        [self addChildViewController:vc];
//    }
//    
//}
//
//- (void)addCenterChildVC:(UIViewController *)vc normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName isRequiredNavController:(BOOL)isRequired
//{
//    if (isRequired) {
//        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
//        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:normalImageName] selectedImage:[UIImage imageNamed:selectedImageName]];
//        nav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//        
//        [self addChildViewController:nav];
//    }else {
//        [self addChildViewController:vc];
//    }
//
//}


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
//    TJPTabBar *tabbar = [[TJPTabBar alloc] init];
//    [self setValue:tabbar forKey:@"tabBar"];
//    [tabbar setCenterBtnClickBlock:^{
//        //中间按钮方法
//        self.selectedIndex = -1;
//    
//        
//    }];
    
    tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 49, SCREEN_W, 49)];
    tabBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabBarView];
    
//    tabBarView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W / 2, 49)];
//    tabBarView1.backgroundColor = [UIColor clearColor];
//    [tabBarView addSubview:tabBarView1];
//    
//    tabBarView3 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W / 3 * 2, 0, SCREEN_W / 3, 49)];
//    tabBarView3.backgroundColor = [UIColor clearColor];
//    [tabBarView addSubview:tabBarView3];
//    
//    tabBarView2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W / 3, 0, 49, 49)];
//    tabBarView2.backgroundColor = [UIColor clearColor];
//    [tabBarView addSubview:tabBarView2];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.tag = 1;
    _button1.frame = CGRectMake(0, 0, SCREEN_W / 3, 49);
    [_button1 setImage:[UIImage imageNamed:@"jingxuan_n"] forState:UIControlStateNormal];
    [_button1 setImage:[UIImage imageNamed:@"jingxuan_h"] forState:UIControlStateSelected];
    [_button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:_button1];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button2.tag = 2;
    _button2.backgroundColor = [UIColor clearColor];
    _button2.frame = CGRectMake(tabBarView.width / 2 - 35, -21, 70, 70);
    [_button2 setBackgroundImage:[UIImage imageNamed:@"faxian_n"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"faxian_h"] forState:UIControlStateSelected];
    [_button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:_button2];
    
    _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button3.tag = 3;
    _button3.frame = CGRectMake(SCREEN_W / 3 * 2, 0, SCREEN_W / 3, 49);
    [_button3 setImage:[UIImage imageNamed:@"me_n"] forState:UIControlStateNormal];
    [_button3 setImage:[UIImage imageNamed:@"me_h"] forState:UIControlStateSelected];
    [_button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:_button3];
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
//    FindVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"FindVC"];
    SelectedVC *managementVC = [storyBoard instantiateViewControllerWithIdentifier:@"SelectedVC"];

//    MeassageVC *vipbusinessVC = [storyBoard instantiateViewControllerWithIdentifier:@"MeassageVC"];
//    MeassageVC *vipbusinessVC = [storyBoard instantiateViewControllerWithIdentifier:@"MeassageVC"];
    FindVC *findVC = [storyBoard instantiateViewControllerWithIdentifier:@"FindVC"];
//    MyVC *myVC = [storyBoard instantiateViewControllerWithIdentifier:@"MyVC"];
    NewMyVC *myVC = [[NewMyVC alloc] init];
    OnlineUserVC *onlineVC = [[OnlineUserVC alloc] init];
    if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
        vcs = @[managementVC, onlineVC, myVC];
    } else {
        
        vcs = @[managementVC, findVC, myVC];
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
}
- (void)buttonClick:(UIButton *)button {
    
    if (button.tag == 2) {
        _button1.selected = NO;
        _button2.selected = YES;
        _button3.selected = NO;
        if (self.selectedIndex == button.tag - 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"findVC" object:nil userInfo:nil];
            _button2.userInteractionEnabled = NO;
        } else {
            self.selectedIndex = button.tag - 1;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeFind) name:@"closeFind" object:nil];
        }
        
    } else {
        _button2.userInteractionEnabled = YES;
        self.selectedIndex = button.tag - 1;
        if (button.tag == 1) {
            _button1.selected = YES;
            _button2.selected = NO;
            _button3.selected = NO;
        } else if (button.tag == 2) {
            _button1.selected = NO;
            _button2.selected = YES;
            _button3.selected = NO;
        } else {
            _button1.selected = NO;
            _button2.selected = NO;
            _button3.selected = YES;
        }
    }
    
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
