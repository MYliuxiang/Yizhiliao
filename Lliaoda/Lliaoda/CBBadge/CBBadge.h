//
//  CBBadge.h
//  6-22 cell多选
//
//  Created by Apple on 2017/8/23.
//  Copyright © 2017年 com.bingo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBBadge : UILabel
@property (nonatomic,assign) NSInteger badgeV;
/**
 *  @Abstract Class method initialize
 *
 *  @return CBBadge instance
 */
+ (instancetype)cb_Badge;

/**
 *  @Abstract setBadgeValue
 *
 *  @param badgeValue badgevalue
 */
- (void)setBadgeValue:(NSInteger)badgeValue;


@end
