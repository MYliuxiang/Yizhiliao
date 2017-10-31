//
//  BannerView.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/22.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BannerView.h"

@implementation BannerView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

-(SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        CGRect frame = CGRectMake(15, 15, kScreenWidth - 30, (kScreenWidth - 30) / 690 * 230);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:nil];
        [_cycleScrollView setPageControlAliment:SDCycleScrollViewPageContolAlimentRight];
        [_cycleScrollView setPageControlStyle:SDCycleScrollViewPageContolStyleAnimated];
        [_cycleScrollView setPageControlDotSize:CGSizeMake(6, 6)];
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.layer.cornerRadius = 5;
        _cycleScrollView.layer.masksToBounds = YES;
         [self addSubview:self.cycleScrollView];
    }
    return _cycleScrollView;
}

/** 点击图片回调banner */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    SelectedBannersModel *model = self.list[index];
    NSString *url = model.link;
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    WebVC *vc = [[WebVC alloc] init];
    vc.urlStr = model.link;
    [[self viewController].navigationController pushViewController:vc animated:YES];
    
    
}


- (void)setList:(NSArray *)list
{
    _list = list;
    NSMutableArray *marr1 = [NSMutableArray array];
    
    for (SelectedBannersModel *model in _list) {
        [marr1 addObject:model.cover];
    }
    self.cycleScrollView.imageURLStringsGroup = marr1;

}

@end
