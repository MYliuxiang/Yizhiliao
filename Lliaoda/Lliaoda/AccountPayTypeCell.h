//
//  AccountPayTypeCell.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountPayTypeCell;
@protocol AccountPayTypeCellDelegate <NSObject>

- (void)unipinAC;
- (void)huafeiAC;
- (void)appleAC;
- (void)kefuAC;

@end
@interface AccountPayTypeCell : UITableViewCell
- (IBAction)unipinBtnAC:(id)sender;
- (IBAction)huafeiBtnAC:(id)sender;
- (IBAction)appleBtnAC:(id)sender;
- (IBAction)kefuBtnAC:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *kefuLabel;
@property (weak, nonatomic) IBOutlet UILabel *appleLabel;
@property (weak, nonatomic) IBOutlet UILabel *huafeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *unipinLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, assign) id<AccountPayTypeCellDelegate>delegate;
+ (AccountPayTypeCell *)tableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                         delegate:(id<AccountPayTypeCellDelegate>)delegate;
@end
