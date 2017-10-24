//
//  SelectedVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "SelectedVC.h"
#import "HotVC.h"


@interface SelectedVC ()
{
    NSArray *list;
}

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@end

@implementation SelectedVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.text = LXSring(@"精選");
    
    [self creatUI];
    
    MEntrance *rance = [MEntrance sharedManager];
    [self.nav addSubview:rance];
    
    
}

- (void)creatUI
{
    list = @[@"熱門",
             @"新人",
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2.0, 20, 100, 40) titles:list headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    _segHead.headColor = [UIColor clearColor];
    _segHead.fontScale = 1.2;
    _segHead.fontSize = 16;
    _segHead.lineScale = 0.3;
    _segHead.bottomLineColor =  [UIColor clearColor];
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 2;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.nav addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
    
}

#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        HotVC *vc = [[HotVC alloc] init];
        vc.index = i;
        [arr addObject:vc];
       
    }
    return arr;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
