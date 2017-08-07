//
//  AccountCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AccountCell.h"

@implementation AccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.priceBtn.layer.cornerRadius = 15;
    self.priceBtn.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AccountModel *)model
{
    _model = model;
    if (model.bonus == 0) {
        
        self.givebtn.hidden = YES;
        
    }else{
    
        NSString *str = [NSString stringWithFormat:@"贈送%d鑽",_model.bonus];
        [self.givebtn setTitle:str forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"720-赠送"];
        UIImage *imagestre = [image stretchableImageWithLeftCapWidth:36 topCapHeight:18];
        [self.givebtn setBackgroundImage:imagestre forState:UIControlStateNormal];
        self.givebtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);

        
    }

}

- (IBAction)priceAC:(id)sender {
    
    
//    if (![PKPaymentAuthorizationViewController class]) {
//        //PKPaymentAuthorizationViewController需iOS8.0以上支持
//        NSLog(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
//        return;
//    }
//    //检查当前设备是否可以支付
//    if (![PKPaymentAuthorizationViewController canMakePayments]) {
//        //支付需iOS9.0以上支持
//        NSLog(@"设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
//        return;
//    }
//    //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
//    NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
//    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
//        NSLog(DTLocalizedString(@"没有绑定支付卡", nil));
//        return;
//    }
    

    
}
@end
