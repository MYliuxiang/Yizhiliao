//
//  RankingListVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "RankingListVC.h"
#import "RankingListCell1.h"
#import "RankingListCell2.h"
#import "RankingListCell3.h"
@interface RankingListVC ()
{
    NSArray *list;
}

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@end

@implementation RankingListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    MEntrance *rance = [[MEntrance alloc] initWithVC:self withimageName:@"qipao" withBageColor:[UIColor whiteColor]];
    [self.nav addSubview:rance];
    [rance setBageMessageCount:50];
    [self creatUI];
    
    [self _loadData];
}

- (void)creatUI
{
    list = @[@"魅力榜",
             @"土豪榜",
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2.0, 20, 200, 40) titles:list headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutCenter];
    _segHead.headColor = [UIColor clearColor];
    _segHead.fontScale = 1.15;
    _segHead.fontSize = 16;
    _segHead.lineScale = 0.3;
    _segHead.singleW_Add = 3;
    _segHead.bottomLineColor =  [UIColor clearColor];
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 1;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.nav addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64 - 49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        TopListVC *vc = [[TopListVC alloc] init];
        vc.index = i;
        [arr addObject:vc];
        
    }
    return arr;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        RankingListCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingListCell1"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RankingListCell1" owner:self options:nil] lastObject];
        }
        return cell;
        
    } else if (indexPath.row == 1 || indexPath.row == 2) {
        RankingListCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingListCell2"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RankingListCell2" owner:self options:nil] lastObject];
        }
        cell.headerImageVIew.layer.cornerRadius = 25;
        cell.bottomImage.layer.cornerRadius = 27;
        if (indexPath.row == 1) {
            cell.countLabel1.text = @"2";
            cell.countLabel2.text = @"No.2";
            cell.yinguanImage.image = [UIImage imageNamed:@"yinguan"];
            cell.yindaiImage.image = [UIImage imageNamed:@"yindai"];
            cell.nameLabel.text = @"啊啊啊啊";
            cell.bottomImage.backgroundColor = UIColorFromRGB(0xe3e3e3);
            cell.headerImageVIew.layer.borderColor = UIColorFromRGB(0xe3e3e3).CGColor;
            
        } else if (indexPath.row == 2) {
            cell.countLabel1.text = @"3";
            cell.countLabel2.text = @"No.3";
            cell.yinguanImage.image = [UIImage imageNamed:@"tongguan"];
            cell.yindaiImage.image = [UIImage imageNamed:@"tongdai"];
            cell.nameLabel.text = @"噼噼啪啪铺";
            cell.bottomImage.backgroundColor = UIColorFromRGB(0xdcc7ac);
            cell.headerImageVIew.layer.borderColor = UIColorFromRGB(0xdcc7ac).CGColor;
        }
        return cell;
        
    } else {
        RankingListCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingListCell3"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RankingListCell3" owner:self options:nil] lastObject];
        }
        cell.countLabel.text = [NSString stringWithFormat:@"No.%ld", indexPath.row + 1];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 165;
    }
    return 100;
}

- (void)_loadData
{
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_topHosts params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        
        if(result){
            NSLog(@"%@",result);
            
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
            }
        }
    } errorBlock:^(NSError *error) {
        
        
    }];
    
}

@end
