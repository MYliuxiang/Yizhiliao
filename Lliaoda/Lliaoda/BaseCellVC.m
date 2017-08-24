//
//  BaseCellVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/22.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseCellVC.h"

@interface BaseCellVC ()

@end

@implementation BaseCellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        //        if (!self.fingerIsTouch) {//这里的作用是在手指离开屏幕后也不让显示主视图，具体可以自己看看效果
        //            return;
        //  }
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
    }
    
}


//#pragma mark UIScrollView
////判断屏幕触碰状态
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    self.fingerIsTouch = YES;
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    self.fingerIsTouch = NO;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (!self.vcCanScroll) {
//        scrollView.contentOffset = CGPointZero;
//    }
//    if (scrollView.contentOffset.y <= 0) {
//        //        if (!self.fingerIsTouch) {//这里的作用是在手指离开屏幕后也不让显示主视图，具体可以自己看看效果
//        //            return;
//        //        }
//        self.vcCanScroll = NO;
//        scrollView.contentOffset = CGPointZero;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
