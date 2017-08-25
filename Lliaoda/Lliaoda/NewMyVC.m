//
//  NewMyVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "NewMyVC.h"

@interface NewMyVC ()

@end

@implementation NewMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headerView.height = kScreenWidth / 750 * 450 + (kScreenWidth - 30) / 69 * 15 / 2;
    self.nav.hidden = YES;
    self.seltedView.layer.cornerRadius = 5;
    self.seltedView.layer.masksToBounds = YES;
    
    
    self.nameArray = [NSMutableArray array];
    self.messagePhotos = [NSMutableArray array];
    self.contents = [NSMutableArray array];
    
    self.cellType = MyTypeVideo;
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenWidth - 30) / 69 * 15 - 4, 50, 4)];
    self.lineView.left = ((kScreenWidth - 30) / 3 - 50)/2;
    self.lineView.backgroundColor = Color_Tab;
    [self.seltedView addSubview:self.lineView];
    
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    //必须给effcetView的frame赋值,因为UIVisualEffectView是一个加到UIIamgeView上的子视图.
    effectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth / 750 * 450);
    [self.backImage addSubview:effectView];
    
    self.headerImage.layer.cornerRadius = 35;
    self.headerImage.layer.masksToBounds = YES;
    
    
    LxCache *cahce = [LxCache sharedLxCache];
    NSString *cacheKey = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSDictionary *dic = [cahce getCacheDataWithKey:cacheKey];
    if (dic != nil) {
        self.ishud = NO;
        self.model = [Mymodel mj_objectWithKeyValues:dic[@"data"]];
        
        self.nickLabel.text = self.model.nickname;
        
        self.idLabel.text = [NSString stringWithFormat:LXSring(@"聊號：%@"),self.model.uid];
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
        [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
        [self setArrayForTable];
        
        self.tableView.tableHeaderView = self.headerView;

    }else{
        
        self.ishud = YES;
        
    }
  
    [self _loadData1];
        

}

- (void)setArrayForTable
{
        NSArray *array;
        NSArray *array1;
        if (self.model.activated == 0) {
            array = @[LXSring(@"邀請有獎"),LXSring(@"接受邀请")];
            array1 = @[@"yaoqingyoujiang",@"yaoqingmaduihuan"];
        }else{
            array = @[LXSring(@"邀請有獎")];
            array1 = @[@"yaoqingyoujiang"];
            
        }
        
        [self.nameArray removeAllObjects];
        [self.messagePhotos removeAllObjects];
        
        if([LXUserDefaults boolForKey:ISMEiGUO]){
            
            [self.nameArray addObject:@[LXSring(@"賬戶")]];
            [self.messagePhotos addObject:@[@"zhanghu"]];
            
            if (self.model.auth == 2) {
                
                [self.nameArray addObject:@[@[LXSring(@"視頻認證"),LXSring(@"收費設定"),LXSring(@"在線時段")]]];
                [self.messagePhotos addObject:@[@"shimingrenzheng",@"shoufeishezhi",@"jingchangchumo"]];
                
                
            }else{
                
                [self.nameArray addObject:@[LXSring(@"視頻認證")]];
                [self.messagePhotos addObject:@[@"shimingrenzheng"]];
                
                
            }
            [self.nameArray addObject:@[LXSring(@"設定")]];
            [self.messagePhotos addObject:@[@"shezhi"]];
            
            
        }else{
            
            [self.nameArray addObject:@[LXSring(@"賬戶"),LXSring(@"收入")]];
            [self.messagePhotos addObject:@[@"zhanghu",@"shouru"]];
            [self.nameArray addObject:array];
            [self.messagePhotos addObject:array1];
            
            if (self.model.auth == 2) {
                
                [self.nameArray addObject:@[@[LXSring(@"視頻認證"),LXSring(@"收費設定"),LXSring(@"在線時段")]]];
                [self.messagePhotos addObject:@[@"shimingrenzheng",@"shoufeishezhi",@"jingchangchumo"]];
                
                
            }else{
                
                [self.nameArray addObject:@[LXSring(@"視頻認證")]];
                [self.messagePhotos addObject:@[@"shimingrenzheng"]];
                
                
            }
            
            [self.nameArray addObject:@[LXSring(@"設定")]];
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
                [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];

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
    [self _loadData];
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
                
                
                self.nickLabel.text = self.model.nickname;
                self.idLabel.text = [NSString stringWithFormat:LXSring(@"聊號：%@"),self.model.uid];
                [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
                [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
                
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



#pragma  mark --------UITableView Delegete----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.cellType == MyTypeMessage){
         return self.nameArray.count;
    }else{
    
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.cellType == MyTypeMessage){
        NSArray *array = self.nameArray[section];
        return array.count;
    }else{
        
        return 1;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.cellType == MyTypePhoto){
        
        static NSString *identifie = @"cellPhotoID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifie];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifie];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.photoVC == nil) {
            
            self.photoVC = [[MyalbumVC alloc] init];
            __weak NewMyVC *this = self;
            self.photoVC.reloadData = ^(NSArray *dataList) {
                this.photoDataList = dataList;
                [this.tableView reloadData];
            };
            [self addChildViewController:_photoVC];
            NSLog(@"%f",self.photoVC.view.width);
            
        }
        self.photoVC.view.width = kScreenWidth;
        [cell addSubview:self.photoVC.view];
       
        return cell;
        
    }else if(self.cellType == MyTypeVideo){
        
        static NSString *identifie = @"cellVideoID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifie];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifie];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        if (self.videoVC == nil) {
            
            self.videoVC = [[MyVideoVC alloc] init];
            __weak NewMyVC *this = self;
            self.videoVC.reloadData = ^(NSArray *dataList) {
                this.videoDataList = dataList;
                [this.tableView reloadData];
            };
            self.videoVC.view.width = kScreenWidth;
            [self addChildViewController:_videoVC];

        }
        
      

        self.videoVC.view.width = kScreenWidth;
        [cell.contentView addSubview:self.videoVC.view];
        
        

        return cell;
        
    }else{
    NewMyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMyCellID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewMyCell" owner:self options:nil] firstObject];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = self.nameArray[indexPath.section][indexPath.row];
    cell.headerImage.image = [UIImage imageNamed:self.messagePhotos[indexPath.section][indexPath.row]];
    
    if (indexPath.section == 0) {
        cell.contentLabel.textColor = [MyColor colorWithHexString:@"#666666"];
        cell.samallImage.hidden = NO;

        if (indexPath.row == 0) {
            cell.samallImage.image = [UIImage imageNamed:@"zuanshi_20"];
            cell.contentLabel.text = [NSString stringWithFormat:@"%d",self.model.deposit];
        }else{
            cell.samallImage.image = [UIImage imageNamed:@"shouru_jvse"];
             cell.contentLabel.text = [NSString stringWithFormat:@"%d",self.model.income];
        }
    }else{
        cell.samallImage.hidden = YES;
        

    if([LXUserDefaults boolForKey:ISMEiGUO]){
        cell.contentLabel.textColor = [MyColor colorWithHexString:@"#666666"];
        if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                
                if(self.model.auth == 0){
                    
                    cell.contentLabel.text = LXSring(@"未认证");
                    
                }else if (self.model.auth == 1){
                    
                    cell.contentLabel.text = LXSring(@"认证中");
                    
                }else if (self.model.auth == 2){
                    
                    cell.contentLabel.text = LXSring(@"認證成功");
                    
                }else{
                    
                    cell.contentLabel.text = LXSring(@"認證失敗");
                    
                }
                
            }else if(indexPath.row == 1){
                
                Charge *charge;
                for (Charge *mo in self.model.charges) {
                    if (mo.uid == self.model.charge) {
                        charge = mo;
                    }
                }
                cell.contentLabel.text = charge.name;
                
                
            }else if(indexPath.row == 2){
                
                NSArray *array = [InputCheck getpreferOptions];
                cell.contentLabel.text = [NSString stringWithFormat:@"%@-%@",array[self.model.preferOnlineOption],array[self.model.preferOfflineOption]];
                
            }

            
        }else if(indexPath.section == 2){
           //设置
            cell.contentLabel.text = @"";

        }
        
        
    
    }else{
        
        if (indexPath.section == 1) {
            //邀请
            cell.contentLabel.textColor = [MyColor colorWithHexString:@"#999999"];
            if (indexPath.row == 0) {
                
                cell.contentLabel.text = LXSring(@"请输入5位邀請碼,即可获得奖励");

            }else{
                
                cell.contentLabel.text = LXSring(@"填入好友的分享的邀請碼，即可获奖励");
            }

            
        }else if(indexPath.section == 2){
             cell.contentLabel.textColor = [MyColor colorWithHexString:@"#666666"];
            if (indexPath.row == 0) {
                
                if(self.model.auth == 0){
                    cell.contentLabel.text = LXSring(@"未认证");
                    
                }else if (self.model.auth == 1){
                    
                    cell.contentLabel.text = LXSring(@"认证中");
                    
                }else if (self.model.auth == 2){
                    
                    cell.contentLabel.text = LXSring(@"認證成功");
                    
                }else{
                    
                    cell.contentLabel.text = LXSring(@"認證失敗");
                    
                }
                
            }else if(indexPath.row == 1){
                
                Charge *charge;
                for (Charge *mo in self.model.charges) {
                    if (mo.uid == self.model.charge) {
                        charge = mo;
                    }
                }
                cell.contentLabel.text = charge.name;
                
                
            }else if(indexPath.row == 2){
                
                NSArray *array = [InputCheck getpreferOptions];
                cell.contentLabel.text = [NSString stringWithFormat:@"%@-%@",array[self.model.preferOnlineOption],array[self.model.preferOfflineOption]];
                
            }


        }else{
         cell.contentLabel.textColor = [MyColor colorWithHexString:@"#666666"];
            //设置
            cell.contentLabel.text = @"";

        }
    
       }
    }
    
    return cell;
    }
    
    
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
    if (self.cellType == MyTypeMessage) {
        
        return 50;
    }else if (self.cellType == MyTypeVideo){
    
        return (self.videoDataList.count + 2) / 2 * (((kScreenWidth - 45) / 2.0 - 1) + 15);

    }else{
    return (self.photoDataList.count + 3) / 3 *  ((kScreenWidth - 60) / 3.0 - 1 + 15);

    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            //账户
        }else{
           //收入
        }
    }else{
        
        
        if([LXUserDefaults boolForKey:ISMEiGUO]){
            if (indexPath.section == 1) {
                
                if (indexPath.row == 0) {
                    
                    //视频认证
                    if(self.model.auth == 0){
                        
                        
                    }else if (self.model.auth == 1){
                        
                        
                    }else if (self.model.auth == 2){
                        
                        
                    }else{
                        
                        
                    }
                    
                }else if(indexPath.row == 1){
                    
                   //收费设置
                    
                }else if(indexPath.row == 2){
                    //在线时段
                    
                }
                
                
            }else if(indexPath.section == 2){
                //设置
                
            }
            
            
            
        }else{
            
            if (indexPath.section == 1) {
                //邀请
                if (indexPath.row == 0) {
                    //邀请有奖

                    
                }else{
                    //接受邀请
                }
                
                
            }else if(indexPath.section == 2){
                //视频认证
                if (indexPath.row == 0) {
                    
                    if(self.model.auth == 0){
                        
                    }else if (self.model.auth == 1){
                        
                        
                    }else if (self.model.auth == 2){
                        
                        
                    }else{
                        
                        
                    }
                    
                }else if(indexPath.row == 1){
                    //收费设置
                    
                    
                }else if(indexPath.row == 2){
                    
                  //在线时段
                    
                }
                
                
            }else{
                //设置
                
            }
            
        }
    }

    
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


- (IBAction)editAc:(id)sender {
    
    
}

- (IBAction)videoAC:(UIButton *)sender {
    [UIView animateWithDuration:.35 animations:^{
        self.lineView.centerX = sender.centerX;
    } completion:^(BOOL finished) {
        self.cellType = MyTypeVideo;
        [self.tableView reloadData];
    }];
}

- (IBAction)photoAC:(UIButton *)sender {
    
    [UIView animateWithDuration:.35 animations:^{
        self.lineView.centerX = sender.centerX;
    } completion:^(BOOL finished) {
        self.cellType = MyTypePhoto;
        [self.tableView reloadData];

    }];
}

- (IBAction)messageAC:(UIButton *)sender {
    
    [UIView animateWithDuration:.35 animations:^{
        self.lineView.centerX = sender.centerX;
    } completion:^(BOOL finished) {
        self.cellType = MyTypeMessage;
        [self.tableView reloadData];

    }];
}

//修改头像
- (IBAction)fixProtaitAC:(id)sender {
}
@end
