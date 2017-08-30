//
//  LxPersonVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectedCell.h"
#import "LxPersonHeader.h"
#import "LxMessageCell.h"
#import "PersonCell.h"
#import "LxVideoTableViewCell.h"
#import "SDCycleScrollView.h"


@interface LxPersonVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic,assign) int type;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *seletedView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
- (IBAction)buttonAC:(UIButton *)sender;
- (IBAction)buttonACTwo:(UIButton *)sender;
@property (nonatomic,retain)UIView *sView;
@property (strong, nonatomic) IBOutlet UIView *headerVIew;
@property (nonatomic,retain) SelectedModel *model;
@property (nonatomic,retain) PersonModel *pmodel;
@property (nonatomic, assign) BOOL isFromHeader;
@property (nonatomic, copy) NSString *personUID;
@property (nonatomic,retain) NSMutableArray *photos;
@property (nonatomic,assign) BOOL isLike;

@property (nonatomic,retain) NSArray *messageArray;
@property (nonatomic,retain) NSArray *messagePhotos;
@property (nonatomic,retain) NSArray *contentArray;

@property(nonatomic, strong)SDCycleScrollView *cycleScrollView;


@property (nonatomic,retain) GiftsView *giftsView;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;
@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImge;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

@property (nonatomic,retain) MessageCount *count;
@property (nonatomic,retain) AgoraAPI *inst;
@property (nonatomic, strong) NSString *lastTime;

@property (nonatomic,assign) BOOL isZhubo;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *idlabel;
@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *numbelLabel;
@property (weak, nonatomic) IBOutlet UILabel *xizuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *feiyongLbael;

@property (weak, nonatomic) IBOutlet UIView *hederLunView;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *videoCallButton;

- (IBAction)videoAC:(id)sender;
- (IBAction)chatAC:(id)sender;
- (IBAction)giftAC:(id)sender;
- (IBAction)chongzhiAC:(id)sender;


@end
