//
//  OnlineUserCell.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/28.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "OnlineUserCell.h"

@implementation OnlineUserCell
+ (OnlineUserCell *)tableView:(UITableView *)tableView
                        model:(UserModel *)model
                    indexPath:(NSIndexPath *)indexPath
{
    OnlineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnlineUserCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OnlineUserCell" owner:self options:nil] firstObject];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.model = model;
    return cell;
}
- (void)setModel:(UserModel *)model {
    _model = model;
    self.nameLabel.text = model.nickname;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"headerImage.jpg"]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 5;
    self.headerImageView.layer.cornerRadius = 5;
    self.chatButton.layer.cornerRadius = 15;
    self.videoButton.layer.cornerRadius = 15;
    
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowRadius = 5.f;
    self.bgView.layer.shadowOpacity = .3f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.headerImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headerImageView.layer.shadowRadius = 5.f;
    self.headerImageView.layer.shadowOpacity = .3f;
    self.headerImageView.layer.shadowOffset = CGSizeMake(0, 2);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageAC)];
    [self.headerImageView addGestureRecognizer:tap];
}

- (void)headerImageAC {
    LxPersonVC *vc = [[LxPersonVC alloc] init];
    vc.personUID = self.model.uid;
    vc.isFromHeader = YES;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chatButtonAC:(id)sender {
    
    LHChatVC *chatVC = [[LHChatVC alloc] init];
    chatVC.sendUid = self.model.uid;
    chatVC.isFromHeader = NO;
    [[self viewController].navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)videoButtonAC:(id)sender {
    if ([AppDelegate shareAppDelegate].netStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"当前网络不可用，请检查您的网络设置") delegate:nil cancelButtonTitle:LXSring(@"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    AppDelegate *app = [AppDelegate shareAppDelegate];
    if(![app.inst isOnline]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LXSring(@"提示") message:LXSring(@"您正处于离线状态") delegate:nil cancelButtonTitle:LXSring(@"确定") otherButtonTitles:nil, nil];
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
@end
