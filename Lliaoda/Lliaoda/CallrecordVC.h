//
//  CallrecordVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"

@interface CallrecordVC : BaseViewController
@property (nonatomic,assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
