//
//  TopListVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface TopListVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *dataList1;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,retain) SelectedModel *model;
@end
