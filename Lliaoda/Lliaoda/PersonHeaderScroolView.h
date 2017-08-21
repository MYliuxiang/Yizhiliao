//
//  PersonHeaderScroolView.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonHeaderScroolView : UIView<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSTimer *timer;
    UIImageView *imageView;
    NSInteger timeCount;
    NSInteger pageCount;
}
//@property (retain, nonatomic) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) NSMutableArray *linksArray;
@end
