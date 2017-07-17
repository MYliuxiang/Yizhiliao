//
//  UserCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/6/22.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.chatBtn.layer.masksToBounds = YES;
    self.chatBtn.layer.cornerRadius = 5;
    self.videoBtn.layer.masksToBounds = YES;
    self.videoBtn.layer.cornerRadius = 5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UserModel *)model
{
    _model = model;
    
    [self.heagImage sd_setImageWithURL:[NSURL URLWithString:model.portrait]];
    self.nickLabel.text = model.nickname;

    self.heagImage.layer.borderWidth = 1;
    self.heagImage.layer.borderColor = [UIColorFromRGB(0xcccccc) CGColor];
}

- (IBAction)callAC:(id)sender {
    
    LHChatVC *chatVC = [[LHChatVC alloc] init];
    chatVC.sendUid = self.model.uid;
    [[self viewController].navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)videoAC:(id)sender {
    
    if ([AppDelegate shareAppDelegate].netStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用，请检查您的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
       AppDelegate *app = [AppDelegate shareAppDelegate];
    if(![app.inst isOnline]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您正处于离线状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    [self videoCallAC];

}

- (void)videoCallAC
{
    NSDictionary *params;
    params = @{@"uid":self.model.uid};
    [WXDataService requestAFWithURL:Url_chatvideocall params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSString *channel = [NSString stringWithFormat:@"%@",result[@"data"][@"channel"]];
                VideoCallView *video = [[VideoCallView alloc] initVideoCallViewWithChancel:channel withUid:self.model.uid withIsSend:YES];
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

- (void)layoutSubviews
{
    [super layoutSubviews];

}



@end
