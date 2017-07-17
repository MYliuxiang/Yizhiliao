//
//  SelectedVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectedModel.h"
#import "Mymodel.h"
#import "UserCell.h"
#import "UserModel.h"


@interface SelectedVC : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
{
    int _begin;
    BOOL _isdownLoad;

}
@property (nonatomic,retain) Mymodel *model;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (nonatomic,retain)NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *tDataList;

@property (nonatomic,retain) MJRefreshBackNormalFooter *footer;

@end
