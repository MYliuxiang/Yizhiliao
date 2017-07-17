//
//  MyalbumVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/27.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "MyalbumCell.h"
#import "AlbumModel.h"
#import "XLPhotoBrowser.h"
#import "MSSBrowseDefine.h"


@interface MyalbumVC : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic,retain) NSMutableArray *dataList;

@end
