//
//  MeassageVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MeassageVC.h"

@interface MeassageVC ()

@end

static MeassageVC *this;
@implementation MeassageVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@ order by timeDate DESC",selfuid];
    NSArray *array = [MessageCount findByCriteria:criteria];
    NSMutableArray *marray = [NSMutableArray array];
    for (MessageCount *count in array) {
        
        NSArray *blacks = [BlackName findAll];
        BOOL isB = NO;
        for (BlackName *black in blacks) {
            if ([black.uid isEqualToString:count.sendUid]) {
                isB = YES;
                [count deleteObject];
            }
        }
        
        if (!isB) {
            
            [marray addObject:count];
        }
    }
    self.dataList = [NSMutableArray arrayWithArray:marray];
    if (self.dataList.count == 0) {
        
        self.noDataView.hidden = NO;
        
    }else{
        
        self.noDataView.hidden = YES;
    }
    int count = 0;
    for (MessageCount *mcount in array) {
        count += mcount.count;
    }
    
    UITabBarItem *item=[self.tabBarController.tabBar.items objectAtIndex:[MainTabBarController shareMainTabBarController].tabBar.items.count - 2];
    // 显示
    item.badgeValue=[NSString stringWithFormat:@"%d",count];
    if(count == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onMessageNoData object:nil];
        item.badgeValue = nil;
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    [aPath moveToPoint:CGPointMake(0, 0)];
   
    self.tableView.layer.cornerRadius = 5;
    self.navbarHiden = YES;
    self.nomessageLabel.text = LXSring(@"暫時沒有消息，去交些新朋友吧！😊");
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(LXSring(@"未知网络"));
                self.isNoWifi = NO;
                [self.tableView reloadData];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(LXSring(@"没有网络"));
                self.isNoWifi = YES;
                [self.tableView reloadData];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(LXSring(@"手机自带网络"));
                self.isNoWifi = NO;
                [self.tableView reloadData];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                self.isNoWifi = NO;
                [self.tableView reloadData];
                break;
        }
    }];
    
    //开始监控
    [manager startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageInstantReceive:) name:Notice_onMessageInstantReceive object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@ order by timeDate DESC",selfuid];
    NSArray *array = [MessageCount findByCriteria:criteria];
    self.dataList = [NSMutableArray arrayWithArray:array];
    int count = 0;
    for (MessageCount *mcount in array) {
        count += mcount.count;
    }
    
    UITabBarItem *item=[self.tabBarController.tabBar.items objectAtIndex:[MainTabBarController shareMainTabBarController].tabBar.items.count - 2];
    // 显示
    item.badgeValue=[NSString stringWithFormat:@"%d",count];
    if(count == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onMessageNoData object:nil];
        item.badgeValue = nil;
    }
    [self.tableView reloadData];
    [self _initView];
    [self initAgore];
    [self addNotice];
    
}

- (void)onMessageInstantReceive:(NSNotification *)notification
{

    NSDictionary *userInfo = notification.userInfo;
    NSString *account = [NSString stringWithFormat:@"%@",userInfo[@"account"]];
    NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",account,[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];
    if ([MessageCount findFirstByCriteria:criteria]) {
        
        MessageCount *count = [MessageCount findFirstByCriteria:criteria];
        
        BOOL ishave = NO;
        for (int i = 0; i < self.dataList.count; i++) {
            MessageCount *mc = self.dataList[i];
             if (mc.uid == count.uid && mc.sendUid == count.sendUid) {
                 ishave = YES;
                 [self.dataList removeObject:mc];
                 [self.dataList insertObject:count atIndex:0];
             }
        }
        if (ishave == NO) {
            [self.dataList insertObject:count atIndex:0];
        }
        [self.tableView reloadData];
        
    }else{
    
    }
    
    self.noDataView.hidden = YES;


}

- (void)addNotice
{
    
    //正在登陆
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin) name:Notice_onLogin object:nil];
    //登入失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginFailed) name:Notice_onLoginFailed object:nil];
    //登入成功、
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSuccess) name:Notice_onLoginSuccess object:nil];
    //当重连成功会触发此回调。重连失败会触发onLogout回调。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReconnected) name:Notice_onReconnected object:nil];
    //登入成功后，丢失连接触发本回调。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReconnecting) name:Notice_onReconnecting object:nil];
    //退出登陸回调(onLogout)。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout) name:Notice_onLogout object:nil];
 
}

//正在登陆
- (void)onLogin
{
    self.text = LXSring(@"正在连接...");
    [self.actView startAnimating];

}
//登入失败
- (void)onLoginFailed
{
    self.text = LXSring(@"訊息(未连接)");
    [self.actView stopAnimating];

}

 //登入成功、
- (void)onLoginSuccess
{
    self.text = LXSring(@"訊息");
    [self.actView stopAnimating];

}

//当重连成功会触发此回调。重连失败会触发onLogout回调。
- (void)onReconnected
{
    self.text = LXSring(@"訊息");
    [self.actView stopAnimating];

}

//登入成功后，丢失连接触发本回调。
- (void)onReconnecting
{

    if ([[NetWorkManager sharedManager] checkNowNetWorkStatus] != NotReachable) {
        
        self.text = LXSring(@"正在连接...");
        [self.actView startAnimating];
    }

}

//退出登陸回调(onLogout)。
- (void)onLogout
{
    self.text = LXSring(@"訊息(未连接)");
    [self.actView stopAnimating];

}



- (void)_initView
{
    
    _actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _actView.center = CGPointMake(self.titleLable.left - 40, self.titleLable.top + 10);
    [self.nav addSubview:_actView];

}

- (void)initAgore
{
    AppDelegate *app = [AppDelegate shareAppDelegate];
    self.inst = app.inst;
    self.instMedia = app.instMedia;
    
    if([self.inst isOnline]){
    
        self.text = LXSring(@"訊息");
        
    }else{
        
        self.text = LXSring(@"訊息(未连接)");
    }
    
}

#pragma  mark --------UITableView Delegete----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifire = @"cellID";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:nil options:nil] lastObject];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.count = self.dataList[indexPath.row];
    if (indexPath.row + 1 == self.dataList.count) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isNoWifi) {
        
        return 20;
    }
    return .1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isNoWifi) {
        
        self.nowifiView.width = kScreenWidth;
        self.nowifiView.height = 30;
        return self.nowifiView;
    }
    
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:LXSring(@"删除") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //1.更新数据
        
        MessageCount *count = self.dataList[indexPath.row];
        [count deleteObject];
        [self.dataList removeObjectAtIndex:indexPath.row];
        int bage = 0;
        for (MessageCount *mcount in self.dataList) {
            bage += mcount.count;
        }
        
        UITabBarItem *item=[self.tabBarController.tabBar.items objectAtIndex:[MainTabBarController shareMainTabBarController].tabBar.items.count - 2];
        // 显示
        item.badgeValue=[NSString stringWithFormat:@"%d",bage];
        if(bage == 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onMessageNoData object:nil];
            item.badgeValue = nil;
        }
        
        //2.更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = Color_Tab;
    //将設定好的按钮方到数组中返回
    return @[deleteAction];
    // return @[deleteAction,topRowAction,collectRowAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCount *count = self.dataList[indexPath.row];
    count.count = 0;
    [count update];
    LHChatVC *chatVC = [[LHChatVC alloc] init];
    chatVC.sendUid = count.sendUid;
    chatVC.count = self.dataList[indexPath.row];
   
    MEntrance *rance = [[MEntrance alloc] init];
    NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@",selfuid];
    NSArray *array = [MessageCount findByCriteria:criteria];
    int count3 = 0;
    
    for (MessageCount *mcount in array) {
        count3 += mcount.count;
        
    }
    [rance setBageMessageCount:count3];
    
    [self.navigationController pushViewController:chatVC animated:YES];
    
}


@end
