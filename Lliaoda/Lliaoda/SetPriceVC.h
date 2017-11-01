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
typedef enum {
    ChatTypeAudio,
    ChatTypeVideo
} ChatType;
@interface SetPriceVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (nonatomic,retain) NSArray *dataList;
@property (nonatomic,retain) Mymodel *model;
@property (nonatomic,retain) Charge *cmodel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;


@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *setPriceView;
@property (weak, nonatomic) IBOutlet UILabel *setPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lefLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel1;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel2;
@property (weak, nonatomic) IBOutlet UILabel *bottomDetaillabel1;
@property (weak, nonatomic) IBOutlet UILabel *bottomDetaillabel2;

@property (nonatomic, assign) ChatType type;

@end
