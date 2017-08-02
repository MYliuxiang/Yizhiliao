//
//  LHChatVC.m
//  LHChatUI
//
//  Created by lenhart on 2016/12/22.
//  Copyright © 2016年 lenhart. All rights reserved.
//

#import "LHChatVC.h"
#import "LHChatBarView.h"
#import "LHIMDBManager.h"
#import "LHTools.h"
#import "LHChatViewCell.h"
#import "LHChatTimeCell.h"
#import "SDImageCache.h"
#import "LHPhotoPreviewController.h"
#import "XSBrowserAnimateDelegate.h"
#import "LHContentModel.h"
#import "IQKeyboardManager.h"

NSString *const kTableViewOffset = @"contentOffset";
NSString *const kTableViewFrame = @"frame";

@interface LHChatVC () <UITableViewDelegate, UITableViewDataSource, XSBrowserDelegate,LHChatBarViewDelegate> {
    NSArray *_imageKeys;
    BOOL isZhubo;
}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) LHChatBarView *chatBarView;
// 满足刷新
@property (nonatomic, assign, getter=isMeetRefresh) BOOL meetRefresh;
// 正在刷新
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSCache *rowHeight;

// 訊息时间
@property (nonatomic, strong) NSString *lastTime;
@property (nonatomic, assign) CGFloat tableViewOffSetY;
@property (nonatomic, assign) NSInteger imageIndex;

@property (nonatomic, strong) XSBrowserAnimateDelegate *browserAnimateDelegate;

@property (nonatomic,retain) UIView *deleteView;

@end

@implementation LHChatVC

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self hideBlack];
    
    NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",_sendUid,[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];
    NSArray *array = [MessageCount findAll];
     if ([MessageCount findFirstByCriteria:criteria]) {
         MessageCount *count = [MessageCount findFirstByCriteria:criteria];
         count.count = 0;
         [count update];
     }

}
#pragma mark - 初始化
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [IQKeyboardManager sharedManager].enable = NO;
    
    _deltedArray = [NSMutableArray array];

    _inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageInstantReceive:) name:Notice_onMessageInstantReceive object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageSendSuccess:) name:Notice_onMessageSendSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageSendError:) name:Notice_onMessageSendError object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageVideoTime:) name:Notice_messageVideoTime object:nil];

    [self addrightImage:@"dengdeng"];
    
    [self _loadData1];


    [self loadData];
    

    [self loadMessageWithDate:0];
    
    [self scrollToBottomAnimated:NO refresh:YES];
    
    [self loadYUe];
    
}

- (void)_loadData1
{
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                self.myModel = [Mymodel mj_objectWithKeyValues:result[@"data"]];
                
                    if (self.myModel.auth == 2) {
                        isZhubo = YES;
                    }else{
                        isZhubo = NO;
                    }
                [self setupInit];

                
            } else{
                
                [self setupInit];

            }
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self setupInit];

    }];
}

- (void)leftAction
{

    [UIView animateWithDuration:.35 animations:^{
        _deleteView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        
        [self.leftbutton removeFromSuperview];
        self.backButtton.hidden = NO;
        self.rightbutton.hidden = NO;
        self.tableView.editing = !self.tableView.editing;
    }];
    

}

- (void)jubaoWithtype:(int)type
{
    NSDictionary *params;
    params = @{@"uid":self.sendUid,@"kind":[NSString stringWithFormat:@"%d",type]};
    [WXDataService requestAFWithURL:Url_report params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"舉報成功！如有需要，可直接联系管理员QQ:2085728544" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
                [alert show];
                
                
            } else{    //请求失败
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
    
    
}


- (void)rightAction
{
    
    NSDictionary *params;
    params = @{@"uid":self.sendUid};
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                LxCache *lxcache = [LxCache sharedLxCache];
                [lxcache setCacheData:result WithKey:[NSString stringWithFormat:@"%@-%@",Url_account,self.sendUid]];
                _pmodel = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"舉報" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:nil message:@"请选择舉報类型" preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    NSString *nickName = _pmodel.nickname;
                    
                    NSString *str = [NSString stringWithFormat:@"你正在舉報%@",nickName];
                    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:str];
                    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color_Text_lightGray range:NSMakeRange(0, 5)];
                    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(5, str.length - 5)];
                    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str.length)];
                    [alertController1 setValue:alertControllerStr forKey:@"_attributedTitle"];
                    
                    UIAlertAction *aletAction1 = [UIAlertAction actionWithTitle:@"广告欺骗" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self jubaoWithtype:0];
                        
                    }];
                    
                    UIAlertAction *aletAction2 = [UIAlertAction actionWithTitle:@"淫秽色情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self jubaoWithtype:1];
                        
                    }];
                    
                    UIAlertAction *aletAction3 = [UIAlertAction actionWithTitle:@"政治反动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self jubaoWithtype:2];
                        
                    }];
                    
                    UIAlertAction *aletAction4 = [UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self jubaoWithtype:3];
                        
                    }];
                    
                    UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    
                    [cancelAction1 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
                    [aletAction1 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
                    [aletAction2 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
                    [aletAction3 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
                    [aletAction4 setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
                    
                    [alertController1 addAction:aletAction1];
                    [alertController1 addAction:aletAction2];
                    [alertController1 addAction:aletAction3];
                    [alertController1 addAction:aletAction4];
                    [alertController1 addAction:cancelAction1];
                    [self presentViewController:alertController1 animated:YES completion:nil];
                    
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [cancelAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
                [defaultAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
                
                
                UIAlertAction *lahei = [UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    BlackName *name = [[BlackName alloc] init];
                    name.uid = self.sendUid;
                    [name save];
                    
                    [SVProgressHUD showSuccessWithStatus:@"拉黑成功"];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        [SVProgressHUD dismiss];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                    
                }];
                
                [lahei setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
                [alertController addAction:lahei];
                                
                [alertController addAction:defaultAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }else{    //请求失败
                
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
        
    }];
    
   
    
}



- (void)loadData
{
    
    LxCache *lxcache = [LxCache sharedLxCache];
    
    id cacheData;
    cacheData = [lxcache getCacheDataWithKey:[NSString stringWithFormat:@"%@-%@",Url_account,self.sendUid]];
    
    if (cacheData != 0) {
        //将数据统一处理
        
        _pmodel = [PersonModel mj_objectWithKeyValues:cacheData[@"data"]];
        self.text = _pmodel.nickname;

    }

    
    NSDictionary *params;
    params = @{@"uid":self.sendUid};
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                LxCache *lxcache = [LxCache sharedLxCache];
                [lxcache setCacheData:result WithKey:[NSString stringWithFormat:@"%@-%@",Url_account,self.sendUid]];
                _pmodel = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                self.text = _pmodel.nickname;
                
            }else{    //请求失败
                
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
        
    }];
    
    
    NSDictionary *params1;
    params1 = @{@"uid":[LXUserDefaults objectForKey:UID]};
    [WXDataService requestAFWithURL:Url_account params:params1 httpMethod:@"GET" isHUD:NO isErrorHud:YES  finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                LxCache *lxcache = [LxCache sharedLxCache];
                [lxcache setCacheData:result WithKey:[NSString stringWithFormat:@"%@-%@",Url_account,[LXUserDefaults objectForKey:UID]]];
               
                
            }else{    //请求失败
                
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
        
    }];

}


- (void)back
{
    self.count.count = 0;
    self.count.draft = _chatBarView.textView.text;
    Message *me = self.messages.lastObject;
    if (me.type == MessageBodyType_Gift) {
        
    }else if(me.type == MessageBodyType_ChongZhi){
    
    }else{
        
        self.count.content = me.content;

    }
    [self.count update];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -----LHChatBarViewDelegate------
- (void)sendMessageToUserType:(MessageBodyType)type name:(NSString *)name types:(NSString *)types {
    NSString *message = [NSString stringWithFormat:@"已對%@發送了%@提示~", _pmodel.nickname, name];
    long long idate = [[NSDate date] timeIntervalSince1970]*1000;
    __block Message *messageModel = [Message new];
    messageModel.isSender = YES;
    messageModel.isRead = NO;
    messageModel.status = MessageDeliveryState_Delivering;
    messageModel.date = idate;
    messageModel.messageID = [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate];
    messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],self.sendUid];
    messageModel.type = type;
    messageModel.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    messageModel.sendUid = self.sendUid;
    messageModel.content = message;
//    switch (type) {
//        case MessageBodyType_Text: {
//            messageModel.content = message;
//            break;
//        }
//        default:
//            break;
//    }
    
    NSDictionary *params;
    if (type == MessageBodyType_Gift) {
        params = @{@"uid":self.sendUid, @"message":message, @"type":@1};

    }else if(type == MessageBodyType_ChongZhi){
        params = @{@"uid":self.sendUid, @"message":message, @"type":@2};

    }
    [WXDataService requestAFWithURL:Url_chatmessagesend params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO  finishBlock:^(id result) {
        if ([[result objectForKey:@"result"] integerValue] == 0) {
            [messageModel save];
            NSString *time = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",messageModel.date]];
            if (![time isEqualToString:self.lastTime]) {
                [self insertNewMessageOrTime:time];
                self.lastTime = time;
            }
            NSIndexPath *index = [self insertNewMessageOrTime:messageModel];
            [self.messages addObject:messageModel];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            NSDictionary *dic = @{
                                  @"message": @{
                                          @"messageID": messageModel.messageID,
                                          @"event": types,
                                          @"content": @"",
                                          @"request": @"-2",
                                          @"time": [NSString stringWithFormat:@"%lld",idate]
                                          }
                                  };
            
            NSString *msgStr = [InputCheck convertToJSONData:dic];
            [_inst messageInstantSend:self.sendUid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate]];
            NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",self.sendUid,[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];
            if (![MessageCount findFirstByCriteria:criteria]){
                
                MessageCount *count = [[MessageCount alloc] init];
                count.content = message;
                count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                count.sendUid = self.sendUid;
                count.count = 0;
                count.timeDate = idate;
                [count save];
                
            }else{
                
                _count.content = message;
                _count.timeDate = messageModel.date;
                _count.count = 0;
                [_count saveOrUpdate];
                
            }

            
            
        }else{
            if ([[result objectForKey:@"result"] integerValue] == 31) {
                LGAlertView *lg = [[LGAlertView alloc] initWithTitle:@"提示" message:result[@"message"] style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"好的" destructiveButtonTitle:nil delegate:nil];
                lg.destructiveButtonBackgroundColor = Color_nav;
                lg.destructiveButtonTitleColor = [UIColor whiteColor];
                lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                lg.cancelButtonTitleColor = Color_nav;
                [lg showAnimated:YES completionHandler:nil];
                
            }else if ([[result objectForKey:@"result"] integerValue] == 30) {
                LGAlertView *lg = [[LGAlertView alloc] initWithTitle:@"提示" message:result[@"message"] style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"好的" destructiveButtonTitle:nil delegate:nil];
                lg.destructiveButtonBackgroundColor = Color_nav;
                lg.destructiveButtonTitleColor = [UIColor whiteColor];
                lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                lg.cancelButtonTitleColor = Color_nav;
                [lg showAnimated:YES completionHandler:nil];
                
            }else{
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
            
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
}
// 主播提醒用户送禮物
- (void)remindGiveGift {
    RepetitionCount *re = [RepetitionCount sharedRepetition];
    long long idate = [[NSDate date] timeIntervalSince1970]*1000;
    long long oldDate = [[NSString stringWithFormat:@"%@",re.mdic[self.sendUid]] longLongValue];
    if (idate - oldDate < 60 * 1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"發送太頻繁，會嚇走金主的~" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self sendMessageToUserType:MessageBodyType_Gift name:@"送禮" types:@"gift"];
        [re.mdic setObject:@(idate) forKey:self.sendUid];
    }

}

// 主播提醒用户儲值
- (void)remindChongZhi {
    RechargeCount *re = [RechargeCount sharedRecharge];
    long long idate = [[NSDate date] timeIntervalSince1970]*1000;
    long long oldDate = [[NSString stringWithFormat:@"%@",re.mdic[self.sendUid]] longLongValue];
    if (idate - oldDate < 60 * 1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"發送太頻繁，會嚇走金主的~" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self sendMessageToUserType:MessageBodyType_ChongZhi name:@"儲值" types:@"recharge"];
        [re.mdic setObject:@(idate) forKey:self.sendUid];
    }
}

// 用户儲值
- (void)chongZhi {
    AccountVC *vc = [[AccountVC alloc] init];
    vc.isCall = NO;
    vc.orderReferee = self.sendUid;
    [self.navigationController pushViewController:vc animated:YES];
}
// 用户送禮物
- (void)giftGive {
    self.blackView.hidden = NO;
    [self newgiftView];
    self.giftsView.pmodel = self.pmodel;
    self.giftsView.isVideoBool = NO;
    [UIView animateWithDuration:.35 animations:^{
        _blackView.hidden = NO;
        self.giftsView.top = kScreenHeight - 300;
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)newgiftView{
    
    if (self.giftsView == nil) {
        
        self.giftsView = [[GiftsView alloc] initGiftsView];
    }
    
    
    __weak LHChatVC *this = self;
    self.giftsView.giftBlock = ^(NSString *giftName, int diamonds, NSString *giftUid) {
        
        NSString *content = [NSString stringWithFormat:@"我送出：%@(%d鉆)", giftName, diamonds];
        NSString *contents = [NSString stringWithFormat:@"%@(%d鉆)", giftName, diamonds];
        long long idate = [[NSDate date] timeIntervalSince1970]*1000;
        __block Message *messageModel = [Message new];
        messageModel.isSender = YES;
        messageModel.isRead = NO;
        messageModel.status = MessageDeliveryState_Delivering;
        messageModel.date = idate;
        messageModel.messageID = [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate];
        messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],this.pmodel.uid];
        messageModel.type = MessageBodyType_Text;
        messageModel.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        messageModel.sendUid = this.pmodel.uid;
        messageModel.content = content;
        [messageModel save];
        
        NSString *time = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",messageModel.date]];
        if (![time isEqualToString:this.lastTime]) {
            [this insertNewMessageOrTime:time];
            this.lastTime = time;
        }
        NSIndexPath *index = [this insertNewMessageOrTime:messageModel];
        [this.messages addObject:messageModel];
        [this.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [SVProgressHUD showSuccessWithStatus:@"禮物已發送，謝謝老闆打賞~"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
        });
        
        NSDictionary *dic = @{
                              @"message": @{
                                      @"messageID": [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate],
                                      @"event": @"gift",
                                      @"content": contents,
                                      @"request": @"-3",
                                      @"time": [NSString stringWithFormat:@"%lld",idate]
                                      }
                              };
        NSString *msgStr = [InputCheck convertToJSONData:dic];
        [this.inst messageInstantSend:this.pmodel.uid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate]];
    };
    [self.view addSubview:self.giftsView];
    
}
- (void)videoCall
{
    
    if (_pmodel == nil) {
        
        NSDictionary *params;
        params = @{@"uid":self.sendUid};
        [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    
                    LxCache *lxcache = [LxCache sharedLxCache];
                    [lxcache setCacheData:result WithKey:[NSString stringWithFormat:@"%@-%@",Url_account,self.sendUid]];
                    _pmodel = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                    [self videoCallAC];
                    
                }else{    //请求失败
                    
                    if ([[result objectForKey:@"result"] integerValue] == 8) {
                        
                        LGAlertView *lg = [[LGAlertView alloc] initWithTitle:@"购买鑽石" message:@"亲，你的鑽石不足，儲值才能继续視訊通话，是否购买鑽石？" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"快速购买" delegate:nil];
                        lg.destructiveButtonBackgroundColor = Color_nav;
                        lg.destructiveButtonTitleColor = [UIColor whiteColor];
                        lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                        lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                        lg.cancelButtonTitleColor = Color_nav;
                        lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                            AccountVC *vc = [[AccountVC alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        };
                        [lg showAnimated:YES completionHandler:nil];
                    }

                }
            }
            
        } errorBlock:^(NSError *error) {
            
            
        }];

        
    }else{
    
        [self videoCallAC];
       
    }
}

- (void)videoCallAC
{
    if ([AppDelegate shareAppDelegate].netStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用，请检查您的网络設定" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
       
    if (self.pmodel.state == 2) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前用户正在忙碌" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    AppDelegate *app = [AppDelegate shareAppDelegate];
    if(![app.inst isOnline]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您正处于离线状态" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *params;
    params = @{@"uid":self.sendUid};
    [WXDataService requestAFWithURL:Url_chatvideocall params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSString *channel = [NSString stringWithFormat:@"%@",result[@"data"][@"channel"]];
                VideoCallView *video = [[VideoCallView alloc] initVideoCallViewWithChancel:channel withUid:self.sendUid withIsSend:YES];
                [video show];
                
            }else{    //请求失败
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
    }];

}

//收到訊息
- (void)onMessageInstantReceive:(NSNotification *)notification
{
   
    NSDictionary *userInfo = notification.userInfo;
    NSString *account = [NSString stringWithFormat:@"%@",userInfo[@"account"]];
    if ( ![account isEqualToString:self.sendUid]) {
        
        return;
    }
    Message *messageModel = [Message new];
    messageModel.isSender = NO;
    messageModel.isRead = YES;
    messageModel.status = MessageDeliveryState_Delivered;
    messageModel.date = [userInfo[@"msg"][@"time"] longLongValue];
    messageModel.type = MessageBodyType_Text;
    messageModel.uid = userInfo[@"account"];
    messageModel.sendUid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    messageModel.request = userInfo[@"msg"][@"request"];
    if ([messageModel.request isEqualToString:@"-2"]) {
        messageModel.event = userInfo[@"msg"][@"event"];
        if ([messageModel.event isEqualToString:@"gift"]) {
            messageModel.type = MessageBodyType_Gift;
        } else {
            messageModel.type = MessageBodyType_ChongZhi;
        }
    } else if ([messageModel.request isEqualToString:@"-3"]) {
        messageModel.event = userInfo[@"msg"][@"event"];
        if ([messageModel.event isEqualToString:@"gift"]) {
            messageModel.content = [NSString stringWithFormat:@"我给你送了：%@鑽，有空记得打给我哟～", userInfo[@"msg"][@"content"]];
        } else {
            messageModel.content = [NSString stringWithFormat:@"我已通過你的頁面儲值：%@", userInfo[@"msg"][@"content"]];
        }
    } else {
        messageModel.content = userInfo[@"msg"][@"content"];
    }
    NSString *time = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",messageModel.date]];
    if (![time isEqualToString:self.lastTime]) {
        [self insertNewMessageOrTime:time];
        self.lastTime = time;
    }
    
    NSIndexPath *index = [self insertNewMessageOrTime:messageModel];
    [self.messages addObject:messageModel];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    
}

//发送訊息失败
- (void)onMessageSendError:(NSNotification *)notification
{

    NSDictionary *userInfo = notification.userInfo;
    NSString *criteria = [NSString stringWithFormat:@"WHERE  messageID = '%@' and sendUid = %@",userInfo[@"messageID"],self.sendUid];
    Message *messageModel = [Message findFirstByCriteria:criteria];
    if (messageModel == nil) {
        
        return;
    }
    messageModel.status = MessageDeliveryState_Failure;
    
    for (int i = 0 ; i < self.dataSource.count; i++) {
        NSObject *obj = [self.dataSource objectAtIndex:i];
        if ([obj isKindOfClass:[NSString class]]) {
        }else{
            Message *model = (Message *)obj;
            if (model.date == messageModel.date) {
                
                model.status = MessageDeliveryState_Failure;
                break;
            }
        }
    }
    
    NSArray *cells = [self.tableView visibleCells];
    [cells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LHChatViewCell class]]) {
            LHChatViewCell *messagecell = (LHChatViewCell *)obj;
            if (messagecell.messageModel.date == messageModel.date) {
                //                messagecell.messageModel.status = MessageDeliveryState_Failure;
                [messagecell layoutSubviews];
                *stop = YES;
            }
        }
    }];
    
}

//发送訊息成功
- (void)messageVideoTime:(NSNotification *)notification
{
    
    NSDictionary *userInfo = notification.userInfo;
//     NSDictionary *dic = [InputCheck dictionaryWithJsonString:userInfo[@"msg"]];
//    NSString *criteria = [NSString stringWithFormat:@"WHERE  messageID = '%@' and sendUid = %@",dic[@"messageID"],self.sendUid];
    Message *messageModel = userInfo[@"msg"];
    if (![messageModel.sendUid isEqualToString:self.sendUid]) {
        
        return;
    }
   
    
    NSString *time = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",messageModel.date]];
    if (![time isEqualToString:self.lastTime]) {
        [self insertNewMessageOrTime:time];
        self.lastTime = time;
    }
    NSIndexPath *index = [self insertNewMessageOrTime:messageModel.content];
    [self.messages addObject:messageModel];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  
    
}


//发送訊息成功
- (void)onMessageSendSuccess:(NSNotification *)notification
{

    NSDictionary *userInfo = notification.userInfo;
    NSString *criteria = [NSString stringWithFormat:@"WHERE  messageID = '%@' and sendUid = %@",userInfo[@"messageID"],self.sendUid];
    Message *messageModel = [Message findFirstByCriteria:criteria];
    if (messageModel == nil) {
        
        return;
    }
    messageModel.status = MessageDeliveryState_Delivered;
    
    BOOL ishaveMessage = NO;
    for (int i = 0 ; i < self.dataSource.count; i++) {
        NSObject *obj = [self.dataSource objectAtIndex:i];
        if ([obj isKindOfClass:[NSString class]]) {
        }else{
            Message *model = (Message *)obj;
            if (model.date == messageModel.date) {
                ishaveMessage = YES;
                model.status = MessageDeliveryState_Delivered;
                break;
            }
        }
    }
    
    if (ishaveMessage) {
        
        NSArray *cells = [self.tableView visibleCells];
        [cells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[LHChatViewCell class]]) {
                LHChatViewCell *messagecell = (LHChatViewCell *)obj;
                if (messagecell.messageModel.date == messageModel.date) {
                    //                messagecell.messageModel.status = MessageDeliveryState_Delivered;
                    [messagecell layoutSubviews];
                    *stop = YES;
                }
            }
        }];
    }else{
    
        NSString *time = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",messageModel.date]];
        if (![time isEqualToString:self.lastTime]) {
            [self insertNewMessageOrTime:time];
            self.lastTime = time;
        }
        NSIndexPath *index = [self insertNewMessageOrTime:messageModel];
        [self.messages addObject:messageModel];
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    }
   
    
}

- (void)setupInit {
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.chatBarView];
    [self.view addSubview:self.blackView];
    self.leftbutton.hidden = YES;
    
    _deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 49)];
    _deleteView.backgroundColor = Color_bg;
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = Color_nav;
    button.frame = CGRectMake((kScreenWidth - 180) / 2.0, 9, 180, 30);
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    [button setTitle:@"删除" forState:UIControlStateNormal];
    button.titleLabel.font =[UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(buttonAC) forControlEvents:UIControlEventTouchUpInside];
    [_deleteView addSubview:button];
    [self.view addSubview:_deleteView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.chatBarView action:@selector(hideKeyboard)];
    tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapBlack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBlack)];
    [self.blackView addGestureRecognizer:tapBlack];
}

- (void)hideBlack {
    self.blackView.hidden = YES;
    [self hideRenandGift];
}

#pragma mark - 获取用户钻石数量
- (void)loadYUe
{
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                NSString *deposit = [NSString stringWithFormat:@"%@",result[@"data"][@"deposit"]];
                NSString *str = [NSString stringWithFormat:@"余额:%@鑽",deposit];
                NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:str];
                [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(3, deposit.length)];
                [self newgiftView];
                self.giftsView.elabel.attributedText = alertControllerMessageStr;
                
            } else{
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

- (void)hideRenandGift {
    if (self.giftsView.top != kScreenHeight) {
        [UIView animateWithDuration:.35 animations:^{
            self.giftsView.top = kScreenHeight;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
//多选删除
- (void)buttonAC
{
//    NSArray *array = self.tableView.indexPathsForSelectedRows;
    for (Message *model in self.deltedArray) {
        
        [self myDelete:model];
        
    }
    [self.deltedArray removeAllObjects];
    
    [UIView animateWithDuration:.35 animations:^{
        _deleteView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        
        [self.leftbutton removeFromSuperview];
        self.backButtton.hidden = NO;
        self.rightbutton.hidden = NO;
        self.tableView.editing = !self.tableView.editing;

    }];
    
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.tableView.editing == YES) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:kTableViewFrame];
    [self.tableView removeObserver:self forKeyPath:kTableViewOffset];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_onMessageInstantReceive object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_onMessageSendError object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_onMessageSendSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_messageVideoTime object:nil];
    

}

#pragma mark - public
//刷新并滑动到底部
- (void)scrollToBottomAnimated:(BOOL)animated refresh:(BOOL)refresh {
    // 表格滑动到底部
    if (refresh) [self.tableView reloadData];
    if (!self.dataSource.count) return;
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

#pragma mark - private
- (void)dropDownLoadDataWithScrollView:(UIScrollView *)scrollView {
    if ([scrollView isMemberOfClass:[UITableView class]]) {
        if (!self.isHeaderRefreshing) return;
        
        Message *model = self.messages.firstObject;
        self.tableViewOffSetY = (self.tableView.contentSize.height - self.tableView.contentOffset.y);
        [self loadMessageWithDate:model.date];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableViewOffSetY)];
        self.headerRefreshing = NO;
    }
}

//加载数据
- (void)loadMessageWithDate:(long)date {
//    NSArray *messages = [[LHIMDBManager shareManager] searchModelArr:[LHMessageModel class] byKey:Id];
    
    NSString *findStr;
    NSString *selfUid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    if (date == 0) {
        
        findStr = [NSString stringWithFormat:@"where chancelID    = '%@_%@' order by date DESC limit 0,20",selfUid,self.sendUid];
    }else{
    
       findStr = [NSString stringWithFormat:@"where chancelID    = '%@_%@' and date < %ld  order by date DESC limit 0,20",selfUid,self.sendUid,date];
    }
    
    NSArray *messages = [Message findByCriteria:findStr];
    self.meetRefresh = messages.count == kMessageCount;
    if(messages.count == 0){
    
        return;
    }
    NSString *ndate = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970])];
    int idate = [ndate intValue];
    [messages enumerateObjectsUsingBlock:^(Message *messageModel, NSUInteger idx, BOOL * stop) {
        
        if(idate - messageModel.date > 60 && messageModel.status == MessageDeliveryState_Delivering){
        
            messageModel.status = MessageDeliveryState_Failure;
            [messageModel update];
            
        }
        
        if(messageModel.type == MessageBodyType_Video)
        {
            [self.dataSource insertObject:messageModel.content atIndex:0];
        }else{
        
        [self.dataSource insertObject:messageModel atIndex:0];
        }
        [self.messages insertObject:messageModel atIndex:0];
        
        NSString *time = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",messageModel.date]];
        if (![self.lastTime isEqualToString:time]) {
            [self.dataSource insertObject:time atIndex:0];
            self.lastTime = time;
        }
    }];
    
    Message *model = self.messages.firstObject;
    if (model.pk == 1) {
        
        self.meetRefresh = 0;
    }

    
    NSUInteger index = [self.dataSource indexOfObject:self.lastTime];
    if (index) {
        [self.dataSource removeObjectAtIndex:index];
        [self.dataSource insertObject:self.lastTime atIndex:0];
    }
}

- (NSIndexPath *)insertNewMessageOrTime:(id)NewMessage {
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
    [self.dataSource addObject:NewMessage];
    [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    return index;
}


- (void)sendMessage:(LHContentModel *)content {
    
    if (content.words && content.words.length) {
        // 文字类型
        [self seavMessage:content.words type:MessageBodyType_Text];
    }
    if (!content.photos && !content.photos.photos.count) return;
    // 图片类型
    [content.photos.photos enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * stop) {
        
        [self seavMessage:image type:MessageBodyType_Image];
    }];
}

- (void)seavMessage:(id)content type:(MessageBodyType)type {
//    NSString *date = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970])];
    
   long long idate = [[NSDate date] timeIntervalSince1970]*1000;
    
//    int idate = [date intValue];
    __block Message *messageModel = [Message new];
    messageModel.isSender = YES;
    messageModel.isRead = NO;
    messageModel.status = MessageDeliveryState_Delivering;
    messageModel.date = idate;
    messageModel.messageID = [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate];
    messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],self.sendUid];
    messageModel.type = type;
    messageModel.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    messageModel.sendUid = self.sendUid;
    switch (type) {
        case MessageBodyType_Text: {
            messageModel.content = content;
            break;
        }
        case MessageBodyType_Image: {
            UIImage *image = (UIImage *)content;
            messageModel.width = image.size.width;
            messageModel.height = image.size.height;
//            [SDImageCache.sharedImageCache storeImage:image forKey:messageModel.date];
            break;
        }
        default:
            break;
    }
   
    NSDictionary *msg = @{@"message":@{
    @"messageID":[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate],
    @"content":content,
    @"type":@(MessageBodyType_Video),
    @"time":[NSString stringWithFormat:@"%lld",idate],
    }};
    NSString *msgStr = [InputCheck convertToJSONData:msg];
        
    NSDictionary *params;
    params = @{@"uid":self.sendUid,@"message":content};
    [WXDataService requestAFWithURL:Url_chatmessagesend params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO finishBlock:^(id result) {
        
        if ([[result objectForKey:@"result"] integerValue] == 0) {

            [messageModel save];
            
            NSString *time = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",messageModel.date]];
            if (![time isEqualToString:self.lastTime]) {
                [self insertNewMessageOrTime:time];
                self.lastTime = time;
            }
            NSIndexPath *index = [self insertNewMessageOrTime:messageModel];
            [self.messages addObject:messageModel];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];

         [_inst messageInstantSend:self.sendUid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate]];
            
            NSString *criteria = [NSString stringWithFormat:@"WHERE sendUid = %@ and uid = %@",self.sendUid,[NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]]];
            if (![MessageCount findFirstByCriteria:criteria]){
                
                MessageCount *count = [[MessageCount alloc] init];
                count.content = messageModel.content;
                count.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
                count.sendUid = self.sendUid;
                count.count = 0;
                count.timeDate = idate;
                [count save];
                
            }else{
                
                _count.content = [NSString stringWithFormat:@"%@",messageModel.content];;
                _count.timeDate = messageModel.date;
                _count.count = 0;
                [_count saveOrUpdate];
                
            }

        }else{
            
            if ([[result objectForKey:@"result"] integerValue] == 29) {

            LGAlertView *lg = [[LGAlertView alloc] initWithTitle:@"购买鑽石" message:result[@"message"] style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"快速购买" delegate:nil];
            lg.destructiveButtonBackgroundColor = Color_nav;
            lg.destructiveButtonTitleColor = [UIColor whiteColor];
            lg.cancelButtonFont = [UIFont systemFontOfSize:16];
            lg.cancelButtonBackgroundColor = [UIColor whiteColor];
            lg.cancelButtonTitleColor = Color_nav;
            lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                AccountVC *vc = [[AccountVC alloc] init];

                [self.navigationController pushViewController:vc animated:YES];
                
            };
            [lg showAnimated:YES completionHandler:nil];
            }else{
        
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            }
        
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
        
    }];

    
    
    
    //显示自己的
    //更新UI操作
   
 
}

#pragma mark - 事件监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kTableViewFrame]) {
        UITableView *tableView = (UITableView *)object;
        CGRect newValue = [change[NSKeyValueChangeNewKey] CGRectValue];
        CGRect oldValue = [change[NSKeyValueChangeOldKey] CGRectValue];
        if (newValue.size.height != oldValue.size.height &&
            tableView.contentSize.height > newValue.size.height) {
            
            [tableView setContentOffset:CGPointMake(0, tableView.contentSize.height - newValue.size.height) animated:YES];
        }
        return;
    }
    
    //    UITableView *tableView = (UITableView *)object;
    CGPoint newValue = [change[NSKeyValueChangeNewKey] CGPointValue];
    CGPoint oldValue = [change[NSKeyValueChangeOldKey] CGPointValue];
    if (!self.headerRefreshing) self.headerRefreshing = newValue.y < 40 && self.isMeetRefresh;
}

#pragma mark  cell事件处理
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    
    Message *model = [userInfo objectForKey:kMessageKey];
    
    LHChatViewCell *cell;
    if (self.tableView.editing) {
        
        for (int i = 0; i < self.dataSource.count; i++) {
            NSObject *ob = self.dataSource[i];
            if (![ob isKindOfClass:[NSString class]]) {
                Message *obM = (Message *)ob;
                if (obM.date == model.date) {
                 
                    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    if (cell.selected) {
                    
                        [self.deltedArray removeObject:self.dataSource[i]];
                    }else{
                        [self.deltedArray addObject:self.dataSource[i]];

                    
                    }
                    
                }
            }
            
        }
        
        cell.selected = !cell.selected;
        
        return;
    }
    
    if ([eventName isEqualToString:kRouterEventTapEventName]){
        //点击cell
    }
    
    if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]) {
        //点击图片
        [self chatImageCellBubblePressed:model];
    }
    if ([eventName isEqualToString:kRouterEventChatResendEventName]) {
        
        Message *remodel = [userInfo objectForKey:kShouldResendCell];
        [self resend:remodel];
        
    }
    
    if ([eventName isEqualToString:kRouterEventGiftBubbleLongTapEventName]) {
        // 點擊彈出禮物框
        self.blackView.hidden = NO;
        [self newgiftView];
        self.giftsView.pmodel = self.pmodel;
        self.giftsView.isVideoBool = NO;
        [UIView animateWithDuration:.35 animations:^{
            _blackView.hidden = NO;
            self.giftsView.top = kScreenHeight - 300;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if ([eventName isEqualToString:kRouterEventRechargeBubbleLongTapEventName]) {
        // 點擊前往儲值界面
        [self chongZhi];
    }
    
    if([eventName isEqualToString:kRouterEventBubbleMenuMore]){
        
//        _longMessage = [userInfo objectForKey:kMessageKey];
        self.tableView.editing = !self.tableView.editing;
        self.backButtton.hidden = YES;
        self.rightbutton.hidden = YES;
        [self addlefttitleString:@"取消"];
        [UIView animateWithDuration:.35 animations:^{
            _deleteView.top = kScreenHeight - 49;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    if([eventName isEqualToString:kRouterEventBubbleMenuDelete]){
        [self.view becomeFirstResponder];
       Message *model = [userInfo objectForKey:kMessageKey];
        [self myDelete:model];
    
    }
    
}


- (void)myDelete:(Message *)model
{
    for (int i = 0 ; i < self.dataSource.count; i++) {
        NSObject *obj = [self.dataSource objectAtIndex:i];
        if ([obj isKindOfClass:[NSString class]]) {
        }else{
            
            BOOL isNextTime = false;
            Message *model1 = (Message *)obj;
            if (model1.date == model.date) {
                
                if (i != self.dataSource.count - 1) {
                    
                    NSObject *obj2 = [self.dataSource objectAtIndex:i + 1 ];
                    if ([obj2 isKindOfClass:[NSString class]]) {
                        //下面一条是时间不需要管
                        
                    }else{
                        
                        //message需要加一个时间cell
                        Message *nextMessage = (Message *)obj2;
                     
                        NSString *nexttime = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",nextMessage.date]];
                        NSString *time = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",nextMessage.date]];
                        if ([nexttime isEqualToString:time]) {
                        
                            isNextTime = YES;

                        }
                        
                    }
                    
                }
                
                NSObject *obj1 = [self.dataSource objectAtIndex:i - 1 ];
                [self.messages removeObject:model];
                if ([obj1 isKindOfClass:[NSString class]]) {
                
                    if (isNextTime) {
                        //跟下条訊息的时间相同
                        [self.dataSource removeObject:obj];
                        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                    }else{
                        //跟下一条的时间不相同
                        [self.dataSource removeObject:obj1];
                        [self.dataSource removeObject:obj];
                        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0],[NSIndexPath indexPathForRow:i-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                       
                    }
                    
                }else{
                    
                     [self.dataSource removeObject:obj];
                     [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                    
                }
                
//                [self.tableView reloadData];
                
            }
        }
    }
    
    [model deleteObject];
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath

{
    NSObject *obj1 = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj1 isKindOfClass:[NSString class]]) {
        
        return UITableViewCellEditingStyleNone;
        
    }
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}


//重发事件
- (void)resend:(Message *)model
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您是否需要重新发送此条信息" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"重发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        for (int i = 0 ; i < self.dataSource.count; i++) {
            NSObject *obj = [self.dataSource objectAtIndex:i];
            if ([obj isKindOfClass:[NSString class]]) {
            }else{
                
                BOOL isNextTime = false;
                Message *model1 = (Message *)obj;
                if (model1.date == model.date) {
                    
                    if (i != self.dataSource.count - 1) {
                        
                        NSObject *obj2 = [self.dataSource objectAtIndex:i + 1 ];
                        if ([obj2 isKindOfClass:[NSString class]]) {
                            //下面一条是时间不需要管
                            
                            
                        }else{
                            
                            //message需要加一个时间cell
                            Message *nextMessage = (Message *)obj2;
                            
                            NSString *nexttime = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",nextMessage.date]];
                            NSString *time = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",nextMessage.date]];
                            if ([nexttime isEqualToString:time]) {
                                
                                isNextTime = YES;
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    
                    NSObject *obj1 = [self.dataSource objectAtIndex:i - 1 ];
                    [self.messages removeObject:model];
                    if ([obj1 isKindOfClass:[NSString class]]) {
                        
                        if (isNextTime) {
                            //跟下条訊息的时间相同
                            [self.dataSource removeObject:obj];
                            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            
                        }else{
                            //跟下一条的时间不相同
                            [self.dataSource removeObject:obj1];
                            [self.dataSource removeObject:obj];
                            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0],[NSIndexPath indexPathForRow:i-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        }
                        
                    }else{
                        
                        [self.dataSource removeObject:obj];
                         [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        
                    }
                    
                    
                    [self.tableView reloadData];
                    
                }
            }
        }

        NSString *date = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970])];
        int idate = [date intValue];
        model.isSender = YES;
        model.isRead = NO;
        model.status = MessageDeliveryState_Delivering;
        model.date = idate;
        model.messageID = [NSString stringWithFormat:@"%@_%d",[LXUserDefaults objectForKey:UID],idate];
        model.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
        model.sendUid = self.sendUid;
        
        NSDictionary *msg = @{@"message":@{
                                      @"messageID":[NSString stringWithFormat:@"%@_%d",[LXUserDefaults objectForKey:UID],idate],
                                      @"content":model.content,
                                      @"time":[NSString stringWithFormat:@"%d",idate],
                                      }};
        NSString *msgStr = [InputCheck convertToJSONData:msg];
       
        
        NSDictionary *params;
        params = @{@"uid":self.sendUid,@"message":model.content};
        [WXDataService requestAFWithURL:Url_chatmessagesend params:params httpMethod:@"POST" isHUD:NO isErrorHud:NO  finishBlock:^(id result) {
            
            if ([[result objectForKey:@"result"] integerValue] == 0) {

                [model update];
                
                NSString *time = [LHTools processingTimeWithDate:[NSString stringWithFormat:@"%lld",model.date]];
                if (![time isEqualToString:self.lastTime]) {
                    [self insertNewMessageOrTime:time];
                    self.lastTime = time;
                }
                NSIndexPath *index = [self insertNewMessageOrTime:model];
                [self.messages addObject:model];
                [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];

             [_inst messageInstantSend:self.sendUid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%d",[LXUserDefaults objectForKey:UID],idate]];
            }else{
            
                if ([[result objectForKey:@"result"] integerValue] == 29) {
                    
                    LGAlertView *lg = [[LGAlertView alloc] initWithTitle:@"购买鑽石" message:result[@"message"] style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"快速购买" delegate:nil];
                    lg.destructiveButtonBackgroundColor = Color_nav;
                    lg.destructiveButtonTitleColor = [UIColor whiteColor];
                    lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                    lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                    lg.cancelButtonTitleColor = Color_nav;
                    lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                        AccountVC *vc = [[AccountVC alloc] init];

                        [self.navigationController pushViewController:vc animated:YES];
                        
                    };
                    [lg showAnimated:YES completionHandler:nil];
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }

            }
            
        } errorBlock:^(NSError *error) {
            NSLog(@"%@",error);
            
            
        }];

        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

// 图片的bubble被点击
- (void)chatImageCellBubblePressed:(Message *)model {
    NSMutableArray *imageKeys = @[].mutableCopy;
    __block NSString *currentKey = nil;
    [self.messages enumerateObjectsUsingBlock:^(Message *messageModel, NSUInteger idx, BOOL * stop) {
        if (messageModel.type == MessageBodyType_Image) {
            [imageKeys addObject:[NSString stringWithFormat:@"%lld",messageModel.date]];
            if ([[NSString stringWithFormat:@"%lld",messageModel.date] isEqualToString:[NSString stringWithFormat:@"%lld",model.date]]) {
                currentKey = [NSString stringWithFormat:@"%lld",messageModel.date];
            }
        }
    }];
    
    _imageKeys = imageKeys.copy;
    _imageIndex = [imageKeys indexOfObject:currentKey];
    LHPhotoPreviewController *photoPreview = [LHPhotoPreviewController new];
    photoPreview.currentIndex = _imageIndex;
    photoPreview.models = imageKeys;
    self.browserAnimateDelegate.delegate = self;
    self.browserAnimateDelegate.index = _imageIndex;
    self.browserAnimateDelegate.im = YES;
    photoPreview.transitioningDelegate = self.browserAnimateDelegate;
    photoPreview.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:photoPreview animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = [self.dataSource objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[NSString class]]) {
        LHChatTimeCell *timeCell = (LHChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LHChatTimeCell class])];
        if (!timeCell) {
            timeCell = [[LHChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LHChatTimeCell class])];
        }
        
        timeCell.timeLable.text = (NSString *)obj;
        
        return timeCell;
    }
    
    Message *messageModel = (Message *)obj;
    
    NSString *cellIdentifier = [LHChatViewCell cellIdentifierForMessageModel:messageModel];
    LHChatViewCell *messageCell = (LHChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!messageCell) {
        messageCell = [[LHChatViewCell alloc] initWithMessageModel:messageModel reuseIdentifier:cellIdentifier];
    }
    
    messageCell.messageModel = messageModel;
    return messageCell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 31;
    } else {
        Message *model = (Message *)obj;
        CGFloat height = [[self.rowHeight objectForKey:model.id] floatValue];
        if (height) {
            return height;
        }
        height = [LHChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:model];
        [self.rowHeight setObject:@(height) forKey:model.messageID];
        return height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dianji");
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.tableView.editing) {
        
        [self.deltedArray addObject:self.dataSource[indexPath.row]];
    }

    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"dianji");
    [self.deltedArray removeObject:self.dataSource[indexPath.row]];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isMeetRefresh) {
        return 40;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.isMeetRefresh) return nil;
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((SCREEN_W - 15) * 0.5, (20 - 15) * 0.5, 15, 15)];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityIndicatorView startAnimating];
    [refreshView addSubview:activityIndicatorView];
    return refreshView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self dropDownLoadDataWithScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        DLog(@"scrollView停止滚动，完全静止");
        [self dropDownLoadDataWithScrollView:scrollView];
    } else {
        DLog(@"用户停止拖拽，但是scrollView由于惯性，会继续滚动，并且减速");
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.chatBarView hideKeyboard];
}



#pragma mark - XSBrowserDelegate
/** 获取一个和被点击cell一模一样的UIImageView */
- (UIImageView *)XSBrowserDelegate:(XSBrowserAnimateDelegate *)browserDelegate imageViewForRowAtIndex:(NSInteger)index {
    NSArray *cells = [self.tableView visibleCells];
    __block UIImageView *imageView = nil;
    [cells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LHChatViewCell class]]) {
            LHChatViewCell *cell = (LHChatViewCell *)obj;
            if (cell.messageModel.type == MessageBodyType_Image) {
                LHChatImageBubbleView *imageBubbleView = (LHChatImageBubbleView *)cell.bubbleView;
                if ([[NSString stringWithFormat:@"%lld",cell.messageModel.date] isEqualToString:_imageKeys[index]]) {
                    imageView = [[UIImageView alloc] initWithImage:imageBubbleView.imageView.image];
                    imageView.frame = imageBubbleView.imageView.frame;
                    *stop = YES;
                }
            }
        }
    }];
    return imageView;
}

/** 获取被点击cell相对于keywindow的frame */
- (CGRect)XSBrowserDelegate:(XSBrowserAnimateDelegate *)browserDelegate fromRectForRowAtIndex:(NSInteger)index {
    NSArray *cells = [self.tableView visibleCells];
    __block LHChatImageBubbleView *currentImageBubbleView;
    __block UIImageView *imageView = nil;
    [cells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LHChatViewCell class]]) {
            LHChatViewCell *cell = (LHChatViewCell *)obj;
            if (cell.messageModel.type == MessageBodyType_Image) {
                LHChatImageBubbleView *imageBubbleView = (LHChatImageBubbleView *)cell.bubbleView;
                if ([[NSString stringWithFormat:@"%d",cell.messageModel.date] isEqualToString:_imageKeys[index]]) {
                    imageView = imageBubbleView.imageView;
                    currentImageBubbleView = imageBubbleView;
                    *stop = YES;
                }
            }
        }
    }];
    if (imageView) {
        return [currentImageBubbleView convertRect:imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    } else return CGRectZero;
}

/** 获取被点击cell中的图片, 将来在图片浏览器中显示的尺寸 */
- (CGRect)XSBrowserDelegate:(XSBrowserAnimateDelegate *)browserDelegate toRectForRowAtIndex:(NSInteger)index {
    __block CGSize size = CGSizeZero;
   
    
   
    [SDImageCache.sharedImageCache queryCacheOperationForKey:_imageKeys[index] done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
        size = image.size;

    }];
    
    CGFloat height = size.height * SCREEN_W / size.width;
    if (height > SCREEN_H) {
        return CGRectMake(0, 0, SCREEN_W, height);
    } else {
        CGFloat offsetY = (SCREEN_H - height) * 0.5;
        return CGRectMake(0, offsetY, SCREEN_W, height);
    }
}

/** 是否在可视区域 */
- (BOOL)XSBrowserDelegate:(XSBrowserAnimateDelegate *)browserDelegate isVisibleForRowAtIndex:(NSInteger)index {
    NSArray *cells = [self.tableView visibleCells];
    __block BOOL isVisual = YES;
    [cells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LHChatViewCell class]]) {
            LHChatViewCell *cell = (LHChatViewCell *)obj;
            if (cell.messageModel.type == MessageBodyType_Image) {
                if ([[NSString stringWithFormat:@"%lld",cell.messageModel.date] isEqualToString:_imageKeys[index]]) {
                    isVisual = NO;
                    *stop = YES;
                }
            }
        }
    }];
    return isVisual;
}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight -1, SCREEN_W, SCREEN_H - kChatBarHeight - kNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor lh_colorWithHex:0xffffff];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView addObserver:self forKeyPath:kTableViewOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_tableView addObserver:self forKeyPath:kTableViewFrame options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return _tableView;
}

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = .7;
        _blackView.hidden = YES;
        
    }
    return _blackView;
}

- (LHChatBarView *)chatBarView {
    if (!_chatBarView) {
        LHWeakSelf;
        _chatBarView = [[LHChatBarView alloc] initWithFrame:CGRectMake(0, SCREEN_H - kChatBarHeight, SCREEN_W, kChatBarHeight)];
        _chatBarView.backgroundColor = [UIColor lh_colorWithHex:0xf8f8fa];
        _chatBarView.delegate = self;
        _chatBarView.tableView = self.tableView;
        _chatBarView.isZhubo = isZhubo;
        _chatBarView.sendContent = ^(LHContentModel *content) {
            [weakSelf sendMessage:content];
        };
    }
    return _chatBarView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = @[].mutableCopy;
    }
    return _messages;
}

- (NSCache *)rowHeight {
    if (!_rowHeight) {
        _rowHeight = [NSCache new];
    }
    return _rowHeight;
}

- (XSBrowserAnimateDelegate *)browserAnimateDelegate {
    if (!_browserAnimateDelegate) {
        _browserAnimateDelegate = [XSBrowserAnimateDelegate shareInstance];
    }
    return _browserAnimateDelegate;
}

@end
