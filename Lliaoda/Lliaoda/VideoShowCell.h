//
//  VideoShowCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoShowModel.h"
@interface VideoShowCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tumbImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatrImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong) VideoShowModel *model;
@end
