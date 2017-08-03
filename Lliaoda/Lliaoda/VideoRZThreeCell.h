//
//  VideoRZThreeCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMVideoPlayController.h"

@interface VideoRZThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
- (IBAction)playAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgeView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end
