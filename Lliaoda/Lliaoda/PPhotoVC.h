//
//  PPhotoVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/7.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonModel.h"
#import "SelectedModel.h"
#import "MyalbumCell.h"
#import "MSSBrowseDefine.h"


@interface PPhotoVC : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,retain) PersonModel *pmodel;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic,retain) SelectedModel *model;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,retain) NSMutableArray *dataList;

@end
