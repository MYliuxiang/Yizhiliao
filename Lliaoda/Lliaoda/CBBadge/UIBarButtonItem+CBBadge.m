//
//  UIBarButtonItem+CBBadge.m
//  CBBadgeView
//
//  Created by 陈彬 on 2017/9/14.
//  Copyright © 2017年 chenb. All rights reserved.
//

#import "UIBarButtonItem+CBBadge.h"
#import "UIView+CBBadge.h"

@implementation UIBarButtonItem (CBBadge)
#pragma mark - badge
- (void)setCb_badge:(CBBadge *)cb_badge {
    [self bottomView].cb_badge = cb_badge;
}

- (CBBadge *)cb_badge {
    return [self bottomView].cb_badge;
}

#define CBLog(fmt, ...) NSLog((@"类名:%@ 方法:%s 第%d行" fmt),NSStringFromClass([self class]),__func__,__LINE__,##__VA_ARGS__)

#pragma mark - 获取Badge的父视图
- (UIView *)bottomView {
    // UIBarButtonItem的Badge所在父视图为:UIImageView
    UIView *navigationButton = [self valueForKey:@"_view"];
//    NSLog(@"%@",navigationButton.subviews);
    CBLog(@"%@",navigationButton.subviews);
    for (UIView *subView in navigationButton.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UIImageView")]) {
            subView.layer.masksToBounds = NO;
            return subView;
        }
    }
    return navigationButton;
}
@end
