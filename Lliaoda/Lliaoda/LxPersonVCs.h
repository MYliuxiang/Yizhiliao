//
//  LxPersonVCs.h
//  Lliaoda
//
//  Created by 小牛 on 2017/10/26.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "NewMyalbumCell.h"
#import "NewMyVideoCell.h"
#import "LxPersonNewCell1.h"
#import "LxPersonNewCell2.h"
#import "LxPersonNewCell3.h"
@interface LxPersonVCs : BaseViewController<UITableViewDelegate, UITableViewDataSource, NewMyVideoCellDelegate, NewMyalbumCellDelegate, LxPersonNewCell3Delegate>
{
    BOOL isSelf; // 判断当前用户是不是自己
    int likeCount;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *xingzuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *zanCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *renzhengButton;
@property (weak, nonatomic) IBOutlet UIButton *unDisturbButton;
@property (weak, nonatomic) IBOutlet UILabel *biaoqianLabel;
@property (weak, nonatomic) IBOutlet UIButton *albumButton;
@property (weak, nonatomic) IBOutlet UIView *albumLineView;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIView *videoLineView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *blackView;

- (IBAction)albumBtnAC:(id)sender;
- (IBAction)videoBtnAC:(id)sender;

@property (nonatomic,retain) SelectedModel *model;
@property (nonatomic,retain) PersonModel *pmodel;

@property (nonatomic,retain) GiftsView *giftsView;

@property (nonatomic, assign) int type; // 视频相册类型  0相册  1视频

@property (nonatomic, assign) BOOL isFromHeader;
@property (nonatomic, copy) NSString *personUID;

@property (nonatomic,retain) MessageCount *count;
@property (nonatomic,retain) AgoraAPI *inst;

@property (nonatomic, strong) NSString *lastTime;
@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic, retain) NSMutableArray *videos;

@property (weak, nonatomic) IBOutlet UIView *giftBGView;
- (IBAction)giftBtnAC:(id)sender;  // 礼物
- (IBAction)upTopBtnAC:(id)sender; // 充值

@property (weak, nonatomic) IBOutlet UIView *zanBGView; // 点赞背景
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
- (IBAction)zanButtonAC:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *albumVideoBGViewTop;



@end
