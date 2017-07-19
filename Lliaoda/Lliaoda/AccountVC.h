//
//  AccountVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "AccountCell.h"
#import "AccountModel.h"
#import "Mymodel.h"
#import "WXApi.h"

typedef NS_ENUM(NSInteger, PayType) {
    WeixinPay,
    AliPay,
    AppPay
};

@interface AccountVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,WXApiDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    Mymodel *myModel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic,retain)NSMutableArray *dataList;
@property (nonatomic,assign) int deposit;
@property (nonatomic,copy) void(^clickBlock)(void);
@property (nonatomic,assign) BOOL isCall;
@end
