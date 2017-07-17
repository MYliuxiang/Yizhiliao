//
//  MGiftModel.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGiftModel : NSObject
@property (nonatomic,assign) int diamonds; // 价格
@property (nonatomic,copy) NSString *icon; // 图片地址
@property (nonatomic,copy) NSString *name; // 大頭貼
@property (nonatomic,copy) NSString *uid; // 大頭貼

@end
