//
//  VideoCallRedView.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/23.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoCallRedView.h"

@implementation VideoCallRedView

- (instancetype)initVideoCallRedView
{
    self = [super init];
    
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        self.frame = CGRectMake(15, kScreenHeight, kScreenWidth - 30, 321);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        _inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];

        self.textView.delegate = self;
        self.dataList = [NSMutableArray array];
        self.firstView.layer.masksToBounds = YES;
        self.firstView.layer.cornerRadius = 5;
        
        self.sendView.layer.masksToBounds = YES;
        self.sendView.layer.cornerRadius = 5;
        
        self.threeView.layer.masksToBounds = YES;
        self.threeView.layer.cornerRadius = 5;
        
        self.sendBtn.layer.masksToBounds = YES;
        self.sendBtn.layer.cornerRadius = 5;
        
        self.chongBtn.layer.masksToBounds = YES;
        self.chongBtn.layer.cornerRadius = 5;

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

#pragma mark ----------键盘通知方法---------------
- (void)keyboardWillChange:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 属性动画
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    self.top = kScreenHeight - 321 - [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 属性动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    self.top = kScreenHeight - 321;
    
    [UIView commitAnimations];
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        self.textViewP.text = @"恭喜發財，越來越美";
    }else{
        self.textViewP.text = @"";
    }
    
//    self.countText.text = [NSString stringWithFormat:@"%lu/20",(unsigned long)self.textView.text.length];
//    if (textView.text.length > 20) {
//        
//        textView.text = [textView.text substringToIndex:20];
//        self.countText.text = [NSString stringWithFormat:@"20/20"];
//    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    
    //获取高亮部分
    
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    
    if (selectedRange && pos) {
        
        return;
        
    }
    
    NSString  *nsTextContent = textView.text;
    
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > 20)
        
    {
        
        //截取到最大位置的字符
        
        NSString *s = [nsTextContent substringToIndex:20];
        
        [textView setText:s];
        
    }
    
    //不让显示负数
    
    self.countText.text = [NSString stringWithFormat:@"%ld/%d",existTextNum,20];
    
}






-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
   
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    
    //获取高亮部分
    
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //获取高亮部分内容
    
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    
    if (selectedRange && pos) {
        
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < 20) {
            
            return YES;
            
        }
        
        else
            
        {
            
            return NO;
            
        }
        
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = 20 - comcatstr.length;
    
    if (caninputlen >= 0)
        
    {
        
        return YES;
        
    }
    
    else
        
    {
        
        NSInteger len = text.length + caninputlen;
        
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
            
        {
            
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            
            //既然是超出部分截取了，哪一定是最大限制了。
            
            self.countText.text = [NSString stringWithFormat:@"%d/%ld",20,(long)20];
            
        }
        
        return NO;
        
    }
    
    
    return YES;
    
}

- (IBAction)closeAC:(id)sender {
    
    [self endEditing:YES];
    [UIView animateWithDuration:.35 animations:^{
        
        self.top = kScreenHeight;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)sendRed:(NSTimer *)timer
{
    if (self.dataList.count == 0) {
    
        [self.timer invalidate];
        self.timer = nil;
        
    }else{
        
        GiftModel *giftModel = self.dataList[0];
        NSString *userId = [NSString stringWithFormat:@"%@%@",[LXUserDefaults objectForKey:UID], giftModel.giftUid];
        AnimOperationManager *manager = [AnimOperationManager sharedManager];
        manager.parentView = self.superview;
        [manager animWithUserID:userId model:giftModel finishedBlock:^(BOOL result) {
            
        }];
        [self.dataList removeObjectAtIndex:0];

    }

}

- (void)animationWithCount:(int)count{

    if (count > 5) {
        count = 5;
    }
   count = count / 2;
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    //例子发射位置
    snowEmitter.emitterPosition = CGPointMake(kScreenWidth / 2,-20);
    //发射源的尺寸大小
    snowEmitter.emitterSize = CGSizeMake(kScreenWidth, 10);
    snowEmitter.backgroundColor = [UIColor redColor].CGColor;
    //发射模式
    snowEmitter.emitterMode = kCAEmitterLayerOutline;
    //发射源的形状
    snowEmitter.emitterShape = kCAEmitterLayerLine;
    
    _snowflake  = [CAEmitterCell emitterCell];
    _snowflake.birthRate       = 1;
    _snowflake.velocity        = -30;
    _snowflake.velocityRange   = 10;
    _snowflake.yAcceleration   = 100.f;
    _snowflake.contents        = (__bridge id)([UIImage imageNamed:@"红包雨02"].CGImage);
    _snowflake.lifetime        = 60.f;
    _snowflake.scale           = 0.5;
    _snowflake.scaleRange      = 0.3;
    snowEmitter.emitterCells = [NSArray arrayWithObjects:_snowflake,nil];
    [self.superview.layer addSublayer:snowEmitter];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        _snowflake.birthRate = 0;
//        snowEmitter.emitterCells = [NSArray arrayWithObjects:_snowflake,nil];
        snowEmitter.birthRate = 0;
        
    });
}

- (IBAction)sendAc:(id)sender {
    
    if ([_onetextField.text integerValue] < 100) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲！红包金额不能低于100鑽石" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([_twotextField.text integerValue] < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲！红包个数不能小于1" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    int acount = [_twotextField.text intValue];
    int diamonds = [_onetextField.text intValue];
    NSString *message;
    if (_textView.text.length == 0) {
        message = @"恭喜發財，越來越美";
    }else{
        message = _textView.text;
    }
    [self endEditing:YES];
    NSDictionary *params;
    params = @{@"uid":@(-1),@"receiverId":self.pmodel.uid,@"quantity":@(acount),@"diamonds":@(diamonds),@"message":message};
    [WXDataService requestAFWithURL:Url_giftsend params:params httpMethod:@"POST" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                //余额显示
                NSString *deposit = [NSString stringWithFormat:@"%@",result[@"data"][@"deposit"]];
                NSString *str = [NSString stringWithFormat:@"余额:%@鑽",deposit];
                NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:str];
                [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(3, deposit.length)];
                self.eLabel.attributedText = alertControllerMessageStr;
                
               
                
                NSString *uid = [NSString stringWithFormat:@"%@",result[@"data"][@"uid"]];
                // 礼物模型
                GiftModel *giftModel = [[GiftModel alloc] init];
                giftModel.headImage = [UIImage imageNamed:@"红包雨02"];
                giftModel.giftName = message;
                giftModel.giftCount = 1;
                giftModel.giftUid = @"-1";
                giftModel.diamonds = diamonds;
                
                for (int i = 0; i<acount; i++) {
                    [self.dataList addObject:giftModel];
                }
                if (acount > 1) {
                    [self animationWithCount:acount];
                }
                
                if (self.timer == nil) {
                    
                    self.timer =  [NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(sendRed:) userInfo:nil repeats:YES];
                }
                
                
                long idate = [[NSDate date] timeIntervalSince1970]*1000;
                NSDictionary *dic = @{
                                      @"message": @{
                                              @"messageID": @"-1",
                                              @"event": @"gift",
                                              @"content": uid,
                                              @"time": [NSString stringWithFormat:@"%ld",idate]
                                              }
                                      };
                
                NSString *msgStr = [InputCheck convertToJSONData:dic];
                [_inst messageInstantSend:self.pmodel.uid uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"-1"]];
                
            }else{    //请求失败
                
                if ([[result objectForKey:@"result"] integerValue] == 8) {
                    
                    
                    LGAlertView *lg = [[LGAlertView alloc] initWithTitle:@"购买鑽石" message:@"老闆，鑽石不夠啦～儲值後立刻打賞！" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"［暫不用］" destructiveButtonTitle:@"［去儲值］" delegate:nil];
                    lg.destructiveButtonBackgroundColor = Color_nav;
                    lg.destructiveButtonTitleColor = [UIColor whiteColor];
                    lg.cancelButtonFont = [UIFont systemFontOfSize:16];
                    lg.cancelButtonBackgroundColor = [UIColor whiteColor];
                    lg.cancelButtonTitleColor = Color_nav;
                    lg.destructiveHandler = ^(LGAlertView * _Nonnull alertView) {
                        self.superview.hidden = YES;
                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                        AccountVC *vc = [[AccountVC alloc] init];
                        vc.isCall = YES;
                        vc.clickBlock = ^(){
                            
                            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                            self.superview.hidden = NO;
                            
                            
                        };
                        [[self topViewController].navigationController pushViewController:vc animated:YES];
                        
                    };
                    [lg showAnimated:YES completionHandler:nil];
                    
                    
                }
                
                
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

- (IBAction)chongzhiAC:(id)sender{
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.superview.hidden = YES;
    AccountVC *vc = [[AccountVC alloc] init];
    vc.isCall = YES;
    vc.clickBlock = ^(){
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        self.superview.hidden = NO;
        
    };
    [[self topViewController].navigationController pushViewController:vc animated:YES];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[AppDelegate shareAppDelegate].window rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
        
    }else{
        
        return vc;
    }
    
    return nil;
}



@end










































