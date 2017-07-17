//
//  MyCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UIButton *profitBtn;
@property (weak, nonatomic) IBOutlet UIButton *profitImage;
@property (weak, nonatomic) IBOutlet UIImageView *fengeImage;
@property (weak, nonatomic) IBOutlet UIButton *profitBtnI;

@property (weak, nonatomic) IBOutlet UIButton *accoutBtn;

@end
