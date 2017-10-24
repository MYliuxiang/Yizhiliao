//
//  CBBadge.m
//  6-22 cell多选
//
//  Created by Apple on 2017/8/23.
//  Copyright © 2017年 com.bingo.com. All rights reserved.
//

#import "CBBadge.h"

@implementation CBBadge

+ (instancetype)cb_Badge {
    CBBadge *badge = [[self alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
    return badge;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBase];
    }
    return self;
}

// ------17*17  13
- (void)setBase {
    self.backgroundColor = [UIColor whiteColor];
    self.textColor = UIColorFromRGB(0x333333);
    self.font = [UIFont systemFontOfSize:10];
    self.textAlignment = NSTextAlignmentCenter;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.5;

    self.layer.shadowRadius = 2;
    self.layer.shadowColor = [UIColor redColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.text = nil;
    self.hidden = YES;
    
  
}

- (void)setBadgeValue:(NSInteger)badgeValue {
    self.badgeV = badgeValue;
    if (badgeValue>99) {
        self.hidden = NO;
        self.text = @"99+";
        [self sizeToFit];
        self.bounds = CGRectMake(0, 0, 27, 17);
        return;
    }else if (badgeValue>9){
        self.hidden = NO;
        self.text = [NSString stringWithFormat:@"%ld",badgeValue];
        self.bounds = CGRectMake(0, 0, 22, 17);
        return;
    }else if (badgeValue>0){
        self.hidden = NO;
        self.text = [NSString stringWithFormat:@"%ld",badgeValue];
        self.bounds = CGRectMake(0, 0, 17, 17);
        return;
    }else{
        self.text = nil;
        self.hidden = YES;
        return;
    }
}

- (void)badgeValue
{
    
    
}

@end
