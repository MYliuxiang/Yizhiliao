//
//  ProfitVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "ProfitVC.h"

@interface ProfitVC ()

@end

@implementation ProfitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.text = @"收入";
    self.dataList = @[@"通話收入",@"禮物及紅包收入",@"總收入",@"可提現總收入"];
    self.tixianBtn.layer.cornerRadius = 22.5;
    self.tixianBtn.layer.masksToBounds = YES;
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifire = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifire];
        
    }
    
    cell.textLabel.text = self.dataList[indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.textColor = Color_Text_black;
        cell.detailTextLabel.textColor = Color_Text_gray;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.video];

    }else if (indexPath.row == 1){
        
        cell.textLabel.textColor = Color_Text_black;
        cell.detailTextLabel.textColor = Color_Text_gray;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.gift];
    
    }else if(indexPath.row == 2){
    
        cell.textLabel.textColor = Color_Text_black;
        cell.detailTextLabel.textColor = Color_Text_gray;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.extractable];

    }else{
    
        cell.textLabel.textColor = Color_nav;
        cell.detailTextLabel.textColor = Color_nav;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",self.model.settled];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.top = cell.detailTextLabel.top + 1;
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (IBAction)tixianAC:(id)sender {
}
@end
