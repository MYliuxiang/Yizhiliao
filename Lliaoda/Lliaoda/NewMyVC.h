//
//  NewMyVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "NewMyCell.h"
#import "MyVideoVC.h"
#import "MyalbumVC.h"
#import "FixpersonalVC.h"
#import "SetHeaderImageVC.h"
typedef NS_ENUM(NSInteger, MyType) {
    MyTypeVideo,
    MyTypePhoto,
    MyTypeMessage,
    MyTypeError
};

@interface NewMyVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,retain) Mymodel *model;
- (IBAction)editAc:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (nonatomic,assign) BOOL ishud;
@property (weak, nonatomic) IBOutlet UIView *seltedView;
- (IBAction)videoAC:(UIButton *)sender;
- (IBAction)photoAC:(UIButton *)sender;
- (IBAction)messageAC:(UIButton *)sender;

@property (nonatomic,retain) NSMutableArray *nameArray;
@property (nonatomic,retain) NSMutableArray *messagePhotos;
@property (nonatomic,retain) NSMutableArray *contents;

@property (nonatomic,retain) UIView *lineView;
@property (nonatomic,assign) MyType cellType;

@property (nonatomic,retain)NSArray *videoDataList;
@property (nonatomic,retain) NSArray *photoDataList;

@property (nonatomic,retain) MyVideoVC *videoVC;
@property (nonatomic,retain) MyalbumVC *photoVC;

- (IBAction)fixProtaitAC:(id)sender;

@property (nonatomic, strong)UIPickerView *startPK;//地址选择器
@property (nonatomic, strong)UIPickerView *endPK;//地址选择器
@property (nonatomic, strong)UIView *pickerBG;//选择器底
@property (nonatomic, retain) UIView *maskView;
@end
