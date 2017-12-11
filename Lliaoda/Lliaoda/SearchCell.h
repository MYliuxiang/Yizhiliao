//
//  SearchCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/12/8.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (nonatomic, strong) SelectedModel *model;
+ (SearchCell *)tableView:(UITableView *)tableView
                    model:(SelectedModel *)model
                indexPath:(NSIndexPath *)indexPath;
@end
