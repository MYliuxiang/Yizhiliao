//
//  SelectedBannersModel.h
//  Lliaoda
//
//  Created by 小牛 on 2017/8/10.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "LXBaseModel.h"

@interface SelectedBannersModel : LXBaseModel
@property (nonatomic, assign) int ranking; // 顺序
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *cover; // 封面图片
@property (nonatomic, copy) NSString *link; // 链接地址
@property (nonatomic, assign) int target;  // 0网页跳转  1APP内跳转
@end
