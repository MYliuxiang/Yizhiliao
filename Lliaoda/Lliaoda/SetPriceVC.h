//
//  SetPriceVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "Mymodel.h"
#import "Charge.h"
@interface SetPriceVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (nonatomic,retain) NSArray *dataList;
@property (nonatomic,retain) Mymodel *model;
@property (nonatomic,retain) Charge *cmodel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@end
