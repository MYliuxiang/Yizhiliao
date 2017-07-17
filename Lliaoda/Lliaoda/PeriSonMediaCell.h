//
//  PeriSonMediaCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/7.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaCell.h"
#import "MyVideoCell.h"
#import "PersonModel.h"
#import "MSSBrowseDefine.h"
#import "VideoPlayVC.h"
#import "SelectedModel.h"
#import "PPhotoVC.h"
#import "PVideoVC.h"


typedef enum : NSInteger {
    PhotoType = 0,
    VideoType,
} MediaType;


@interface PeriSonMediaCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
- (IBAction)photoClick:(id)sender;
- (IBAction)videoClick:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic,assign) MediaType type ;
@property (nonatomic,retain) PersonModel *model;
@property (nonatomic,retain) SelectedModel *smodel;
@property (weak, nonatomic) IBOutlet UIImageView *videoIV;
@property (nonatomic,retain) NSArray *dataList;
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;

@end
