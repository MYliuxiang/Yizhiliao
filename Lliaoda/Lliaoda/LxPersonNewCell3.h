//
//  LxPersonNewCell3.h
//  Lliaoda
//
//  Created by 小牛 on 2017/10/27.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LxPersonNewCell3;
@protocol LxPersonNewCell3Delegate <NSObject>
- (void)giftBtnClick;
- (void)chargeBtnClick;
@end

@interface LxPersonNewCell3 : UITableViewCell
- (IBAction)getGiftBtnAC:(id)sender;
- (IBAction)getMoneyBtnAC:(id)sender;
@property (nonatomic, weak) id<LxPersonNewCell3Delegate>delegate;
@end
