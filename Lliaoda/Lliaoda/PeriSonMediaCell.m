//
//  PeriSonMediaCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/7.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "PeriSonMediaCell.h"

@implementation PeriSonMediaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.photoBtn setTitle:LXSring(@"相薄(23)") forState:UIControlStateNormal];
    [self.videoBtn setTitle:LXSring(@"影片(3)") forState:UIControlStateNormal];
    self.videoBtn.selected = NO;
    self.photoBtn.selected = YES;
    self.videoIV.hidden = YES;
    self.photoIV.hidden = NO;
    _layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _layout.minimumLineSpacing= 5;
    _layout.minimumInteritemSpacing= 10;
    _layout.itemSize = CGSizeMake((kScreenWidth - 45) / 4.0,(kScreenWidth - 45) / 4.0 );
    [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//滚动方向
    
    //設定代理
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0,15, 10, 15);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"MediaCell" bundle:nil] forCellWithReuseIdentifier:@"MediaCellID"];
    
}

- (void)setModel:(PersonModel *)model
{
    _model = model;
    self.type = PhotoType;
    self.dataList = _model.photos;
    [self.photoBtn setTitle:[NSString stringWithFormat: LXSring(@"相薄(%d)"),_model.photoCount] forState:UIControlStateNormal];
    [self.videoBtn setTitle:[NSString stringWithFormat: LXSring(@"影片(%d)"),_model.videoCount] forState:UIControlStateNormal];
    [_collectionView reloadData];
    
    
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"相薄(%d)",_model.photoCount]];
//    
//    [self.photoBtn setAttributedTitle:str forState:UIControlStateNormal];
//
//    NSRange strRange = {0,[str length]};
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
//    
//    [self.photoBtn setAttributedTitle:str forState:UIControlStateSelected];
    
    
}

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (self.dataList.count == 0) {
        
        return 1;
    }
    return self.dataList.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果有闲置的就拿到使用,如果没有,系统自动的去创建
    
    MediaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCellID" forIndexPath:indexPath];
    
    cell.coverImageView.tag = indexPath.row + 100;
    
    if (self.dataList.count == 0) {
        
        cell.videoImageView.hidden = YES;
        if (self.type == PhotoType) {
           
            cell.coverImageView.image = [UIImage imageNamed:@"noPhoto.jpg"];
            
        }else{
            
            cell.coverImageView.image = [UIImage imageNamed:@"noVideo.jpg"];
         
        }

        
    }else{
    if (self.type == PhotoType) {
        cell.videoImageView.hidden = YES;
        
        Photo *photo = self.dataList[indexPath.row];
        NSLog(@"%@",photo.url);
        [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:photo.url]];
        
    }else{
    
        Video *video = self.dataList[indexPath.row];
        [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:video.cover]];
        cell.videoImageView.hidden = NO;
    }
    }
    cell.row = indexPath.row;
    [cell setNeedsLayout];
       
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataList.count == 0) {
        
        return;
    }
    
    if (indexPath.row == 3) {
        if (self.type == PhotoType) {
            
            PPhotoVC *vc = [[PPhotoVC alloc] init];
            vc.pmodel = self.model;
            vc.model = self.smodel;
            [[self viewController].navigationController pushViewController:vc animated:YES];
            
        }else{
            
            PVideoVC *vc = [[PVideoVC alloc] init];
            vc.pmodel = self.model;
            vc.model = self.smodel;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        
        
        }
        
        return;
    }
    
    if (self.type == PhotoType) {
        
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
            UIImageView *imageView = [self.contentView viewWithTag:i + 100];
            MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
            browseItem.bigImageUrl = model.url;// 加载网络图片大图地址
            browseItem.smallImageView = imageView;// 小图
            [browseItemArray addObject:browseItem];
        }
        MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:indexPath.row];
        //    bvc.isEqualRatio = NO;// 大图小图不等比时需要設定这个属性（建议等比）
        [bvc showBrowseViewController];
        
    }else{
    
        Video *model = self.dataList[indexPath.row];
        
        VideoPlayVC *vc = [[VideoPlayVC alloc] init];
       
        //播放視訊
        vc.videoUrl = [NSURL URLWithString:model.url];
        [[self viewController] presentViewController:vc animated:YES completion:nil];
    
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)photoClick:(id)sender {
    
    self.photoBtn.selected = YES;
    self.videoBtn.selected = NO;
    self.videoIV.hidden = YES;
    self.photoIV.hidden = NO;
    self.type = PhotoType;
    self.dataList = self.model.photos;
    [self.collectionView reloadData];
    
}

- (IBAction)videoClick:(id)sender {
    
    self.videoIV.hidden = NO;
    self.photoIV.hidden = YES;
    self.photoBtn.selected = NO;
    self.videoBtn.selected = YES;
    self.type = VideoType;
    self.dataList = self.model.videos;
    [self.collectionView reloadData];

}
@end
