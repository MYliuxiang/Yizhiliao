//
//  VideoRZVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "VideoRZCell.h"
#import "VideoRZTwoCell.h"
#import "VideoRZThreeCell.h"
#import "FMVideoPlayController.h"
#import "FMImagePicker.h"
#import "VideoOneVC.h"

@interface VideoRZVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSArray *dataList;
@property (weak, nonatomic) IBOutlet UIButton *yanzBtn;
- (IBAction)yanzhenAC:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@end
