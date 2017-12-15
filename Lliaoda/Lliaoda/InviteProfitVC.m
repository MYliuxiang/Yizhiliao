//
//  InviteProfitVC.m
//  Lliaoda
//
//  Created by 小牛 on 2017/12/11.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "InviteProfitVC.h"
#import "InviteProfitCell.h"
#import "IntiveProfitModel.h"
@interface InviteProfitVC ()
{
    int begin;
    BOOL isdownload;
}
@end

@implementation InviteProfitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"邀请收益明细");
    _dataList = [NSMutableArray array];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(download)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upload)];

    
    [self loadData];
}

- (void)download {
    begin = 0;
    [_dataList removeAllObjects];
    isdownload = YES;
    [self loadData];
}
- (void)upload {
    [self loadData];
    isdownload = NO;
}

- (void)loadData {
    NSDictionary *params;
    params = @{@"begin":@(begin)};
    [WXDataService requestAFWithURL:Url_inviteDetail params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSDictionary *dic = result[@"data"];
                NSArray *logs = dic[@"logs"];
                for (NSDictionary *dics in logs) {
                    IntiveProfitModel *model = [IntiveProfitModel mj_objectWithKeyValues:dics];
                    begin = model.pid;
                    [_dataList addObject:model];
                }
                [_tableView reloadData];
                
                if ([dic[@"page"][@"remain"] intValue] == 0) {
                    // 没有更多
                    if (isdownload) {
                        
                        [_tableView.mj_header endRefreshing];
                        
                    }
                    
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                    [_tableView reloadData];
                } else {
                    //还有更多
                    if (isdownload) {
                        
                        [_tableView.mj_header endRefreshing];
                        [_tableView.mj_footer resetNoMoreData];
                    } else {
                        
                        [_tableView.mj_footer endRefreshing];
                        [_tableView.mj_footer resetNoMoreData];
                    }
                    [_tableView reloadData];
                }
                
                
            }else{    //请求失败
                if (isdownload){
                    
                    [_tableView.mj_header endRefreshing];
                    
                }else{
                    
                    [_tableView.mj_footer endRefreshing];
                }
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                
                
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        if (isdownload) {
            [_tableView.mj_header endRefreshing];
        } else {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntiveProfitModel *model;
    if (indexPath.row < _dataList.count) {
        model = _dataList[indexPath.row];
    }
    return [InviteProfitCell tableView:tableView indexPath:indexPath model:model];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntiveProfitModel *model;
    if (indexPath.row < _dataList.count) {
        model = _dataList[indexPath.row];
    }
//    "已经注册登陆，你已获得："  =  "已经注册登陆，你已获得：";
//    "已充值%d钻，你获得："  =  "已充值%d钻，你获得：";
    NSString *string = @"";
    if (model.categoryId == 0) {
        // 邀请
        string = LXSring(@"已经注册登陆，你已获得：");
    } else {
        // 充值
        string = [NSString stringWithFormat:LXSring(@"已充值%d钻，你获得："), model.value];
    }
    CGSize size = [self setWidth:SCREEN_W - 147 height:300 font:14 content:string];
    
    long timeSp = model.createdAt;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    NSString *string1 = [formatter stringFromDate:date];
    NSString *string2 = model.nickname;
    NSString *str = [NSString stringWithFormat:@"%@ %@", string2, string1];
    CGSize size2 = [self setWidth:SCREEN_W - 147 height:300 font:14 content:str];
    
    return size.height + 62 - 17 + size2.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IntiveProfitModel *model;
    if (indexPath.row < _dataList.count) {
        model = _dataList[indexPath.row];
    }
    begin = [model.sourceId intValue];
    LxPersonVC *vc = [[LxPersonVC alloc] init];
    vc.isFromHeader = YES;
    vc.personUID = model.sourceId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize) setWidth:(CGFloat)width height:(CGFloat)height font:(CGFloat)font content:(NSString *)content{
    UIFont *fonts = [UIFont systemFontOfSize:font];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName, nil];
    CGSize size1 = [content boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
