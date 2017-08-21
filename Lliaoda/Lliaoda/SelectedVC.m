//
//  SelectedVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "SelectedVC.h"
#import "SelectedCell.h"
#import "SelectedHeader.h"
#import "PersonalVC.h"

@interface SelectedVC ()

@end

@implementation SelectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.text = LXSring(@"精選");
    
    _flowlayout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _flowlayout.minimumLineSpacing= 15;
    _flowlayout.minimumInteritemSpacing= 15;
    _flowlayout.itemSize = CGSizeMake((kScreenWidth - 45) / 2.0,(kScreenWidth - 45) / 2.0 + 45);
    [_flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];//滚动方向
    
    //設定代理
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 15, 5, 15);
    [_collectionView registerNib:[UINib nibWithNibName:@"SelectedCell" bundle:nil] forCellWithReuseIdentifier:@"SelectedCellID"];
    [_collectionView registerNib:[UINib nibWithNibName:@"SelectedHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID"];
//    [_collectionView registerNib:[UINib nibWithNibName:@"SelectedBannersHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID1"];
    [_collectionView registerClass:[SelectedBannersHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID1"];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    
    self.dataList = [NSMutableArray array];
    self.tDataList = [NSMutableArray array];
    self.bannersArray = [NSMutableArray array];
    self.bannersTitlesArray = [NSMutableArray array];
    self.bannersImagesArray = [NSMutableArray array];
    self.bannersLinksArray = [NSMutableArray array];
       
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downLoad)];
     _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoad)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downLoad1)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoad1)];
    self.tableView.hidden = YES;
    self.collectionView.hidden = YES;
    [self isZhuBo];
    
}


- (void)isZhuBo
{
    
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                self.model = [Mymodel mj_objectWithKeyValues:result[@"data"]];
                if (self.model.auth == 2) {
                    [LXUserDefaults setObject:@"1" forKey:itemNumber];
                    [LXUserDefaults synchronize];
                    self.tableView.hidden = NO;
                    self.collectionView.hidden = YES;
                    [_tableView.mj_header beginRefreshing];
                    
                }else{
                    [LXUserDefaults setObject:@"2" forKey:itemNumber];
                    [LXUserDefaults synchronize];
                    self.tableView.hidden = YES;
                    self.collectionView.hidden = NO;
                    [_collectionView.mj_header beginRefreshing];
                }
                
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


////下啦刷新
- (void)downLoad
{
    _isdownLoad = YES;
    _begin = 0;
    [self.bannersImagesArray removeAllObjects];
    [self.bannersTitlesArray removeAllObjects];
    [self.bannersLinksArray removeAllObjects];
    [self _loadData];
    
}

//上啦加载
- (void)upLoad
{
    _isdownLoad = NO;
    [self _loadData];
    
}

- (void)_loadData
{
    NSDictionary *params;
    
    if(_isdownLoad){
    
        params = @{@"begin":[NSString stringWithFormat:@"%d",_begin],@"count":@"11"};
        
    }else{
        
        params = @{@"begin":[NSString stringWithFormat:@"%d",_begin],@"count":@"10"};
    
    }
    
    [WXDataService requestAFWithURL:Url_recommend params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
       
        if(result){
            NSLog(@"%@",result[@"message"]);
            if (_isdownLoad) {
                
                _begin += 11;
                
            }else{
                
                _begin += 10;
                
            }
            NSDictionary *dic = result;
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSMutableArray *marray = [NSMutableArray array];
                NSArray *array = dic[@"data"][@"broadcasters"];
                NSArray *array1 = dic[@"data"][@"banners"];
                for (NSDictionary *subDic in array) {
                    SelectedModel *model = [SelectedModel mj_objectWithKeyValues:subDic];
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
                    self.dataList = marray;
                    
                    LxCache *lxcache = [LxCache sharedLxCache];
                    [lxcache setCacheData:result WithKey:Url_recommend];
                    
                } else {
                    
                    [self.dataList addObjectsFromArray:marray];
                }
                
                if ([dic[@"data"][@"page"][@"remain"] intValue] == 0) {
                    //没有更多了
                    if (_isdownLoad) {
                        
                        [_collectionView.mj_header endRefreshing];

                    }
                    
                    [_collectionView.mj_footer endRefreshingWithNoMoreData];
                    [_collectionView reloadData];



                }else{
                    
                    //还有更多
                    if (_isdownLoad) {
                        
                        [_collectionView.mj_header endRefreshing];
                        [_collectionView.mj_footer resetNoMoreData];
                    } else {
                        
                        [_collectionView.mj_footer endRefreshing];
                        [_collectionView.mj_footer resetNoMoreData];
                    }
                    [_collectionView reloadData];

                }
                
                
            }else{
            
            //请求失败
            
                if (_isdownLoad){
                    
                    [_collectionView.mj_header endRefreshing];
                    
                }else{
                    
                    [_collectionView.mj_footer endRefreshing];
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
            [_collectionView.mj_header endRefreshing];
        } else {
            [_collectionView.mj_footer endRefreshing];
        }
        
    }];

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

#pragma mark - UITabelView Delegate

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
            static NSString *identifire = @"cellID1";
            UserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:nil options:nil] lastObject];
                
            }
            
            cell.model = self.tDataList[indexPath.row - 1];
            return cell;
        }
        
        
    }
    
    static NSString *identifire = @"cellID1";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:nil options:nil] lastObject];
        
    }
    
    cell.model = self.tDataList[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (self.bannersArray.count == 0) {
        return 0;
//    }
//    return SCREEN_W / 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bannersArray.count > 0) {
        if (indexPath.row == 0) {
            return SCREEN_W / 2;
        }
    }
    return 90;

}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    SelectedBannersHeader *headerView = [[SelectedBannersHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W / 2)];
//    headerView.linksArray = self.bannersLinksArray;
//    headerView.titlesArray = self.bannersTitlesArray;
//    headerView.imagesArray = self.bannersImagesArray;
//    
//    return headerView;
//}


#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.bannersArray.count == 0) {
        if (self.dataList.count == 0) {
            
            return 0;
        }
        
        return self.dataList.count - 1;
    } else {
        return self.dataList.count;
    }
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果有闲置的就拿到使用,如果没有,系统自动的去创建
    SelectedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectedCellID" forIndexPath:indexPath];
    if (self.bannersArray.count == 0) {
        cell.model = self.dataList[indexPath.row + 1];
    } else {
        cell.model = self.dataList[indexPath.row];
    }
    
    [cell setNeedsLayout];
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{

    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){

        if (self.bannersArray.count == 0) {
            SelectedHeader *_heardView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID" forIndexPath:indexPath];
            if (self.dataList.count != 0) {
                _heardView.model = self.dataList[0];
                
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
            [_heardView addGestureRecognizer:tap];
            reusableview = _heardView;
        } else {
        
            SelectedBannersHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID1" forIndexPath:indexPath];
            headerView.linksArray = self.bannersLinksArray;
            headerView.titlesArray = self.bannersTitlesArray;
            headerView.imagesArray = self.bannersImagesArray;
            reusableview = headerView;
        }
       

       }
    

    return reusableview;

}

- (void)tap
{
    PersonalVC *vc = [[PersonalVC alloc] init];
    vc.model = self.dataList[0];
    [self.navigationController pushViewController:vc animated:YES];

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (self.bannersArray.count == 0) {
        if (self.dataList.count == 0) {
            
            return CGSizeMake(0, 0);
        }
        CGSize size= CGSizeMake(kScreenWidth, kScreenWidth);
        return size;
    } else {
        
        CGSize size= CGSizeMake(kScreenWidth, kScreenWidth / 2);
        return size;
    }
    

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bannersArray.count == 0) {
        PersonalVC *vc = [[PersonalVC alloc] init];
        vc.model = self.dataList[indexPath.row + 1];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        PersonalVC *vc = [[PersonalVC alloc] init];
        vc.model = self.dataList[indexPath.row];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
