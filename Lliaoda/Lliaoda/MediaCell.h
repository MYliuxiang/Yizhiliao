//
//  MediaCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/7.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (nonatomic,retain) UIToolbar *toolbar;

@property (nonatomic,retain) UIVisualEffectView *effectView;
@property (nonatomic,assign) int row;

@end
