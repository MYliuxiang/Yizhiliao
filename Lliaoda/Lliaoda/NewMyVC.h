//
//  NewMyVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "NewMyCell.h"

typedef NS_ENUM(NSInteger, MyType) {
    MyTypeVideo,
    MyTypePhoto,
    MyTypeMessage
};

@interface NewMyVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,retain) Mymodel *model;
- (IBAction)editAc:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (nonatomic,assign) BOOL ishud;
@property (weak, nonatomic) IBOutlet UIView *seltedView;
- (IBAction)videoAC:(UIButton *)sender;
- (IBAction)photoAC:(UIButton *)sender;
- (IBAction)messageAC:(UIButton *)sender;

@property (nonatomic,retain) NSMutableArray *nameArray;
@property (nonatomic,retain) NSMutableArray *messagePhotos;
@property (nonatomic,retain) NSMutableArray *contents;

@property (nonatomic,retain) UIView *lineView;
@property (nonatomic,assign) MyType cellType;


@end
