//
//  MyVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MyVC.h"
#import "FixpersonalVC.h"
#import "InvitationVC.h"

@interface MyVC ()

@end

@implementation MyVC

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navbarHiden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.nameArray = [NSMutableArray array];
    self.headerImage.layer.cornerRadius = 75 / 2.0;
    self.headerImage.layer.masksToBounds = YES;
    [self.editBtn setTitle:DTLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self.headerImage addGestureRecognizer:tap];

    LxCache *cahce = [LxCache sharedLxCache];
    NSString *cacheKey = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSDictionary *dic = [cahce getCacheDataWithKey:cacheKey];
    if (dic != nil) {
        
        self.model = [Mymodel mj_objectWithKeyValues:dic[@"data"]];
        
        self.nickLabel.text = self.model.nickname;
        NSLog(@"%@", DTLocalizedString(@"聊號：%@", nil));
        self.idLabel.text = [NSString stringWithFormat:DTLocalizedString(@"聊號：%@", nil),self.model.uid];
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
        
        NSArray *array;
        if (self.model.activated == 0) {
            array = @[DTLocalizedString(@"邀请有奖", nil),DTLocalizedString(@"接受邀请", nil)];
        }else{
            array = @[DTLocalizedString(@"邀请有奖", nil)];
            
        }
        
        if([LXUserDefaults boolForKey:ISMEiGUO]){
            
            if (self.model.auth == 2) {
                
                self.nameArray = [NSMutableArray arrayWithObjects:@[DTLocalizedString(@"视频认证", nil),DTLocalizedString(@"收费设置", nil),DTLocalizedString(@"在线时段", nil)],@[DTLocalizedString(@"视频秀", nil),DTLocalizedString(@"相册", nil)], @[DTLocalizedString(@"设置", nil)],nil];
                
                
            }else{
                
                self.nameArray = [NSMutableArray arrayWithObjects:@[DTLocalizedString(@"视频认证", nil)],@[DTLocalizedString(@"视频秀", nil),DTLocalizedString(@"相册", nil)],@[DTLocalizedString(@"设置", nil)], nil];
                
            }
            
            
        }else{
            
            if (self.model.auth == 2) {
                
                self.nameArray = [NSMutableArray arrayWithObjects:array,@[DTLocalizedString(@"视频认证", nil),DTLocalizedString(@"收费设置", nil),DTLocalizedString(@"在线时段", nil)],@[DTLocalizedString(@"视频秀", nil),DTLocalizedString(@"相册", nil)], @[DTLocalizedString(@"设置", nil)],nil];
                
                
            }else{
                
                self.nameArray = [NSMutableArray arrayWithObjects:array,@[DTLocalizedString(@"视频认证", nil)],@[DTLocalizedString(@"视频秀", nil),DTLocalizedString(@"相册", nil)],@[DTLocalizedString(@"设置", nil)], nil];
                
            }
            
            
        }
        
        
        [_tableView reloadData];
        
    }

    
    self.headerView.width = kScreenWidth;
    self.headerView.height = kScreenWidth*434/750.0;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self _loadData1];
    [CityTool sharedCityTool];
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    self.maskView.hidden = YES;
    [self.tabBarController.view addSubview:self.maskView];
    
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiden)];
    ta.delegate=self;
    [self.maskView addGestureRecognizer:ta];

}
- (void)hiden
{
    [UIView animateWithDuration:0.33 animations:^{
        
        self.pickerBG.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 266);
        self.maskView.hidden = YES;

        
    } completion:^(BOOL finished) {
        
    }];

}



- (void)crpickerBG {
    
    if (self.pickerBG == nil) {
        
    _pickerBG = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight, kScreenWidth, 216 + 60)];
    _pickerBG.backgroundColor = [UIColor whiteColor];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    toolView.backgroundColor = Color_bg;
    [_pickerBG addSubview:toolView];
    
    
    //確定按钮
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 0,50,40)];
    cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancel setTitleColor:Color_nav forState:UIControlStateNormal];
    [cancel setTitle:DTLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [toolView addSubview:cancel];
    [cancel addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //取消按钮
    UIButton *enter = [[UIButton alloc]initWithFrame:CGRectMake(10, 0,50,40)];
    enter.titleLabel.font = [UIFont systemFontOfSize:14];
    [enter setTitleColor:Color_nav forState:UIControlStateNormal];
    [enter setTitle:@"取消" forState:UIControlStateNormal];
    [toolView addSubview:enter];
    [enter addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 47.5, kScreenWidth / 2.0, 20)];
        label1.text = DTLocalizedString(@"上線時間", nil);
        label1.textColor = Color_nav;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:14];
        [_pickerBG addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0, 47.5, kScreenWidth / 2.0, 20)];
        label2.text = DTLocalizedString(@"下線時間", nil);
        label2.textColor = Color_nav;
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
        
        [self.endPK.subviews objectAtIndex:1].layer.borderColor = Color_nav.CGColor;
        
        [self.endPK.subviews objectAtIndex:2].layer.borderColor = Color_nav.CGColor;
        
        [self.startPK.subviews objectAtIndex:1].layer.borderWidth = 0.5f;
        
        [self.startPK.subviews objectAtIndex:2].layer.borderWidth = 0.5f;
        
        [self.startPK.subviews objectAtIndex:1].layer.borderColor = Color_nav.CGColor;
        
        [self.startPK.subviews objectAtIndex:2].layer.borderColor = Color_nav.CGColor;
    
        [self.endPK selectRow:self.model.preferOfflineOption inComponent:0 animated:YES];
        [self.startPK selectRow:self.model.preferOnlineOption inComponent:0 animated:YES];
    }
    
   
    
    
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


- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSArray *array = [InputCheck getpreferOptions];
    NSString *titleString = array[row];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:titleString];
    NSRange range = [titleString rangeOfString:titleString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:Color_nav range:range];
    
    return attributedString;
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



- (void)_loadData1
{
    
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                self.model = [Mymodel mj_objectWithKeyValues:result[@"data"]];
                
                LxCache *lxcache = [LxCache sharedLxCache];
                NSString *cacheKey = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                [lxcache setCacheData:result WithKey:cacheKey];

                
                self.nickLabel.text = self.model.nickname;
                self.idLabel.text = [NSString stringWithFormat:@"聊號：%@",self.model.uid];
                [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
                
                NSArray *array;
                if (self.model.activated == 0) {
                    array = @[DTLocalizedString(@"邀請有獎", nil),DTLocalizedString(@"接受邀请", nil)];
                }else{
                    array = @[DTLocalizedString(@"邀請有獎", nil)];

                }
                if([LXUserDefaults boolForKey:ISMEiGUO]){
                    
                    if (self.model.auth == 2) {
                        
                        self.nameArray = [NSMutableArray arrayWithObjects:@[DTLocalizedString(@"視頻認證", nil),DTLocalizedString(@"收費設定", nil),DTLocalizedString(@"在線時段", nil)],@[DTLocalizedString(@"小視頻", nil),DTLocalizedString(@"相薄", nil)], @[DTLocalizedString(@"設定", nil)],nil];
                        
                        
                    }else{
                        
                        self.nameArray = [NSMutableArray arrayWithObjects:@[DTLocalizedString(@"視頻認證", nil)],@[DTLocalizedString(@"小視頻", nil),DTLocalizedString(@"相薄", nil)],@[DTLocalizedString(@"設定", nil)], nil];
                        
                    }
                    
                    
                }else{
                    
                    if (self.model.auth == 2) {
                        
                        self.nameArray = [NSMutableArray arrayWithObjects:array,@[DTLocalizedString(@"視頻認證", nil),DTLocalizedString(@"收費設定", nil),DTLocalizedString(@"在線時段", nil)],@[DTLocalizedString(@"小視頻", nil),DTLocalizedString(@"相薄", nil)], @[DTLocalizedString(@"設定", nil)],nil];
                        
                        
                    }else{
                        
                        self.nameArray = [NSMutableArray arrayWithObjects:array,@[DTLocalizedString(@"視頻認證", nil)],@[DTLocalizedString(@"小視頻", nil),DTLocalizedString(@"相薄", nil)],@[DTLocalizedString(@"設定", nil)], nil];
                        
                    }
                    
                    
                }
                
                
                [_tableView reloadData];
                
                
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

- (void)click
{
    FixpersonalVC *vc = [[FixpersonalVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
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
                LxCache *lxcache = [LxCache sharedLxCache];
                NSString *cacheKey = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                [lxcache setCacheData:result WithKey:cacheKey];
                
                self.nickLabel.text = self.model.nickname;
                self.idLabel.text = [NSString stringWithFormat:@"聊號：%@",self.model.uid];
                [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
                               
                NSArray *array;
                if (self.model.activated == 0) {
                    array = @[DTLocalizedString(@"邀請有獎", nil),DTLocalizedString(@"接受邀请", nil)];
                }else{
                    array = @[DTLocalizedString(@"邀請有獎", nil)];
                    
                }
                if([LXUserDefaults boolForKey:ISMEiGUO]){
                
                    if (self.model.auth == 2) {
                        
                        self.nameArray = [NSMutableArray arrayWithObjects:@[DTLocalizedString(@"視頻認證", nil),DTLocalizedString(@"收費設定", nil),DTLocalizedString(@"在線時段", nil)],@[DTLocalizedString(@"小視頻", nil),DTLocalizedString(@"相薄", nil)], @[DTLocalizedString(@"設定", nil)],nil];
                        
                        
                    }else{
                        
                        self.nameArray = [NSMutableArray arrayWithObjects:@[DTLocalizedString(@"視頻認證", nil)],@[DTLocalizedString(@"小視頻", nil),DTLocalizedString(@"相薄", nil)],@[DTLocalizedString(@"設定", nil)], nil];
                        
                    }
                    

                }else{
                
                    if (self.model.auth == 2) {
                        
                        self.nameArray = [NSMutableArray arrayWithObjects:array,@[DTLocalizedString(@"視頻認證", nil),DTLocalizedString(@"收費設定", nil),DTLocalizedString(@"在線時段", nil)],@[DTLocalizedString(@"小視頻", nil),DTLocalizedString(@"相薄", nil)], @[DTLocalizedString(@"設定", nil)],nil];
                        
                        
                    }else{
                        
                        self.nameArray = [NSMutableArray arrayWithObjects:array,@[DTLocalizedString(@"視頻認證", nil)],@[DTLocalizedString(@"小視頻", nil),DTLocalizedString(@"相薄", nil)],@[DTLocalizedString(@"設定", nil)], nil];
                        
                    }
                    

                }
                
                
                [_tableView reloadData];
                
                
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
    
        return 1;
    }
    NSArray *array = self.nameArray[section - 1];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if(indexPath.section == 0){
    
        static NSString *identifire = @"cellIDOne";
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil] lastObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accoutLabel.text = [NSString stringWithFormat:@"賬戶：%d个鑽石",self.model.deposit];
        cell.profitLabel.text =  cell.detailTextLabel.text = [NSString stringWithFormat:@"收入：%d个聊币",self.model.income];
        cell.contentView.backgroundColor = Color_Cell;
        [cell.accoutBtn addTarget:self action:@selector(accoutAC) forControlEvents:UIControlEventTouchUpInside];
        [cell.profitBtn addTarget:self action:@selector(profitAC) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    
    }
    static NSString *identifire = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifire];
        UIImageView *iV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59.5,kScreenWidth, .5)];
        iV.backgroundColor = [MyColor colorWithHexString:@"#f0f0f0"];
        iV.tag = 100;
        [cell.contentView addSubview:iV];
    }
    UIImageView *iv = (UIImageView *)[cell.contentView viewWithTag:100];
    if (indexPath.section != 0 && indexPath.row == 0) {
        
        iv.hidden = NO;
        
        
        
    }else{
    
        if (self.model.auth == 2) {
            if (indexPath.section ==1 && indexPath.row == 1) {
                iv.hidden = NO;
            }else{
            
                iv.hidden = YES;
            }
        }else{

        iv.hidden = YES;
            
        }
    }
    
    cell.contentView.backgroundColor = Color_Cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.nameArray[indexPath.section - 1][indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = Color_Text_black;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = Color_Text_gray;
    
    if([LXUserDefaults boolForKey:ISMEiGUO]){
        
        if(indexPath.section == 6){
            
            if (indexPath.row == 0) {
                
                cell.detailTextLabel.text = @"请输入5位邀請碼,即可获得奖励";
            }else{
                
                cell.detailTextLabel.text = @"填入好友的分享的邀請碼，即可获奖励";
            }
            
        }else if (indexPath.section == 1){
            
            if (indexPath.row == 0) {
                
                if(self.model.auth == 0){
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:DTLocalizedString(@"未认证", nil)];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    
                }else if (self.model.auth == 1){
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:DTLocalizedString(@"认证中", nil)];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    
                }else if (self.model.auth == 2){
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:DTLocalizedString(@"認證成功", nil)];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    
                }else{
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:DTLocalizedString(@"認證失敗", nil)];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                
            }else if(indexPath.row == 1){
                
                Charge *charge;
                for (Charge *mo in self.model.charges) {
                    if (mo.uid == self.model.charge) {
                        charge = mo;
                    }
                }
                cell.detailTextLabel.text = charge.name;
                
                
            }else if(indexPath.row == 2){
                
                NSArray *array = [InputCheck getpreferOptions];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",array[self.model.preferOnlineOption],array[self.model.preferOfflineOption]];
                
            }
            
            
        }else if(indexPath.row == 3){
            
            if (indexPath.row == 0) {
                
                cell.detailTextLabel.text = @"上传小視頻，就有机会上精选";
                
            }else{
                
                cell.detailTextLabel.text = @"";
            }
        }

        
    }else{
        
        if(indexPath.section == 1){
            
            if (indexPath.row == 0) {
                
                cell.detailTextLabel.text = @"邀請好友，即可獲得獎勵";
            }else{
                
                cell.detailTextLabel.text = @"填入邀請碼，即可獲得獎勵";
            }
            
        }else if (indexPath.section == 2){
            
            if (indexPath.row == 0) {
                
                if(self.model.auth == 0){
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:DTLocalizedString(@"未认证", nil)];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    
                }else if (self.model.auth == 1){
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:DTLocalizedString(@"认证中", nil)];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    
                }else if (self.model.auth == 2){
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:DTLocalizedString(@"認證成功", nil)];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    
                }else{
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:DTLocalizedString(@"認證失敗", nil)];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                
            }else if(indexPath.row == 1){
                
                Charge *charge;
                for (Charge *mo in self.model.charges) {
                    if (mo.uid == self.model.charge) {
                        charge = mo;
                    }
                }
                cell.detailTextLabel.text = charge.name;
                
                
            }else if(indexPath.row == 2){
                
                NSArray *array = [InputCheck getpreferOptions];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",array[self.model.preferOnlineOption],array[self.model.preferOfflineOption]];
                
            }
            
            
        }else if(indexPath.row == 3){
            
            if (indexPath.row == 0) {
                
                cell.detailTextLabel.text = @"上传小視頻，就有机会上精选";
                
            }else{
                
                cell.detailTextLabel.text = @"";
            }
        }

        
        
    }

    
    return cell;
    
    
}

- (void)accoutAC
{

    AccountVC *vc = [[AccountVC alloc] init];
    vc.deposit = self.model.deposit;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)profitAC{

    ProfitVC *vc = [[ProfitVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.model == nil) {
        return;
    }
    
    
    if([LXUserDefaults boolForKey:ISMEiGUO]){
    
            if (indexPath.section == 1 && indexPath.row == 0) {
            
            
            if (self.model.auth == 0) {
                //未认证
                VideoRZVC *vc = [[VideoRZVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (self.model.auth == 1){
                //认证中
                
                
            }else if (self.model.auth == 2){
                //認證成功
                VideoRZResultVC *vc = [[VideoRZResultVC alloc] init];
                vc.sucuress = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
                //認證失敗
                VideoRZResultVC *vc = [[VideoRZResultVC alloc] init];
                vc.sucuress = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        
        if (indexPath.section == 1 && indexPath.row == 1) {
            
            
            SetPriceVC *vc = [[SetPriceVC alloc] init];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        if (indexPath.section == 1 && indexPath.row == 2) {
            
            //在線時段
            [self crpickerBG];
            
            [UIView animateWithDuration:0.33 animations:^{
                self.pickerBG.frame = CGRectMake(0, kScreenHeight - 266, kScreenWidth, 266);
                self.maskView.hidden = NO;
                
            } completion:^(BOOL finished) {
                
                
            }];
            
        }
        
        //视屏秀
        if (indexPath.section == 2 && indexPath.row == 0) {
            
            MyVideoVC *vc = [[MyVideoVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        //相薄
        if(indexPath.section == 2 && indexPath.row == 1){
            
            MyalbumVC *vc = [[MyalbumVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        if (indexPath.section == 3) {
            
            SettingVC *vc = [[SettingVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }

    
    }else{
    //邀请有奖
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        InvitationVC *vc = [[InvitationVC alloc] init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    //接受邀请
    if (indexPath.section == 1 && indexPath.row == 1) {
       
        AcceptVC *vc = [[AcceptVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

        
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {

        
        if (self.model.auth == 0) {
            //未认证
            VideoRZVC *vc = [[VideoRZVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (self.model.auth == 1){
            //认证中
            
            
        }else if (self.model.auth == 2){
            //認證成功
            VideoRZResultVC *vc = [[VideoRZResultVC alloc] init];
            vc.sucuress = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            //認證失敗
            VideoRZResultVC *vc = [[VideoRZResultVC alloc] init];
            vc.sucuress = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        
        
            SetPriceVC *vc = [[SetPriceVC alloc] init];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
            
            }
    
    if (indexPath.section == 2 && indexPath.row == 2) {

        //在線時段
        [self crpickerBG];

        [UIView animateWithDuration:0.33 animations:^{
            self.pickerBG.frame = CGRectMake(0, kScreenHeight - 266, kScreenWidth, 266);
            self.maskView.hidden = NO;

        } completion:^(BOOL finished) {
        

        }];
        
    }
    
    //视屏秀
    if (indexPath.section == 3 && indexPath.row == 0) {
        
        MyVideoVC *vc = [[MyVideoVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    //相薄
    if(indexPath.section == 3 && indexPath.row == 1){
    
        MyalbumVC *vc = [[MyalbumVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
    if (indexPath.section == 4) {
        
        SettingVC *vc = [[SettingVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    }
    
}

- (void)clickImage
{
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:@[self.model.photo] currentImageIndex:0];
//    browser.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    browser.browserStyle = XLPhotoBrowserStyleIndexLabel; // 微博样式
//    browser.indexLabel.hidden = YES;
    
    
    // 設定长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
    [browser setActionSheetWithTitle:DTLocalizedString(@"个人封面", nil) delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:DTLocalizedString(@"拍照", nil),DTLocalizedString(@"从手机相薄选择", nil),DTLocalizedString(@"保存图片", nil),nil];
}


#pragma mark  -  XLPhotoBrowserDelegate

- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    // do something yourself
    switch (actionSheetindex) {
        case 0: // 拍照
        {
            [self CreameAction:1];
            [browser dismiss];
        }
            break;
        case 1: // 从手机相薄选择
        {
            [self CreameAction:2];
            [browser dismiss];

        }
            break;
        case 2: // 保存图片
        {
            [browser saveCurrentShowImage];

        }
            break;
       
        default:
        {
            
        }
            break;
    }
}

- (void)resetScrollView
{
   
}

////拍照的点击事
- (void)CreameAction:(NSInteger )index{
    
    static NSUInteger sourceType;
    
    if (index ==1) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if(index ==2){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // 跳转到相机或相薄页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [_tableView reloadData];
        NSData *imageData = UIImageJPEGRepresentation(image, .3);
        
        NSDictionary *params;
        [WXDataService postImage:Url_account params:params imageName:@"photo" fileData:imageData finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    
                    self.model.photo = result[@"data"][@"photo"];
                    [self.tableView reloadData];
                    
                }      //请求失败
                if ([[result objectForKey:@"result"] integerValue] == 1) {
                    
                    [SVProgressHUD showErrorWithStatus:DTLocalizedString(@"网络失败", nil)];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                    });
                    
                }
            }
            
            
        } errorBlock:^(NSError *error) {
            
        }];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)personalAC:(id)sender {
    
    FixpersonalVC *vc = [[FixpersonalVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)tap:(id)sender {
    
   
}

- (IBAction)setAC:(id)sender {
    
    SettingVC *vc = [[SettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)fixAC:(id)sender {
    
    FixpersonalVC *vc = [[FixpersonalVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}


@end















