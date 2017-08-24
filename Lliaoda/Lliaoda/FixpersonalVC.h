//
//  FixpersonalVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "FixNickNameVC.h"
#import "FixintroduceVC.h"
#import "Mymodel.h"
#import "PersonalDataCell.h"
#import "FixIndustryVC.h"
typedef NS_ENUM(NSInteger, PickerType) {
    PickerSex,
    PickerDate,
    PickerPlace
};
@interface FixpersonalVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,retain)NSArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) UIImage *headerImage;
@property (nonatomic, strong)UIDatePicker *datePicker;//时间选择器
@property (nonatomic,retain) Mymodel *model;
@property (nonatomic, strong)UIPickerView *picker;//地址选择器
@property (nonatomic,assign) PickerType type;

@property (nonatomic, strong)NSString *cityTitle;
@property (nonatomic, strong)NSString *provinceTitle;
@property (nonatomic, strong)NSString *countrieTitle;
@property (nonatomic, strong)NSArray *provinces;//省
@property (nonatomic, strong)NSArray *citys;//市
@property (nonatomic, strong)NSArray *countries;//市

@property (nonatomic,retain)UIPickerView *sexPicker;
@property (nonatomic,retain)NSArray *sexDatalist;
@property (nonatomic, retain)CityTool *tool;


@property (nonatomic, retain) NSArray *imagesArr;


@end
