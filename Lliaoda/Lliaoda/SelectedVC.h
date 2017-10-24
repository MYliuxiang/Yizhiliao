//
//  SelectedVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"


@interface SelectedVC : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
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
