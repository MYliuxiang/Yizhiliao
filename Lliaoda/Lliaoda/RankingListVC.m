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
    [self creatUI];
    
    
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

@end
