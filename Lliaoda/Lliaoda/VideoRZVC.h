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
#import "VideoOneVC.h"

@interface VideoRZVC : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) UIImagePickerController *imagePicker;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSArray *dataList;
@property (weak, nonatomic) IBOutlet UIButton *yanzBtn;
- (IBAction)yanzhenAC:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property(nonatomic,assign) int type;
// 未提交视频
@property (weak, nonatomic) IBOutlet UIView *unApproveBGView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *unApproveDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *unApproveTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *unApproveUploadButton;
- (IBAction)unApproveUploadButtonAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *unApproveVideoImageView;
@property (weak, nonatomic) IBOutlet UIButton *unApproveVideoPlayButton;
- (IBAction)unApproveVideoPlayButtonAC:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *unApproveLeftLabel;
@property (weak, nonatomic) IBOutlet UIView *unApproveView1;
@property (weak, nonatomic) IBOutlet UIView *unApproveView2;

// 准备提交视频
//@property (weak, nonatomic) IBOutlet UIView *approvingBGView;
//@property (weak, nonatomic) IBOutlet UIImageView *approvingVideoImageView;
//@property (weak, nonatomic) IBOutlet UIButton *approvingVideoPlayButton;
//- (IBAction)approvingVideoPlayButtonAC:(id)sender;
//@property (weak, nonatomic) IBOutlet UILabel *approvingDetailLabel;
//@property (weak, nonatomic) IBOutlet UIButton *approvingUploadButton;
//- (IBAction)approvingUploadButtonAC:(id)sender;
//@property (weak, nonatomic) IBOutlet UIView *approvingView;

@end
