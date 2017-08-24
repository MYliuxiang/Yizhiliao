//
//  ProfitCell1.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/22.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfitCell1;
@protocol ProfitCell1Delegate <NSObject>

- (void)cashButtonAC;

@end
@interface ProfitCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *yueLabel;
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
- (IBAction)cashBtnClick:(id)sender;
@property (nonatomic, assign) id<ProfitCell1Delegate>delegate;
+ (ProfitCell1 *)tableView:(UITableView *)tableView
                 indexPath:(NSIndexPath *)indexPath
                  delegate:(id<ProfitCell1Delegate>)delegate;
@end
