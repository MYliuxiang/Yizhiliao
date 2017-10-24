//
//  UIBarButtonItem+CBBadge.h
//  CBBadgeView
//
//  Created by 陈彬 on 2017/9/14.
//  Copyright © 2017年 chenb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBBadge.h"

@interface UIBarButtonItem (CBBadge)
@property (nonatomic, strong)CBBadge *cb_badge;

- (UIView *)bottomView;
@end
