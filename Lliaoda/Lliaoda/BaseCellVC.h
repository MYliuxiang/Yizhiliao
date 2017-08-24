//
//  BaseCellVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/22.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCellVC : UIViewController

@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL fingerIsTouch;
@property (nonatomic,retain) UIScrollView *scrollview;

@end
