//
//  LxPersonVCs.m
//  Lliaoda
//
//  Created by 小牛 on 2017/10/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LxPersonVCs.h"

@interface LxPersonVCs ()

@end

@implementation LxPersonVCs

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headerView.height = kScreenWidth / 750 * 450 + 60 + 60;
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
//    [self.rightbutton setImage:[UIImage imageNamed:@"dengdeng_bai"] forState:UIControlStateNormal];
    
    self.headerImageView.layer.cornerRadius = 40;
    self.renzhengButton.layer.cornerRadius = 5;
    
    self.tableView.tableHeaderView = self.headerView;
    
    
    _type = 0;
    
    [self _loadData];
}
- (void)_loadData
{
    NSDictionary *params;
    //    NSString *str = [LXUserDefaults objectForKey:itemNumber];
    //    if ([str isEqualToString:@"1"]) {
    //        params = @{@"uid":self.model.uid};
    //
    //    } else {
    //        params = @{@"uid":self.model.uid};
    //    }
    params = @{@"uid":self.model.uid};
    [WXDataService requestAFWithURL:Url_accountshow params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                self.tableView.tableHeaderView = self.headerView;
                self.pmodel = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                self.nameLabel.text = self.pmodel.nickname;
                self.idLabel.text = [NSString stringWithFormat:@"ID：%@",self.pmodel.uid];
                CGFloat height = [self heightForText:self.pmodel.intro];
                if (height <= 30) {
                    self.headerView.height = kScreenWidth / 750 * 450 + 60 + 60;
                } else {
                    self.headerView.height = kScreenWidth / 750 * 450 + 60 + height + 30;
                }
                [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.pmodel.portrait]];
                if (self.pmodel.like == 0) {
                    //                    self.likeButton.selected = NO;
                    //                    self.likeImge.image = [UIImage imageNamed:@"xinxing_22"];
                    //                    self.isLike = NO;
                }else{
                    //已经点赞
                    //                    self.likeButton.selected = YES;
                    //                        self.likeImge.image = [UIImage imageNamed:@"xinxing_h"];
                    //                    self.isLike = YES;
                    
                }
                //                [self.likeButton setTitle:[NSString stringWithFormat:@"%d",self.pmodel.likeCount] forState:UIControlStateNormal];
                //                self.likeLabel.text = [NSString stringWithFormat:@"%d",self.pmodel.likeCount];
                if (self.pmodel.gender == 0) {
                    
                    //                    self.sexImage.image = [UIImage imageNamed:@"nansheng"];
                    
                    //男
                }else{
                    
                    //                    self.sexImage.image = [UIImage imageNamed:@"nvsheng"];
                    
                }
                
                self.xingzuoLabel.text = [InputCheck getXingzuo:[NSDate dateWithTimeIntervalSince1970:[_pmodel.birthday longLongValue] / 1000]];
                
                self.ageLabel.text = [InputCheck dateToOld:[NSDate dateWithTimeIntervalSince1970:[_pmodel.birthday longLongValue] / 1000]];
                self.text = self.pmodel.nickname;
                
                Charge *charge;
                for (Charge *mo in self.pmodel.charges) {
                    if (mo.uid == self.pmodel.charge) {
                        charge = mo;
                    }
                }
                
                //                if ([LXUserDefaults boolForKey:ISMEiGUO]){
                //                    self.view3.hidden = YES;
                //
                //                }else{
                //                    self.feiyongLbael.text = charge.name;
                //                    if (self.feiyongLbael.text.length == 0) {
                //                        self.view3.hidden = YES;
                //                    } else {
                //                        self.view3.hidden = NO;
                //                    }
                //                }
                
                //                NSMutableArray *marray = [NSMutableArray array];
                //                for (Photo *photo in self.pmodel.photos) {
                //                    [self.photos addObject:photo.url];
                //                }
                //                if (marray.count == 0 && self.pmodel.portrait != nil) {
                //                    [self.photos addObject:self.pmodel.portrait];
                //                }
                //                self.cycleScrollView.imageURLStringsGroup = self.photos;
                //
                //                self.messageArray = @[LXSring(@"最近活躍"),LXSring(@"地區"),LXSring(@"行业"),LXSring(@"簽名檔"),LXSring(@"经常出没")];
                //                self.messagePhotos = @[@"zuijinhuoyue",@"laizi",@"hangye",@"gexingqianming",@"jingchangchumo"];
                
                
                
                
//                NSArray *array = [InputCheck getpreferOptions];
                //                NSString *str = [InputCheck handleActiveWith:self.pmodel.lastActiveAt];
                //                NSString *str1 = [[CityTool sharedCityTool] getAdressWithCountrieId:self.model.country WithprovinceId:self.model.province WithcityId:self.model.city];
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
                //                NSString *str3 = [NSString stringWithFormat:@"%@-%@",array[self.pmodel.preferOnlineOption],array[self.pmodel.preferOfflineOption]];
                
                //                self.contentArray = @[str,str1,str4,str2,str3];
                
                //                Present *present = self.pmodel.presents[0];
                
                
                [_tableView reloadData];
                
                if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
                    //                    _tableViewBottom.constant = 0;
                    //                    self.footerView.hidden = YES;
                }else{
                    //                    _tableViewBottom.constant = 49;
                    //                    self.footerView.hidden = NO;
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
    return 3;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
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
            [cell.addButton setImage:[UIImage imageNamed:@"dengdeng_huang"] forState:UIControlStateNormal];
            [cell.addButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [cell.addButton addTarget:self action:@selector(toAlbum) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        } else if (_type == 1) {
            NewMyVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMyVideoCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NewMyVideoCell" owner:self options:nil] lastObject];
            }
            cell.delegate = self;
            for (int i = 0; i < self.pmodel.videos.count; i++) {
                Video *video = self.pmodel.videos[i];
                switch (i) {
                    case 0:
                        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                        break;
                    case 1:
                        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                        break;
                    case 2:
                        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                        break;
                    case 3:
                        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                        break;
                        
                    default:
                        break;
                }
            }
            cell.addLabel.hidden = YES;
            [cell.addButton setImage:[UIImage imageNamed:@"dengdeng_huang"] forState:UIControlStateNormal];
            [cell.addButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [cell.addButton addTarget:self action:@selector(toVideo) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
    } else if (indexPath.section == 1) {
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
        }
        return cell;
    }
    LxPersonNewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"LxPersonNewCell2"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LxPersonNewCell2" owner:self options:nil] lastObject];
    }
    cell.bottomLineView.hidden = NO;
    cell.chatButton.layer.cornerRadius = 5;
    if (indexPath.row == 0) {
        [cell.chatButton setImage:[UIImage imageNamed:@"sixinliaotian"] forState:UIControlStateNormal];
        [cell.chatButton setTitle:@"私訊聊天" forState:UIControlStateNormal];
        [cell.chatButton addTarget:self action:@selector(chatButtonAC) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (indexPath.row == 1) {
        [cell.chatButton setImage:[UIImage imageNamed:@"yuyin_s"] forState:UIControlStateNormal];
        [cell.chatButton setTitle:@"語音聊天" forState:UIControlStateNormal];
        [cell.chatButton addTarget:self action:@selector(yuyinButtonAC) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
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
    
//    MyVideoVC *vc = [[MyVideoVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
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
//            if (self.isFromHeader) {
//                params = @{@"uid":self.personUID};
//            } else {
//                params = @{@"uid":self.model.uid};
//            }
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
    if (tag >= self.pmodel.videos.count) {
        return;
    }
    Video *video = self.pmodel.videos[tag];
    VideoPlayVC *vc = [[VideoPlayVC alloc] init];
    vc.videoUrl = [NSURL URLWithString:video.url];
    [self presentViewController:vc animated:YES completion:nil];
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
@end
