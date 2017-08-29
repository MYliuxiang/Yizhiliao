//
//  LxVideoTableViewCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVideoCell.h"
#import "PersonModel.h"
#import "AcceptVC.h"

@interface LxVideoTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,retain) NSArray *dataList;
@property (nonatomic,retain) UIViewController *vc;
@property (nonatomic,retain) PersonModel *model;


@end
