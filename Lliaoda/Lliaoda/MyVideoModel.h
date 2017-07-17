//
//  MyVideoModel.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyVideoModel : NSObject

@property(nonatomic,assign) int uid;
@property (nonatomic,assign) int selected;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *cover;


@end
