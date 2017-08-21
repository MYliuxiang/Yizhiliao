//
//  PersonSelectCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonSelectCell;
@protocol PersonSelectCellDelegate <NSObject>

- (void)button1Click;
- (void)button2Click;
@end
@interface PersonSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *btnBGView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
- (IBAction)button1AC:(id)sender;
- (IBAction)button2AC:(id)sender;
+ (PersonSelectCell *)tableView:(UITableView *)tableView
                      indexPath:(NSIndexPath *)indexPath
                       delegate:(id<PersonSelectCellDelegate>)delegate;
@property (nonatomic, assign) id<PersonSelectCellDelegate>delegate;
@end
