//
//  ServiceErrorType.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/27.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ErrorType) {
    FANHUIONE,                  // 过期
    FANHUITWO,                 // 注销
};
@interface ServiceErrorType : NSObject


+ (void)dealWithErrorType:(ErrorType)type;



@end



