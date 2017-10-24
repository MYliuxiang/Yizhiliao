//
//  MEntrance.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MEntrance.h"

@implementation MEntrance

+ (MEntrance *)sharedManager
{
    static MEntrance *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(kScreenWidth - 60, 20, 40, 40);
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _btn.frame = CGRectMake(0, 0, 40, 40);
            [_btn setImage:[UIImage imageNamed:@"qipao"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        _btn.cb_badge = [CBBadge cb_Badge];
       
        NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@",selfuid];
        NSArray *array = [MessageCount findByCriteria:criteria];
        int count = 0;
        
        for (MessageCount *mcount in array) {
            count += mcount.count;
            
        }
        [_btn.cb_badge setBadgeValue:count];
        [_btn.cb_badge setBadgeValue:3];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageInstantReceive:) name:Notice_robotMessage object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageNoData:) name:Notice_onMessageNoData object:nil];
        
    }
    return self;
}

#pragma mark - LeftView红点判断
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

- (void)onMessageNoData:(NSNotification *)notification {

    [_btn.cb_badge setBadgeValue:0];
}

- (void)buttonClick:(UIButton *)btn
{
    
    
    
}

- (void)setBageMessageCount:(int)count
{
    
     [_btn.cb_badge setBadgeValue:count];
    
}


@end
