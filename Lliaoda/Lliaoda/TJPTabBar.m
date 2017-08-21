//
//  TJPTabBar.m
//  TJPYingKe
//
//  Created by Walkman on 2016/12/7.
//  Copyright © 2016年 AaronTang. All rights reserved.
//

#import "TJPTabBar.h"

@interface TJPTabBar()
@property (nonatomic, weak) UIButton * centerBtn;



@end

@implementation TJPTabBar


#pragma mark - lazy
//- (UIButton *)centerBtn {
//    if (!_centerBtn) {
//        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [centerButton setImage:[UIImage imageNamed:@"faxian_h"] forState:UIControlStateNormal];
//        [centerButton addTarget:self action:@selector(centerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [centerButton sizeToFit];
//        [self addSubview:centerButton];
//        _centerBtn = centerButton;
//    }
//    return _centerBtn;
//}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupInit];
        
    }
    return self;
}

- (void)setupInit {
    //设置样式 取出边线
    self.barStyle = UIBarStyleBlack;
    self.backgroundImage = [UIImage imageNamed:@"tabbar_bg"];
    self.tintColor=Color_Tab;

    
}


- (void)centerButtonClicked {
    if (self.centerBtnClickBlock) {
        self.centerBtnClickBlock();
    }
}

//布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];

    NSInteger count = self.items.count;
    
    //确定单个控件大小
    CGFloat buttonW = self.width / count;
    CGFloat buttonH = self.height;
    CGFloat tabBarBtnY = 0;
    
    int tabBarBtnIndex = 0;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            if (tabBarBtnIndex == count / 2) {
                
                subView.centerX = self.width * 0.5;
                subView.frame = CGRectMake((self.width - buttonW) / 2.0, self.height - 70 - 5, buttonW, 70);
                }else{
            
                    
                CGFloat btnX = tabBarBtnIndex * buttonW;
                subView.frame = CGRectMake(btnX, tabBarBtnY, buttonW, buttonH);
            }
            tabBarBtnIndex ++;

           
        }
        
    }
    
    /****    设置中间按钮frame   ****/
    
}

//设置允许交互的区域     方法返回的view为处理事件最合适的view
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (!self.isHidden) {
        //转换坐标到中间按钮,生成一个新的点
        CGPoint pointInCenterBtn = [self convertPoint:point toView:self.centerBtn];
        //判断  如果该点是在中间按钮,那么处理事件最合适的View,就是这个button
        if ([self.centerBtn pointInside:pointInCenterBtn withEvent:event]) {
            return self.centerBtn;
        }
        return view;
    }
    return view;
    
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    
//    //转换坐标到中间按钮,生成一个新的点
//    CGPoint pointInCenterBtn = [self convertPoint:point toView:self.centerBtn];
//    
//    CGPoint middleBtnCenter = CGPointMake(40, 40);
//    
//    //pow函数 pow(x,y)  其作用是计算x的y次方
//    //sqrt函数是C语言中的平方根函数
//    
//    //计算出距离
//    CGFloat distance = sqrt(pow(pointInCenterBtn.x - middleBtnCenter.x, 2) + pow(pointInCenterBtn.y - middleBtnCenter.y, 2));
//    //判断该触摸事件是否能够响应
//    if (pointInCenterBtn.y < 3.5 || (distance > 40 && pointInCenterBtn.y < 18)) {
//        return NO;
//    }
//    
//    return YES;
//}





@end
