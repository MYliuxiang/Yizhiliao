//
//  LxCollectionHeaderView.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LxCollectionHeaderView.h"

@implementation LxCollectionHeaderView

-(SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth - 30, (kScreenWidth - 30) / 690 * 230 - 15);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"大.jpg"]];
        [_cycleScrollView setPageControlAliment:SDCycleScrollViewPageContolAlimentRight];
        [_cycleScrollView setPageControlStyle:SDCycleScrollViewPageContolStyleAnimated];
        [_cycleScrollView setPageControlDotSize:CGSizeMake(6, 6)];
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.layer.cornerRadius = 5;
        _cycleScrollView.layer.masksToBounds = YES;
    }
    return _cycleScrollView;
}

/** 点击图片回调banner */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
 
    
}

- (void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;

    NSMutableArray *marr1 = [NSMutableArray array];
    NSMutableArray *marr2 = [NSMutableArray array];

    for (SelectedBannersModel *model in _dataList) {
        [marr1 addObject:model.cover];
    }
    _cycleScrollView.imageURLStringsGroup = marr1;
//    _cycleScrollView.titlesGroup = marray2;
}


@end
