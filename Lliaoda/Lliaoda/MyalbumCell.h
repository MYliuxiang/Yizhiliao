//
//  MyalbumCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/27.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"
#import "PersonModel.h"
@interface MyalbumCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *feiView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,retain) AlbumModel *model;
@property (nonatomic,retain) Photo *photo;
@end
