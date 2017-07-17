//
//  AccountCell.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"

@interface AccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *valueLab;
@property (weak, nonatomic) IBOutlet UIImageView *headIG;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
- (IBAction)priceAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *givebtn;

@property (nonatomic,retain) AccountModel *model;

@end
