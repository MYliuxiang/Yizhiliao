//
//  FindVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "JXCircleView.h"
#import "WKFRadarView.h"
#import "JXRadarPointView.h"
#import "PersonalVC.h"
#import "SelectedModel.h"

@interface FindVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *finBtn;
- (IBAction)findAC:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *findView;
@property (strong, nonatomic) IBOutlet UIView *findBgView;
@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
- (IBAction)rechargeAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *findCardView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *placelabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (nonatomic,assign) BOOL first;
@property (nonatomic,retain) NSArray *charges;


- (IBAction)closeAC:(id)sender;
- (IBAction)closeMatch:(id)sender;

@end
