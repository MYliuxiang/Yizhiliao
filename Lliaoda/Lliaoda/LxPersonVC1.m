//
//  NewMyVC1.m
//  Lliaoda
//
//  Created by 小牛 on 2017/10/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LxPersonVC1.h"

@interface LxPersonVC1 ()

@end

@implementation LxPersonVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headerView.height = kScreenWidth / 750 * 450;
    self.nav.hidden = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.tableView.tableHeaderView = self.headerView;
    
    [self _loadData];
    
    
}

- (void)_loadData
{
    NSDictionary *params;
//    NSString *str = [LXUserDefaults objectForKey:itemNumber];
//    if ([str isEqualToString:@"1"]) {
//        params = @{@"uid":self.model.uid};
//
//    } else {
//        params = @{@"uid":self.model.uid};
//    }
    params = @{@"uid":self.model.uid};
    [WXDataService requestAFWithURL:Url_accountshow params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                self.tableView.tableHeaderView = self.headerView;
                self.pmodel = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                self.nameLabel.text = self.pmodel.nickname;
                self.idLabel.text = [NSString stringWithFormat:@"ID：%@",self.pmodel.uid];
                CGFloat height = [self heightForText:self.pmodel.intro];
                if (height <= 30) {
                    self.headerView.height = kScreenWidth / 750 * 450 + 60 + 60;
                } else {
                    self.headerView.height = kScreenWidth / 750 * 450 + 60 + height;
                }
                if (self.pmodel.like == 0) {
//                    self.likeButton.selected = NO;
                    //                    self.likeImge.image = [UIImage imageNamed:@"xinxing_22"];
//                    self.isLike = NO;
                }else{
                    //已经点赞
//                    self.likeButton.selected = YES;
                    //                        self.likeImge.image = [UIImage imageNamed:@"xinxing_h"];
//                    self.isLike = YES;
                    
                }
//                [self.likeButton setTitle:[NSString stringWithFormat:@"%d",self.pmodel.likeCount] forState:UIControlStateNormal];
                //                self.likeLabel.text = [NSString stringWithFormat:@"%d",self.pmodel.likeCount];
                if (self.pmodel.gender == 0) {
                    
//                    self.sexImage.image = [UIImage imageNamed:@"nansheng"];
                    
                    //男
                }else{
                    
//                    self.sexImage.image = [UIImage imageNamed:@"nvsheng"];
                    
                }
                
                self.xingzuoLabel.text = [InputCheck getXingzuo:[NSDate dateWithTimeIntervalSince1970:[_pmodel.birthday longLongValue] / 1000]];
                
                self.ageLabel.text = [InputCheck dateToOld:[NSDate dateWithTimeIntervalSince1970:[_pmodel.birthday longLongValue] / 1000]];
                self.text = self.pmodel.nickname;
                
                Charge *charge;
                for (Charge *mo in self.pmodel.charges) {
                    if (mo.uid == self.pmodel.charge) {
                        charge = mo;
                    }
                }
                
//                if ([LXUserDefaults boolForKey:ISMEiGUO]){
//                    self.view3.hidden = YES;
//
//                }else{
//                    self.feiyongLbael.text = charge.name;
//                    if (self.feiyongLbael.text.length == 0) {
//                        self.view3.hidden = YES;
//                    } else {
//                        self.view3.hidden = NO;
//                    }
//                }
                
                NSMutableArray *marray = [NSMutableArray array];
//                for (Photo *photo in self.pmodel.photos) {
//                    [self.photos addObject:photo.url];
//                }
//                if (marray.count == 0 && self.pmodel.portrait != nil) {
//                    [self.photos addObject:self.pmodel.portrait];
//                }
//                self.cycleScrollView.imageURLStringsGroup = self.photos;
//
//                self.messageArray = @[LXSring(@"最近活躍"),LXSring(@"地區"),LXSring(@"行业"),LXSring(@"簽名檔"),LXSring(@"经常出没")];
//                self.messagePhotos = @[@"zuijinhuoyue",@"laizi",@"hangye",@"gexingqianming",@"jingchangchumo"];
                
                
                
                
                NSArray *array = [InputCheck getpreferOptions];
                NSString *str = [InputCheck handleActiveWith:self.pmodel.lastActiveAt];
                NSString *str1 = [[CityTool sharedCityTool] getAdressWithCountrieId:self.model.country WithprovinceId:self.model.province WithcityId:self.model.city];
                NSString *str2;
                if (self.pmodel.intro.length == 0) {
                    str2 = @"";
                }else{
                    str2 = [NSString stringWithFormat:@"%@",self.pmodel.intro];
                }
                NSString *str4;
                if (self.pmodel.domain.length == 0) {
                    str4 = @"";
                }else{
                    str4 = [NSString stringWithFormat:@"%@",self.pmodel.intro];
                }
                NSString *str3 = [NSString stringWithFormat:@"%@-%@",array[self.pmodel.preferOnlineOption],array[self.pmodel.preferOfflineOption]];
                
//                self.contentArray = @[str,str1,str4,str2,str3];
                
                Present *present = self.pmodel.presents[0];
                
                
                [_tableView reloadData];
                
                if ([self.model.uid isEqualToString:[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]]) {
//                    _tableViewBottom.constant = 0;
//                    self.footerView.hidden = YES;
                }else{
//                    _tableViewBottom.constant = 49;
//                    self.footerView.hidden = NO;
                }
                
                
                
            }else{    //请求失败
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
        
    }];
}


- (CGFloat)heightForText:(NSString *)text
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    return [text boundingRectWithSize:CGSizeMake(SCREEN_W - 140, 1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (_type == 0) {
            LxPersonAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxPersonAlbumCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"LxPersonAlbumCell" owner:self options:nil] lastObject];
            }
            return cell;
        } else {
            LxPersonVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LxPersonVideoCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"LxPersonVideoCell" owner:self options:nil] lastObject];
            }
            return cell;
        }
    }
    static NSString *iden = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)albumBtnAC:(id)sender {
}

- (IBAction)videoBtnAC:(id)sender {
}
@end
