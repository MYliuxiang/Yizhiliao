//
//  TJPTabBarController.m
//  TJPYingKe
//
//  Created by Walkman on 2016/12/7.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import "TJPTabBarController.h"

#import "TJPTabBar.h"

@interface TJPTabBarController ()<UINavigationControllerDelegate>
{
    UIView *tabBarView;
    UIView *tabBarView1;
    UIView *tabBarView2;
    UIView *tabBarView3;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
}
@end

@implementation TJPTabBarController

//+ (instancetype)shareInstance
//{
//    static TJPTabBarController *tabBarC;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        tabBarC = [[TJPTabBarController alloc] init];
//    });
//    return tabBarC;
//}
//
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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initViewController];
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
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.tag = 1;
    button1.frame = CGRectMake(0, 0, SCREEN_W / 3, 49);
    [button1 setImage:[UIImage imageNamed:@"jingxuan_n"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"jingxuan_h"] forState:UIControlStateSelected];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 2;
    button2.backgroundColor = [UIColor clearColor];
    button2.frame = CGRectMake(tabBarView.width / 2 - 35, -21, 70, 70);
    [button2 setBackgroundImage:[UIImage imageNamed:@"faxian_n"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"faxian_h"] forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:button2];
    
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.tag = 3;
    button3.frame = CGRectMake(SCREEN_W / 3 * 2, 0, SCREEN_W / 3, 49);
    [button3 setImage:[UIImage imageNamed:@"me_n"] forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"me_h"] forState:UIControlStateSelected];
    [button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:button3];
    
    if (self.selectedIndex == 1){
        button1.selected = NO;
        button2.selected = YES;
        button3.selected = NO;
    }else if (self.selectedIndex == 2){
        button1.selected = NO;
        button2.selected = NO;
        button3.selected = YES;
        
    } else {
        button1.selected = YES;
        button2.selected = NO;
        button3.selected = NO;
    }
    
}

- (void)initViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    FindVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"FindVC"];
    SelectedVC *managementVC = [storyBoard instantiateViewControllerWithIdentifier:@"SelectedVC"];
    MeassageVC *vipbusinessVC = [storyBoard instantiateViewControllerWithIdentifier:@"MeassageVC"];
    MyVC *myVC = [storyBoard instantiateViewControllerWithIdentifier:@"MyVC"];
    NSArray *vcs = @[managementVC, vipbusinessVC, myVC];
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
    self.selectedIndex = button.tag - 1;
    if (button.tag == 1) {
        button1.selected = YES;
        button2.selected = NO;
        button3.selected = NO;
    } else if (button.tag == 2) {
        button1.selected = NO;
        button2.selected = YES;
        button3.selected = NO;
    } else {
        button1.selected = NO;
        button2.selected = NO;
        button3.selected = YES;
    }
}
#pragma mark - UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
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
