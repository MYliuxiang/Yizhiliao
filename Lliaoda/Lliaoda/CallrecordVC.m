//
//  CallrecordVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "CallrecordVC.h"
#import "CallRecordCell.h"

@interface CallrecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain) NSMutableArray *dataList;

@end

@implementation CallrecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navbarHiden = YES;
    self.dataList = [NSMutableArray array];
    
    NSString *uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    
    NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@",uid];
    self.dataList = [CallTime findByCriteria:criteria];
    [_tableView reloadData];

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
    CallRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CallRecordCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.call = self.dataList[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CallTime *call = self.dataList[indexPath.row];
    SelectedModel *model = [[SelectedModel alloc] init];
    model.uid = [NSString stringWithFormat:@"%d",call.sendUid];
    LxPersonVCs *vc = [[LxPersonVCs alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


