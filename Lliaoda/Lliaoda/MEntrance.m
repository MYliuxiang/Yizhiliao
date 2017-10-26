//
//  MEntrance.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MEntrance.h"
#import "MessageRecordVC.h"

@implementation MEntrance

- (instancetype)initWithVC:(UIViewController *)vc withimageName:(NSString *)imagename withBageColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        
        //
        self.vc = vc;
        self.frame = CGRectMake(kScreenWidth - 60, 20, 40, 40);
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _btn.frame = CGRectMake(0, 0, 40, 40);
        [_btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        _btn.cb_badge = [CBBadge cb_Badge];
        _btn.cb_badge.backgroundColor = color;
        
        NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@",selfuid];
        NSArray *array = [MessageCount findByCriteria:criteria];
        int count = 0;
        
        for (MessageCount *mcount in array) {
            count += mcount.count;
            
        }
        [_btn.cb_badge setBadgeValue:count];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onrobotMessage:) name:Notice_robotMessage object:nil];
        
      
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageInstantReceive:) name:Notice_onMessageInstantReceive object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMEntranceNotice:) name:Notice_MEntranceNotice object:nil];
        
    }
    return self;
    
}


#pragma mark - LeftView红点判断
//设置全局统一通知
- (void)onMEntranceNotice:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [self.btn.cb_badge setBadgeValue:[userInfo[@"count"] integerValue]];
    
    
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
   
    [_btn.cb_badge setBadgeValue:count];

}

- (void)onrobotMessage:(NSNotification *)notification
{
    NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@",selfuid];
    NSArray *array = [MessageCount findByCriteria:criteria];
    int count = 0;
    
    for (MessageCount *mcount in array) {
        count += mcount.count;
        
    }
    [_btn.cb_badge setBadgeValue:count];
    
}

- (void)buttonClick:(UIButton *)btn
{
    if (self.vc != nil) {
        MessageRecordVC *vc = [[MessageRecordVC alloc] init];
        [self.vc.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (void)setBageMessageCount:(int)count
{
    [_btn.cb_badge setBadgeValue:count];
    NSDictionary *dic = @{@"count":[NSString stringWithFormat:@"%d",count]};
    [[NSNotificationCenter defaultCenter] postNotificationName:Notice_MEntranceNotice object:nil userInfo:dic];
}


@end
