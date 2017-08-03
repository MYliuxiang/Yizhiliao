//
//  ProfitCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/7/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfitCell;
@protocol ProfitCellDelegate <NSObject>

- (void)btnClick:(ProfitCell *)cell;

@end
@interface ProfitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *tixianButton;
- (IBAction)tixianBtnClick:(id)sender;
@property (nonatomic, assign) id<ProfitCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIButton *label2;

+ (ProfitCell *)tableView:(UITableView *)tableView
                indexPath:(NSIndexPath *)indexPath
                 delegate:(id<ProfitCellDelegate>)delegate;
@end
