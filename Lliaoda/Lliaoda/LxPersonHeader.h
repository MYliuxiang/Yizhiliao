//
//  LxPersonHeader.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxPersonHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *seletedView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
- (IBAction)buttonAC:(UIButton *)sender;
- (IBAction)buttonACTwo:(UIButton *)sender;
@property (nonatomic,retain)UIView *sView;
@property (nonatomic,assign) int type;
@property (nonatomic, copy) void (^oneAction)(int type);

@end
