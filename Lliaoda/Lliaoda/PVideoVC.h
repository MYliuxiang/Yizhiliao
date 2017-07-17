//
//  PVideoVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/7.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonModel.h"
#import "SelectedModel.h"
#import "VideoPlayVC.h"
#import "MyVideoCell.h"

@interface PVideoVC : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,retain) PersonModel *pmodel;
@property (nonatomic,retain) SelectedModel *model;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic,retain) NSMutableArray *dataList;


@end
