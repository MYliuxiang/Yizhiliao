//
//  TJPTabBar.h
//  TJPYingKe
//
//  Created by Walkman on 2016/12/7.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJPTabBar : UITabBar

/** 中间按钮点击回调*/
@property (nonatomic, copy) void(^centerBtnClickBlock)();


@end
