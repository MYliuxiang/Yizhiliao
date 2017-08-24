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

@interface PersonSelectCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (weak, nonatomic) IBOutlet UIView *btnBGView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (nonatomic, assign) BOOL cellCanScroll;
@property (nonatomic, copy) void (^oneAction)(int type);

- (IBAction)button1AC:(id)sender;
- (IBAction)button2AC:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contView;
+ (PersonSelectCell *)tableView:(UITableView *)tableView
                      indexPath:(NSIndexPath *)indexPath
                       delegate:(id<PersonSelectCellDelegate>)delegate;
@property (nonatomic, weak) id<PersonSelectCellDelegate>delegate;

@property (nonatomic,retain) UITableView *tableView;

@end
