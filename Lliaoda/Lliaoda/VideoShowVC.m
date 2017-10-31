//
//  VideoShowVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoShowVC.h"
#import "VideoShowCell.h"
#import "VideoShowModel.h"

@interface VideoShowVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    int _begin;
    BOOL _isdownLoad;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property(strong,nonatomic) NSMutableArray *dataList;
@end

@implementation VideoShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = @"视频秀";
    self.dataList = [NSMutableArray array];
    [self creatCollection];
    MEntrance *rance = [[MEntrance alloc] initWithVC:self withimageName:@"qipao" withBageColor:[UIColor whiteColor]];
    [self.nav addSubview:rance];
}
- (void)creatCollection
{
    _layout.sectionInset= UIEdgeInsetsMake(15, 15, 15, 15);
    _layout.minimumLineSpacing= 15;
    _layout.minimumInteritemSpacing= 15;
    _layout.itemSize = CGSizeMake((kScreenWidth - 45) / 2.0,(kScreenWidth - 45) / 2.0 + 42);
    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];//滚动方向
    //設定代理
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView.backgroundColor = Color_bg;
    [_collectionView registerNib:[UINib nibWithNibName:@"VideoShowCell" bundle:nil] forCellWithReuseIdentifier:@"VideoShowCellID"];
//    [_collectionView registerNib:[UINib nibWithNibName:@"SelectedHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID"];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downLoad)];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoad)];
    [_collectionView.mj_header beginRefreshing];
    
}

////下啦刷新
- (void)downLoad
{
    _isdownLoad = YES;
    _begin = 0;
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
    urlStr = Url_mediavideo;
    params = @{@"begin":[NSString stringWithFormat:@"%d",_begin],@"count":@"20"};
    [WXDataService requestAFWithURL:urlStr params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        
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
                NSArray *array = dic[@"data"][@"videos"];
                marray = [VideoShowModel mj_objectArrayWithKeyValuesArray:array];
               
                
                if (_isdownLoad) {
                    self.dataList = marray;
                    LxCache *lxcache = [LxCache sharedLxCache];
                    [lxcache setCacheData:result WithKey:urlStr];
                    
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
    VideoShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoShowCellID" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    [cell setNeedsLayout];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    VideoShowModel *model = self.dataList[indexPath.row];
    OtherVideoPlayVC *vc = [[OtherVideoPlayVC alloc] init];
    PersonModel *pmodel = [[PersonModel alloc] init];
    pmodel.nickname = model.nickname;
    pmodel.uid = model.userId;
    pmodel.portrait = model.portrait;
    vc.model = pmodel;
    //播放視訊
    vc.videoUrl = [NSURL URLWithString:model.url];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
