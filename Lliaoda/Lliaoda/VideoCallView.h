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

typedef NS_ENUM(NSInteger, CallType) {
    CallTypeVideo,
    CallTypeVoice
};

@interface VideoCallView : UIView<AgoraRtcEngineDelegate>
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
- (IBAction)refuseAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
- (IBAction)agreeAC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic,retain) Mymodel *selfModel;
@property (nonatomic,assign) CallType callType;

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
@property (nonatomic, retain) UIButton *xuanzhuanButton;

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

@property (nonatomic, retain) PersonModel *pModel;

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

//主动呼叫
- (instancetype)initVideoCallViewWithChancel:(NSString *)chancel withUid:(NSString *)uid withIsSend:(BOOL)isSend withType:(NSInteger)callType;


- (void)show;

- (void)dismiss;

@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;

- (IBAction)giftAC:(id)sender;
- (IBAction)redAC:(id)sender;

@property (nonatomic,retain)  UIVisualEffectView *effectView;

@property (nonatomic, retain) UIVisualEffectView *smallEffectView;

@property (weak, nonatomic) IBOutlet UIButton *refuse;

@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;

@property (weak, nonatomic) IBOutlet UILabel *likeLab;

@property (weak, nonatomic) IBOutlet UILabel *yeLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gitfButtonCenter;

@property (weak, nonatomic) IBOutlet UIView *jinbiView;
@property (weak, nonatomic) IBOutlet UILabel *jinbiLabel;
@property (weak, nonatomic) IBOutlet UIView *jinbiView1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redlayoutConstranint;


@property (weak, nonatomic) IBOutlet UIView *headerBGView;

@property (weak, nonatomic) IBOutlet UIView *timeLabelBGView;
@property (weak, nonatomic) IBOutlet UIView *timeLabelBGView1;

@property (nonatomic, strong) AgoraRtcVideoCanvas *local;
@property (nonatomic, strong) AgoraRtcVideoCanvas *remate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftCentrConstraint;

@property (nonatomic, assign) BOOL isBigLocal;

@property (nonatomic, assign) int charge;
@property (nonatomic, assign) int giftCharge; // 礼物收入


@end
