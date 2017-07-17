//
//  IAPModel.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/7/4.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "JKDBModel.h"

@interface IAPModel : JKDBModel
@property (nonatomic,copy) NSString *receipt;
@property (nonatomic,copy) NSString *uid;

@end
