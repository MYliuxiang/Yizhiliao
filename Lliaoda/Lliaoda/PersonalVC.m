//
//  PersonalVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "PersonalVC.h"
#import <LGAlertView/LGAlertView.h>

@interface PersonalVC ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@end

@implementation PersonalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.label1.text = LXSring(@"送禮物");
    self.label2.text = LXSring(@"聊天");
    self.label3.text = LXSring(@"視頻通訊");
    self.label4.text = LXSring(@"去充值");

    self.videoBtn.layer.cornerRadius = 22;
    self.videoBtn.layer.masksToBounds = YES;
    
    self.chatBtn.layer.cornerRadius = 22;
    self.chatBtn.layer.masksToBounds = YES;

    UITapGestureRecognizer *hidRandG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRenandGift)];
    [self.blackView addGestureRecognizer:hidRandG];
    
//    [self haveVideoLoadData];
    [self _loadData];
    self.footerView.width = kScreenWidth;
    self.footerView.height = 64;
    self.footerView.frame = CGRectMake(0, kScreenHeight - 64, kScreenWidth, 64);
    [self.view addSubview:self.footerView];
    
    [self addrightImage:@"dengdeng"];
    
    CABasicAnimation*scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //transform.scale:  x轴，y轴同时按比例缩放：
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0]; //从 from
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.1]; //to
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeBackwards;
    scaleAnimation.repeatCount = HUGE_VALF;  //重复次数       from到to
    scaleAnimation.duration = 0.8;    //一次时间
    [self.hongBtn.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"]; //key -- value.
    [self _loadData1];
}

- (void)haveVideoLoadData
{
    
    NSDictionary *params;
    params = @{@"uid":self.model.uid};
    [WXDataService requestAFWithURL:Url_appconfig params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                _videoEnble = [result[@"data"][@"config"][@"videoEnabled"] boolValue];
                if (_videoEnble) {
                    
                    self.footerView.width = kScreenWidth;
                    self.footerView.height = 64;
                    self.footerView.frame = CGRectMake(0, kScreenHeight - 64, kScreenWidth, 64);
                    [self.view addSubview:self.footerView];
                    self.constraint.constant = 64;
                    [self.videoBtn setImage:[UIImage imageNamed:@"shipin_bai"] forState:UIControlStateNormal];

                    [self.videoBtn setTitle:LXSring(@"視訊通话") forState:UIControlStateNormal];
                    
                }else{
                    
                    self.footerView.width = kScreenWidth;
                    self.footerView.height = 64;
                    self.footerView.frame = CGRectMake(0, kScreenHeight - 64, kScreenWidth, 64);
                    [self.view addSubview:self.footerView];
                    self.constraint.constant = 64;
                    [self.videoBtn setImage:[UIImage imageNamed:@"liaotian"] forState:UIControlStateNormal];
                     [self.videoBtn setTitle:LXSring(@"聊天") forState:UIControlStateNormal];
                    self.constraint.constant = 64;
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


- (void)_loadData
{
    NSDictionary *params;
    params = @{@"uid":self.model.uid};
    [WXDataService requestAFWithURL:Url_accountshow params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
            
                self.pmodel = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                self.dataList = @[@[LXSring(@"20鑽/分钟")],@[LXSring(@"相薄視訊")],@[LXSring(@"聊號"),LXSring(@"地區"),LXSring(@"星座"),LXSring(@"经常出没")],@[LXSring(@"簽名檔")]];
                self.text = self.pmodel.nickname;
                Present *present = self.pmodel.presents[0];
                if ([present.type isEqualToString:@"video"]) {
                    
                    self.headerIV.hidden = NO;
                    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:present.cover]];
                }else{
                    
                    self.headerIV.hidden = YES;

                    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:present.url]];
                }
                
//                [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
                self.headerView.width = kScreenWidth;
                self.headerView.height = kScreenWidth;
                
                if(_model.state == 0){
                    
                    self.stateView.layer.borderColor = Color_Text_gray.CGColor;
                    self.stateView.layer.cornerRadius = 10;
                    self.stateView.layer.masksToBounds = YES;
                    self.stateView.layer.borderWidth = .5;
                    self.stateLabel.text = LXSring(@"离线");
                    self.stateLabel1.backgroundColor = Color_Text_gray;
                    self.stateLabel1.layer.cornerRadius = 8;
                    self.stateLabel1.layer.masksToBounds = YES;
                    self.stateView.hidden = YES;
                    self.stateLabel.hidden = YES;
                    
                }else if (_model.state == 1){
                    
                    self.stateView.hidden = YES;
                    self.stateLabel.hidden = YES;
                    self.stateView.layer.borderColor = Color_green.CGColor;
                    self.stateView.layer.cornerRadius = 10;
                    self.stateView.layer.masksToBounds = YES;
                    self.stateView.layer.borderWidth = .5;
                    self.stateLabel.text = LXSring(@"我有空");
                    self.stateLabel1.backgroundColor = Color_green;
                    self.stateLabel1.layer.cornerRadius = 8;
                    self.stateLabel1.layer.masksToBounds = YES;
                    
                }else{
                    
                    
                    self.stateView.hidden = NO;
                    self.stateLabel.hidden = NO;
                    self.stateView.layer.borderColor = Color_nav.CGColor;
                    self.stateView.layer.cornerRadius = 10;
                    self.stateView.layer.masksToBounds = YES;
                    self.stateView.layer.borderWidth = .5;
                    self.stateLabel.text = LXSring(@"忙碌");
                    self.stateLabel1.backgroundColor = Color_nav;
                    self.stateLabel1.layer.cornerRadius = 8;
                    self.stateLabel1.layer.masksToBounds = YES;
                    
                }

                
                self.tableView.tableHeaderView = self.headerView;
                                
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

- (void)rightAction
{
    
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
        
        BlackName *name = [[BlackName alloc] init];
        name.uid = self.model.uid;
        [name save];
        
        [SVProgressHUD showSuccessWithStatus:LXSring(@"拉黑成功")];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
    }];
    [lahei setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
    [alertController addAction:lahei];
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma  mark --------UITableView Delegete----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataList[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 3){
    
        static NSString *identifire = @"cellID3";
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonCell" owner:nil options:nil] lastObject];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tText.text = self.pmodel.intro;
        return  cell;
    
    }else if(indexPath.section == 1){
    
        static NSString *identifire = @"cellID1";
        PeriSonMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PeriSonMediaCell" owner:nil options:nil] lastObject];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.pmodel;
        cell.smodel = self.model;
        return  cell;
        
    }else{
    
        static NSString *identifire = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifire];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 0, 60, 60)];
            [button setImage:[UIImage imageNamed:@"xihuan_n"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"xihuan_h"] forState:UIControlStateSelected];
            [button setTitleColor:Color_nav forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            button.tag = 100;
            [button addTarget:self action:@selector(buttonAC:) forControlEvents:UIControlEventTouchUpInside];
            if (self.pmodel.like == 0) {
                
                button.selected = NO;
                
            }else{
                
                button.selected = YES;
            
            }
            [cell.contentView addSubview:button];

            
            UILabel *label = [[UILabel alloc] init];
            label.textColor = Color_nav;
            label.font = [UIFont systemFontOfSize:14];
            label.tag = 102;
            label.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:label];

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(button.left - 1, 15, .5, 30)];
            imageView.tag = 101;
            imageView.backgroundColor = Color_Text_gray;
            [cell.contentView addSubview:imageView];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageV = (UIImageView *)[cell.contentView viewWithTag:101];
        UIButton *button = (UIButton *)[cell.contentView viewWithTag:100];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:102];

        
        if (indexPath.section == 0) {
            
            label.hidden = NO;
            imageV.hidden = NO;
            button.hidden = NO;
            if (self.pmodel.like == 0) {
                button.selected = NO;
            }else{
            
                button.selected = YES;
            }
            cell.imageView.image = [UIImage imageNamed:@"zuanshi_fen"];
            
            Charge *charge;
            for (Charge *mo in self.pmodel.charges) {
                if (mo.uid == self.pmodel.charge) {
                    charge = mo;
                }
            }
            
            label.text = [InputCheck handleActiveWith:self.pmodel.lastActiveAt];
            [label sizeToFit];

            cell.textLabel.text = charge.name;
            cell.textLabel.textColor = Color_nav;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            label.frame = CGRectMake(0, 0, kScreenWidth - 70, 64);


        }else{
            
            label.hidden = YES;
            imageV.hidden = YES;
            button.hidden = YES;
            cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
            cell.textLabel.textColor = Color_Text_black;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = Color_Text_gray;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            if (indexPath.row == 0) {
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.model.uid];
            }else if(indexPath.row == 1){
                cell.detailTextLabel.text = [[CityTool sharedCityTool] getAdressWithCountrieId:self.model.country WithprovinceId:self.model.province WithcityId:self.model.city];
            }else if(indexPath.row == 2){
            
                cell.detailTextLabel.text = [InputCheck getXingzuo:[NSDate dateWithTimeIntervalSince1970:[_pmodel.birthday longLongValue] / 1000]];
            }else if(indexPath.row == 3){
             
                NSArray *array = [InputCheck getpreferOptions];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",array[self.pmodel.preferOnlineOption],array[self.pmodel.preferOfflineOption]];
                
            }
            
        }
        cell.detailTextLabel.textColor = Color_Text_gray;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        
        return cell;

    }
    
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
    if (indexPath.section == 3) {
        return [PersonCell whc_CellHeightForIndexPath:indexPath tableView:tableView];
    }
    if (indexPath.section == 1) {
        
        return (kScreenWidth - 45) / 4.0 + 44 + 10;
    }
    
    return 64;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)buttonAC:(UIButton *)sender
{
    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"亲，当前用户是您自己，不能設定讚与不讚！") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    if (sender.selected) {
        
        //設定不讚
        NSDictionary *params;
        params = @{@"uid":self.model.uid,@"state":@0};
        [WXDataService requestAFWithURL:Url_like params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    sender.selected = NO;
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
                    [sender.layer addAnimation:animation forKey:nil];

                    
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
        params = @{@"uid":self.model.uid,@"state":@1};
        [WXDataService requestAFWithURL:Url_like params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    
                    sender.selected = YES;
                    
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
                    [sender.layer addAnimation:animation forKey:nil];

                    
           long long idate = [[NSDate date] timeIntervalSince1970]* 1000;

            NSArray *contents = @[LXSring(@"帥氣的人都喜歡跟我視訊聊天！感覺你特別帥喔！"),LXSring(@"終於等到你！你再不出現，我都要發脾氣了～"),LXSring(@"讚我就是喜歡我，喜歡我就來跟我視訊聊天吧！"),LXSring(@"只點讚，不說話的人走路容易跌倒喔～"),LXSring(@"喜歡我吧？我也特別喜歡喜歡我的人呢！來視訊呀～")];
            NSString *contentStr =  contents[rand() % 5];
            NSDictionary *dic = @{@"message":@{@"messageID":[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate],
                                                  @"content":contentStr,
                                                  @"time":[NSString stringWithFormat:@"%lld",idate],
                                                  }};
                    
                    //显示自己的
                    //更新UI操作
                    NSDictionary *mdic = @{@"account":self.model.uid,@"msg":dic[@"message"],};
                    
                    NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",self.model.uid,[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];
                    if (![MessageCount findFirstByCriteria:criteria]){
                        
                        MessageCount *count = [[MessageCount alloc] init];
                        count.content = [NSString stringWithFormat:@"%@",dic[@"message"][@"content"]];
                        count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                        count.sendUid = self.model.uid;
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
                        messageModel.uid = self.model.uid;
                        messageModel.messageID = [NSString stringWithFormat:@"%@",dic[@"message"][@"messageID"]];
                        messageModel.sendUid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                        messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],self.model.uid];
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
                        params = @{@"uid":self.model.uid,@"message":content};
                        [WXDataService requestAFWithURL:Url_chatmessagesend params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
                            if ([[result objectForKey:@"result"] integerValue] == 0) {
                                [_inst messageInstantSend:self.model.uid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate]];
                            }if ([[result objectForKey:@"result"] integerValue] == 29) {
                                
                                LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"成为VIP") message:result[@"message"] style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"取消") destructiveButtonTitle:LXSring(@"获取VIP") delegate:nil];
                                lg.destructiveButtonBackgroundColor = Color_nav;
                                lg.destructiveButtonTitleColor = [UIColor whiteColor];
                                lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                                lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                                lg.cancelButtonTitleColor = Color_nav;
                                lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                                    AccountVC *vc = [[AccountVC alloc] init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                    
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
                        chatVC.sendUid = self.model.uid;
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


- (void)jubaoWithtype:(int)type
{
    
    
    NSDictionary *params;
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

- (IBAction)chatAC:(id)sender {
    
    
    if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"不能与自己聊天。") delegate:nil cancelButtonTitle:LXSring(@"確定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    LHChatVC *chatVC = [[LHChatVC alloc] init];
    chatVC.sendUid = self.model.uid;
    [self.navigationController pushViewController:chatVC animated:YES];

}

- (IBAction)hongVC:(id)sender {
    
    InvitationVC *vc = [[InvitationVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)giftBtnClick:(id)sender {
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


- (IBAction)topupBtnClick:(id)sender {
    
    AccountVC *vc = [[AccountVC alloc] init];
    vc.isCall = NO;
    vc.orderReferee = self.model.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)hideRenandGift {
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

- (IBAction)videoCall:(id)sender {
    
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


//    Charge *charge;
//    for (Charge *mo in self.pmodel.charges) {
//        if (mo.uid == self.pmodel.charge) {
//            charge = mo;
//        }
//    }
//
//    NSString *str = charge.name;
//    NSString *str1 = [NSString stringWithFormat:@"与当前用户視訊通话，每分钟需支付%@，是否继续通话",str];
//    LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"提示") message:str1 style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"取消") destructiveButtonTitle:LXSring(@"確定") delegate:nil];
//    lg.destructiveButtonBackgroundColor = [UIColor whiteColor];
//    lg.destructiveButtonTitleColor = Color_nav;
//    lg.cancelButtonFont = [UIFont systemFontOfSize:16];
//    lg.cancelButtonBackgroundColor = [UIColor whiteColor];
//    lg.cancelButtonTitleColor = Color_nav;
//    
//    
//    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str1];
//    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(16, str.length)];
//    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, str1.length)];
//    
//    lg.messageattributedText = alertControllerStr;
//    
//    lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
//        
//        
//    };
//    [lg showAnimated:YES completionHandler:nil];
    
}

- (void)videoCallAC
{
    NSDictionary *params;
    params = @{@"uid":self.model.uid};
    [WXDataService requestAFWithURL:Url_chatvideocall params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSString *channel = [NSString stringWithFormat:@"%@",result[@"data"][@"channel"]];
                VideoCallView *video = [[VideoCallView alloc] initVideoCallViewWithChancel:channel withUid:self.model.uid withIsSend:YES];
                [video show];
                
                
            }else{    //请求失败
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    
                    if ([[result objectForKey:@"result"] integerValue] == 8) {
                        
                        LGAlertView *lg = [[LGAlertView alloc] initWithTitle:LXSring(@"购买鑽石") message:LXSring(@"亲，你的鑽石不足，儲值才能继续視訊通话，是否购买鑽石？") style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:LXSring(@"取消") destructiveButtonTitle:LXSring(@"快速购买") delegate:nil];

                        lg.destructiveButtonBackgroundColor = Color_nav;
                        lg.destructiveButtonTitleColor = [UIColor whiteColor];
                        lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                        lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                        lg.cancelButtonTitleColor = Color_nav;
                        lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                            AccountVC *vc = [[AccountVC alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        };
                        [lg showAnimated:YES completionHandler:nil];
                        
                        
                    }
                    
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
    }];

}

- (IBAction)headClick:(id)sender {
    
    Present *present = self.pmodel.presents[0];
    if ([present.type isEqualToString:@"video"]) {
        
        VideoPlayVC *vc = [[VideoPlayVC alloc] init];
        //播放視訊
        vc.videoUrl = [NSURL URLWithString:present.url];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        
      
    }
}
- (IBAction)headClick1:(id)sender {
    
    Present *present = self.pmodel.presents[0];
    if ([present.type isEqualToString:@"video"]) {
        
        VideoPlayVC *vc = [[VideoPlayVC alloc] init];
        //播放視訊
        vc.videoUrl = [NSURL URLWithString:present.url];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        
        
    }
}
@end























