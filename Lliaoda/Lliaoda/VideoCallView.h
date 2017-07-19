//
//  VideoCallView.h
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/27.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "agorasdk.h"
#import <videoprp/AgoraYuvEnhancerObjc.h>
#import "AppDelegate.h"
#import "PersonModel.h"
#import "AccountVC.h"
#import <AVFoundation/AVFoundation.h>
#import "UMMobClick/MobClick.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "AGVideoPreProcessing.h"
#import "VideoCallRedView.h"
#import "GiftsView.h"
#import "PresentView.h"
#import "GiftModel.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"
#import "RecordGiftModel.h"
#import "Mymodel.h"
#import "AGVideoProcessing.h"

@interface VideoCallView : UIView<AgoraRtcEngineDelegate>
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
- (IBAction)refuseAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
- (IBAction)agreeAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic,retain) Mymodel *selfModel;

@property (weak, nonatomic) IBOutlet UIView *closeView;

- (IBAction)closeVideo:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *headeLab;

@property (weak, nonatomic) IBOutlet UILabel *nickeNameLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;


- (IBAction)likeAC:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *footerLab;

@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;

@property (weak, nonatomic) IBOutlet UIView *lowMoneyView;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *gotoMoneyBtn;

- (IBAction)gotoMoneyAC:(id)sender;


@property (retain, nonatomic) UIImageView *smallImageView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (nonatomic,copy) NSString *channel;

@property (nonatomic,assign) BOOL isSend;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,assign) BOOL isfist;

@property (nonatomic,retain) AVAudioPlayer *avAudioPlayer;

@property (nonatomic,retain) AVAudioPlayer *endPlayer;

@property (nonatomic,retain) AgoraRtcEngineKit *instMedia;

@property (nonatomic,retain) AgoraAPI *inst;

@property (nonatomic,retain) PersonModel *model;

@property (nonatomic,retain) NSTimer *timer;

@property (nonatomic,retain) NSTimer *longTimer;

@property (nonatomic,assign) int longTime;

@property (nonatomic,assign) int callTime;

@property (nonatomic,assign) BOOL iscalling;

@property (nonatomic,assign) BOOL islow;

@property (nonatomic,retain) AgoraYuvEnhancerObjc *yuvEN;

@property (nonatomic,assign) long long starttime;

@property (nonatomic,assign) long long endtime;

@property (nonatomic,retain) NSTimer *keytimer;

@property (nonatomic,assign) int keyTime;

@property (nonatomic,retain) VideoCallRedView *redView;

@property (nonatomic,retain) GiftsView *giftsView;

@property (nonatomic,retain) NSMutableArray *gifts;

@property (nonatomic,retain) NSTimer *giftTimer;


- (instancetype)initVideoCallViewWithChancel:(NSString *)chancel withUid:(NSString *)uid withIsSend:(BOOL)isSend;

- (void)show;

- (void)dismiss;

@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;

- (IBAction)giftAC:(id)sender;
- (IBAction)redAC:(id)sender;


@end
