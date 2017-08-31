//
//  GiftsView.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "GiftsView.h"

@implementation GiftsView

static NSString *identifire = @"GiftID";

- (instancetype)initGiftsView
{
    self = [super init];
    
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        
        
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 305);
        
        [self.chonBtn setTitle:LXSring(@"充值") forState:UIControlStateNormal];
        self.chonBtn.layer.masksToBounds = YES;
        self.chonBtn.layer.cornerRadius = 5;
        self.pageControl.currentPage = 0;
        _inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];
        self.dataList = [NSMutableArray array];
        [self creatCollectionView];
        [self loagGifts];
     
    }
    
    return self;
}

- (void)loagGifts
{
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_gifts params:params httpMethod:@"GET" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
               
                NSArray *array = result[@"data"][@"gifts"];
                NSMutableArray *marray = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    
                    MGiftModel *model = [MGiftModel mj_objectWithKeyValues:dic];
                    [marray addObject:model];
                    [self.dataList addObject:model];
//                    if (marray.count == 8) {
//                        NSArray *array = [NSArray arrayWithArray:marray];
//                        [self.dataList addObject:array];
//                        [marray removeAllObjects];
//                    }
                    
                }
                
//                if (marray.count < 8 && marray.count > 0) {
//                    [self.dataList addObject:marray];
//                }
                
//                int i;
                if (self.dataList.count <= 8) {
                    self.pageControl.hidden = YES;
                }else{
                
                    self.pageControl.hidden = NO;
                }
                self.pageControl.numberOfPages = self.dataList.count / 8 + 1;
                [self.collectionView reloadData];
                [self.collectionView selectItemAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]animated:YES scrollPosition:UICollectionViewScrollPositionNone];

                
            }else{    //请求失败
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
    }];

}

- (void)creatCollectionView
{

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.gifLayout = [[GiftLayout alloc] init];

    _gifLayout.minimumLineSpacing= -1;
    _gifLayout.minimumInteritemSpacing= -1;
    _gifLayout.itemSize = CGSizeMake((kScreenWidth + 3) / 4,123);
//    _gifLayout.sectionInset=UIEdgeInsetsMake(0, (kScreenWidth - 240) / 5.0, 0, (kScreenWidth - 240) / 5.0);

    [_gifLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//滚动方向
    //設定代理
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
//    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 20, 0);
    self.collectionView.collectionViewLayout = self.gifLayout;
    [_collectionView registerNib:[UINib nibWithNibName:@"GiftCell" bundle:nil] forCellWithReuseIdentifier:identifire];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.allowsMultipleSelection = NO;

}

//設定页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = (int)(scrollView.contentOffset.x/scrollView.frame.size.width + 0.5)%5;
    
    self.pageControl.currentPage = page;
    
}

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count;
    if (self.dataList.count % 8) {
        count = self.dataList.count/8 + 1;
    }else{
    
        count = self.dataList.count/8;
    }
    return count * 8;
    
//    NSArray *array = self.dataList[section];
//    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果有闲置的就拿到使用,如果没有,系统自动的去创建
    GiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifire forIndexPath:indexPath];
    NSArray *array = self.dataList[indexPath.section];
//    if (array.count < 8) {
//        if (indexPath.row < array.count) {
//            
//            MGiftModel *model = self.dataList[indexPath.section][indexPath.row];
//            cell.model = model;
//        }
//        
//    }else{
//        
//        MGiftModel *model = self.dataList[indexPath.section][indexPath.row];
//        cell.model = model;
//    }
    
    if (indexPath.row < _dataList.count) {
        
        MGiftModel *model = self.dataList[indexPath.row];
        cell.model = model;
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [MyColor colorWithHexString:@"#666666"].CGColor;
    }else{
    
        cell.model = nil;
        cell.layer.borderWidth = 0;
        cell.layer.borderColor = [MyColor colorWithHexString:@"#666666"].CGColor;
    }
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth - 3) / 4, 121)];
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderWidth = 1;
    view.layer.borderColor = Color_Tab.CGColor;
    cell.selectedBackgroundView = view;
    cell.selectedBackgroundView.frame = CGRectMake(1, 1, (kScreenWidth + 3) / 4 - 2, 121);
    
    [cell setNeedsLayout];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row >= _dataList.count) {
     
        return;
    }
    
    MGiftModel *model = self.dataList[indexPath.row];
    NSDictionary *params;
    params = @{@"uid":[NSString stringWithFormat:@"%@", model.uid],@"receiverId":self.pmodel.uid,@"quantity":@1};
    [WXDataService requestAFWithURL:Url_giftsend params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSString *deposit = [NSString stringWithFormat:@"%@",result[@"data"][@"deposit"]];
                NSString *str = [NSString stringWithFormat:LXSring(@"余额:%@鑽"),deposit];
//                NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:str];
//                [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(3, deposit.length)];
                
                self.elabel.text = str;
                
                
                NSString *uid = [NSString stringWithFormat:@"%@",result[@"data"][@"uid"]];
                // 礼物模型
                GiftModel *giftModel = [[GiftModel alloc] init];
                giftModel.giftImage = model.icon;
                giftModel.giftName = [NSString stringWithFormat:LXSring(@"送出%@"),model.name];
                giftModel.giftCount = 1;
                giftModel.giftUid = model.uid;
                giftModel.diamonds = model.diamonds;
                
                NSString *userId = [NSString stringWithFormat:@"%@%@",[LXUserDefaults objectForKey:UID],model.uid];
                if (self.isVideoBool) {
                    AnimOperationManager *manager = [AnimOperationManager sharedManager];
                    manager.parentView = self.superview;
                    [manager animWithUserID:userId model:giftModel finishedBlock:^(BOOL result) {
                        
                    }];
                    long idate = [[NSDate date] timeIntervalSince1970]*1000;
                    NSDictionary *dic = @{
                                          @"message": @{
                                                  @"messageID": @"-1",
                                                  @"event": @"gift",
                                                  @"content": uid,
                                                  @"time": [NSString stringWithFormat:@"%ld",idate]
                                                  }
                                          };
                    
                    NSString *msgStr = [InputCheck convertToJSONData:dic];
                    [_inst messageInstantSend:self.pmodel.uid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"-1"]];
                    
                } else {
                    // 向服務器發送禮物數據
                    [self sendGiftMessage:model.name diamonds:model.diamonds giftUid:giftModel.giftUid];
                }
                
                
                
                
            }else{    //请求失败
                
                if ([[result objectForKey:@"result"] integerValue] == 8) {
                    
                   
                    LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"购买鑽石") message:LXSring(@"啊噢～餘額不太夠，儲值後才能送禮物喲！") style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"［暫時不用］") destructiveButtonTitle:LXSring(@"［快速儲值］") delegate:nil];
                    lg.destructiveButtonBackgroundColor = Color_nav;
                    lg.destructiveButtonTitleColor = UIColorFromRGB(0x00ddcc);
                    lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                    lg.cancelButtonBackgroundColor = Color_nav;
                    lg.cancelButtonTitleColor = [UIColor blackColor];
                    lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                        self.superview.hidden = YES;
                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                        AccountVC *vc = [[AccountVC alloc] init];
                        vc.isCall = YES;
                        vc.clickBlock = ^(){
                            
                            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                            self.superview.hidden = NO;
                            
                            
                        };
                        [[self topViewController].navigationController pushViewController:vc animated:YES];
                        
                    };
                    [lg showAnimated:YES completionHandler:nil];
                    
                    
                }

                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
    }];
    
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[AppDelegate shareAppDelegate].window rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
        
    }else{
        
        return vc;
    }
    
    return nil;
}


- (IBAction)chongAC:(id)sender {
    if(self.isVideoBool){
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    }
    self.superview.hidden = YES;
    AccountVC *vc = [[AccountVC alloc] init];
    vc.isCall = YES;
    vc.clickBlock = ^(){
        if(self.isVideoBool){
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

        }
    self.superview.hidden = NO;
        
    };
     [[self topViewController].navigationController pushViewController:vc animated:YES];
    
    
}

- (void)sendGiftMessage:(NSString *)giftName diamonds:(int)diamonds giftUid:(NSString *)giftUid{
    
    if (self.giftBlock) {
        
        self.giftBlock(giftName, diamonds, giftUid);
        return;
        
    }
    
    
    
    NSString *content = [NSString stringWithFormat:LXSring(@"我送出：%@(%d鉆)"), giftName, diamonds];
    NSString *contents = [NSString stringWithFormat:@"%@(%d)", giftName, diamonds];
    long long idate = [[NSDate date] timeIntervalSince1970]*1000;
    __block Message *messageModel = [Message new];
    messageModel.isSender = YES;
    messageModel.isRead = NO;
    messageModel.status = MessageDeliveryState_Delivering;
    messageModel.date = idate;
    messageModel.messageID = [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate];
    messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],self.pmodel.uid];
    messageModel.type = MessageBodyType_Text;
    messageModel.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    messageModel.sendUid = self.pmodel.uid;
    messageModel.content = content;
    
    [messageModel save];
    [SVProgressHUD showSuccessWithStatus:LXSring(@"禮物已發送，謝謝老闆打賞~")];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
    });
    NSDictionary *dic = @{
                          @"message": @{
                                  @"messageID": [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate],
                                  @"event": @"gift",
                                  @"content": contents,
                                  @"request": @"-3",
                                  @"time": [NSString stringWithFormat:@"%lld",idate]
                                  }
                          };

    NSString *msgStr = [InputCheck convertToJSONData:dic];
    [_inst messageInstantSend:self.pmodel.uid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate]];
    
    NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",self.pmodel.uid,[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];
    
    if ([MessageCount findFirstByCriteria:criteria]) {
        
        MessageCount *count = [MessageCount findFirstByCriteria:criteria];
        count.content = [NSString stringWithFormat:LXSring(@"我送出：%@(%d鉆)"), giftName, diamonds];
        count.count = count.count;
        
        count.timeDate = idate;
        count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        count.sendUid = self.pmodel.uid;
        [count update];
        
    }else{
        
        MessageCount *count = [[MessageCount alloc] init];
        count.content = [NSString stringWithFormat:LXSring(@"我送出：%@(%d鉆)"), giftName, diamonds];
        count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        count.sendUid = self.pmodel.uid;
        count.count = 0;
        count.timeDate = idate;
        [count save];
    }
    
    NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSString *criteria2 = [NSString stringWithFormat:@"WHERE uid = %@",selfuid];
    NSArray *array = [MessageCount findByCriteria:criteria2];
    int count = 0;
    
    for (MessageCount *mcount in array) {
        count += mcount.count;
        
    }
    UITabBarItem *item=[[MainTabBarController shareMainTabBarController].tabBar.items objectAtIndex:[MainTabBarController shareMainTabBarController].tabBar.items.count - 2];
    // 显示
    item.badgeValue=[NSString stringWithFormat:@"%d",count];
    if(count == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onMessageNoData object:nil];
        item.badgeValue = nil;
    }

    
    
    
    
}
@end
