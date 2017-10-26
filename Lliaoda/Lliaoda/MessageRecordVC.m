//
//  MessageRecordVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MessageRecordVC.h"

@interface MessageRecordVC ()
{
    NSArray *list;
}

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@end

@implementation MessageRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatUI];
    
    
    
}

- (void)creatUI
{
    list = @[@"訊息",
             @"通話記錄",
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2.0, 20, 200, 40) titles:list headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    _segHead.headColor = [UIColor clearColor];
    _segHead.fontScale = 1.15;
    _segHead.fontSize = 16;
    _segHead.lineScale = 0.3;
    _segHead.bottomLineColor =  [UIColor clearColor];
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    _segScroll.scrollEnabled = NO;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.nav addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
    
}

#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    
   UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MeassageVC *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MeassageVC"];
    vc.index = 0;
    [arr addObject:vc];
    
    CallrecordVC *vc1 = [[CallrecordVC alloc] init];
    vc.index = 1;
    [arr addObject:vc1];
    return arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
