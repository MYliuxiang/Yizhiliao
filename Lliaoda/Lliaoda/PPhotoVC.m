//
//  PPhotoVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/7.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "PPhotoVC.h"

@interface PPhotoVC ()

@end

@implementation PPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"相薄");
    [self addrightImage:@"dengdeng"];

    self.dataList = [NSMutableArray array];
    _layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _layout.minimumLineSpacing= 10;
    _layout.minimumInteritemSpacing= 10;
    _layout.itemSize = CGSizeMake((kScreenWidth - 41) / 3.0,(kScreenWidth - 40) / 3.0 );
    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];//滚动方向
    
    //設定代理
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(10,10, 10, 10);
    [_collectionView registerNib:[UINib nibWithNibName:@"MyalbumCell" bundle:nil] forCellWithReuseIdentifier:@"MyalbumCellID"];
    _collectionView.backgroundColor = Color_bg;
    
    [self _loadData];
    
}

- (void)_loadData
{
    NSDictionary *params;
    params = @{@"type":@"photo",@"uid":self.model.uid};
    [WXDataService requestAFWithURL:Url_accountmedia params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                [self.dataList removeAllObjects];
                NSArray *array = result[@"data"];
                for (NSDictionary *dic in array) {
                    AlbumModel *model = [AlbumModel mj_objectWithKeyValues:dic];
                    [self.dataList addObject:model];
                }
                
                [self.collectionView reloadData];
                
                
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
    MyalbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyalbumCellID" forIndexPath:indexPath];
        cell.bgImageView.tag = indexPath.row + 100;
    cell.photo = self.dataList[indexPath.row];
    cell.isFirst = NO;
    [cell setNeedsLayout];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        NSMutableArray *images = [NSMutableArray array];
        for (Photo *model in self.dataList) {
            [images addObject:model.url];
        }
        // 加载网络图片
        NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
        int i = 0;
        for(i = 0;i < self.dataList.count ;i++)
        {
            Photo *model = self.dataList[i];
            UIImageView *imageView = [self.view viewWithTag:i + 100];
            MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
            browseItem.bigImageUrl = model.url;// 加载网络图片大图地址
            browseItem.smallImageView = imageView;// 小图
            [browseItemArray addObject:browseItem];
        }
        MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:indexPath.row];
        //    bvc.isEqualRatio = NO;// 大图小图不等比时需要設定这个属性（建议等比）
        [bvc showBrowseViewController];
    
}

- (void)rightAction
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:LXSring(@"舉報") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:nil message:LXSring(@"请选择舉報类型") preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSString *nickName = self.model.nickname;
        
        NSString *str = [NSString stringWithFormat:LXSring(@"你正在舉報%@"),nickName];
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color_Text_lightGray range:NSMakeRange(0, 5)];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(5, str.length - 5)];
        [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str.length)];
        [alertController1 setValue:alertControllerStr forKey:@"_attributedTitle"];
        
        UIAlertAction *aletAction1 = [UIAlertAction actionWithTitle:LXSring(@"广告欺骗") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self jubaoWithtype:0];
            
        }];
        
        UIAlertAction *aletAction2 = [UIAlertAction actionWithTitle:LXSring(@"淫秽色情") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self jubaoWithtype:1];
            
        }];
        
        UIAlertAction *aletAction3 = [UIAlertAction actionWithTitle:LXSring(@"政治反动") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self jubaoWithtype:2];
            
        }];
        
        UIAlertAction *aletAction4 = [UIAlertAction actionWithTitle:LXSring(@"其他") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self jubaoWithtype:3];
            
        }];
        
        UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:LXSring(@"取消") style:UIAlertActionStyleCancel handler:nil];
        
        [cancelAction1 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
        [aletAction1 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
        [aletAction2 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
        [aletAction3 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
        [aletAction4 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
        
        [alertController1 addAction:aletAction1];
        [alertController1 addAction:aletAction2];
        [alertController1 addAction:aletAction3];
        [alertController1 addAction:aletAction4];
        [alertController1 addAction:cancelAction1];
        [self presentViewController:alertController1 animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LXSring(@"取消") style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
    [defaultAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
    
    
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)jubaoWithtype:(int)type
{
    
    
    NSDictionary *params;
    params = @{@"uid":self.model.uid,@"kind":[NSString stringWithFormat:@"%d",type]};
    
    [WXDataService requestAFWithURL:Url_report params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                
                [SVProgressHUD showSuccessWithStatus:LXSring(@"舉報成功")];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
            } else{    //请求失败
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


@end
