//
//  BannerView.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/8/22.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "BannerView.h"

@implementation BannerView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

-(SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        CGRect frame = CGRectMake(15, 15, kScreenWidth - 30, (kScreenWidth - 30) / 690 * 230);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:nil];
        [_cycleScrollView setPageControlAliment:SDCycleScrollViewPageContolAlimentRight];
        [_cycleScrollView setPageControlStyle:SDCycleScrollViewPageContolStyleAnimated];
        [_cycleScrollView setPageControlDotSize:CGSizeMake(6, 6)];
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.layer.cornerRadius = 5;
        _cycleScrollView.layer.masksToBounds = YES;
         [self addSubview:self.cycleScrollView];
    }
    return _cycleScrollView;
}

/** 点击图片回调banner */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    SelectedBannersModel *model = self.list[index];
//    NSString *url = model.link;
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    if ([model.link isEqualToString:@"#"]) {
        return;
    } else if ([model.link containsString:@"/app/user?id="]) {
        NSString *userID = [model.link substringFromIndex:13];
        LxPersonVC *vc = [[LxPersonVC alloc] init];
        vc.personUID = userID;
        vc.isFromHeader = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
    } else {
        if (model.target == 0) {
            WebVC *vc = [[WebVC alloc] init];
            vc.urlStr = model.link;
            vc.deposit = self.model.deposit;
            vc.model = self.model;
            [[self viewController].navigationController pushViewController:vc animated:YES];
            
        } else {
            NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
            if ([lang hasPrefix:@"id"]){
                if ([model.link isEqualToString:@"/app/pay"]) {
                    // 支付
                    AccountPayTypeVC *vc = [[AccountPayTypeVC alloc] init];
                    [[self viewController].navigationController pushViewController:vc animated:YES];
                    
                } else if ([model.link isEqualToString:@"/app/pay/unipin"]) {
                    // 第三方支付
                    [self unipinAC];
                    
                } else if ([model.link isEqualToString:@"/app/pay/unipin_dcb"]) {
                    // 话费支付
                    [self huafeiAC];
                    
                } else if ([model.link isEqualToString:@"/app/pay/store"]) {
                    // 苹果支付
                    [self appleAC];
                    
                } else if ([model.link isEqualToString:@"#"]) {
                    return;
                }
                else {
                    //邀请有奖
                    InvitationVC *vc = [[InvitationVC alloc] init];
                    vc.model = self.model;
                    [[self viewController].navigationController pushViewController:vc animated:YES];
                    
                }
                
            }else if ([lang hasPrefix:@"ar"]){
                if ([model.link hasPrefix:@"/app/pay"]) {
                    // 支付
                    AccountVC *vc = [[AccountVC alloc] init];
                    [[self viewController].navigationController pushViewController:vc animated:YES];
                } else {
                    //邀请有奖
                    InvitationVC *vc = [[InvitationVC alloc] init];
                    vc.model = self.model;
                    [[self viewController].navigationController pushViewController:vc animated:YES];
                    
                }
            }
            
            //        WebVC *vc = [[WebVC alloc] init];
            //        vc.urlStr = model.link;
            //        [[self viewController].navigationController pushViewController:vc animated:YES];
        }
    }
    
}

// unipin
- (void)unipinAC {
    AccountVC *vc = [[AccountVC alloc] init];
    vc.deposit = self.model.deposit;
    vc.payType = UnipinPay;
    vc.isCall = NO;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}
// 话费
- (void)huafeiAC {
    AccountVC *vc = [[AccountVC alloc] init];
    vc.deposit = self.model.deposit;
    vc.payType = HuaFeiPay;
    vc.isCall = NO;
    [[self viewController].navigationController pushViewController:vc animated:YES];
    
    //    http://demo.yizhiliao.tv/pages/id-id/unipin_dcb.html?order=<订单ID>&price=<支付的价格>
    //    [self orderCreate:self.accountModel.uid withType:HuaFeiPay];
}

// 苹果支付
- (void)appleAC {
    AccountVC *vc = [[AccountVC alloc] init];
    vc.deposit = self.model.deposit;
    vc.payType = AppPay;
    vc.isCall = NO;
    [[self viewController].navigationController pushViewController:vc animated:YES];
    
    //    [self orderCreate:self.accountModel.uid withType:AppPay];
}


- (void)setList:(NSArray *)list
{
    _list = list;
    NSMutableArray *marr1 = [NSMutableArray array];
    
    for (SelectedBannersModel *model in _list) {
        [marr1 addObject:model.cover];
    }
    self.cycleScrollView.imageURLStringsGroup = marr1;

}

@end
