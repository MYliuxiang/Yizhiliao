//
//  Charge.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/2.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Charge : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int uid;
@property (nonatomic, assign) int value;
@property (nonatomic, assign) int type;
@end
