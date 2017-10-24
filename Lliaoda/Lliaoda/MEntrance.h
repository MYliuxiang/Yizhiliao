//
//  MEntrance.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEntrance : UIView
{
    UIButton *_btn;
    
}

+ (MEntrance *)sharedManager;
- (void)setBageMessageCount:(int)count;

@end
