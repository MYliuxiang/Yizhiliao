//
//  MyVideoCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyVideoModel.h"
#import "PersonModel.h"

@interface MyVideoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *feiView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *videoIg;
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,retain) MyVideoModel *model;
@property (nonatomic,retain) Video *video;
@property (weak, nonatomic) IBOutlet UILabel *fengMLabel;

@end
