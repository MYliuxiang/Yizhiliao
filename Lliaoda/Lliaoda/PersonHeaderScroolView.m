//
//  PersonHeaderScroolView.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/21.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "PersonHeaderScroolView.h"
#define ImageWidth SCREEN_W
@implementation PersonHeaderScroolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)initScrollView {
    [timer invalidate];
    timer = nil;
    
    [scrollView removeFromSuperview];
    [pageControl removeFromSuperview];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageWidth)];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(ImageWidth * _imagesArray.count, ImageWidth);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    for (int i = 0; i < self.imagesArray.count; i++) {
        NSString *imageUrl = _imagesArray[i];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.width, 0, ImageWidth, ImageWidth)];
        imageView.tag = 100 + i;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        [scrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrooViewDidSelect:)];
        [imageView addGestureRecognizer:tap];
//        if (self.titlesArray.count == self.imagesArray.count) {
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * ImageWidth, ImageWidth / 2 - 50, SCREEN_W, 20)];
//            label.textColor = [UIColor redColor];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont systemFontOfSize:17];
//            label.text = self.titlesArray[i];
//            label.backgroundColor = [UIColor clearColor];
//            [scrollView addSubview:label];
//        }
    }
    [self addSubview:scrollView];
    
    if (self.imagesArray.count > 1) {
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bottom - 20, self.width, 20)];
        pageControl.currentPage = 0;
        pageControl.numberOfPages = pageCount;
        pageControl.pageIndicatorTintColor = [UIColor blackColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [self addSubview:pageControl];
        timeCount = 0;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViews {
    int currentPage = scrollViews.contentOffset.x / SCREEN_W;
    pageControl.currentPage = currentPage;
}

- (void)scrollImage {
    
    timeCount ++;
    if (timeCount == pageCount) {
        timeCount = 0;
    }
    pageControl.currentPage = timeCount;
    
    
    CGRect frame = CGRectMake(timeCount * SCREEN_W, 0, ImageWidth, ImageWidth);
    [scrollView scrollRectToVisible:frame animated:YES];
}


- (void)scrooViewDidSelect:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag - 100;
    if (self.linksArray.count == self.imagesArray.count) {
        NSString *url = self.linksArray[tag];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
}

- (void)setImagesArray:(NSMutableArray *)imagesArray {
    _imagesArray = imagesArray;
    pageCount = _imagesArray.count;
    //    self.cycleScrollView.imageURLStringsGroup = imagesArray;
    [self initScrollView];
    //    for (int i = 0; i < imagesArray.count; i++) {
    //        NSString *imageUrl = imagesArray[i];
    //        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    //    }
}
@end
