
//
//  LxPersonVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LxPersonVC.h"

@interface LxPersonVC ()
@property (nonatomic, strong) NSMutableArray *messages;


@end

@implementation LxPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }

    self.photos = [NSMutableArray array];
    self.nav.backgroundColor = [UIColor clearColor];
    self.titleLable.textColor = [UIColor whiteColor];
    self.text = self.model.nickname;
    self.type = 0;
    [self.backButtton setImage:[UIImage imageNamed:@"back_bai"] forState:UIControlStateNormal];
    
    self.view1.layer.cornerRadius = 15 / 2.0;
    self.view1.layer.masksToBounds = YES;
    
    self.view2.layer.cornerRadius = 15 / 2.0;
    self.view2.layer.masksToBounds = YES;

    self.view3.layer.cornerRadius = 15 / 2.0;
    self.view3.layer.masksToBounds = YES;
    
//    self.likeView.layer.cornerRadius = 22 / 2.0;
//    self.likeView.layer.masksToBounds = YES;
//    self.likeView.layer.borderColor = [[UIColor whiteColor] CGColor];
//    self.likeView.layer.borderWidth = 1;
//    [self.likeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)]];
    
    self.likeButton.layer.cornerRadius = 11;
    self.likeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.likeButton.layer.borderWidth = 1;

    self.footerView.hidden = YES;
    
    if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
        
        self.isZhubo = YES;
        self.giftBtn.hidden = YES;
        self.chongzhiBtn.hidden = YES;
        
    }else{
    
        self.isZhubo = NO;
        self.giftBtn.hidden = NO;
        self.chongzhiBtn.hidden = NO;
    }
    
    self.seletedView.layer.cornerRadius = 45 / 2.0;
    self.seletedView.layer.masksToBounds = YES;
    self.button1.layer.cornerRadius = 41 / 2.0;
    self.button1.layer.masksToBounds = YES;
    self.button2.layer.cornerRadius = 41 / 2.0;
    self.button2.layer.masksToBounds = YES;
    self.button1.titleLabel.textColor = [UIColor whiteColor];
    self.type = 0;
    
    UITapGestureRecognizer *hidRandG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRenandGift)];
    [self.blackView addGestureRecognizer:hidRandG];

    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        _tableViewBottom.constant = 0;
        [self addrightImage:@"bianji"];
        self.giftBtn.hidden = YES;
        self.chongzhiBtn.hidden = YES;
        self.footerView.hidden = YES;
    }else{
        
        [self addrightImage:@"dengdeng"];
        self.giftBtn.hidden = NO;
        self.chongzhiBtn.hidden = NO;
        self.footerView.hidden = NO;
        _tableViewBottom.constant = 49;
    }
    [_chatButton setTitle:LXSring(@"私信") forState:UIControlStateNormal];
    [_videoCallButton setTitle:LXSring(@"視頻通訊") forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button2 setTitleColor:[MyColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [_button1 setTitle:LXSring(@"個人資料") forState:UIControlStateNormal];
    [_button2 setTitle:LXSring(@"小視頻") forState:UIControlStateNormal];
    self.sView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, kScreenWidth / 2 - 15 - 2, 41)];
    self.sView.layer.cornerRadius = 41 / 2.0;
    self.sView.layer.masksToBounds = YES;
    
    self.sView.backgroundColor = Color_Tab;
    [self.seletedView insertSubview:self.sView atIndex:0];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self _loadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)like
{
    
    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"亲，当前用户是您自己，不能設定讚与不讚！") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.isLike) {
        
        //設定不讚
        NSDictionary *params;
        if (self.isFromHeader) {
            params = @{@"uid":self.personUID,@"state":@0};
        } else {
            params = @{@"uid":self.model.uid,@"state":@0};
        }
        [WXDataService requestAFWithURL:Url_like params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    self.isLike = NO;
//                    self.likeImge.image = [UIImage imageNamed:@"xinxing_22"];
//                    self.likeLabel.text = [NSString stringWithFormat:@"%d",[self.likeLabel.text intValue] -1];
                    self.likeButton.selected = NO;
                    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",[self.likeButton.titleLabel.text intValue] -1] forState:UIControlStateNormal];
                                            //已经点赞
                    
                }else{    //请求失败
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                    });
                    
                }
            }
            
        } errorBlock:^(NSError *error) {
            NSLog(@"%@",error);
            
            
        }];
        
        
    }else{
        
        //設定讚
        NSDictionary *params;
        if (self.isFromHeader) {
            params = @{@"uid":self.personUID,@"state":@1};
        } else {
            params = @{@"uid":self.model.uid,@"state":@1};
        }
        
        [WXDataService requestAFWithURL:Url_like params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    
                    self.isLike = YES;
//                    self.likeImge.image = [UIImage imageNamed:@"xinxing_h"];
//                    self.likeLabel.text = [NSString stringWithFormat:@"%d",[self.likeLabel.text intValue] +1];
                    
                    self.likeButton.selected = YES;
                    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",[self.likeButton.titleLabel.text intValue] +1] forState:UIControlStateNormal];
                    
                    long long idate = [[NSDate date] timeIntervalSince1970]* 1000;
                    
                    NSArray *contents = @[LXSring(@"帥氣的人都喜歡跟我視訊聊天！感覺你特別帥喔！"),LXSring(@"終於等到你！你再不出現，我都要發脾氣了～"),LXSring(@"讚我就是喜歡我，喜歡我就來跟我視訊聊天吧！"),LXSring(@"只點讚，不說話的人走路容易跌倒喔～"),LXSring(@"喜歡我吧？我也特別喜歡喜歡我的人呢！來視訊呀～")];
                    NSString *contentStr =  contents[rand() % 5];
                    NSDictionary *dic = @{@"message":@{@"messageID":[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate],
                                                       @"content":contentStr,
                                                       @"time":[NSString stringWithFormat:@"%lld",idate],
                                                       }};
                    
                    //显示自己的
                    //更新UI操作
                    
                    NSDictionary *mdic;
                    if (self.isFromHeader) {
                        mdic = @{@"account":self.personUID,@"msg":dic[@"message"]};
                    } else {
                        mdic = @{@"account":self.model.uid,@"msg":dic[@"message"]};
                    }
                    
                    
                    NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",self.model.uid,[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];
                    if (![MessageCount findFirstByCriteria:criteria]){
                        
                        MessageCount *count = [[MessageCount alloc] init];
                        count.content = [NSString stringWithFormat:@"%@",dic[@"message"][@"content"]];
                        count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                        if (self.isFromHeader) {
                            count.sendUid = self.personUID;
                        } else {
                            count.sendUid = self.model.uid;
                        }
                        
                        count.count = 0;
                        count.timeDate = idate;
                        [count save];
                        
                        Message *messageModel = [Message new];
                        messageModel.isSender = NO;
                        messageModel.isRead = YES;
                        messageModel.status = MessageDeliveryState_Delivered;
                        messageModel.date = [[NSString stringWithFormat:@"%@",dic[@"message"][@"time"]] longLongValue];
                        messageModel.type = MessageBodyType_Text;
                        messageModel.content = [NSString stringWithFormat:@"%@",dic[@"message"][@"content"]];
                        if (self.isFromHeader) {
                            messageModel.uid = self.personUID;
                            messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],self.personUID];
                        } else {
                            messageModel.uid = self.model.uid;
                            messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],self.model.uid];
                        }
                        
                        messageModel.messageID = [NSString stringWithFormat:@"%@",dic[@"message"][@"messageID"]];
                        messageModel.sendUid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                        
                        [messageModel save];
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_onMessageInstantReceive object:nil userInfo:mdic];
                        
                        NSString *nickName = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:NickName]];
                        //给主播发送的
                        NSString *content = [NSString stringWithFormat:LXSring(@"%@關注了你，可以主動跟他聊聊，或直接點擊下方“＋”發起通話喲！"),nickName];
                        NSDictionary *msg = @{@"message":@{
                                                      @"messageID":[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate],
                                                      @"content":content,
                                                      @"time":[NSString stringWithFormat:@"%lld",idate],
                                                      }};
                        NSString *msgStr = [InputCheck convertToJSONData:msg];
                        
                        AgoraAPI *_inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];
                        
                        NSDictionary *params;
                        if (self.isFromHeader) {
                            params = @{@"uid":self.personUID,@"message":content};
                        } else {
                            params = @{@"uid":self.model.uid,@"message":content};
                        }
                        
                        [WXDataService requestAFWithURL:Url_chatmessagesend params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
                            if ([[result objectForKey:@"result"] integerValue] == 0) {
                                [_inst messageInstantSend:self.model.uid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate]];
                                
                            }else if ([[result objectForKey:@"result"] integerValue] == 29) {
                                LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"成为VIP") message:result[@"message"] style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"取消") destructiveButtonTitle:LXSring(@"获取VIP") delegate:nil];
                                lg.destructiveButtonBackgroundColor = Color_nav;
                                lg.destructiveButtonTitleColor = UIColorFromRGB(0x00ddcc);
                                lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                                lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                                lg.cancelButtonTitleColor = UIColorFromRGB(0x333333);
                                lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                                    if ([LXUserDefaults boolForKey:ISMEiGUO]){
                                        AccountVC *vc = [[AccountVC alloc] init];
                                        [self.navigationController pushViewController:vc animated:YES];
                                        
                                    }else{
                                        NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
                                        if ([lang hasPrefix:@"id"]){
                                            AccountPayTypeVC *vc = [[AccountPayTypeVC alloc] init];
                                            [self.navigationController pushViewController:vc animated:YES];
                                            
                                        } else if ([lang hasPrefix:@"ar"]){
                                            AccountVC *vc = [[AccountVC alloc] init];
                                            [self.navigationController pushViewController:vc animated:YES];
                                        }
                                    }
                                    
                                    
                                };
                                [lg showAnimated:YES completionHandler:nil];
                            }else{
                                
                                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                    [SVProgressHUD dismiss];
                                });
                            }
                            
                            
                        } errorBlock:^(NSError *error) {
                            NSLog(@"%@",error);
                            
                        }];
                        LHChatVC *chatVC = [[LHChatVC alloc] init];
                        if (self.isFromHeader) {
                            chatVC.sendUid = self.personUID;
                        } else {
                            chatVC.sendUid = self.model.uid;
                        }
                        
//                        chatVC.personID = self.personUID;
//                        chatVC.isFromHeader = self.isFromHeader;
                        [self.navigationController pushViewController:chatVC animated:YES];
                        
                        
                    }
                    
                }else{    //请求失败
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                    });
                }
            }
            
        } errorBlock:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
        
    }




}

//影藏礼物
- (void)hideRenandGift
{
    
    if (self.giftsView.top != kScreenHeight) {
        
        
        [UIView animateWithDuration:.35 animations:^{
            
            _blackView.hidden = YES;
            self.giftsView.top = kScreenHeight;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}


-(SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:nil];
        [_cycleScrollView setPageControlAliment:SDCycleScrollViewPageContolAlimentRight];
        [_cycleScrollView setPageControlStyle:SDCycleScrollViewPageContolStyleAnimated];
        [_cycleScrollView setPageControlDotSize:CGSizeMake(6, 6)];
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.autoScrollTimeInterval = 5;
        [self.hederLunView insertSubview:_cycleScrollView atIndex:0];
    }
    return _cycleScrollView;
}

/** 点击图片回调banner */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
 
    NSMutableArray *images = [NSMutableArray array];
    for (Photo *model in self.pmodel.photos) {
        [images addObject:model.url];
    }
    // 加载网络图片
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < self.photos.count ;i++)
    {
        UIImageView *imageView = [self.view viewWithTag:i + 100];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = self.photos[i];// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:index];
    //    bvc.isEqualRatio = NO;// 大图小图不等比时需要設定这个属性（建议等比）
    [bvc showBrowseViewController];


}


- (void)_loadData
{
    
    NSDictionary *params;
    NSString *str = [LXUserDefaults objectForKey:itemNumber];
    if ([str isEqualToString:@"1"]) {
        if (self.isFromHeader) {
            params = @{@"uid":self.personUID};
        } else {
            params = @{@"uid":self.model.uid};
        }

    } else {
        if (self.isFromHeader) {
            params = @{@"uid":self.personUID};
        } else {
            params = @{@"uid":self.model.uid};
        }
//        params = @{@"uid":self.model.uid};
    }
    [WXDataService requestAFWithURL:Url_accountshow params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                self.headerVIew.height = kScreenWidth + 45 + 40;
                self.tableView.tableHeaderView = self.headerVIew;
           
                
                self.pmodel = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                
                self.nickNameLab.text = self.pmodel.nickname;
                self.idlabel.text = [NSString stringWithFormat:@"ID：%@",self.pmodel.uid];
                
                if (self.pmodel.like == 0) {
                    self.likeButton.selected = NO;
//                    self.likeImge.image = [UIImage imageNamed:@"xinxing_22"];
                    self.isLike = NO;
                    }else{
                    //已经点赞
                        self.likeButton.selected = YES;
//                        self.likeImge.image = [UIImage imageNamed:@"xinxing_h"];
                        self.isLike = YES;
                        
                        }
                [self.likeButton setTitle:[NSString stringWithFormat:@"%d",self.pmodel.likeCount] forState:UIControlStateNormal];
//                self.likeLabel.text = [NSString stringWithFormat:@"%d",self.pmodel.likeCount];
                if (self.pmodel.gender == 0) {
                
                    self.sexImage.image = [UIImage imageNamed:@"nansheng"];

                    //男
                }else{
                    
                    self.sexImage.image = [UIImage imageNamed:@"nvsheng"];
                
                }
                
                self.xizuoLabel.text = [InputCheck getXingzuo:[NSDate dateWithTimeIntervalSince1970:[_pmodel.birthday longLongValue] / 1000]];
              
                self.numbelLabel.text = [InputCheck dateToOld:[NSDate dateWithTimeIntervalSince1970:[_pmodel.birthday longLongValue] / 1000]];
                self.text = self.pmodel.nickname;
                
                Charge *charge;
                for (Charge *mo in self.pmodel.charges) {
                    if (mo.uid == self.pmodel.charge) {
                        charge = mo;
                    }
                }
                
                if ([LXUserDefaults boolForKey:ISMEiGUO]){
                    self.view3.hidden = YES;
                    
                }else{
                    self.feiyongLbael.text = charge.name;
                    if (self.feiyongLbael.text.length == 0) {
                        self.view3.hidden = YES;
                    } else {
                        self.view3.hidden = NO;
                    }
                }
                
                NSMutableArray *marray = [NSMutableArray array];
                for (Photo *photo in self.pmodel.photos) {
                    [self.photos addObject:photo.url];
                }
                if (marray.count == 0 && self.pmodel.portrait != nil) {
                    [self.photos addObject:self.pmodel.portrait];
                }
                self.cycleScrollView.imageURLStringsGroup = self.photos;
                
                self.messageArray = @[LXSring(@"最近活躍"),LXSring(@"地區"),LXSring(@"行业"),LXSring(@"簽名檔"),LXSring(@"经常出没")];
                self.messagePhotos = @[@"zuijinhuoyue",@"laizi",@"hangye",@"gexingqianming",@"jingchangchumo"];
                
                
                
                
                NSArray *array = [InputCheck getpreferOptions];
                NSString *str = [InputCheck handleActiveWith:self.pmodel.lastActiveAt];
                 NSString *str1 = [[CityTool sharedCityTool] getAdressWithCountrieId:self.model.country WithprovinceId:self.model.province WithcityId:self.model.city];
                NSString *str2;
                if (self.pmodel.intro.length == 0) {
                    str2 = @"";
                }else{
                 str2 = [NSString stringWithFormat:@"%@",self.pmodel.intro];
                }
                NSString *str4;
                if (self.pmodel.domain.length == 0) {
                    str4 = @"";
                }else{
                    str4 = [NSString stringWithFormat:@"%@",self.pmodel.intro];
                }
                 NSString *str3 = [NSString stringWithFormat:@"%@-%@",array[self.pmodel.preferOnlineOption],array[self.pmodel.preferOfflineOption]];
                
                self.contentArray = @[str,str1,str4,str2,str3];
                
                Present *present = self.pmodel.presents[0];
               
                
                [_tableView reloadData];
                
                if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
                    _tableViewBottom.constant = 0;
                    self.footerView.hidden = YES;
                }else{
                    _tableViewBottom.constant = 49;
                    self.footerView.hidden = NO;
                }

                
                
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

- (void)rightAction
{
    
    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setBool:YES forKey:@"ToEdit"];
        [self.navigationController popToRootViewControllerAnimated:NO];
//        [TJPTabBarController shareInstance].selectedIndex = 2;
//        return;
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:LXSring(@"舉報") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:nil message:LXSring(@"请选择舉報类型") preferredStyle:UIAlertControllerStyleActionSheet];
            
            NSString *nickName = self.pmodel.nickname;
            
            NSString *str = [NSString stringWithFormat:LXSring(@"你正在舉報%@"),nickName];
            NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str];
            [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color_Text_lightGray range:NSMakeRange(0, str.length - nickName.length)];
            [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(str.length - nickName.length, nickName.length)];
            [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str.length)];
            [alertController1 setValue:alertControllerStr forKey:@"_attributedTitle"];
            
            UIAlertAction *aletAction1 = [UIAlertAction actionWithTitle:LXSring(@"广告欺骗") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self jubaoWithtype:0];
                
            }];
            
            UIAlertAction *aletAction2 = [UIAlertAction actionWithTitle:LXSring(@"淫秽色情") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self jubaoWithtype:1];
                
            }];
            
            UIAlertAction *aletAction3 = [UIAlertAction actionWithTitle:LXSring(@"政治反动") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self jubaoWithtype:2];
                
            }];
            
            UIAlertAction *aletAction4 = [UIAlertAction actionWithTitle:LXSring(@"其他") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self jubaoWithtype:3];
                
            }];
            
            UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:LXSring(@"取消") style:UIAlertActionStyleCancel handler:nil];
            
            [cancelAction1 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
            [aletAction1 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
            [aletAction2 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
            [aletAction3 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
            [aletAction4 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
            
            [alertController1 addAction:aletAction1];
            [alertController1 addAction:aletAction2];
            [alertController1 addAction:aletAction3];
            [alertController1 addAction:aletAction4];
            [alertController1 addAction:cancelAction1];
            [self presentViewController:alertController1 animated:YES completion:nil];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LXSring(@"取消") style:UIAlertActionStyleCancel handler:nil];
        [cancelAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
        [defaultAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
        
        UIAlertAction *lahei = [UIAlertAction actionWithTitle:LXSring(@"拉黑") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            NSDictionary *params;
            if (self.isFromHeader) {
                params = @{@"uid":self.personUID};
            } else {
                params = @{@"uid":self.model.uid};
            }
            [WXDataService requestAFWithURL:Url_block params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
                if(result){
                    if ([[result objectForKey:@"result"] integerValue] == 0) {
                        
                        BlackName *name = [[BlackName alloc] init];
                        name.uid = self.model.uid;
                        [name save];
                        
                        [SVProgressHUD showSuccessWithStatus:LXSring(@"拉黑成功")];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                        
                        
                    } else{    //请求失败
                        [SVProgressHUD showErrorWithStatus:result[@"message"]];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                        });
                        
                    }
                }
                
            } errorBlock:^(NSError *error) {
                NSLog(@"%@",error);
                
                
            }];
            
            
            
        }];
        [lahei setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
        [alertController addAction:lahei];
        [alertController addAction:defaultAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    

}

- (void)jubaoWithtype:(int)type
{
    
    
    NSDictionary *params;
    if (self.isFromHeader) {
        params = @{@"uid":self.personUID,@"kind":[NSString stringWithFormat:@"%d",type]};
    } else {
        params = @{@"uid":self.model.uid,@"kind":[NSString stringWithFormat:@"%d",type]};
    }
    
    [WXDataService requestAFWithURL:Url_report params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                
                [SVProgressHUD showSuccessWithStatus:LXSring(@"舉報成功")];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
            } else{    //请求失败
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
    
    

}




- (IBAction)buttonAC:(UIButton *)sender {
    if (self.type == 0) {
        
        return;
    }
    [UIView animateWithDuration:.35 animations:^{
        
        self.sView.left = 2;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button2 setTitleColor:[MyColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        
    } completion:^(BOOL finished) {
        
        self.type = 0;
        [self.tableView reloadData];
        
    }];
    
    
}

- (IBAction)buttonACTwo:(UIButton *)sender {
    
    if (self.type == 1) {
        
        return;
    }
    [UIView animateWithDuration:.35 animations:^{
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button1 setTitleColor:[MyColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        
        self.sView.left = 2 + kScreenWidth / 2.0 - 15 - 2;
        
    } completion:^(BOOL finished) {
        self.type = 1;
        [self.tableView reloadData];

        
    }];
    
}


#pragma  mark --------UITableView Delegete----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == 0) {
        
        return self.messagePhotos.count;
        
    }else{
    
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 0) {
        if (indexPath.row == 3) {
            return [LxMessageCell whc_CellHeightForIndexPath:indexPath tableView:tableView];
        } else {
            return 50;
        }
        
        
    }else{
    
        if (self.pmodel.videos.count == 0) {
            
            return (kScreenWidth - 45) / 2 ;

        }else{
        
            return (kScreenWidth - 45) / 2 * (self.pmodel.videos.count / 2);

        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.type == 0) {
        
        LxMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxMessageCellID"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LxMessageCell" owner:self options:nil] firstObject];
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.contlabel.text = self.contentArray[indexPath.row];
        cell.heaImage.image = [UIImage imageNamed:self.messagePhotos[indexPath.row]];
        cell.nameLabel.text = self.messageArray[indexPath.row];
        return cell;
    }else{
        LxVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxVideoTableViewCellID"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LxVideoTableViewCell" owner:self options:nil] firstObject];
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.dataList = self.pmodel.videos;
        cell.vc = self;
        cell.model = self.pmodel;
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        
        return;
    }
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            // 圆角弧度半径
            CGFloat cornerRadius = 5.f;
            // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
            cell.backgroundColor = UIColor.clearColor;
            
            // 创建一个shapeLayer
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
            // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
            CGMutablePathRef pathRef = CGPathCreateMutable();
            // 获取cell的size
            CGRect bounds = CGRectInset(cell.bounds, 15, 0);
            
            // CGRectGetMinY：返回对象顶点坐标
            // CGRectGetMaxY：返回对象底点坐标
            // CGRectGetMinX：返回对象左边缘坐标
            // CGRectGetMaxX：返回对象右边缘坐标
            
            // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
            BOOL addLine = NO;
            // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            if (indexPath.row == 0) {
                // 初始起点为cell的左下角坐标
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                // 起始坐标为左下角，设为p1，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                // 初始起点为cell的左上角坐标
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                // 添加cell的rectangle信息到path中（不包括圆角）
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
            layer.path = pathRef;
            backgroundLayer.path = pathRef;
            // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
            CFRelease(pathRef);
            // 按照shape layer的path填充颜色，类似于渲染render
            // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            layer.fillColor = [UIColor whiteColor].CGColor;
            // 添加分隔线图层
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 52, bounds.size.height-lineHeight, bounds.size.width - 70, lineHeight);
                // 分隔线颜色取自于原来tableview的分隔线颜色
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            
            // view大小与cell一致
            UIView *roundView = [[UIView alloc] initWithFrame:bounds];
            // 添加自定义圆角后的图层到roundView中
            [roundView.layer insertSublayer:layer atIndex:0];
            roundView.backgroundColor = UIColor.clearColor;
            //cell的背景view
            //cell.selectedBackgroundView = roundView;
            cell.backgroundView = roundView;
            
            //以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
            UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
            backgroundLayer.fillColor = tableView.separatorColor.CGColor;
            [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
            selectedBackgroundView.backgroundColor = UIColor.clearColor;
            cell.selectedBackgroundView = selectedBackgroundView;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)videoAC:(id)sender {
    
    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"不能给自己打电话。") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([AppDelegate shareAppDelegate].netStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"当前网络不可用，请检查您的网络設定") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (self.pmodel.state == 2) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"当前用户正在忙碌") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    AppDelegate *app = [AppDelegate shareAppDelegate];
    if(![app.inst isOnline]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"您正处于离线状态") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self videoCallAC];

}

- (void)videoCallAC
{
    NSDictionary *params;
    if (self.isFromHeader) {
        params = @{@"uid":self.personUID};
    } else {
        params = @{@"uid":self.model.uid};
    }
    
    [WXDataService requestAFWithURL:Url_chatvideocall params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSString *channel = [NSString stringWithFormat:@"%@",result[@"data"][@"channel"]];
                if (self.isFromHeader) {
                    VideoCallView *video = [[VideoCallView alloc] initVideoCallViewWithChancel:channel withUid:self.personUID withIsSend:YES];
                    [video show];
                } else {
                    VideoCallView *video = [[VideoCallView alloc] initVideoCallViewWithChancel:channel withUid:self.model.uid withIsSend:YES];
                    [video show];
                }
                
                
                
            }else{    //请求失败
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    
                    if ([[result objectForKey:@"result"] integerValue] == 8) {
                        
                        LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"购买鑽石") message:LXSring(@"亲，你的鑽石不足，儲值才能继续視訊通话，是否购买鑽石？") style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"取消") destructiveButtonTitle:LXSring(@"快速购买") delegate:nil];
                        
                        lg.destructiveButtonBackgroundColor = Color_nav;
                        lg.destructiveButtonTitleColor = UIColorFromRGB(0x00ddcc);
                        lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                        lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                        lg.cancelButtonTitleColor = UIColorFromRGB(0x333333);
                        lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                            if ([LXUserDefaults boolForKey:ISMEiGUO]){
                                AccountVC *vc = [[AccountVC alloc] init];
                                [self.navigationController pushViewController:vc animated:YES];
                                
                            }else{
                                NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
                                if ([lang hasPrefix:@"id"]){
                                    AccountPayTypeVC *vc = [[AccountPayTypeVC alloc] init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                    
                                } else if ([lang hasPrefix:@"ar"]){
                                    AccountVC *vc = [[AccountVC alloc] init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }
                            
                        };
                        [lg showAnimated:YES completionHandler:nil];
                        
                        
                    }
                    
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
    }];
    
}


- (IBAction)chatAC:(id)sender {
    
    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"不能与自己聊天。") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    LHChatVC *chatVC = [[LHChatVC alloc] init];
    if (self.isFromHeader) {
        chatVC.sendUid = self.personUID;
    } else {
        chatVC.sendUid = self.model.uid;
    }
//    chatVC.sendUid = self.model.uid;
//    chatVC.personID = self.personUID;
//    chatVC.isFromHeader = self.isFromHeader;
    [self.navigationController pushViewController:chatVC animated:YES];

}

- (IBAction)giftAC:(id)sender {
    
    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"不能给自己送禮物。") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
        RepetitionCount *re = [RepetitionCount sharedRepetition];
        long long idate = [[NSDate date] timeIntervalSince1970]*1000;
        long long oldDate = [[NSString stringWithFormat:@"%@",re.mdic[self.personUID]] longLongValue];
        if (idate - oldDate < 60 * 1000) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"發送太頻繁，會嚇走金主的~") delegate:nil cancelButtonTitle:LXSring(@"好的") otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [self sendMessageToUserType:MessageBodyType_Gift name:LXSring(@"送禮") types:@"gift"];
            [re.mdic setObject:@(idate) forKey:self.personUID];
        }
        
    } else {
        
        [self newgiftView];
        [self _loadData1];
        self.giftsView.pmodel = self.pmodel;
        self.giftsView.isVideoBool = NO;
        [UIView animateWithDuration:.35 animations:^{
            _blackView.hidden = NO;
            self.giftsView.top = kScreenHeight - 300;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

#pragma mark - 获取用户钻石数量
- (void)_loadData1
{
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSString *deposit = [NSString stringWithFormat:@"%@",result[@"data"][@"deposit"]];
                NSString *str = [NSString stringWithFormat:LXSring(@"余额:%@鑽"),deposit];
                //                NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:str];
                //                [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(3, deposit.length)];
                //                [self newgiftView];
                self.giftsView.elabel.text = str;
                NSLog(@"%@", self.giftsView.elabel.text);
            } else{
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
            }
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}


- (void)newgiftView{
    
    if (self.giftsView == nil) {
        
        self.giftsView = [[GiftsView alloc] initGiftsView];
    }
    
    [self.view addSubview:self.giftsView];
    
}

- (void)sendMessageToUserType:(MessageBodyType)type name:(NSString *)name types:(NSString *)types {
    NSString *message = @"";
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"zh-Hant"]) {
        message = [NSString stringWithFormat:LXSring(@"已對%@發送了%@提示~"), _pmodel.nickname, name];
    }else if ([lang hasPrefix:@"id"]){
        message = [NSString stringWithFormat:LXSring(@"已對%@發送了%@提示~"), name, _pmodel.nickname];
    }else{
        message = [NSString stringWithFormat:LXSring(@"已對%@發送了%@提示~"), _pmodel.nickname, name];
    }
    long long idate = [[NSDate date] timeIntervalSince1970]*1000;
    __block Message *messageModel = [Message new];
    messageModel.isSender = YES;
    messageModel.isRead = NO;
    messageModel.status = MessageDeliveryState_Delivering;
    messageModel.date = idate;
    messageModel.messageID = [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate];
    messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],self.personUID];
    messageModel.type = type;
    messageModel.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    messageModel.sendUid = self.personUID;
    messageModel.content = message;
       
    NSDictionary *params;
    if (type == MessageBodyType_Gift) {
        params = @{@"uid":self.personUID, @"message":message, @"type":@1};
        
    }else if(type == MessageBodyType_ChongZhi){
        params = @{@"uid":self.personUID, @"message":message, @"type":@2};
        
    }
    [WXDataService requestAFWithURL:Url_chatmessagesend params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO  finishBlock:^(id result) {
        if ([[result objectForKey:@"result"] integerValue] == 0) {
            [messageModel save];
            NSString *time = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",messageModel.date]];
            if (![time isEqualToString:self.lastTime]) {
                //                [self insertNewMessageOrTime:time];
                self.lastTime = time;
            }
            //            NSIndexPath *index = [self insertNewMessageOrTime:messageModel];
            [self.messages addObject:messageModel];
            //            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            NSDictionary *dic = @{
                                  @"message": @{
                                          @"messageID": messageModel.messageID,
                                          @"event": types,
                                          @"content": @"",
                                          @"request": @"-2",
                                          @"time": [NSString stringWithFormat:@"%lld",idate]
                                          }
                                  };
            
            NSString *msgStr = [InputCheck convertToJSONData:dic];
            [_inst messageInstantSend:self.personUID uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate]];
            NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",self.personUID,[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];
            if (![MessageCount findFirstByCriteria:criteria]){
                
                MessageCount *count = [[MessageCount alloc] init];
                count.content = message;
                count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                count.sendUid = self.personUID;
                count.count = 0;
                count.timeDate = idate;
                [count save];
                
            }else{
                
                _count.content = message;
                _count.timeDate = messageModel.date;
                _count.count = 0;
                [_count saveOrUpdate];
                
            }
            
            
            
        }else{
            if ([[result objectForKey:@"result"] integerValue] == 31) {
                LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"提示") message:result[@"message"] style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"好的") destructiveButtonTitle:nil delegate:nil];
                lg.destructiveButtonBackgroundColor = Color_nav;
                lg.destructiveButtonTitleColor = UIColorFromRGB(0x00ddcc);
                lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                lg.cancelButtonTitleColor = UIColorFromRGB(0x333333);
                [lg showAnimated:YES completionHandler:nil];
                
            }else if ([[result objectForKey:@"result"] integerValue] == 30) {
                LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"提示") message:result[@"message"] style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"好的") destructiveButtonTitle:nil delegate:nil];
                lg.destructiveButtonBackgroundColor = Color_nav;
                lg.destructiveButtonTitleColor = UIColorFromRGB(0x00ddcc);
                lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                lg.cancelButtonTitleColor = UIColorFromRGB(0x333333);
                [lg showAnimated:YES completionHandler:nil];
                
            }else{
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
            
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
}

- (IBAction)chongzhiAC:(id)sender {
    
    if ([[LXUserDefaults objectForKey:itemNumber] isEqualToString:@"1"]) {
        RechargeCount *re = [RechargeCount sharedRecharge];
        long long idate = [[NSDate date] timeIntervalSince1970]*1000;
        long long oldDate = [[NSString stringWithFormat:@"%@",re.mdic[self.personUID]] longLongValue];
        if (idate - oldDate < 60 * 1000) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"發送太頻繁，會嚇走金主的~") delegate:nil cancelButtonTitle:LXSring(@"好的") otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [self sendMessageToUserType:MessageBodyType_ChongZhi name:LXSring(@"儲值") types:@"recharge"];
            [re.mdic setObject:@(idate) forKey:self.personUID];
        }
        
    } else {
        if ([LXUserDefaults boolForKey:ISMEiGUO]){
            AccountVC *vc = [[AccountVC alloc] init];
            vc.isCall = NO;
            vc.orderReferee = self.model.uid;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
            if ([lang hasPrefix:@"id"]){
                
                AccountPayTypeVC *vc = [[AccountPayTypeVC alloc] init];
                vc.isCall = NO;
                vc.orderReferee = self.model.uid;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else if ([lang hasPrefix:@"ar"]){
                AccountVC *vc = [[AccountVC alloc] init];
                vc.isCall = NO;
                vc.orderReferee = self.model.uid;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }

}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = @[].mutableCopy;
    }
    return _messages;
}

- (IBAction)likeButtonAC:(id)sender {
    [self like];
}
@end
