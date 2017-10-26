//
//  CallRecordCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "CallRecordCell.h"

@implementation CallRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.thumb.layer.cornerRadius = 25;
    self.thumb.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCall:(CallTime *)call
{
    _call = call;
    
//    @"endedAt":@(call.endedAt),@"duration":@(call.duration)
//    self.time
    self.alltime.text = [self timeFormatted:(int)_call.duration /100];
    self.time.text = [InputCheck timeWithTimeIntervalString:[NSString stringWithFormat:@"%lld",_call.endedAt - _call.duration] withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    LxCache *lxcache = [LxCache sharedLxCache];
    id cacheData;
    cacheData = [lxcache getCacheDataWithKey:[NSString stringWithFormat:@"%@-%d",Url_account,_call.sendUid]];
    
    if (cacheData != 0) {
        //将数据统一处理
        
        PersonModel *pmodel = [PersonModel mj_objectWithKeyValues:cacheData[@"data"]];
        NSLog(@"%@",pmodel.nickname);
        [self.thumb sd_setImageWithURL:[NSURL URLWithString:pmodel.portrait]];
        self.name.text = pmodel.nickname;
        
    }else{
        
        NSDictionary *params;
        params = @{@"uid":[NSString stringWithFormat:@"%d",_call.sendUid]};
        [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
            if(result){
                if ([[result objectForKey:@"result"] integerValue] == 0) {
                    
                    
                    LxCache *lxcache = [LxCache sharedLxCache];
                    [lxcache setCacheData:result WithKey:[NSString stringWithFormat:@"%@-%d",Url_account,_call.uid]];
                    PersonModel *pmodel = [PersonModel mj_objectWithKeyValues:result[@"data"]];
                    NSLog(@"%@",pmodel.nickname);
                    
                    [self.thumb sd_setImageWithURL:[NSURL URLWithString:pmodel.portrait]];
                    self.name.text = pmodel.nickname;
                    
                }else{    //请求失败
                    
                    
                }
            }
            
        } errorBlock:^(NSError *error) {
            
            
        }];
        
    }
    
    
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (hours == 0) {
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


@end





