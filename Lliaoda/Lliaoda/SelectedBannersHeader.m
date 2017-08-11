//
//  SelectedBannersHeader.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/10.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "SelectedBannersHeader.h"

@implementation SelectedBannersHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}



- (void)initScrollView {
    [timer invalidate];
    timer = nil;
    
    [scrollView removeFromSuperview];
    [pageControl removeFromSuperview];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, SCREEN_W / 2)];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.width * _imagesArray.count, SCREEN_W / 2);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    for (int i = 0; i < self.imagesArray.count; i++) {
        NSString *imageUrl = _imagesArray[i];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.width, 0, self.width, SCREEN_W / 2)];
        imageView.tag = 100 + i;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        [scrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrooViewDidSelect:)];
        [imageView addGestureRecognizer:tap];
        NSLog(@"%lu", (unsigned long)self.titlesArray.count);
        if (self.titlesArray.count == self.imagesArray.count) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * self.width, SCREEN_W / 2 - 50, SCREEN_W, 20)];
            label.textColor = [UIColor redColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:17];
            label.text = self.titlesArray[i];
            label.backgroundColor = [UIColor clearColor];
            [scrollView addSubview:label];
        }
    }
    [self addSubview:scrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bottom - 20, self.width, 20)];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = pageCount;
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:pageControl];
    timeCount = 0;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
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
    

    CGRect frame = CGRectMake(timeCount * SCREEN_W, 0, self.width, self.height);
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
