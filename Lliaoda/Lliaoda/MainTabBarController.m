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
//    self.tabBar.selectedImageTintColor = [UIColor colorWithRed:65/255.0 green:205/255.0 blue:62/255.0 alpha:1];
    
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
    UITabBarItem *item=[self.tabBar.items objectAtIndex:itemIndex];
    // 显示
    item.badgeValue=[NSString stringWithFormat:@"%d",count];
    if(count == 0){
    
        item.badgeValue = nil;
    }
    
//    NSDictionary *params;
//    [WXDataService requestAFWithURL:Url_chatvideoreend params:params httpMethod:@"POST" isHUD:YES finishBlock:^(id result) {
//        if(result){
//            if ([[result objectForKey:@"result"] integerValue] == 0) {
//                
//            }else{    //请求失败
//                
//            }
//        }
//        
//    } errorBlock:^(NSError *error) {
//        
//    }];
//
    
   
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
    UITabBarItem *item=[self.tabBar.items objectAtIndex:itemIndex];
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
