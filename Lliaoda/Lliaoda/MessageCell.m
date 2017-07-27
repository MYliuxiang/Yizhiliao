//
//  MessageCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/27.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 30;
    [self.countLabel sizeToFit];
    self.countLabel.width = self.countLabel.width + 8;
    self.countLabel.height = self.countLabel.height + 8;
    if (self.countLabel.width < self.countLabel.height) {
        self.countLabel.width = self.countLabel.height;
    }
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = self.countLabel.height / 2.0;
    self.countLabel.bottom = self.headerImageView.bottom;
    self.countLabel.right = self.headerImageView.right;
    
}

- (void)setCount:(MessageCount *)count
{
    _count = count;
    
    NSString *str;
    if (_count.count > 99) {
        
        str = @"...";

        
    }else{
        
        str = [NSString stringWithFormat:@"%d",count.count];
        
    }
    self.countLabel.text = [NSString stringWithFormat:@"%d",count.count];
    if (count.count == 0) {
        
        self.countLabel.hidden = YES;
    }else{
    
        self.countLabel.hidden = NO;
    }
    
    [self.countLabel sizeToFit];
    self.countLabel.width = self.countLabel.width + 8;
    self.countLabel.height = self.countLabel.height + 8;
    if (self.countLabel.width < self.countLabel.height) {
        self.countLabel.width = self.countLabel.height;
    }
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = self.countLabel.height / 2.0;
    self.countLabel.bottom = self.headerImageView.bottom;
    self.countLabel.right = self.headerImageView.right;
    NSString *timestr = [NSString stringWithFormat:@"%lld",count.timeDate];
    self.timeLabel.text = [LHTools processingTimeWithDate:timestr];
    if (count.draft.length == 0) {
        if ([count.request isEqualToString:@"-2"]) {
            if ([count.event isEqualToString:@"gift"]) {
                self.contentLab.text = @"收到我的送禮提醒";
            } else {
                self.contentLab.text = @"收到我的充值提醒";
            }
        } else {
            if ([count.request isEqualToString:@"-3"]) {
                if ([count.event isEqualToString:@"gift"]) {
                    self.contentLab.text = [NSString stringWithFormat:@"收到我送出的：%@", count.content];
                } else {
                    self.contentLab.text = [NSString stringWithFormat:@"我已通過你的頁面充值：%@", count.content];
                }
            } else {
                self.contentLab.text = count.content;
            }
            
        }
    }else{
    
        NSString *contentStr = [NSString stringWithFormat:@"[草稿]%@",count.draft];
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(0, 4)];
        self.contentLab.attributedText = alertControllerStr;
        
    }
    
    LxCache *lxcache = [LxCache sharedLxCache];
    
    id cacheData;
    cacheData = [lxcache getCacheDataWithKey:[NSString stringWithFormat:@"%@-%@",Url_account,count.sendUid]];
    
    if (cacheData != 0) {
        //将数据统一处理
        PersonModel *pmodel = [PersonModel mj_objectWithKeyValues:cacheData[@"data"]];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:pmodel.portrait]];
        self.nickNameLab.text = pmodel.nickname;
    
    }
    
    NSDictionary *params;
    params = @{@"uid":count.sendUid};
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                LxCache *lxcache = [LxCache sharedLxCache];
                [lxcache setCacheData:result WithKey:[NSString stringWithFormat:@"%@-%@",Url_account,count.sendUid]];
           PersonModel *pmodel = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:pmodel.portrait]];
                self.nickNameLab.text = pmodel.nickname;
                                
            }else{    //请求失败
               
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        
        
    }];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
