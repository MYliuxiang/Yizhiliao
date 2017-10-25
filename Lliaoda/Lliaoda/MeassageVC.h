//
//  MeassageVC.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BaseViewController.h"
#import "LHChatVC.h"
#import "MessageCell.h"
#import "MessageCount.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>


@interface MeassageVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{

}
@property (nonatomic,retain) UIActivityIndicatorView *actView;  //风火轮视图
@property (weak, nonatomic) IBOutlet UILabel *nomessageLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) AgoraAPI *inst;
@property (nonatomic,retain) AgoraRtcEngineKit *instMedia;
@property (strong, nonatomic) IBOutlet UIView *nowifiView;
@property (nonatomic,retain) NSMutableArray *dataList;
@property (nonatomic,assign) BOOL isNoWifi;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (nonatomic,assign) NSInteger index;

@end
