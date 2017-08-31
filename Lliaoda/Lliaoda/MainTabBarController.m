//
//  MainTabBarController.m
//  iCheated
//
//  Created by yunhe on 15/5/29.
//  Copyright (c) 2015年 01. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
@interface MainTabBarController ()<UITabBarControllerDelegate,UITabBarDelegate>

@end

static MainTabBarController *mainTVC = nil;

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mainTVC = self;
    self.delegate = self;
//    self.tabBar.alpha = .9;
    
    self.tabBar.tintColor=Color_nav;
    

    
            NSArray *iapArray = [IAPModel findAll];
            if (iapArray.count != 0) {
    
                [[AppDelegate shareAppDelegate] appPay];
            }
    //自定义标签栏
    [self _initTabBar];
    
    if (self.iszhubo) {
        [self zhuViewcontrollers];
    }else{
        
        [self nozhuViewcontrollers];
    }

    //点击tabbar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarSelect:) name:NotiCenter_TabbarSeleced object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageInstantReceive:) name:Notice_onMessageInstantReceive object:nil];

    
    NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@",selfuid];
    NSArray *array = [MessageCount findByCriteria:criteria];
    int count = 0;
   
    for (MessageCount *mcount in array) {
        count += mcount.count;
        
    }
    UITabBarItem *item=[self.tabBar.items objectAtIndex:self.tabBar.items.count - 2];
    // 显示
    item.badgeValue=[NSString stringWithFormat:@"%d",count];
    if(count == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onMessageNoData object:nil];
        item.badgeValue = nil;
    }
    
}

- (void)nozhuViewcontrollers
{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FindVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"FindVC"];
    BaseNavigationController *nav_main = [[BaseNavigationController alloc]initWithRootViewController:homeVC];
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:LXSring(@"發現") image:[UIImage imageNamed:@"faxian"] selectedImage:[UIImage imageNamed:@"faxian"]];
    homeVC.tabBarItem = tabBarItem1;
    
    
    SelectedVC *managementVC = [storyBoard instantiateViewControllerWithIdentifier:@"SelectedVC"];
    BaseNavigationController *nav_managementVC = [[BaseNavigationController alloc]initWithRootViewController:managementVC];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:LXSring(@"精選") image:[UIImage imageNamed:@"jingxuan_n"] selectedImage:[UIImage imageNamed:@"jingxuan_h"]];
    managementVC.tabBarItem = tabBarItem2;
    
    
    MeassageVC *vipbusinessVC = [storyBoard instantiateViewControllerWithIdentifier:@"MeassageVC"];
    BaseNavigationController *nav_vipbusinessVC = [[BaseNavigationController alloc]initWithRootViewController:vipbusinessVC];
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:LXSring(@"訊息") image:[UIImage imageNamed:@"xiaoxi_h"] selectedImage:[UIImage imageNamed:@"xiaoxi_n"]];
    vipbusinessVC.tabBarItem = tabBarItem3;
    
    
    MyVC *myVC = [storyBoard instantiateViewControllerWithIdentifier:@"MyVC"];
    BaseNavigationController *nav_myVC = [[BaseNavigationController alloc]initWithRootViewController:myVC];
    UITabBarItem *tabBarItem4 = [[UITabBarItem alloc] initWithTitle:LXSring(@"我的") image:[UIImage imageNamed:@"me_n"] selectedImage:[UIImage imageNamed:@"me_h"]];
    myVC.tabBarItem = tabBarItem4;
    
    self.viewControllers = @[nav_main,nav_managementVC,nav_vipbusinessVC,nav_myVC];
    
}

- (void)zhuViewcontrollers
{
    
    // 1.获取当前的StoryBoard面板
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SelectedVC *managementVC = [storyBoard instantiateViewControllerWithIdentifier:@"SelectedVC"];
    BaseNavigationController *nav_managementVC = [[BaseNavigationController alloc]initWithRootViewController:managementVC];
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:LXSring(@"精選") image:[UIImage imageNamed:@"jingxuan_n"] selectedImage:[UIImage imageNamed:@"jingxuan_h"]];
    managementVC.tabBarItem = tabBarItem1;
    
    
    MeassageVC *vipbusinessVC = [storyBoard instantiateViewControllerWithIdentifier:@"MeassageVC"];
    BaseNavigationController *nav_vipbusinessVC = [[BaseNavigationController alloc]initWithRootViewController:vipbusinessVC];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:LXSring(@"訊息") image:[UIImage imageNamed:@"xiaoxi_h"] selectedImage:[UIImage imageNamed:@"xiaoxi_n"]];
    vipbusinessVC.tabBarItem = tabBarItem2;
    
    MyVC *myVC = [storyBoard instantiateViewControllerWithIdentifier:@"MyVC"];
    BaseNavigationController *nav_myVC = [[BaseNavigationController alloc]initWithRootViewController:myVC];
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:LXSring(@"我的") image:[UIImage imageNamed:@"me_n"] selectedImage:[UIImage imageNamed:@"me_h"]];
    myVC.tabBarItem = tabBarItem3;
    
    self.viewControllers = @[nav_managementVC,nav_vipbusinessVC,nav_myVC];
    
}


- (void)onMessageInstantReceive:(NSNotification *)notification
{
    NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@",selfuid];
    NSArray *array = [MessageCount findByCriteria:criteria];
    int count = 0;
    
    for (MessageCount *mcount in array) {
        count += mcount.count;
        
    }
    UITabBarItem *item=[self.tabBar.items objectAtIndex:self.tabBar.items.count - 2];
    // 显示
    item.badgeValue=[NSString stringWithFormat:@"%d",count];
    if(count == 0){
        
        item.badgeValue = nil;
    }


}



- (void)gotoHomeAction
{
    self.selectedIndex = 0;

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{

    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
   
    

}

- (void)tabbarSelect:(NSNotification*)noti
{
    NSInteger count = [noti.object integerValue];
    self.selectedIndex = count;
//    [self tabBarController:self didSelectViewController:nil];
    
}

- (void)_initTabBar
{
    
        //点击tabbar
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarSelect:) name:NotiCenter_TabbarSeleced object:nil];
        


}

//单例方法
+ (instancetype)shareMainTabBarController;
{
    if (mainTVC == nil) {
        
      mainTVC = [[self alloc] init];
    }
    return mainTVC;
    
}



@end
