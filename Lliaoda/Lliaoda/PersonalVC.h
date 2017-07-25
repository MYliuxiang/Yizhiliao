//
//  PersonalVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectedModel.h"
#import "PersonModel.h"
#import "PersonCell.h"
#import "AccountVC.h"
#import "LHChatVC.h"
#import "PeriSonMediaCell.h"
#import "InvitationVC.h"

@interface PersonalVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
- (IBAction)headClick1:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
- (IBAction)chatAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hongBtn;

- (IBAction)hongVC:(id)sender;
- (IBAction)giftBtnClick:(id)sender;
- (IBAction)topupBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *blackView;

- (IBAction)videoCall:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSArray *dataList;
@property (nonatomic,retain) SelectedModel *model;
@property (nonatomic,retain) PersonModel *pmodel;
@property (nonatomic,assign) BOOL videoEnble;

@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UIView *stateLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
- (IBAction)headClick:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (nonatomic,retain) GiftsView *giftsView;
@end
