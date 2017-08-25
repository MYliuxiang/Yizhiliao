//
//  AccountChargeCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountChargeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bigBGView;
@property (weak, nonatomic) IBOutlet UIImageView *leftTopImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *zuanImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;
- (IBAction)chargeButtonAC:(id)sender;

@end
