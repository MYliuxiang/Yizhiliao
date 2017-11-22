//
//  LxPersonVCs.m
//  Lliaoda
//
//  Created by 小牛 on 2017/10/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LxPersonVCs.h"
#define AlbumVideoBGViewHeight 60  // 相冊視頻按鈕背景高度
#define GiftChargeBGViewHeight 30  // 提醒充值送禮背景高度
#define BiaoqianLabelSpace 30      // 标签的上下间距和
@interface LxPersonVCs ()

@end

@implementation LxPersonVCs

- (UIStatusBarStyle)preferredStatusBarStyle {
        return UIStatusBarStyleLightContent;
//    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];
    
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    
      self.headerView.height = 376;
    self.nav.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.backButtton setImage:[UIImage imageNamed:@"back_bai"] forState:UIControlStateNormal];
    self.titleLable.textColor = [UIColor whiteColor];
    self.rightbutton.hidden = NO;
    [self addrightImage:@"dengdeng_bai"];
    
    self.headerImageView.layer.cornerRadius = 40;
    self.renzhengButton.layer.cornerRadius = 5;
    self.renzhengButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.renzhengButton.layer.borderWidth = 1;
    
    self.tableView.tableHeaderView = self.headerView;
    
    
    _type = 0;
    
    [self _loadData];
    
    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        isSelf = YES;
        _giftBGView.hidden = YES;
        [self addrightImage:@"bianji"];
        
    } else {
        isSelf = NO;
        _giftBGView.hidden = NO;
        [self addrightImage:@"dengdeng"];
    }
    
    UITapGestureRecognizer *hidRandG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRenandGift)];
    [_blackView addGestureRecognizer:hidRandG];
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
    }
    [WXDataService requestAFWithURL:Url_accountshow params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                self.tableView.tableHeaderView = self.headerView;
                self.pmodel = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                self.nameLabel.text = self.pmodel.nickname;
                self.idLabel.text = [NSString stringWithFormat:@"ID：%@",self.pmodel.uid];
                self.zanCountLabel.text = [NSString stringWithFormat:@"%d", self.pmodel.likeCount];
                likeCount = self.pmodel.likeCount;
                _unDisturbButton.selected = self.pmodel.isDND;
                
                if (self.pmodel.like == 1) {
                    // 喜歡
                    _zanButton.selected = YES;
                } else {
                    _zanButton.selected = NO;
                }
                CGFloat height = [self heightForText:self.pmodel.intro];
                if (height <= 30) {
                    if (self.pmodel.auth == 2) {
                        self.headerView.height = kScreenWidth / 750 * 450 + AlbumVideoBGViewHeight + 60 + GiftChargeBGViewHeight;
                    } else {
                        self.headerView.height = kScreenWidth / 750 * 450 + AlbumVideoBGViewHeight + 60;
                    }
                    
                } else {
                    if (self.pmodel.auth == 2) {
                        self.headerView.height = kScreenWidth / 750 * 450 + AlbumVideoBGViewHeight + height + GiftChargeBGViewHeight + BiaoqianLabelSpace;
                    } else {
                        self.headerView.height = kScreenWidth / 750 * 450 + AlbumVideoBGViewHeight + GiftChargeBGViewHeight + height + BiaoqianLabelSpace;
                    }
                }
                if (self.pmodel.auth == 2) {
                    _zanBGView.hidden = NO;
                    _unDisturbButton.hidden = NO;
                    _renzhengButton.hidden = NO;
                    _albumVideoBGViewTop.constant = 40;
                } else {
                    _zanBGView.hidden = YES;
                    _unDisturbButton.hidden = YES;
                    _renzhengButton.hidden = YES;
                    _giftBGView.hidden = YES;
                    _albumVideoBGViewTop.constant = 10;
                }
                if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
                    [self addrightImage:@"bianji"];
                    _albumVideoBGViewTop.constant = 10;
                } else {
                    [self addrightImage:@"dengdeng"];
                }
                [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.pmodel.portrait]];
                
                
                self.xingzuoLabel.text = [InputCheck getXingzuo:[NSDate dateWithTimeIntervalSince1970:[_pmodel.birthday longLongValue] / 1000]];
                
                self.ageLabel.text = [InputCheck dateToOld:[NSDate dateWithTimeIntervalSince1970:[_pmodel.birthday longLongValue] / 1000]];
                self.text = self.pmodel.nickname;
                self.placeLabel.text = [[CityTool sharedCityTool] getCityWithCountrieId:_pmodel.country WithprovinceId:_pmodel.province WithcityId:_pmodel.city];
                Charge *charge;
                for (Charge *mo in self.pmodel.charges) {
                    if (mo.uid == self.pmodel.charge) {
                        charge = mo;
                    }
                }
                
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
                [_tableView reloadData];
                
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
- (CGFloat)heightForText:(NSString *)text
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    return [text boundingRectWithSize:CGSizeMake(SCREEN_W - 140, 1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isSelf) {
        return 1;
    }
    return 3;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        if (self.pmodel.auth == 2) {
            return 2;
        } else {
            return 1;
        }
        
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_type == 0) {
            NewMyalbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMyalbumCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NewMyalbumCell" owner:self options:nil] lastObject];
            }
            cell.imageView1.image = [UIImage imageNamed:@"moren"];
            cell.imageView2.image = [UIImage imageNamed:@"moren"];
            cell.imageView3.image = [UIImage imageNamed:@"moren"];
            cell.imageView4.image = [UIImage imageNamed:@"moren"];
            
            cell.delegate = self;
            for (int i = 0; i < self.pmodel.photos.count; i++) {
                Photo *photo = self.pmodel.photos[i];
                switch (i) {
                    case 0:
                        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:photo.url]];
                        break;
                    case 1:
                        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:photo.url]];
                        break;
                    case 2:
                        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:photo.url]];
                        break;
                    case 3:
                        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:photo.url]];
                        break;

                    default:
                        break;
                }
            }
            cell.addLabel.hidden = YES;
            if (self.pmodel.photos.count < 6) {
                
                [cell.addButton setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
                [cell.addButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

            }else{
            [cell.addButton setImage:[UIImage imageNamed:@"dengdeng_huang"] forState:UIControlStateNormal];
            [cell.addButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [cell.addButton addTarget:self action:@selector(toAlbum) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell;
            
        } else if (_type == 1) {
            NewMyVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMyVideoCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NewMyVideoCell" owner:self options:nil] lastObject];
            }
            [cell.playButton1 setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
            [cell.playButton2 setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
            [cell.playButton3 setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
            [cell.playButton4 setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
            cell.delegate = self;
            for (int i = 0; i < self.pmodel.videos.count; i++) {
                Video *video = self.pmodel.videos[i];
                switch (i) {
                    case 0:
                        [cell.playButton1 setImage:[UIImage imageNamed:@"dashipin"] forState:UIControlStateNormal];
                        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                        break;
                    case 1:
                        [cell.playButton2 setImage:[UIImage imageNamed:@"dashipin"] forState:UIControlStateNormal];
                        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                        break;
                    case 2:
                        [cell.playButton3 setImage:[UIImage imageNamed:@"dashipin"] forState:UIControlStateNormal];
                        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                        break;
                    case 3:
                        [cell.playButton4 setImage:[UIImage imageNamed:@"dashipin"] forState:UIControlStateNormal];
                        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                        break;
                        
                    default:
                        break;
                }
            }
            if (self.pmodel.videos.count < 6) {
                
                [cell.addButton setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
                [cell.addButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }else{
            cell.addLabel.hidden = YES;
            [cell.addButton setImage:[UIImage imageNamed:@"dengdeng_huang"] forState:UIControlStateNormal];
            [cell.addButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [cell.addButton addTarget:self action:@selector(toVideo) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        if (self.pmodel.auth == 2) {
            LxPersonNewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"LxPersonNewCell1"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"LxPersonNewCell1" owner:self options:nil] lastObject];
            }
            cell.bottomLineView.hidden = NO;
            if (indexPath.row == 0) {
                cell.littleImageView.image = [UIImage imageNamed:@"shijian"];
                cell.leftLabel.text = @"常在線時間";
                NSArray *array = [InputCheck getpreferOptions];
                cell.contentLabel.text = [NSString stringWithFormat:@"%@-%@",array[self.pmodel.preferOnlineOption],array[self.pmodel.preferOfflineOption]];
                
            } else {
                cell.bottomLineView.hidden = YES;
                cell.littleImageView.image = [UIImage imageNamed:@"jietonglv"];
                cell.leftLabel.text = @"接聽率";
                if (self.pmodel.rate1 == -1) {
                    cell.contentLabel.text = @"0";
                } else {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%d", self.pmodel.rate1];
                }
            }
            return cell;
        } else {
            LxPersonNewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"LxPersonNewCell3"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"LxPersonNewCell3" owner:self options:nil] lastObject];
            }
            cell.delegate = self;
            return cell;
        }
        
    }
    LxPersonNewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"LxPersonNewCell2"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LxPersonNewCell2" owner:self options:nil] lastObject];
    }
    cell.bottomLineView.hidden = NO;
    cell.chatButton.layer.cornerRadius = 5;
    if (self.pmodel.auth == 2) {
        cell.freeLabel.hidden = YES;
        cell.priceBGView.hidden = NO;
    } else {
        cell.freeLabel.hidden = NO;
        cell.priceBGView.hidden = YES;
    }
    if (indexPath.row == 0) {
        cell.contentLabel.text = @"每日限免，VIP享無限暢聊！";
        [cell.chatButton setImage:[UIImage imageNamed:@"sixinliaotian"] forState:UIControlStateNormal];
        [cell.chatButton setTitle:@"私訊聊天" forState:UIControlStateNormal];
        [cell.chatButton addTarget:self action:@selector(chatButtonAC) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (indexPath.row == 1) {
        Charge *charge;
        for (Charge *mo in self.pmodel.charges) {
            if (mo.uid == self.pmodel.chargeAudio) {
                charge = mo;
            }
        }
        cell.contentLabel.text = charge.name;
        [cell.chatButton setImage:[UIImage imageNamed:@"yuyin_s"] forState:UIControlStateNormal];
        [cell.chatButton setTitle:@"語音聊天" forState:UIControlStateNormal];
        [cell.chatButton addTarget:self action:@selector(yuyinButtonAC) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        Charge *charge;
        for (Charge *mo in self.pmodel.charges) {
            if (mo.uid == self.pmodel.charge) {
                charge = mo;
            }
        }
        cell.contentLabel.text = charge.name;
        cell.bottomLineView.hidden = YES;
        [cell.chatButton setImage:[UIImage imageNamed:@"yuyinliaotian"] forState:UIControlStateNormal];
        [cell.chatButton setTitle:@"視訊聊天" forState:UIControlStateNormal];
        [cell.chatButton addTarget:self action:@selector(videoButtonAC) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return (SCREEN_W - 40) / 2 + 15;
    } else if (indexPath.section == 1) {
        if (self.pmodel.auth == 2) {
            return 70;
        }
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (IBAction)albumBtnAC:(id)sender {
    _type = 0;
    _albumButton.selected = NO;
    _videoButton.selected = YES;
    _albumLineView.hidden = NO;
    _videoLineView.hidden = YES;
    [_tableView reloadData];
}

- (IBAction)videoBtnAC:(id)sender {
    _type = 1;
    _albumButton.selected = YES;
    _videoButton.selected = NO;
    _albumLineView.hidden = YES;
    _videoLineView.hidden = NO;
    [_tableView reloadData];
}

- (void)toAlbum {
    PPhotoVC *vc = [[PPhotoVC alloc] init];
    vc.pmodel = self.pmodel;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toVideo {
    
    PVideoVC *vc = [[PVideoVC alloc] init];
    vc.pmodel = self.pmodel;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)rightAction
{
    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_toEdit object:nil];
        [self.navigationController popToRootViewControllerAnimated:NO];
//        TJPTabBarController *tab = [TJPTabBarController shareInstance];
//        tab.selectedIndex = 4;
        
        
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
            params = @{@"uid":self.model.uid};
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
//    if (self.isFromHeader) {
//        params = @{@"uid":self.personUID,@"kind":[NSString stringWithFormat:@"%d",type]};
//    } else {
//        params = @{@"uid":self.model.uid,@"kind":[NSString stringWithFormat:@"%d",type]};
//    }
    params = @{@"uid":self.model.uid,@"kind":[NSString stringWithFormat:@"%d",type]};
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

#pragma mark - NewMyalbumCellDelegate
- (void)imageShowAC:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 100;
    if (index < self.pmodel.photos.count) {
        NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
        for(int i = 0; i < self.pmodel.photos.count; i++)
        {
            Photo *model = self.pmodel.photos[i];
            UIImageView *imageView = (UIImageView *)tap.view;
            MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
            browseItem.bigImageUrl = model.url;// 加载网络图片大图地址
            browseItem.smallImageView = imageView;// 小图
            [browseItemArray addObject:browseItem];
        }
        MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:index];
        //    bvc.isEqualRatio = NO;// 大图小图不等比时需要設定这个属性（建议等比）
        [bvc showBrowseViewController];
    }
}


#pragma mark - NewMyVideoCellDelegate
- (void)videoPlayAC:(UIButton *)button {
    NSInteger tag = button.tag - 100;
    if (tag < self.pmodel.videos.count) {
        
        Video *video = self.pmodel.videos[tag];
        OtherVideoPlayVC *vc = [[OtherVideoPlayVC alloc] init];
        PersonModel *pmodel = [[PersonModel alloc] init];
        pmodel.nickname = self.pmodel.nickname;
        pmodel.uid = self.pmodel.uid;
        pmodel.portrait = self.pmodel.portrait;
        vc.model = pmodel;
        //播放視訊
        vc.videoUrl = [NSURL URLWithString:video.url];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
}

#pragma mark - 私信聊天
- (void)chatButtonAC {
    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"不能与自己聊天。") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    LHChatVC *chatVC = [[LHChatVC alloc] init];
    chatVC.sendUid = self.model.uid;
//    if (self.isFromHeader) {
//        chatVC.sendUid = self.personUID;
//    } else {
//        chatVC.sendUid = self.model.uid;
//    }
    //    chatVC.sendUid = self.model.uid;
    //    chatVC.personID = self.personUID;
    //    chatVC.isFromHeader = self.isFromHeader;
    [self.navigationController pushViewController:chatVC animated:YES];
}
#pragma mark - 语言聊天
- (void)yuyinButtonAC {
    [self vioceCallAC];
}

- (void)vioceCallAC
{
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
    
    NSDictionary *params;
    NSString *uid;
    if (self.isFromHeader) {
        uid = _personUID;
    } else {
        uid = self.model.uid;
    }
    params = @{@"uid":uid,@"type":@1};
    
    [WXDataService requestAFWithURL:Url_chatvideocall params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSString *channel = [NSString stringWithFormat:@"%@",result[@"data"][@"channel"]];
                VideoCallView *voiceView = [[VideoCallView alloc] initVideoCallViewWithChancel:channel withUid:uid withIsSend:YES withType:CallTypeVoice];
                [voiceView show];
                
            }else{    //请求失败
                
                if ([[result objectForKey:@"result"] integerValue] == 8) {
                    
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
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
    }];
    
    
}
#pragma mark - 视频聊天
- (void)videoButtonAC {
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
                    VideoCallView *video = [[VideoCallView alloc] initVideoCallViewWithChancel:channel withUid:self.personUID withIsSend:YES withType:CallTypeVideo];
                    [video show];
                } else {
                    VideoCallView *video = [[VideoCallView alloc] initVideoCallViewWithChancel:channel withUid:self.model.uid withIsSend:YES withType:CallTypeVideo];
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

#pragma mark - LxPersonNewCell3Delegate 提醒用户充值和送礼
- (void)giftBtnClick {
    // 提醒用戶送禮
    RepetitionCount *re = [RepetitionCount sharedRepetition];
    long long idate = [[NSDate date] timeIntervalSince1970]*1000;
    long long oldDate = [[NSString stringWithFormat:@"%@",re.mdic[self.personUID]] longLongValue];
    if (idate - oldDate < 60 * 1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"發送太頻繁，會嚇走金主的~") delegate:nil cancelButtonTitle:LXSring(@"好的") otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self sendMessageToUserType:MessageBodyType_Gift name:LXSring(@"送禮") types:@"gift"];
        if (self.isFromHeader) {
            [re.mdic setObject:@(idate) forKey:self.personUID];
        } else {
            [re.mdic setObject:@(idate) forKey:self.model.uid];
        }
        
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

- (void)chargeBtnClick {
    // 提醒用戶充值
    RechargeCount *re = [RechargeCount sharedRecharge];
    long long idate = [[NSDate date] timeIntervalSince1970]*1000;
    long long oldDate = [[NSString stringWithFormat:@"%@",re.mdic[self.model.uid]] longLongValue];
    if (idate - oldDate < 60 * 1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"發送太頻繁，會嚇走金主的~") delegate:nil cancelButtonTitle:LXSring(@"好的") otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self sendMessageToUserType:MessageBodyType_ChongZhi name:LXSring(@"儲值") types:@"recharge"];
        if (self.isFromHeader) {
            [re.mdic setObject:@(idate) forKey:self.personUID];
        } else {
            [re.mdic setObject:@(idate) forKey:self.model.uid];
        }
        
    }
    
    
}

#pragma mark - 用户充值送礼
- (IBAction)giftBtnAC:(id)sender {
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

- (IBAction)upTopBtnAC:(id)sender {
    
    AccountVC *vc = [[AccountVC alloc] init];
    vc.isCall = NO;
    vc.orderReferee = self.model.uid;
    [self.navigationController pushViewController:vc animated:YES];
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
        if (self.isFromHeader) {
            params = @{@"uid":self.personUID, @"message":message, @"type":@1};
        } else {
            params = @{@"uid":self.model.uid, @"message":message, @"type":@1};
        }
        
        
    }else if(type == MessageBodyType_ChongZhi){
        if (self.isFromHeader) {
            params = @{@"uid":self.personUID, @"message":message, @"type":@2};
        } else {
            params = @{@"uid":self.model.uid, @"message":message, @"type":@2};
        }
        
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
- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = @[].mutableCopy;
    }
    return _messages;
}

#define mark - 点赞
- (IBAction)zanButtonAC:(id)sender {
    
    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"亲，当前用户是您自己，不能設定讚与不讚！") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    _zanButton.selected = !_zanButton.selected;
    if (!_zanButton.selected) {
        
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
                    _zanButton.selected = NO;
                    CAKeyframeAnimation * animation;
                    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                    animation.duration = 0.5;
                    animation.removedOnCompletion = YES;
                    animation.fillMode = kCAFillModeForwards;
                    
                    NSMutableArray *values = [NSMutableArray array];
                    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
                    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
                    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
                    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
                    
                    animation.values = values;
                    
                    likeCount --;
                    self.zanCountLabel.text = [NSString stringWithFormat:@"%d", likeCount];
//                    [self _loadData];
                    
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
                    
                    
                    _zanButton.selected = YES;
//                    [self _loadData];
                    
                    likeCount ++;
                    self.zanCountLabel.text = [NSString stringWithFormat:@"%d", likeCount];
                    
                    CAKeyframeAnimation * animation;
                    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                    animation.duration = 0.5;
                    animation.removedOnCompletion = YES;
                    animation.fillMode = kCAFillModeForwards;
                    
                    NSMutableArray *values = [NSMutableArray array];
                    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
                    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
                    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
                    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
                    
                    animation.values = values;
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
@end
