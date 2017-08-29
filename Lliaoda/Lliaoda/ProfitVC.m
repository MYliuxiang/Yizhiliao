//
//  ProfitVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "ProfitVC.h"

@interface ProfitVC ()<ProfitCellDelegate, ProfitCell1Delegate>

@end

@implementation ProfitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.nav.backgroundColor = [UIColor clearColor];
    self.titleLable.textColor = [UIColor whiteColor];
    [self.backButtton setImage:[UIImage imageNamed:@"back_bai"] forState:UIControlStateNormal];
    self.text = LXSring(@"收益");
    self.view.backgroundColor = UIColorFromRGB(0x00ddcc);
//    self.dataList = @[LXSring(@"通话收益"),LXSring(@"礼物及红包收益"),LXSring(@"总收益"),LXSring(@"可提现总收益")];
//    self.dataList = @[LXSring(@"通话收益"),LXSring(@"礼物及红包收益"),LXSring(@"总收益"),LXSring(@"邀请"),LXSring(@"可提现总收益")];
    self.dataList = @[LXSring(@"通話收益"),LXSring(@"禮物及紅包收益"),LXSring(@"储值提成收益"),LXSring(@"邀請")];
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"id"]){
        self.dataList = @[LXSring(@"通話收益"),LXSring(@"禮物及紅包收益"),LXSring(@"邀請")];
    }else{
        self.dataList = @[LXSring(@"通話收益"),LXSring(@"禮物及紅包收益"),LXSring(@"储值提成收益"),LXSring(@"邀請")];
    }
    self.tixianBtn.layer.cornerRadius = 22.5;
    self.tixianBtn.layer.masksToBounds = YES;
    self.tixianBtn.backgroundColor = UIColorFromRGB(0xFB3476);
    [self.tixianBtn setTitle:LXSring(@"去提现") forState:UIControlStateNormal];
    [self loadData];
}

- (void)loadData
{
    
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_accountfund params:params httpMethod:@"GET" isHUD:YES  isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                self.model = [FundModel mj_objectWithKeyValues:result[@"data"]];
                self.footerView.width = kScreenWidth;
                self.footerView.height = 125;
                self.tableView.tableFooterView = self.footerView;
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
        NSLog(@"%@",error);
               
    }];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark --------UITableView Delegete----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataList.count;
//    if (section == 1) {
//        NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
//        if ([lang hasPrefix:@"id"]){
//            return 3;
//        }else{
//            return 4;
//        }
//        
//    } else {
//        return 1;
//    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        ProfitCell1 *cell = [ProfitCell1 tableView:tableView
                                         indexPath:indexPath
                                          delegate:self];
        cell.yueLabel.text = [NSString stringWithFormat:@"%d",self.model.extractable];
        cell.yueLabel.adjustsFontSizeToFitWidth = YES;
        return cell;
    } else if (indexPath.row == 4) {
        ProfitCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfitCell3"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfitCell3" owner:self options:nil] lastObject];
        }
        cell.countLabel.text = [NSString stringWithFormat:@"%d",self.model.income];
        return cell;
    } else {
        ProfitCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfitCell2"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfitCell2" owner:self options:nil] lastObject];
        }
        cell.bgView.layer.cornerRadius = 5;
        if (indexPath.row == 1) {
            cell.leftLabel.text = LXSring(@"通話收益");
            cell.leftImageView.image = [UIImage imageNamed:@"tonghuashouyi"];
            cell.countLabel.text = [NSString stringWithFormat:@"%d",self.model.video];
        } else if (indexPath.row == 2) {
            cell.leftLabel.text = LXSring(@"禮物收益");
            cell.leftImageView.image = [UIImage imageNamed:@"liwushouyi"];
            cell.countLabel.text = [NSString stringWithFormat:@"%d",self.model.gift];
        } else if (indexPath.row == 3) {
            cell.leftLabel.text = LXSring(@"邀請收益");
            cell.leftImageView.image = [UIImage imageNamed:@"yaoqingshouyi"];
            cell.countLabel.text = [NSString stringWithFormat:@"%d",self.model.share];
        }
        return cell;
    }
    
    
    
//    if (indexPath.section == 0) {
//        ProfitCell *cell = [ProfitCell tableView:tableView
//                                       indexPath:indexPath
//                                        delegate:self];
//        cell.countLabel.text = [NSString stringWithFormat:@"%d",self.model.extractable];
//        cell.tixianButton.layer.cornerRadius = 20;
//        cell.tixianButton.layer.borderWidth = 1;
//        cell.tixianButton.layer.borderColor = [UIColor whiteColor].CGColor;
//        return cell;
//    } else if (indexPath.section == 1) {
//        static NSString *identifire = @"cellID";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifire];
//            
//        }
//        
//        cell.textLabel.text = self.dataList[indexPath.row];
//        if (indexPath.row == 0) {
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.video];
//        }else if (indexPath.row == 1){
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.gift];
//        }else if(indexPath.row == 2){
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.order];
//
//        }else{
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.share];
//        }
//        cell.textLabel.textColor = Color_Text_black;
//        cell.detailTextLabel.textColor = Color_nav;
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
//        cell.detailTextLabel.top = cell.detailTextLabel.top + 1;
//        
//        return cell;
//
//    } else {
//        static NSString *identifire = @"cellID";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifire];
//        }
//        cell.textLabel.text = LXSring(@"累計提現");
//        cell.textLabel.textColor = Color_Text_black;
//        cell.detailTextLabel.textColor = Color_nav;
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.income];
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
//        return cell;
//    }
    
    
//    static NSString *identifire = @"cellID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifire];
//        
//    }
//    
//    cell.textLabel.text = self.dataList[indexPath.row];
//    if (indexPath.row == 0) {
//        cell.textLabel.textColor = Color_Text_black;
//        cell.detailTextLabel.textColor = Color_Text_gray;
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.video];
//
//    }else if (indexPath.row == 1){
//        
//        cell.textLabel.textColor = Color_Text_black;
//        cell.detailTextLabel.textColor = Color_Text_gray;
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.gift];
//    
//    }else if(indexPath.row == 2){
//    
//        cell.textLabel.textColor = Color_Text_black;
//        cell.detailTextLabel.textColor = Color_Text_gray;
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.income];
//
//    } else if (indexPath.row == 3) {
//        cell.textLabel.textColor = Color_Text_black;
//        cell.detailTextLabel.textColor = Color_Text_gray;
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.share];
//    } else{
//    
//        cell.textLabel.textColor = Color_nav;
//        cell.detailTextLabel.textColor = Color_nav;
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.extractable];
//    }
//    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
//    cell.detailTextLabel.top = cell.detailTextLabel.top + 1;
//    
//    return cell;
//    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 0;
//    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 2) {
//        return 0;
//    }
//    return 10;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 195 + 64;
    } else if (indexPath.row == 4) {
        return 100;
    }
    return 90;
//    if (indexPath.section == 0) {
//        return 200;
//    }
//    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (IBAction)tixianAC:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LXSring(@"提現") message:LXSring(@"提現相關事宜，請聯繫客服\n微信：yizhiliao2017") delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

#pragma mark - ProfitCellDelegate
- (void)btnClick:(ProfitCell *)cell {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LXSring(@"提現") message:LXSring(@"提現相關事宜，請聯繫客服\n微信：yizhiliao2017") delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

#pragma mark - ProfitCell1Delegate
- (void)cashButtonAC {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LXSring(@"提現") message:LXSring(@"提現相關事宜，請聯繫客服\n微信：yizhiliao2017") delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}
@end
