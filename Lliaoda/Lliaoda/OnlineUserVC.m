//
//  OnlineUserVC.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/29.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "OnlineUserVC.h"

@interface OnlineUserVC ()

@end

@implementation OnlineUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageInstantReceive:) name:Notice_onMessageInstantReceive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageInstantReceive:) name:Notice_onMessageNoData object:nil];
    
    self.text = LXSring(@"在线用户");
    self.nav.backgroundColor = [UIColor whiteColor];
    self.bannersArray = [NSMutableArray array];
    self.tDataList = [NSMutableArray array];
    self.bannersArray = [NSMutableArray array];
    self.bannersTitlesArray = [NSMutableArray array];
    self.bannersImagesArray = [NSMutableArray array];
    self.bannersLinksArray = [NSMutableArray array];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downLoad1)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoad1)];
    [_tableView.mj_header beginRefreshing];
    self.isShowMessageButton = YES;
}

////下啦刷新
- (void)downLoad1
{
    _isdownLoad = YES;
    _begin = 0;
    [self.bannersArray removeAllObjects];
    [self.bannersTitlesArray removeAllObjects];
    [self.bannersImagesArray removeAllObjects];
    [self.bannersLinksArray removeAllObjects];
    [self tloadData];
    
}

//上啦加载
- (void)upLoad1
{
    _isdownLoad = NO;
    [self tloadData];
    
}

- (void)tloadData
{
    NSDictionary *params;
    
    
    params = @{@"page":[NSString stringWithFormat:@"%d",_begin]};
    
    
    
    [WXDataService requestAFWithURL:Url_recommendusers params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        
        if(result){
            NSLog(@"%@",result[@"message"]);
            
            _begin++;
            NSDictionary *dic = result;
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSMutableArray *marray = [NSMutableArray array];
                NSArray *array = dic[@"data"][@"users"];
                NSArray *array1 = dic[@"data"][@"banners"];
                for (NSDictionary *subDic in array) {
                    UserModel *model = [UserModel mj_objectWithKeyValues:subDic];
                    NSArray *blacks = [BlackName findAll];
                    BOOL isB = NO;
                    for (BlackName *black in blacks) {
                        if ([black.uid isEqualToString:model.uid]) {
                            isB = YES;
                        }
                        
                    }
                    
                    if (!isB) {
                        
                        [marray addObject:model];
                        
                    }
                    
                }
                
                for (NSDictionary *subDic in array1) {
                    SelectedBannersModel *model = [SelectedBannersModel mj_objectWithKeyValues:subDic];
                    [self.bannersArray addObject:model];
                    if (model.title == nil) {
                        [self.bannersTitlesArray addObject:@""];
                    } else {
                        [self.bannersTitlesArray addObject:model.title];
                    }
                    [self.bannersImagesArray addObject:model.cover];
                    [self.bannersLinksArray addObject:model.link];
                }
                
                if (_isdownLoad) {
                    self.tDataList = marray;
                    
                    LxCache *lxcache = [LxCache sharedLxCache];
                    [lxcache setCacheData:result WithKey:Url_recommendusers];
                    
                } else {
                    
                    [self.tDataList addObjectsFromArray:marray];
                }
                
                if ([dic[@"data"][@"page"][@"hasNext"] intValue] == 0) {
                    //没有更多了
                    if (_isdownLoad) {
                        
                        [_tableView.mj_header endRefreshing];
                        
                    }
                    
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                    [_tableView reloadData];
                    
                    
                    
                }else{
                    
                    //还有更多
                    if (_isdownLoad) {
                        
                        [_tableView.mj_header endRefreshing];
                        [_tableView.mj_footer resetNoMoreData];
                    } else {
                        
                        [_tableView.mj_footer endRefreshing];
                        [_tableView.mj_footer resetNoMoreData];
                    }
                    [_tableView reloadData];
                    
                }
                
                
            }else{
                
                //请求失败
                
                if (_isdownLoad){
                    
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
        NSLog(@"%@",error);
        
        if (_isdownLoad) {
            [_tableView.mj_header endRefreshing];
        } else {
            [_tableView.mj_footer endRefreshing];
        }
        
    }];
    
}

#pragma  mark --------UITableView Delegete----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.bannersArray.count > 0) {
        return self.tDataList.count + 1;
    }
    return self.tDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bannersArray.count > 0) {
        if (indexPath.row == 0) {
            static NSString *iden = @"cellIDS";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
                SelectedBannersHeader *headerView = [[SelectedBannersHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W / 2)];
                headerView.linksArray = self.bannersLinksArray;
                headerView.titlesArray = self.bannersTitlesArray;
                headerView.imagesArray = self.bannersImagesArray;
                [cell addSubview:headerView];
            }
            return cell;
            
        } else {
            
            UserModel *model = self.tDataList[indexPath.row - 1];
            return [OnlineUserCell tableView:tableView
                                       model:model
                                   indexPath:indexPath];
        }
        
        
    }
    UserModel *model = self.tDataList[indexPath.row];
    return [OnlineUserCell tableView:tableView
                               model:model
                           indexPath:indexPath];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bannersArray.count > 0) {
        if (indexPath.row == 0) {
            return SCREEN_W / 2;
        }
    }
    return 145;
    
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
#pragma mark - LeftView红点判断
- (void)onMessageInstantReceive:(NSNotification *)notification
{
    NSString *selfuid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    NSString *criteria = [NSString stringWithFormat:@"WHERE uid = %@",selfuid];
    NSArray *array = [MessageCount findByCriteria:criteria];
    int count = 0;
    
    for (MessageCount *mcount in array) {
        count += mcount.count;
        
    }
    [self widthString:[NSString stringWithFormat:@"%d", count]];
    
    
}

- (void)widthString:(NSString *)string {
    int value = [string intValue];
    if (value <= 0) {
        self.messageCountLabel.hidden = YES;
    } else {
        self.messageCountLabel.hidden = NO;
        if (value > 0 && value < 10) {
            self.messageCountLabel.frame = CGRectMake(self.messageButton.right - 20, 0, 15, 15);
        } else if (value >= 10 && value < 100) {
            CGSize size = [self setWidth:300 height:15 font:10 content:string];
            self.messageCountLabel.frame = CGRectMake(self.messageButton.right - 20, 0, size.width + 6, 15);
        } else if (value >= 100) {
            string = @"99+";
            CGSize size = [self setWidth:300 height:15 font:10 content:string];
            self.messageCountLabel.frame = CGRectMake(self.messageButton.right - 20, 0, size.width + 6, 15);
        }
        self.messageCountLabel.text = string;
    }
}

- (void)onMessageNoData:(NSNotification *)notification {
    self.messageCountLabel.text = @"0";
    self.messageCountLabel.hidden = YES;
}

#pragma mark - 根据文本内容确定label的大小
- (CGSize) setWidth:(CGFloat)width height:(CGFloat)height font:(CGFloat)font content:(NSString *)content{
    UIFont *fonts = [UIFont systemFontOfSize:font];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName, nil];
    CGSize size1 = [content boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size1;
}
@end
