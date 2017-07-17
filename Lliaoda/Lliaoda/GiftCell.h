//
//  GiftCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGiftModel.h"

@interface GiftCell : UICollectionViewCell

@property (nonatomic,retain)MGiftModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *giftImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zuanImage;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
