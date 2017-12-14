//
//  SearchVC.m
//  Lliaoda
//
//  Created by 小牛 on 2017/12/8.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "SearchVC.h"
#import "SearchCell.h"
@interface SearchVC ()

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.dataList = [NSMutableArray array];
    self.nav.backgroundColor = Color_Tab;
    [self.backButtton setImage:[UIImage imageNamed:@"back_bai"] forState:UIControlStateNormal];
    self.searchView.hidden = NO;
    [self addrighttitleString:LXSring(@"搜索")];
    _nilLabel.text = LXSring(@"对不起，暂时没有匹配到ID或昵称");
//    self.searchTextField.placeholder = LXSring(@"请输入主播ID或者名字");
    [self.rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)loadData {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.searchTextField.text, @"text", nil];
    [WXDataService requestAFWithURL:Url_hostSearch params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSArray *datas = result[@"data"];
                for (NSDictionary *dic in datas) {
                    SelectedModel *model = [[SelectedModel alloc] initWithDataDic:dic];
                    [self.dataList addObject:model];
                }
                if (self.dataList.count == 0) {
                    self.tableView.hidden = YES;
                    self.nilView.hidden = NO;
                } else {
                    self.tableView.hidden = NO;
                    self.nilView.hidden = YES;
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectedModel *model;
    if (indexPath.row < self.dataList.count) {
        model = self.dataList[indexPath.row];
    }
    return [SearchCell tableView:tableView
                           model:model
                       indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LxPersonVC *vc = [[LxPersonVC alloc] init];
    vc.model = self.dataList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)rightAction {
    [self.view endEditing:YES];
    [self.dataList removeAllObjects];
    if (self.searchTextField.text.length != 0) {
        [self loadData];
    }
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
