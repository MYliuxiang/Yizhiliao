//
//  LxVideoTableViewCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LxVideoTableViewCell.h"

@implementation LxVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
       
        _layout.minimumLineSpacing= 15;
        _layout.minimumInteritemSpacing= 15;
        _layout.itemSize = CGSizeMake((kScreenWidth - 45 - 1) / 2.0,(kScreenWidth - 45) / 2.0);
        [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];//滚动方向
    
        //設定代理
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"CVideoCell" bundle:nil] forCellWithReuseIdentifier:@"CVideoCellID"];
        _collectionView.backgroundColor = [UIColor clearColor];
    
}

- (void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    if (_dataList.count == 0) {
        
    }

}

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataList.count == 0) {
        return 1;
    }
    return self.dataList.count;

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果有闲置的就拿到使用,如果没有,系统自动的去创建
    CVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CVideoCellID" forIndexPath:indexPath];
    if(self.dataList.count == 0)
    {
        cell.himage.image = [UIImage imageNamed:@"noVideo.jpg"];
    }else{
    
        Video *video = self.dataList[indexPath.row];
        [cell.himage sd_setImageWithURL:[NSURL URLWithString:video.cover]];
    }
    [cell setNeedsLayout];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataList.count == 0) {
        return;
    }

    Video *model = self.dataList[indexPath.row];
    VideoPlayVC *vc = [[VideoPlayVC alloc] init];
    //播放視訊
    vc.videoUrl = [NSURL URLWithString:model.url];
//    [self.vc.navigationController pushViewController:vc animated:YES];
    [self.vc presentViewController:vc animated:YES completion:nil];
   
   

    
    
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
