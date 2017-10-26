//
//  MEntrance.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEntrance : UIView

@property (nonatomic,retain)UIButton *btn;

@property (nonatomic,retain) UIViewController *vc;

- (instancetype)initWithVC:(UIViewController *)vc withimageName:(NSString *)imagename withBageColor:(UIColor *)color;

- (void)setBageMessageCount:(int)count;

- (void)updateBage;

@end
