//
//  ProfitVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "FundModel.h"

@interface ProfitVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *tixianBtn;
- (IBAction)tixianAC:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain)NSArray *dataList;
@property (nonatomic,retain)FundModel *model;

@end
