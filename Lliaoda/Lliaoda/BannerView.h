//
//  BannerView.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/22.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedBannersModel.h"

@interface BannerView : UICollectionReusableView<SDCycleScrollViewDelegate>
@property(nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)  NSArray *list;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) NSMutableArray *linksArray;

@end
