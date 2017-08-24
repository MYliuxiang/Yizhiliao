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
#import "PersonHeaderCell.h"
#import "PersonSelectCell.h"
#import "PersonBottomCell.h"
#import "InfomationVideoVC.h"
#import "InfomationMessageVC.h"
#import "FSBaseTableView.h"
typedef NS_ENUM(NSInteger, CellType) {
    CellMessage,
    CellVideoType
};


@interface PersonalVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,PersonSelectCellDelegate,UIGestureRecognizerDelegate>
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraint;
@property (weak, nonatomic) IBOutlet FSBaseTableView *tableView;


- (IBAction)videoCall:(id)sender;
@property (nonatomic,retain) NSArray *dataList;
@property (nonatomic,retain) SelectedModel *model;
@property (nonatomic,retain) PersonModel *pmodel;
@property (nonatomic,assign) BOOL videoEnble;
@property (weak, nonatomic) IBOutlet UILabel *thankLabel;

@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UIView *stateLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
- (IBAction)headClick:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (nonatomic,retain) GiftsView *giftsView;
@property (nonatomic, copy) NSString *personUID;
@property (nonatomic,retain) MessageCount *count;
@property (nonatomic,retain) AgoraAPI *inst;
@property (nonatomic, strong) NSString *lastTime;
@property (nonatomic, assign) BOOL isFromHeader;
@property (nonatomic, strong) PersonSelectCell *contentCell;

@property (nonatomic,assign) CellType type;
@property (nonatomic, assign) BOOL canScroll;

@end
