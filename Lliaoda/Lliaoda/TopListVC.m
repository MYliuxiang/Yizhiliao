//
//  TopListVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "TopListVC.h"
#import "RankingListCell1.h"
#import "RankingListCell2.h"
#import "RankingListCell3.h"
#import "LxPersonVCs.h"
@interface TopListVC ()

@end

@implementation TopListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navbarHiden = YES;
    _dataList = [NSMutableArray array];
    _dataList1 = [NSMutableArray array];
    if (_index == 0) {
        [self _loadTopHostsData];
    } else {
        [self _loadTopUsersData];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        TopListVC *vc = [[TopListVC alloc] init];
        vc.index = i;
        [arr addObject:vc];
        
    }
    return arr;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_index == 0) {
        return _dataList.count;
    }
    return _dataList1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectedModel *model;
    if (_index == 0) {
        model = _dataList[indexPath.row];
    } else {
        model = _dataList1[indexPath.row];
    }
    if (indexPath.row == 0) {
        RankingListCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingListCell1"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RankingListCell1" owner:self options:nil] lastObject];
            cell.bottomImage.layer.cornerRadius = 42;
            cell.headerImageView.layer.cornerRadius = 40;
        }
        
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait]];
        cell.nameLabel.text = model.nickname;
        [cell setNeedsLayout];
        return cell;
        
    } else if (indexPath.row == 1 || indexPath.row == 2) {
        RankingListCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingListCell2"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RankingListCell2" owner:self options:nil] lastObject];
            cell.headerImageVIew.layer.cornerRadius = 25;
            cell.bottomImage.layer.cornerRadius = 27;
        }
        
        if (indexPath.row == 1) {
            cell.countLabel1.text = @"2";
            cell.countLabel2.text = @"No.2";
            cell.yinguanImage.image = [UIImage imageNamed:@"yinguan"];
            cell.yindaiImage.image = [UIImage imageNamed:@"yindai"];
            cell.bottomImage.backgroundColor = UIColorFromRGB(0xe3e3e3);
            cell.headerImageVIew.layer.borderColor = UIColorFromRGB(0xe3e3e3).CGColor;
            
        } else if (indexPath.row == 2) {
            cell.countLabel1.text = @"3";
            cell.countLabel2.text = @"No.3";
            cell.yinguanImage.image = [UIImage imageNamed:@"tongguan"];
            cell.yindaiImage.image = [UIImage imageNamed:@"tongdai"];
            cell.bottomImage.backgroundColor = UIColorFromRGB(0xdcc7ac);
            cell.headerImageVIew.layer.borderColor = UIColorFromRGB(0xdcc7ac).CGColor;
        }
        [cell.headerImageVIew sd_setImageWithURL:[NSURL URLWithString:model.portrait]];
        cell.nameLabel.text = model.nickname;
        [cell setNeedsLayout];
        return cell;
        
    } else {
        RankingListCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingListCell3"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RankingListCell3" owner:self options:nil] lastObject];
            cell.headerImageView.layer.cornerRadius = 25;
        }
        cell.countLabel.text = [NSString stringWithFormat:@"No.%ld", indexPath.row + 1];
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait]];
        cell.nameLabel.text = model.nickname;
        
        [cell setNeedsLayout];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 165;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectedModel *model;
    if (_index == 0) {
        model = _dataList[indexPath.row];
    } else {
        model = _dataList1[indexPath.row];
    }
    LxPersonVCs *vc = [[LxPersonVCs alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_loadTopHostsData
{
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_topHosts params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSDictionary *dics = result;
                NSArray *data = dics[@"data"];
                for (NSDictionary *dic in data) {
                    SelectedModel *model = [[SelectedModel alloc] initWithDataDic:dic];
                    [_dataList addObject:model];
                }
                [_tableView reloadData];
                
            } else {
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

- (void)_loadTopUsersData
{
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_topUsers params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSDictionary *dics = result;
                NSArray *data = dics[@"data"];
                for (NSDictionary *dic in data) {
                    SelectedModel *model = [[SelectedModel alloc] initWithDataDic:dic];
                    [_dataList1 addObject:model];
                }
                [_tableView reloadData];
            } else {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
