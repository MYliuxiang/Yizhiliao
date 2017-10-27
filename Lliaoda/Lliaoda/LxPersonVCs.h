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
@interface LxPersonVCs : BaseViewController<UITableViewDelegate, UITableViewDataSource, NewMyVideoCellDelegate, NewMyalbumCellDelegate>
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

- (IBAction)albumBtnAC:(id)sender;
- (IBAction)videoBtnAC:(id)sender;

@property (nonatomic,retain) SelectedModel *model;
@property (nonatomic,retain) PersonModel *pmodel;

@property (nonatomic, assign) int type; // 视频相册类型  0相册  1视频

@property (nonatomic, assign) BOOL isFromHeader;
@property (nonatomic, copy) NSString *personUID;

@property (nonatomic, retain) NSMutableArray *photos;
@end
