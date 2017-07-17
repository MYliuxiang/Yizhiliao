//
//  MyVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "AccountVC.h"
#import "ProfitVC.h"
#import "SettingVC.h"
#import "SetPriceVC.h"
#import "VideoRZVC.h"
#import "VideoRZResultVC.h"
#import "Mymodel.h"
#import "XLPhotoBrowser.h"
#import "MyCell.h"
#import "AcceptVC.h"
#import "MyalbumVC.h"
#import "MyVideoVC.h"
#import "AboutVC.h"

@interface MyVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *nameArray;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (nonatomic,retain) Mymodel *model;
@property (nonatomic, strong)UIPickerView *startPK;//地址选择器
@property (nonatomic, strong)UIPickerView *endPK;//地址选择器
@property (nonatomic, strong)UIView *pickerBG;//选择器底
@property (nonatomic,retain) UIView *maskView;


- (IBAction)personalAC:(id)sender;
- (IBAction)tap:(id)sender;
- (IBAction)setAC:(id)sender;
- (IBAction)fixAC:(id)sender;

@end
