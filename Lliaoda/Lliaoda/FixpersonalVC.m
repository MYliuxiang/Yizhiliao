//
//  FixpersonalVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "FixpersonalVC.h"

@interface FixpersonalVC ()

@property (nonatomic, strong)UIView *pickerBG;//选择器底

@end

@implementation FixpersonalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"個人資料");
    self.dataList = @[@[LXSring(@"大頭貼"),LXSring(@"暱稱"),LXSring(@"聊號"),],@[LXSring(@"性别"),LXSring(@"生日"),LXSring(@"地區")],@[LXSring(@"簽名檔")]];
    self.sexDatalist = @[LXSring(@"女"),LXSring(@"男")];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    [self crpickerBG];

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.33 animations:^{
        self.pickerBG.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 256);
    } completion:^(BOOL finished) {
        
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

}

- (void)crpickerBG {
    
    _pickerBG = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight, kScreenWidth, 216 + 50)];
    _pickerBG.backgroundColor = [UIColor whiteColor];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    toolView.backgroundColor = [UIColor whiteColor];
    [_pickerBG addSubview:toolView];
    
    
    //確定按钮
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, 0,50,50)];
    cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancel setTitleColor:Color_nav forState:UIControlStateNormal];
    [cancel setTitle:LXSring(@"保存") forState:UIControlStateNormal];
    [toolView addSubview:cancel];
    [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //取消按钮
    UIButton *enter = [[UIButton alloc]initWithFrame:CGRectMake(10, 0,50,50)];
    enter.titleLabel.font = [UIFont systemFontOfSize:14];
    [enter setTitleColor:Color_nav forState:UIControlStateNormal];
    [enter setTitle:@"取消" forState:UIControlStateNormal];
    [toolView addSubview:enter];
    [enter addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 216)];;
    //指定显示的区域模式   传一个国家的代号
   
    _datePicker.locale=[NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
    //指定一个显示的模式:我们只用到时间
    _datePicker.datePickerMode=UIDatePickerModeDate;
    if (self.model.birthday) {
        
        [_datePicker setDate:[NSDate dateWithTimeIntervalSince1970:22 * 365 * 24 * 60 * 60]];
        
    }else{
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.birthday / 1000];
        [_datePicker setDate:date];

    }
    [_pickerBG addSubview:_datePicker];
    [self.view addSubview:_pickerBG];
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 216)];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    NSInteger rowProvince = 0;
    CountrieModel *model = self.countries[rowProvince];
    [self refrshOfProvincsWithCountriesKey:model.uid];
    NSInteger rowCity = 0;
    ProvinceModel *pmodel = self.provinces[rowCity];
    [self refrshOfCityWithCountriesKey:model.uid WithProvincsKey:pmodel.uid];
    [self setIndexWithCountrieId:self.model.country WithprovinceId:self.model.province WithcityId:self.model.city];
    [_pickerBG addSubview:self.picker];
    [self.view addSubview:_pickerBG];
    
    
    self.sexPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 216)];
    self.sexPicker.dataSource = self;
    self.sexPicker.delegate = self;
    [_pickerBG addSubview:self.sexPicker];

    
    
}

- (void)setIndexWithCountrieId:(int)countrieId
                WithprovinceId:(int)provinceId
                    WithcityId:(int)cityId
{
    BOOL isSet = false;
    for(int i = 0;i<self.countries.count;i++){
        CountrieModel *model = self.countries[i];
        if (model.uid == countrieId) {
            self.provinces = model.provinces;
            [self.picker selectRow:i inComponent:0 animated:NO];
            
            for (int j = 0; j < self.provinces.count; j++) {
                ProvinceModel *pmodel = self.provinces[j];
                if (pmodel.uid == provinceId) {
                    
                    self.citys = pmodel.cities;
                    [self.picker selectRow:j inComponent:1 animated:NO];
                    
                    for (int m = 0; m < self.citys.count; m++) {
                        CityModel *cmodel = self.citys[m];
                        if (cmodel.uid == cityId) {
                            
                            [self.picker selectRow:m inComponent:2 animated:NO];
                            isSet = YES;
                        }
                    }

                }
            }
            
        }
    
    
    }
    if (!isSet) {
        
        [self.picker selectRow:0 inComponent:0 animated:NO];
        [self.picker selectRow:0 inComponent:1 animated:NO];
        [self.picker selectRow:0 inComponent:2 animated:NO];
        
    }

}

- (NSArray *)countries {
    if (!_countries) {
       
        self.tool = [CityTool sharedCityTool];
        self.countries = self.tool.countrys;
    }
    return _countries;
}

- (NSArray *)compareKeys:(NSArray *)keys {
    NSArray *array = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *a = (NSString *)obj1;
        NSString *b = (NSString *)obj2;
        int aNum = [a intValue];
        int bNum = [b intValue];
        
        if (aNum > bNum) {
            return NSOrderedDescending;
        }
        else if (aNum < bNum){
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    NSLog(@"%@",array);
    return array;
    
}


//刷新省
- (void)refrshOfProvincsWithCountriesKey:(int)countriesKey {
    
    NSArray *array;
    for (CountrieModel *model in self.countries) {
        if (model.uid == countriesKey) {
            
            array = model.provinces;

        }
    }
    
       if (array.count > 0) {
        self.provinces = array;
    } else {
        self.provinces = @[];
    }
    
    
}

//刷新市
- (void)refrshOfCityWithCountriesKey:(int)countriesKey
                     WithProvincsKey:(int)provincsKey
{
    
    NSArray *array;
    for (CountrieModel *model in self.countries) {
        if (model.uid == countriesKey) {
            
            array = model.provinces;
            
        }
    }
    
    if (array.count > 0) {
        self.provinces = array;
    } else {
        self.provinces = @[];
    }
    
    NSArray *array1;
    for (ProvinceModel *model1 in self.provinces) {
        if (model1.uid == provincsKey) {
            
            array1 = model1.cities;
            
        }
    }
    
    if (array.count > 0) {
        self.citys = array1;
    } else {
        self.citys = @[];
    }

    
}

//字体大小
- (CGFloat)fontWithString:(NSString *)string {
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat font = 0;
    for (int i = 17; i > 0; i--) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:i]};
        CGSize rect = [string sizeWithAttributes:attributes];
        if (rect.width <= width) {
            font = (CGFloat)i;
            break;
        }
    }
    return font;
}


#pragma mark pickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.picker) {
        return 3;

    }else{
    
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == self.picker) {
    if (component == 0) {
        return self.countries.count;
    }else if (component == 1) {
        
        if ([self.provinces count] <= 0) {
            return 1;
        } else {
            return self.provinces.count;
        }
        
    } else {
        
        if ([self.citys count] <= 0) {
            return 1;
        } else {
            return self.citys.count;
        }
    }
    }else{
    
        return self.sexDatalist.count;
    
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    if (pickerView == self.picker) {

    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
    UILabel *myView = nil;
    if (component == 0) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        CountrieModel *model = self.countries[row];
        myView.text = model.name;
        myView.font = [UIFont systemFontOfSize:[self fontWithString:myView.text]];         //用label来設定字体大小
        myView.backgroundColor = [UIColor clearColor];
    }else if (component == 1){
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30)];
        ProvinceModel *model = self.provinces[row];
        myView.text = [self.provinces count] ? model.name : @"";
        myView.textAlignment = NSTextAlignmentCenter;
        myView.font = [UIFont systemFontOfSize:[self fontWithString:myView.text]];
        myView.backgroundColor = [UIColor clearColor];
        if ([self.citys count] <= 0) {
            myView.userInteractionEnabled = NO;
        } else {
            myView.userInteractionEnabled = YES;
        }
    } else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30)];
        CityModel *model = self.citys[row];
        myView.text = [self.citys count] ? model.name : @"";
        myView.textAlignment = NSTextAlignmentCenter;
        myView.font = [UIFont systemFontOfSize:[self fontWithString:myView.text]];
        myView.backgroundColor = [UIColor clearColor];
        if ([self.citys count] <= 0) {
            myView.userInteractionEnabled = NO;
        } else {
            myView.userInteractionEnabled = YES;
        }
    }
    
    return myView;
    }else{
    
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
        UILabel *myView = nil;
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = self.sexDatalist[row];
        myView.font = [UIFont systemFontOfSize:[self fontWithString:myView.text]];         //用label来設定字体大小
        myView.backgroundColor = [UIColor clearColor];
        
        return myView;
    
    }
        
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.picker) {
        
    if (component == 0) {
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        CountrieModel *model = self.countries[rowProvince];
        [self refrshOfProvincsWithCountriesKey:model.uid];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        
        ProvinceModel *pmodel = self.provinces[rowCity];
        [self refrshOfCityWithCountriesKey:model.uid WithProvincsKey:pmodel.uid];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
       
        
    }
    if (component == 1) {
        [pickerView selectRow:0 inComponent:2 animated:NO];
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        CountrieModel *model = self.countries[rowProvince];
        [self refrshOfProvincsWithCountriesKey:model.uid];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        ProvinceModel *pmodel = self.provinces[rowCity];
        [self refrshOfCityWithCountriesKey:model.uid WithProvincsKey:pmodel.uid];
        [pickerView reloadComponent:2];
        
    }
    }
    
}

#pragma mark ----------確定-------------
- (void)cancelAction:(UIButton *)sender
{
    [UIView animateWithDuration:0.33 animations:^{
        self.pickerBG.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 256);
    } completion:^(BOOL finished) {
        
        if (_type == PickerDate) {
            //选择时间
            NSDate *theDate = _datePicker.date;
           long long idate = [theDate timeIntervalSince1970] * 1000;
            if (self.model.birthday == idate) {
                return ;
            }
            NSDictionary *params;
            params = @{@"birthday":@(idate)};
            [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
                if(result){
                    if ([[result objectForKey:@"result"] integerValue] == 0) {
                        
                        self.model.birthday = idate;
                        [_tableView reloadData];

                    }else{    //请求失败
                        [SVProgressHUD showErrorWithStatus:result[@"message"]];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                        });
                        
                    }
                }
                
            } errorBlock:^(NSError *error) {
                NSLog(@"%@",error);
                    }];
            
            
        }else if(_type == PickerPlace){
        //选择地点
                        
            NSInteger rowCountry = [self.picker selectedRowInComponent:0];
            CountrieModel *model = self.countries[rowCountry];
            NSInteger rowProvince = [self.picker selectedRowInComponent:1];
            ProvinceModel *pmodel = self.provinces[rowProvince];
            NSInteger rowCity = [self.picker selectedRowInComponent:2];
            CityModel *cmodel = self.citys[rowCity];
            
      
            if (self.model.country == rowCountry && self.model.province == rowProvince && self.model.city == rowCity) {
                return ;
            }
            NSDictionary *params;
            params = @{@"country":[NSString stringWithFormat:@"%d",model.uid],@"province":[NSString stringWithFormat:@"%d",pmodel.uid],@"city":[NSString stringWithFormat:@"%d",cmodel.uid]};
            [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
                if(result){
                    if ([[result objectForKey:@"result"] integerValue] == 0) {
                        
                        self.model.country = model.uid;
                        self.model.province = pmodel.uid;
                        self.model.city = cmodel.uid;
                        [_tableView reloadData];
                        
                    } else{    //请求失败
                        [SVProgressHUD showErrorWithStatus:result[@"message"]];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                        });
                        
                    }
                }
                
            } errorBlock:^(NSError *error) {
                NSLog(@"%@",error);
                
            }];
            
            [_tableView reloadData];
        
        
        }else{
            //修改性别
            
            //选择时间
        
            NSInteger sex = [self.sexPicker selectedRowInComponent:0];
            if (self.model.gender == sex) {
                return ;
            }
            NSDictionary *params;
            params = @{@"gender":@(sex)};
            [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
                if(result){
                    if ([[result objectForKey:@"result"] integerValue] == 0) {
                        
                        self.model.gender = sex;
                        [_tableView reloadData];
                        
                    }else{    //请求失败
                        [SVProgressHUD showErrorWithStatus:result[@"message"]];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                        });
                        
                    }
                }
                
            } errorBlock:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        
        }
        
    }];
    
}

#pragma mark ----------取消-------------
- (void)enterAction:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.33 animations:^{
        self.pickerBG.frame = CGRectMake(0, self.view.height, self.view.width, 0);
    } completion:^(BOOL finished) {
        
    }];
    
}



#pragma  mark --------UITableView Delegete----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataList[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifire = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifire];
        
      UIImageView *headerImage = [[UIImageView alloc] init];
        headerImage.backgroundColor = [UIColor clearColor];
        headerImage.frame = CGRectMake(kScreenWidth - 20 - 40 - 10 - 5, 10, 40, 40);
        headerImage.layer.masksToBounds = YES;
        headerImage.layer.cornerRadius = 20;
        headerImage.tag = 100;
        [cell.contentView addSubview:headerImage];

    }
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:100];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [image sd_setImageWithURL:[NSURL URLWithString:self.model.portrait]];
        image.hidden = NO;
    }else{
    
        image.hidden = YES;
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            cell.detailTextLabel.text = @"";

        }else if(indexPath.row == 1){
        
            cell.detailTextLabel.text = self.model.nickname;

        }else{
            
            cell.detailTextLabel.text = self.model.uid;
        
        }
        
    }else if(indexPath.section == 1){
    
        if (indexPath.row == 0) {
            
            if (self.model.gender == 0) {
                cell.detailTextLabel.text = LXSring(@"女");

            }else{
            
                cell.detailTextLabel.text = LXSring(@"男");

            }
            
        }else if(indexPath.row == 1){
            
            cell.detailTextLabel.text = [InputCheck timeWithTimeIntervalString:[NSString stringWithFormat:@"%ld",self.model.birthday]
                                         withDateFormat:@"yyyy-MM-dd"];
            
        }else{
            
            cell.detailTextLabel.text = [[CityTool sharedCityTool] getAdressWithCountrieId:self.model.country WithprovinceId:self.model.province WithcityId:self.model.city];
            
        }
        
    }else{
    
        cell.detailTextLabel.text = self.model.intro;
        
    }
    cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = Color_Text_black;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = Color_Text_gray;
    cell.detailTextLabel.top = cell.detailTextLabel.top + 1;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:LXSring(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self CreameAction:1];

            
        }];
        
        UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:LXSring(@"从手机相薄选择") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self CreameAction:2];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LXSring(@"取消") style:UIAlertActionStyleCancel handler:nil];
        [cancelAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
        [defaultAction setValue:Color_nav forKey:@"_titleTextColor"];
        [defaultAction1 setValue:Color_nav forKey:@"_titleTextColor"];

        
        [alertController addAction:defaultAction];

        [alertController addAction:defaultAction1];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        //修改暱稱
        FixNickNameVC *vc = [[FixNickNameVC alloc] init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if (indexPath.section == 2) {
        //修改簽名檔
        FixintroduceVC *VC = [[FixintroduceVC alloc] init];
        VC.model = self.model;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        self.type = PickerDate;
        self.datePicker.hidden = NO;
        self.picker.hidden = YES;
        self.sexPicker.hidden = YES;
        [UIView animateWithDuration:0.33 animations:^{
            self.pickerBG.frame = CGRectMake(0, kScreenHeight - 266, kScreenWidth, 266);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    //修改性别
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        self.type = PickerSex;
        self.datePicker.hidden = YES;
        self.picker.hidden = YES;
        self.sexPicker.hidden = NO;
        [self.sexPicker selectRow:self.model.gender inComponent:0 animated:NO];
        [UIView animateWithDuration:0.33 animations:^{
            self.pickerBG.frame = CGRectMake(0, kScreenHeight - 266, kScreenWidth, 266);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        
        self.type = PickerPlace;
        self.sexPicker.hidden = YES;
        self.datePicker.hidden = YES;
        self.picker.hidden = NO;
        [UIView animateWithDuration:0.33 animations:^{
            self.pickerBG.frame = CGRectMake(0, kScreenHeight - 266, kScreenWidth, 266);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

////拍照的点击事
- (void)CreameAction:(NSInteger )index{
    
    static NSUInteger sourceType;
    
    if (index ==1) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if(index ==2){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // 跳转到相机或相薄页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{
        }];
    }
}

-(UIImage *)getSubImageWith:(UIImage *)originalImage
{
    
    CGRect cropFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    CGRect squareFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    
    CGFloat oriWidth = cropFrame.size.width;
    CGFloat oriHeight = originalImage.size.height * (oriWidth / originalImage.size.width);
    CGFloat oriX = cropFrame.origin.x + (cropFrame.size.width - oriWidth) / 2;
    CGFloat oriY = cropFrame.origin.y + (cropFrame.size.height - oriHeight) / 2;
 CGRect oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    CGRect latestFrame = oldFrame;
    
    CGFloat scaleRatio = latestFrame.size.width / originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.width / scaleRatio;
    if (latestFrame.size.width < cropFrame.size.width) {
        CGFloat newW = originalImage.size.width;
        CGFloat newH = newW * (cropFrame.size.height /cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (latestFrame.size.height < cropFrame.size.height) {
        CGFloat newH = originalImage.size.height;
        CGFloat newW = newH * (cropFrame.size.width / cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
//        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
      UIImage *image =  [self getSubImageWith:[info objectForKey:UIImagePickerControllerEditedImage]];
        
        NSData *imageData = UIImageJPEGRepresentation(image, .3);
        NSDictionary *params;
        params = @{@"private":@0};
        [SVProgressHUD showWithStatus:LXSring(@"正在上传")];
        [WXDataService requestAFWithURL:Url_storagekey params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    NSString *key = result[@"data"][@"key"];
                    NSString *secret = result[@"data"][@"secret"];
                    NSString *token = result[@"data"][@"token"];
                    NSString *endpoint = result[@"data"][@"endpoint"];
                    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:key secretKeyId:secret securityToken:token];
                    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
                    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
                    put.bucketName = result[@"data"][@"bucket"];
                    NSDate*dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval a=[dat timeIntervalSince1970];
                    int b = a;
                    NSString *timeString = [NSString stringWithFormat:@"%d",b];
                    put.objectKey = [NSString stringWithFormat:@"%@/media/%@_cover.jpg",result[@"data"][@"path"],timeString];
                    put.uploadingData = imageData; // 直接上传NSData
                    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
                    };
                    
                    OSSTask *putTask = [client putObject:put];
                    [putTask continueWithBlock:^id(OSSTask *task) {
                        if (!task.error) {
                            
                            NSLog(@"upload object success!");
                            
                        }else{
                            
                        }
                        return nil;
                    }];
                    [putTask waitUntilFinished];
                    
                    if (!putTask.error) {
                        
                        [self postPhotopath:[NSString stringWithFormat:@"%@/media/%@_cover.jpg",result[@"data"][@"path"],timeString] withImage:image];
                        
                        
                    }else{
                        
                        [SVProgressHUD showErrorWithStatus:LXSring(@"上传失败")];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                        });
                        
                    }
                    
                }else{    //请求失败
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                    });
                    
                }
                
            }
            
        } errorBlock:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];

        
//        NSData *imageData = UIImageJPEGRepresentation(image, .3);
//        
    }];
    
}

- (void)postPhotopath:(NSString *)path
                                withImage:(UIImage *)image
    {
        
        NSDictionary *params;
        params = @{@"portrait":path};
        
        [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    
                    [SVProgressHUD dismiss];
                    self.model.portrait = result[@"data"][@"portrait"];
                    [LXUserDefaults setObject:result[@"data"][@"portrait"] forKey:Portrait];
                    [LXUserDefaults synchronize];
                    [self.tableView reloadData];
                    
                } else{
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                    });
                    
                }
            }
            
        } errorBlock:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
        
        
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end








