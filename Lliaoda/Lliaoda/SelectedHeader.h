//
//  SelectedHeader.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedModel.h"

@interface SelectedHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UIView *stateLabel1;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *palceImageV;

@property (nonatomic,retain) SelectedModel *model;

@end
