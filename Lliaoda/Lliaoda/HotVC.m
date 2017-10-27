//
//  HotVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "HotVC.h"
#import "SelectedCell.h"
#import "PersonalVC.h"
#import "LxPersonVCs.h"
@interface HotVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    int _begin;
    BOOL _isdownLoad;
    
}

@property (nonatomic,retain) Mymodel *model;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (nonatomic,retain)NSMutableArray *dataList;
@property (nonatomic, retain) NSMutableArray *bannersArray;
@property (nonatomic, retain) NSMutableArray *bannersTitlesArray;
@property (nonatomic, retain) NSMutableArray *bannersImagesArray;
@property (nonatomic, retain) NSMutableArray *bannersLinksArray;
@property (nonatomic,retain) NSMutableArray *tDataList;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic,retain) MJRefreshBackNormalFooter *footer;

@end

@implementation HotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navbarHiden = YES;
    self.bannersArray = [NSMutableArray array];
    _flowlayout.sectionInset=UIEdgeInsetsMake(15, 15, 15, 15);
    self.view.backgroundColor = UIColorFromRGB(0xf7fcff);

    _flowlayout.minimumLineSpacing= 15;
    _flowlayout.minimumInteritemSpacing= 15;
    _flowlayout.itemSize = CGSizeMake((kScreenWidth - 45) / 2.0,(kScreenWidth - 45) / 2.0 + 45);
    [_flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];//滚动方向
//    self.isShowMessageButton = YES;
    //設定代理
    self.collectionView.showsVerticalScrollIndicator = NO;
    //    self.collectionView.contentInset = UIEdgeInsetsMake(0, 15, 5, 15);
    [_collectionView registerNib:[UINib nibWithNibName:@"SelectedCell" bundle:nil] forCellWithReuseIdentifier:@"SelectedCellID"];
   
    //    [_collectionView registerNib:[UINib nibWithNibName:@"SelectedBannersHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID1"];
    [_collectionView registerClass:[BannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID1"];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView reloadData];
    self.dataList = [NSMutableArray array];
    self.tDataList = [NSMutableArray array];
    self.bannersArray = [NSMutableArray array];
    self.bannersTitlesArray = [NSMutableArray array];
    self.bannersImagesArray = [NSMutableArray array];
    self.bannersLinksArray = [NSMutableArray array];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downLoad)];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoad)];
    [_collectionView.mj_header beginRefreshing];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HotVC *vc = [[HotVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
    
    NSString *urlStr;
    if (self.index == 0) {
        urlStr = Url_recommend;
       params = @{@"begin":[NSString stringWithFormat:@"%d",_begin],@"count":@"20"};
    }else{
        
        if(_begin == 0){
            
            params = @{@"count":@"20"};

        }else{
            SelectedModel *model = self.dataList[_begin -1];
            params = @{@"begin":@(model.updatedAt),@"count":@"20"};

            
        }
      urlStr = Url_recommendnew;
    }
    
    [WXDataService requestAFWithURL:Url_recommend params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
   
        
        if(result){
            NSLog(@"%@",result[@"message"]);
            if (_isdownLoad) {
                
                _begin += 20;
                
            }else{
                
                _begin += 20;
                
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


#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果有闲置的就拿到使用,如果没有,系统自动的去创建
    SelectedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectedCellID" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    [cell setNeedsLayout];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        if (self.bannersArray.count == 0) {
           
            reusableview = nil;
            
        } else {
            
            BannerView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID1" forIndexPath:indexPath];
            headerView.list = self.bannersArray;
            reusableview = headerView;
        }
        
    }
    
    return reusableview;
    
}

- (void)tap
{
    LxPersonVC *vc = [[LxPersonVC alloc] init];
    vc.model = self.dataList[0];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (self.bannersArray.count == 0) {
        
        CGSize size= CGSizeMake(0, 0);
        return size;
    } else {
        
        CGSize size= CGSizeMake(kScreenWidth, (kScreenWidth - 30) / 690 * 230 + 15);
        return size;
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LxPersonVCs *vc = [[LxPersonVCs alloc] init];
    vc.model = self.dataList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

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
//        self.messageCountLabel.hidden = YES;
    } else {
//        self.messageCountLabel.hidden = NO;
        if (value > 0 && value < 10) {
//            self.messageCountLabel.frame = CGRectMake(self.messageButton.right - 20, 0, 15, 15);
        } else if (value >= 10 && value < 100) {
            CGSize size = [self setWidth:300 height:15 font:10 content:string];
//            self.messageCountLabel.frame = CGRectMake(self.messageButton.right - 20, 0, size.width + 6, 15);
        } else if (value >= 100) {
            string = @"99+";
            CGSize size = [self setWidth:300 height:15 font:10 content:string];
//            self.messageCountLabel.frame = CGRectMake(self.messageButton.right - 20, 0, size.width + 6, 15);
        }
//        self.messageCountLabel.text = string;
    }
}

- (void)onMessageNoData:(NSNotification *)notification {
//    self.messageCountLabel.text = @"0";
//    self.messageCountLabel.hidden = YES;
}

#pragma mark - 根据文本内容确定label的大小
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
