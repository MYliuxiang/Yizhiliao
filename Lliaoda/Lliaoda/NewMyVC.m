//
//  NewMyVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "NewMyVC.h"
#import "AccountPayTypeVC.h"
@interface NewMyVC ()

@end

@implementation NewMyVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headerView.height = 225 + 55;
    self.nav.hidden = YES;
    self.seltedView.layer.cornerRadius = 5;
    self.seltedView.layer.masksToBounds = YES;
    
    MEntrance *rance = [[MEntrance alloc] initWithVC:self withimageName:@"xiaoxi_bai" withBageColor:Color_nav];
    [self.headerView addSubview:rance];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    self.nameArray = [NSMutableArray array];
    self.messagePhotos = [NSMutableArray array];
    self.contents = [NSMutableArray array];
    
    self.videoArrays = [NSMutableArray array];
    self.photoArrays = [NSMutableArray array];
    
    self.cellType = MyTypePhoto;
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenWidth - 30) / 69 * 15 - 4, 50, 4)];
    self.lineView.left = ((kScreenWidth - 30) / 3 - 50)/2;
    self.lineView.backgroundColor = Color_Tab;
    [self.seltedView addSubview:self.lineView];
    
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    //必须给effcetView的frame赋值,因为UIVisualEffectView是一个加到UIIamgeView上的子视图.
    effectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth / 750 * 450);
//    [self.backImage addSubview:effectView];
    
    self.headerImage.layer.cornerRadius = 40;
    self.headerImage.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *headImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageAC)];
    [self.headerImage addGestureRecognizer:headImage];
    
    
    LxCache *cahce = [LxCache sharedLxCache];
    NSString *cacheKey = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSDictionary *dic = [cahce getCacheDataWithKey:cacheKey];
    if (dic != nil) {
        self.ishud = NO;
        self.model = [Mymodel mj_objectWithKeyValues:dic[@"data"]];
        
        self.nickLabel.text = self.model.nickname;
        
        self.idLabel.text = [NSString stringWithFormat:LXSring(@"聊號：%@"),self.model.uid];
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
//        [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
//        self.cellType = MyTypeVideo;

        [self setArrayForTable];
        
        self.tableView.tableHeaderView = self.headerView;

    }else{
        
        self.ishud = YES;
        
    }
  
    [self _loadData1];

}

- (void)_loadPhotoData
{
    NSDictionary *params;
    params = @{@"type":@"photo"};
    [WXDataService requestAFWithURL:Url_accountmedia params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                [self.photoArrays removeAllObjects];
                NSArray *array = result[@"data"];
                for (NSDictionary *dic in array) {
                    AlbumModel *model = [AlbumModel mj_objectWithKeyValues:dic];
                    [self.photoArrays addObject:model];
                }
//                self.reloadData(self.dataList);
//                [self.collectionView reloadData];
                [self.tableView reloadData];
                
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


- (void)_loadVideoData
{
    NSDictionary *params;
    params = @{@"type":@"video"};
    [WXDataService requestAFWithURL:Url_accountmedia params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSArray *array = result[@"data"];
                for (NSDictionary *dic in array) {
                    MyVideoModel *model = [MyVideoModel mj_objectWithKeyValues:dic];
                    [self.videoArrays addObject:model];
                }
                
                [self.tableView reloadData];

                
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

- (void)setHeaderVIew {
    if (self.model.auth == 2) {
        // 已認證
        self.sqrzButton.backgroundColor = [UIColor clearColor];
        [self.sqrzButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sqrzButton.layer.cornerRadius = 5;
        self.sqrzButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.sqrzButton.layer.borderWidth = 2;
        [self.sqrzButton setTitle:@"認證成功" forState:UIControlStateNormal];
        self.sqrzButton.userInteractionEnabled = YES;
        
        
    } else if (self.model.auth == 1) {
        // 認證中
        self.sqrzButton.backgroundColor = [UIColor clearColor];
        [self.sqrzButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sqrzButton.layer.cornerRadius = 5;
        self.sqrzButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.sqrzButton.layer.borderWidth = 1;
        [self.sqrzButton setTitle:@"認證中" forState:UIControlStateNormal];
        self.sqrzButton.userInteractionEnabled = NO;
        
    } else {
        // 申請認證
        self.sqrzButton.backgroundColor = UIColorFromRGB(0xf7db00);
        [self.sqrzButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        self.sqrzButton.layer.cornerRadius = 5;
        self.sqrzButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.sqrzButton.layer.borderWidth = 0;
        [self.sqrzButton setTitle:@"申請認證" forState:UIControlStateNormal];
        self.sqrzButton.userInteractionEnabled = YES;
    }
    
    NSDate *date = [NSDate date];
    long timeInt = [date timeIntervalSince1970] * 1000;
    NSInteger times = (timeInt - self.model.birthday) / 1000;
    NSInteger birthday = times / 3600 / 24 / 365;
    _ageLabel.text = [NSString stringWithFormat:@"%ld", (long)birthday];
    
    _constellationsLabel.text = [InputCheck getXingzuo:[NSDate dateWithTimeIntervalSince1970:self.model.birthday / 1000]];
 
    _addressLabel.text = [[CityTool sharedCityTool] getCityWithCountrieId:self.model.country WithprovinceId:self.model.province WithcityId:self.model.city];
}

- (void)headImageAC {
//    SetHeaderImageVC *vc = [[SetHeaderImageVC alloc] init];
//    vc.portrait = self.model.portrait;
//    [self.navigationController pushViewController:vc animated:YES];
    
    FixpersonalVC *vc = [[FixpersonalVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setArrayForTable
{

    [self.nameArray removeAllObjects];
    [self.messagePhotos removeAllObjects];
    
    if([LXUserDefaults boolForKey:ISMEiGUO]){
        
        if (self.model.auth == 2) {
            [self.nameArray addObject:@[@"常在線時間"]];
            [self.messagePhotos addObject:@[@"shijian"]];
        }
        
        [self.nameArray addObject:@[@"鑽石"]];
        [self.messagePhotos addObject:@[@"zuanshi"]];
        
        [self.nameArray addObject:@[@"關於我們", @"建議與反饋"]];

        [self.messagePhotos addObject:@[@"guanyu", @"fankui"]];
        
        
    }else{
        if (self.model.auth == 2) {
            [self.nameArray addObject:@[@"常在線時間"]];
            [self.messagePhotos addObject:@[@"shijian"]];
            
            if (self.model.activated == 0) {
                [self.nameArray addObject:@[@"語音聊天收費",@"視頻聊天收費",@"邀請有獎",@"接受邀请"]];
                [self.messagePhotos addObject:@[@"yuyin",@"shipin",@"yaoqing",@"yaoqingmaduihuan"]];
                
            }else{
                [self.nameArray addObject:@[@"語音聊天收費",@"視頻聊天收費",@"邀請有獎"]];
                [self.messagePhotos addObject:@[@"yuyin",@"shipin",@"yaoqing"]];
            }
            
            [self.nameArray addObject:@[@"鑽石", @"收益"]];
            [self.messagePhotos addObject:@[@"zuanshi",@"shouyi"]];
            
        }else{
            
            if (self.model.activated == 0) {
                [self.nameArray addObject:@[@"邀請有獎",@"接受邀请"]];
                [self.messagePhotos addObject:@[@"yaoqing",@"jieshouyaoqing"]];
            }else{
                [self.nameArray addObject:@[@"邀請有獎"]];
                [self.messagePhotos addObject:@[@"yaoqing"]];
            }
            
            [self.nameArray addObject:@[@"鑽石"]];
            [self.messagePhotos addObject:@[@"zuanshi"]];
        }
        
        [self.nameArray addObject:@[@"關於我們", @"建議與反饋"]];
        [self.messagePhotos addObject:@[@"guanyu", @"fankui"]];
        
        [self.nameArray addObject:@[@"設置"]];
        [self.messagePhotos addObject:@[@"shezhi"]];
    }
    [_tableView reloadData];
}

- (void)_loadData1
{
    
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:self.ishud isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                self.model = [Mymodel mj_objectWithKeyValues:result[@"data"]];
                self.tableView.tableHeaderView = self.headerView;

                LxCache *lxcache = [LxCache sharedLxCache];
                NSString *cacheKey = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                [lxcache setCacheData:result WithKey:cacheKey];
                
                
                self.nickLabel.text = self.model.nickname;
                self.idLabel.text = [NSString stringWithFormat:LXSring(@"聊號：%@"),self.model.uid];
                [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];                
//                [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
//                self.cellType = MyTypeVideo;

                [self setArrayForTable];
                
                
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nickLabel.text = self.model.nickname;
    
    [self.videoArrays removeAllObjects];
    [self.photoArrays removeAllObjects];
    
    [self _loadData];
    [self _loadPhotoData];
    
    [self _loadVideoData];
    [self.tableView reloadData];
    
    
}

- (void)_loadData
{
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                self.model = [Mymodel mj_objectWithKeyValues:result[@"data"]];
                self.tableView.tableHeaderView = self.headerView;
                
                LxCache *lxcache = [LxCache sharedLxCache];
                NSString *cacheKey = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                [lxcache setCacheData:result WithKey:cacheKey];
                
                self.unDisturbButton.selected = self.model.isDND;
                self.nickLabel.text = self.model.nickname;
                self.idLabel.text = [NSString stringWithFormat:@"ID：%@",self.model.uid];
                [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
                _upCountLabel.text = [NSString stringWithFormat:@"%d", self.model.likeCount];
//                [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
//                if (self.model.auth == 2) {
//                    _zanBgView.hidden = NO;
//                    _upCountLabel.text = [NSString stringWithFormat:@"%d", self.model.likeCount];
//                } else {
//                    _zanBgView.hidden = YES;
//                }
                
                [self setArrayForTable];
                [self setHeaderVIew];
                [self.tableView reloadData];

                
                
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



#pragma  mark --------UITableView Delegete----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.nameArray.count + 1;
//    if(self.cellType == MyTypeMessage){
//         return self.nameArray.count + 1;
//    }else if(self.cellType == MyTypeError){
//        return 0;
//
//    }else{
//
//        return 1;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        NSArray *array = self.nameArray[section - 1];
        return array.count;
    }
    
//    if(self.cellType == MyTypeMessage){
//        NSArray *array = self.nameArray[section];
//        return array.count;
//    }else if(self.cellType == MyTypeError){
//        return 0;
//
//    }else{
//        return 1;
//
//    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.cellType == MyTypeVideo) {
            NewMyVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMyVideoCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NewMyVideoCell" owner:self options:nil] lastObject];
            }
            cell.delegate = self;
            [cell.playButton1 setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
            [cell.playButton2 setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
            [cell.playButton3 setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
            [cell.playButton4 setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];

            for (int i = 0; i < self.videoArrays.count; i++) {
                MyVideoModel *model = self.videoArrays[i];
                switch (i) {
                    case 0:
                        [cell.playButton1 setImage:[UIImage imageNamed:@"dashipin"] forState:UIControlStateNormal];
                        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                        break;
                    case 1:
                        [cell.playButton2 setImage:[UIImage imageNamed:@"dashipin"] forState:UIControlStateNormal];
                        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                        break;
                    case 2:
                        [cell.playButton3 setImage:[UIImage imageNamed:@"dashipin"] forState:UIControlStateNormal];
                        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                        break;
                    case 3:
                        [cell.playButton4 setImage:[UIImage imageNamed:@"dashipin"] forState:UIControlStateNormal];
                        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                        break;
                        
                    default:
                        break;
                }
            }
            [cell.addButton addTarget:self action:@selector(toVideo) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        } else if (self.cellType == MyTypePhoto) {
            NewMyalbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMyalbumCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NewMyalbumCell" owner:self options:nil] lastObject];
            }
            cell.delegate = self;
            cell.imageView1.image = [UIImage imageNamed:@"jiahao"];
            cell.imageView2.image = [UIImage imageNamed:@"jiahao"];
            cell.imageView3.image = [UIImage imageNamed:@"jiahao"];
            cell.imageView4.image = [UIImage imageNamed:@"jiahao"];
            for (int i = 0; i < self.photoArrays.count; i++) {
                AlbumModel *model = self.photoArrays[i];
                switch (i) {
                    case 0:
                        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:model.url]];
                        break;
                    case 1:
                        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:model.url]];
                        break;
                    case 2:
                        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:model.url]];
                        break;
                    case 3:
                        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:model.url]];
                        break;
                        
                    default:
                        break;
                }
            }
            [cell.addButton addTarget:self action:@selector(toAlbum) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
    NewMyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMyCellID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewMyCell" owner:self options:nil] firstObject];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.delegate = self;
    NSArray *array = self.nameArray[indexPath.section - 1];
    if (indexPath.row == array.count - 1) {
        cell.bottomLineView.hidden = YES;
    } else {
        cell.bottomLineView.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accountBGView.hidden = YES;
    cell.nameLabel.text = self.nameArray[indexPath.section - 1][indexPath.row];
    cell.headerImage.image = [UIImage imageNamed:self.messagePhotos[indexPath.section - 1][indexPath.row]];
    cell.accountBGView.layer.cornerRadius = 5;
    if ([LXUserDefaults boolForKey:ISMEiGUO]) {
        if (self.model.auth == 2) {
            // 主播
            if (indexPath.section == 1) {
                // 常在線時間
                cell.contentLabel.textColor = [MyColor colorWithHexString:@"#666666"];
                NSArray *array = [InputCheck getpreferOptions];
                cell.contentLabel.text = [NSString stringWithFormat:@"%@-%@",array[self.model.preferOnlineOption],array[self.model.preferOfflineOption]];
                cell.samallImage.hidden = YES;
            } else if (indexPath.section == 2) {
                cell.samallImage.hidden = YES;
                cell.contentLabel.textColor = [MyColor colorWithHexString:@"#666666"];
                if (indexPath.section == 2) {
                    cell.contentLabel.text = @"";
                    cell.accountBGView.hidden = NO;
                    cell.accountLabel.text = [NSString stringWithFormat:@"%d鑽石",self.model.deposit];
                    [cell.accountButton setTitle:@"充值" forState:UIControlStateNormal];
                    cell.accountButton.layer.cornerRadius = 5;
                    
                }
            }
            
        } else {
            if (indexPath.section == 1) {
                cell.samallImage.hidden = YES;
                cell.contentLabel.textColor = [MyColor colorWithHexString:@"#666666"];
                if (indexPath.section == 2) {
                    cell.contentLabel.text = @"";
                    cell.accountBGView.hidden = NO;
                    cell.accountLabel.text = [NSString stringWithFormat:@"%d鑽石",self.model.deposit];
                    [cell.accountButton setTitle:@"充值" forState:UIControlStateNormal];
                    cell.accountButton.layer.cornerRadius = 5;
                }
            }
        }
    } else {
        if (self.model.auth == 2) {
            if (indexPath.section == 1) {
                // 常在線時間
                cell.contentLabel.textColor = [MyColor colorWithHexString:@"#666666"];
                NSArray *array = [InputCheck getpreferOptions];
                cell.contentLabel.text = [NSString stringWithFormat:@"%@-%@",array[self.model.preferOnlineOption],array[self.model.preferOfflineOption]];
                cell.samallImage.hidden = YES;
                
            } else if (indexPath.section == 2) {
                if (indexPath.row == 0) {
                    cell.samallImage.hidden = NO;
                    Charge *charge;
                    for (Charge *mo in self.model.charges) {
                        if (mo.uid == self.model.chargeAudio) {
                            charge = mo;
                        }
                    }
                    cell.contentLabel.text = charge.name;
                    
                } else if (indexPath.row == 1) {
                    cell.samallImage.hidden = NO;
                    Charge *charge;
                    for (Charge *mo in self.model.charges) {
                        if (mo.uid == self.model.charge) {
                            charge = mo;
                        }
                    }
                    cell.contentLabel.text = charge.name;
                    
                } else if (indexPath.row == 2) {
                    cell.samallImage.hidden = YES;
                    cell.contentLabel.text = @"邀請好友, 立刻獲得獎勵";
                    
                } else {
                    if (self.model.activated == 0) {
                        cell.samallImage.hidden = YES;
                        cell.contentLabel.text = @"填入邀請碼，獲得獎勵";
                    }
                }
            } else if (indexPath.section == 3) {
                if (indexPath.row == 0) {
                    cell.samallImage.hidden = YES;
                    cell.contentLabel.text = @"";
                    cell.accountBGView.hidden = NO;
                    cell.accountLabel.text = [NSString stringWithFormat:@"%d鑽石",self.model.deposit];
                    [cell.accountButton setTitle:@"充值" forState:UIControlStateNormal];
                    cell.accountButton.layer.cornerRadius = 5;
                    
                } else {
                    cell.samallImage.hidden = YES;
                    cell.contentLabel.text = @"";
                    cell.accountBGView.hidden = NO;
                    cell.accountLabel.text = [NSString stringWithFormat:@"%d聊幣",self.model.income];
                    [cell.accountButton setTitle:@"提現" forState:UIControlStateNormal];
                    cell.accountButton.layer.cornerRadius = 5;
                }
            } else {
                cell.samallImage.hidden = YES;
                cell.contentLabel.text = @"";
            }
        } else {
            // 未認證
            if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    cell.samallImage.hidden = YES;
                    cell.contentLabel.text = @"邀請好友, 立刻獲得獎勵";
                } else {
                    cell.samallImage.hidden = YES;
                    cell.contentLabel.text = @"填入邀請碼，獲得獎勵";
                }
            } else if (indexPath.section == 2) {
                cell.samallImage.hidden = YES;
                cell.contentLabel.text = @"";
                cell.accountBGView.hidden = NO;
                cell.accountLabel.text = [NSString stringWithFormat:@"%d鑽石",self.model.deposit];
                [cell.accountButton setTitle:@"充值" forState:UIControlStateNormal];
                cell.accountButton.layer.cornerRadius = 5;
                
            } else if (indexPath.section == 3) {
                cell.samallImage.hidden = YES;
                
            } else {
                cell.samallImage.hidden = YES;
                cell.contentLabel.text = @"";
            }
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return (kScreenWidth - 30) / 2 + 15;
    } else {
        return 60;
    }
    
    
//    if (self.cellType == MyTypeMessage) {
//
//        return 50;
//    }else if (self.cellType == MyTypeVideo){
//
//        return (self.videoDataList.count + 2) / 2 * (((kScreenWidth - 45) / 2.0 - 1) + 15);
//
//    }else{
//    return (self.photoDataList.count + 3) / 3 *  ((kScreenWidth - 60) / 3.0 - 1 + 15);
//
//    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 15;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        if (self.cellType == PhotoType) {
//            MyalbumVC *vc = [[MyalbumVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//
//        } else if (self.cellType == VideoType) {
//            MyVideoVC *vc = [[MyVideoVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }
//    }
    if ([LXUserDefaults boolForKey:ISMEiGUO]) {
        if (self.model.auth == 2) {
            if (indexPath.section == 1) {
                // 常在線時間
                [self crpickerBG];
                [UIView animateWithDuration:0.33 animations:^{
                    self.pickerBG.frame = CGRectMake(0, kScreenHeight - 266, kScreenWidth, 266);
                    self.maskView.hidden = NO;
                } completion:^(BOOL finished) {
                    
                }];
            } else if (indexPath.section == 2) {
                // 鑽石餘額
//                AccountVC *vc = [[AccountVC alloc] init];
//                vc.deposit = self.model.deposit;
//                [self.navigationController pushViewController:vc animated:YES];
                
            } else if (indexPath.section == 3) {
                
                if (indexPath.row == 0) {
                    // 關於
                    AboutVC *vc = [[AboutVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    // 建議
                }
            }
        } else {
            if (indexPath.section == 1) {
                // 鑽石餘額
//                AccountVC *vc = [[AccountVC alloc] init];
//                vc.deposit = self.model.deposit;
//                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.row == 2) {
                if (indexPath.row == 0) {
                    // 關於
                    AboutVC *vc = [[AboutVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    // 建議
                    SuggestFeedbackVC *vc = [[SuggestFeedbackVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                // 設置
                SettingVC *vc = [[SettingVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    } else {
        if (self.model.auth == 2) {
            // 主播
            if (indexPath.section == 1) {
                // 常在線時間
                [self crpickerBG];
                [UIView animateWithDuration:0.33 animations:^{
                    self.pickerBG.frame = CGRectMake(0, kScreenHeight - 266, kScreenWidth, 266);
                    self.maskView.hidden = NO;
                } completion:^(BOOL finished) {
                    
                }];
            } else if (indexPath.section == 2) {
                if (indexPath.row == 0) {
                    // 語音收费设置
                    SetPriceVC *vc = [[SetPriceVC alloc] init];
                    vc.model = self.model;
                    vc.type = ChatTypeAudio;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 1) {
                    // 视频收费设置
                    SetPriceVC *vc = [[SetPriceVC alloc] init];
                    vc.type = ChatTypeVideo;
                    vc.model = self.model;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 2) {
                    // 邀请有奖
                    InvitationVC *vc = [[InvitationVC alloc] init];
                    vc.model = self.model;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    // 接受邀请
                    AcceptVC *vc = [[AcceptVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            } else if (indexPath.section == 3) {
                if (indexPath.row == 0) {
                    // 钻石
//                    AccountVC *vc = [[AccountVC alloc] init];
//                    vc.deposit = self.model.deposit;
//                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    // 收益
//                    ProfitVC *vc = [[ProfitVC alloc] init];
//                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else if (indexPath.section == 4) {
                if (indexPath.row == 0) {
                    // 关于
                    AboutVC *vc = [[AboutVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    // 建議
                    SuggestFeedbackVC *vc = [[SuggestFeedbackVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                // 設置
                SettingVC *vc = [[SettingVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            // 用戶
            if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    // 邀請有獎
                    InvitationVC *vc = [[InvitationVC alloc] init];
                    vc.model = self.model;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    // 接受邀請
                    AcceptVC *vc = [[AcceptVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else if (indexPath.section == 2) {
                // 鑽石
//                AccountVC *vc = [[AccountVC alloc] init];
//                vc.deposit = self.model.deposit;
//                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.section == 3) {
                if (indexPath.row == 0) {
                    // 關於
                    AboutVC *vc = [[AboutVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    // 建議
                    SuggestFeedbackVC *vc = [[SuggestFeedbackVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                // 設置
                SettingVC *vc = [[SettingVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    
    
    
//    if (indexPath.section == 0) {
//
//        if (indexPath.row == 0) {
//            //账户
//
//            if ([LXUserDefaults boolForKey:ISMEiGUO]){
//                AccountVC *vc = [[AccountVC alloc] init];
//                vc.deposit = self.model.deposit;
//                [self.navigationController pushViewController:vc animated:YES];
//
//            }else{
//                NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
//                if ([lang hasPrefix:@"id"]){
//                    AccountPayTypeVC *vc = [[AccountPayTypeVC alloc] init];
//                    vc.deposit = self.model.deposit;
//                    [self.navigationController pushViewController:vc animated:YES];
//
//                } else if ([lang hasPrefix:@"ar"]){
//                    AccountVC *vc = [[AccountVC alloc] init];
//                    vc.deposit = self.model.deposit;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//            }
//
////            AccountVC *vc = [[AccountVC alloc] init];
////            vc.deposit = self.model.deposit;
////            [self.navigationController pushViewController:vc animated:YES];
//
//        }else{
//           //收入
//            ProfitVC *vc = [[ProfitVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }else{
//
//
//        if([LXUserDefaults boolForKey:ISMEiGUO]){
//            if (indexPath.section == 1) {
//
//                if (indexPath.row == 0) {
//
//                    //视频认证
//                    if (self.model.auth == 1 || self.model.auth == 2) {
//
//                    } else {
//                        VideoRZVC *vc = [[VideoRZVC alloc] init];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//
//                }else if(indexPath.row == 1){
//                   //收费设置
//                    SetPriceVC *vc = [[SetPriceVC alloc] init];
//                    vc.model = self.model;
//                    [self.navigationController pushViewController:vc animated:YES];
//
//                }else if(indexPath.row == 2){
//                    //在线时段
//                    [self crpickerBG];
//
//                    [UIView animateWithDuration:0.33 animations:^{
//                        self.pickerBG.frame = CGRectMake(0, kScreenHeight - 266, kScreenWidth, 266);
//                        self.maskView.hidden = NO;
//
//                    } completion:^(BOOL finished) {
//
//
//                    }];
//                }
//
//
//            }else if(indexPath.section == 2){
//                //设置
//                SettingVC *vc = [[SettingVC alloc] init];
//                vc.isDND = self.model.isDND;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//
//
//
//        }else{
//
//            if (indexPath.section == 1) {
//                //邀请
//                if (indexPath.row == 0) {
//                    //邀请有奖
//                    InvitationVC *vc = [[InvitationVC alloc] init];
//                    vc.model = self.model;
//                    [self.navigationController pushViewController:vc animated:YES];
//
//                }else{
//                    //接受邀请
//                    AcceptVC *vc = [[AcceptVC alloc] init];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//
//
//            }else if(indexPath.section == 2){
//                //视频认证
//                if (indexPath.row == 0) {
//                    //视频认证
//                    if (self.model.auth == 1 || self.model.auth == 2) {
//
//                    } else {
//                        VideoRZVC *vc = [[VideoRZVC alloc] init];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//
//                }else if(indexPath.row == 1){
//                    //收费设置
//                    SetPriceVC *vc = [[SetPriceVC alloc] init];
//                    vc.model = self.model;
//                    [self.navigationController pushViewController:vc animated:YES];
//
//                }else if(indexPath.row == 2){
//
//                  //在线时段
//                    [self crpickerBG];
//
//                    [UIView animateWithDuration:0.33 animations:^{
//                        self.pickerBG.frame = CGRectMake(0, kScreenHeight - 266, kScreenWidth, 266);
//                        self.maskView.hidden = NO;
//
//                    } completion:^(BOOL finished) {
//
//
//                    }];
//                }
//
//
//            }else{
//                //设置
//                SettingVC *vc = [[SettingVC alloc] init];
//                vc.isDND = self.model.isDND;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//
//        }
//    }

    
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellType != 2) {
        
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
            NSArray *array = self.nameArray[indexPath.section];
            
            if (array.count == 1) {
                
                addLine = NO;
            }
            
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

#pragma mark - NewMyCellDelegate
- (void)accountButtonClick:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"充值"]) {
        AccountVC *vc = [[AccountVC alloc] init];
        vc.deposit = self.model.deposit;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([button.titleLabel.text isEqualToString:@"提現"]) {
        ProfitVC *vc = [[ProfitVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (void)crpickerBG {
    
    if (self.pickerBG == nil) {
        
        _pickerBG = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight, kScreenWidth, 216 + 60)];
        _pickerBG.backgroundColor = [UIColor whiteColor];
        
        UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        toolView.backgroundColor = Color_bg;
        [_pickerBG addSubview:toolView];
        
        _pickerBG.layer.shadowColor = [UIColor blackColor].CGColor;
        _pickerBG.layer.shadowRadius = 5.f;
        _pickerBG.layer.shadowOpacity = .3f;
        _pickerBG.layer.shadowOffset = CGSizeMake(0, 0);
        
        //確定按钮
        UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 0,50,40)];
        cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancel setTitleColor:UIColorFromRGB(0x00ddcc) forState:UIControlStateNormal];
        [cancel setTitle:LXSring(@"保存") forState:UIControlStateNormal];
        [toolView addSubview:cancel];
        [cancel addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //取消按钮
        UIButton *enter = [[UIButton alloc]initWithFrame:CGRectMake(10, 0,50,40)];
        enter.titleLabel.font = [UIFont systemFontOfSize:14];
        [enter setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [enter setTitle:LXSring(@"取消") forState:UIControlStateNormal];
        [toolView addSubview:enter];
        [enter addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 47.5, kScreenWidth / 2.0, 20)];
        label1.text = LXSring(@"上線時間");
        label1.textColor = UIColorFromRGB(0xfe707d);
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:14];
        [_pickerBG addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0, 47.5, kScreenWidth / 2.0, 20)];
        label2.text = LXSring(@"下線時間");
        label2.textColor = UIColorFromRGB(0xfe707d);
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = [UIFont systemFontOfSize:14];
        [_pickerBG addSubview:label2];
        
        
        
        self.startPK = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth / 2.0, 216)];
        self.startPK.dataSource = self;
        self.startPK.delegate = self;
        [_pickerBG addSubview:self.startPK];
        
        self.endPK = [[UIPickerView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, 60, kScreenWidth/2.0, 216)];
        self.endPK.dataSource = self;
        self.endPK.delegate = self;
        [_pickerBG addSubview:self.endPK];
        [self.tabBarController.view addSubview:_pickerBG];
        
        [self.endPK.subviews objectAtIndex:1].layer.borderWidth = 0.5f;
        
        [self.endPK.subviews objectAtIndex:2].layer.borderWidth = 0.5f;
        
        [self.endPK.subviews objectAtIndex:1].layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        
        [self.endPK.subviews objectAtIndex:2].layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        
        [self.startPK.subviews objectAtIndex:1].layer.borderWidth = 0.5f;
        
        [self.startPK.subviews objectAtIndex:2].layer.borderWidth = 0.5f;
        
        [self.startPK.subviews objectAtIndex:1].layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        
        [self.startPK.subviews objectAtIndex:2].layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        
        [self.endPK selectRow:self.model.preferOfflineOption inComponent:0 animated:YES];
        [self.startPK selectRow:self.model.preferOnlineOption inComponent:0 animated:YES];
    }
}

#pragma mark pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return [InputCheck getpreferOptions].count;
    
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
    UILabel *myView = nil;
    
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = [InputCheck getpreferOptions][row];
    myView.font = [UIFont systemFontOfSize:[self fontWithString:myView.text]];         //用label来設定字体大小
    myView.backgroundColor = [UIColor clearColor];
    
    NSInteger a = [pickerView selectedRowInComponent:0];
    if (a==row) {
        
        myView.attributedText = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
        
    }
    
    return myView;
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [pickerView reloadAllComponents];
    
    
}

- (UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
    UILabel *myView = nil;
    
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = [InputCheck getpreferOptions][row];
    myView.font = [UIFont systemFontOfSize:[self fontWithString:myView.text]];         //用label来設定字体大小
    myView.textColor = Color_nav;
    return myView;
    
    
}
//字体大小
- (CGFloat)fontWithString:(NSString *)string {
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat font = 0;
    for (int i = 17; i > 0; i--) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:i]};
        CGSize rect = [string sizeWithAttributes:attributes];
        if (rect.width <= width) {
            font = (CGFloat)i;
            break;
        }
    }
    return font;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSArray *array = [InputCheck getpreferOptions];
    NSString *titleString = array[row];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:titleString];
    NSRange range = [titleString rangeOfString:titleString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:range];
    
    return attributedString;
}

#pragma mark - NewMyalbumCellDelegate
- (void)imageShowAC:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 100;
    if (index < self.photoArrays.count) {
        NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
        for(int i = 0; i < self.photoArrays.count; i++)
        {
            AlbumModel *model = self.photoArrays[i];
            UIImageView *imageView = (UIImageView *)tap.view;
            MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
            browseItem.bigImageUrl = model.url;// 加载网络图片大图地址
            browseItem.smallImageView = imageView;// 小图
            [browseItemArray addObject:browseItem];
        }
        MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:index];
        //    bvc.isEqualRatio = NO;// 大图小图不等比时需要設定这个属性（建议等比）
        [bvc showBrowseViewController];
    } else {
        [self toAlbum];
    }
}


#pragma mark - NewMyVideoCellDelegate
- (void)videoPlayAC:(UIButton *)button {
    NSInteger tag = button.tag - 100;
    if (tag < self.videoArrays.count) {
        MyVideoModel *model = self.videoArrays[tag];
        VideoPlayVC *vc = [[VideoPlayVC alloc] init];
        vc.videoUrl = [NSURL URLWithString:model.url];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        [self toVideo];
    }
    
    
}

#pragma mark ----------取消-------------
- (void)cancelAction:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.33 animations:^{
        self.pickerBG.frame = CGRectMake(0, self.view.height, self.view.width, 0);
        self.maskView.hidden = YES;
        
    }completion:^(BOOL finished) {
        
    }];
    
}
#pragma mark ----------確定-------------
- (void)enterAction:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.33 animations:^{
        self.maskView.hidden = YES;
        
        self.pickerBG.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 256);
    } completion:^(BOOL finished) {
        
        
        NSDictionary *params;
        NSInteger startRow = [self.startPK selectedRowInComponent:0];
        NSInteger endRow = [self.endPK selectedRowInComponent:0];
        
        
        params = @{@"preferOfflineOption":@(endRow),@"preferOnlineOption":@(startRow)};
        [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    
                    self.model.preferOfflineOption = [result[@"data"][@"preferOfflineOption"] intValue];
                    
                    self.model.preferOnlineOption = [result[@"data"][@"preferOnlineOption"] intValue];
                    
                    [_tableView reloadData];
                    
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
        
        [_tableView reloadData];
        //
        
        
    }];
    
    
    
}


- (IBAction)editAc:(id)sender {
    FixpersonalVC *vc = [[FixpersonalVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)videoAC:(UIButton *)sender {
    self.photoButton.selected = YES;
    self.videoButton.selected = NO;
    self.photoLineView.hidden = YES;
    self.videoLineView.hidden = NO;
    
    self.cellType = MyTypeVideo;
    [UIView animateWithDuration:.35 animations:^{
//        self.lineView.centerX = sender.centerX;
        
    } completion:^(BOOL finished) {
        
        [self.tableView reloadData];
    }];
}

- (IBAction)photoAC:(UIButton *)sender {
    self.photoButton.selected = NO;
    self.videoButton.selected = YES;
    self.photoLineView.hidden = NO;
    self.videoLineView.hidden = YES;
    
    self.cellType = MyTypePhoto;
    [UIView animateWithDuration:.35 animations:^{
        self.lineView.centerX = sender.centerX;
    } completion:^(BOOL finished) {
        
        [self.tableView reloadData];

    }];
}

- (IBAction)messageAC:(UIButton *)sender {
    self.cellType = MyTypeMessage;
    [UIView animateWithDuration:.35 animations:^{
        self.lineView.centerX = sender.centerX;
    } completion:^(BOOL finished) {
        
        [self.tableView reloadData];

    }];
}

//修改头像
- (IBAction)fixProtaitAC:(id)sender {
}
#pragma mark - 免打扰
- (IBAction)unDisturbBtnAC:(id)sender {
    self.unDisturbButton.selected = !self.unDisturbButton.selected;
    if (self.unDisturbButton.selected) {
        // 设置免打扰
        [self unDisturb:1];
    } else {
        // 解除免打扰
        [self unDisturb:2];
    }
}

- (void)unDisturb:(int)isDnD {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@(isDnD), @"isDND", nil];
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSLog(@"%@", result);
                
            } else{
                self.unDisturbButton.selected = !self.unDisturbButton.selected;
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

- (IBAction)sqrzButtonAC:(id)sender {
    if (self.model.auth == 2) {
        //認證成功
        VideoRZResultVC *vc = [[VideoRZResultVC alloc] init];
        vc.sucuress = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.model.auth == 0) {
        // 未認證
        VideoRZVC *vc = [[VideoRZVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        //認證失敗
        VideoRZResultVC *vc = [[VideoRZResultVC alloc] init];
        vc.sucuress = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)editUserinfoBtnAC:(id)sender {
    FixpersonalVC *vc = [[FixpersonalVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toAlbum {
    MyalbumVC *vc = [[MyalbumVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toVideo {
    MyVideoVC *vc = [[MyVideoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
