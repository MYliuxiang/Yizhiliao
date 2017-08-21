//
//  PersonBottomCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *huoyueLabel;
@property (weak, nonatomic) IBOutlet UILabel *laiziLabel;
@property (weak, nonatomic) IBOutlet UILabel *hangyeLabel;
@property (weak, nonatomic) IBOutlet UILabel *qianmingLabel;
@property (weak, nonatomic) IBOutlet UILabel *chumoLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
+ (PersonBottomCell *)tableView:(UITableView *)tableView
                      indexPath:(NSIndexPath *)indexPath;
@end
