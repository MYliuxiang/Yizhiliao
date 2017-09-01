//
//  AccountPayTypeVC.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "AccountPayTypeCell.h"
#import "WXApi.h"
#import <PassKit/PassKit.h>
#import <AddressBook/AddressBook.h>
#import <StoreKit/StoreKit.h>
@interface AccountPayTypeVC : BaseViewController<UITableViewDelegate, UITableViewDataSource, AccountPayTypeCellDelegate>
{
    Mymodel *myModel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *depositCount;
@property (nonatomic,retain) Mymodel *model;
@property (nonatomic, retain) AccountModel *accountModel;
@property (nonatomic, copy) NSString *orderReferee;
@property (nonatomic,assign) int deposit;
@property (nonatomic,copy) void(^clickBlock)(void);
@property (nonatomic,assign) BOOL isCall;
@end
