//
//  SearchVC.h
//  Lliaoda
//
//  Created by 小牛 on 2017/12/8.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *nilView;
@property (weak, nonatomic) IBOutlet UILabel *nilLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end
