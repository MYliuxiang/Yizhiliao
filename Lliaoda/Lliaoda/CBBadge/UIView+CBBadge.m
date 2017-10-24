//
//  UIView+BadgeValue.m
//  6-22 cell多选
//
//  Created by Apple on 2017/8/23.
//  Copyright © 2017年 com.bingo.com. All rights reserved.
//

#import "UIView+CBBadge.h"
#import <objc/runtime.h>

@implementation UIView (CBBadge)
#pragma mark - **************** badge
static const char CBBadgeKey = '\0';
- (void)setCb_badge:(CBBadge *)cb_badge {
    if (cb_badge != self.cb_badge) {
        [self.cb_badge removeFromSuperview];
        [self addSubview:cb_badge];
        // 切换视图层次
        [self bringSubviewToFront:cb_badge];
        cb_badge.center = CGPointMake(self.frame.size.width-8, 8);
        // 存储新的
        [self willChangeValueForKey:@"cb_badge"]; // KVO
        objc_setAssociatedObject(self, &CBBadgeKey,
                                 cb_badge, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"cb_badge"]; // KVO
    }
}

- (CBBadge *)cb_badge {
    return objc_getAssociatedObject(self, &CBBadgeKey);
}

@end
