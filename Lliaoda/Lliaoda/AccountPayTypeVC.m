//
//  AccountPayTypeVC.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/25.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AccountPayTypeVC.h"

@interface AccountPayTypeVC ()<PKPaymentAuthorizationViewControllerDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>

@end

@implementation AccountPayTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"%d", _accountModel.price);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.text = LXSring(@"帳戶");
    self.nav.backgroundColor = [UIColor clearColor];
    self.titleLable.textColor = [UIColor whiteColor];
    [self.backButtton setImage:[UIImage imageNamed:@"back_bai"] forState:UIControlStateNormal];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *iden = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        AccountHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"AccountHeaderView" owner:self options:nil] lastObject];
        headerView.frame = CGRectMake(0, 0, SCREEN_W, 246);
        if (headerView == nil) {
            headerView = [[AccountHeaderView alloc] init];
        }
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.countLabel.text = _depositCount;
        [headerView.inviteButton addTarget:self action:@selector(inviteBtnAC) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:headerView];
        return cell;
        
        
    } else {
        return [AccountPayTypeCell tableView:tableView
                                   indexPath:indexPath
                                    delegate:self];
        
//        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 246;
    }
    return 265 - 50;
}

- (void)inviteBtnAC {
    InvitationVC *vc = [[InvitationVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - AccountPayTypeCellDelegate
// unipin
- (void)unipinAC {
    
}
// 话费
- (void)huafeiAC {
//    http://demo.yizhiliao.tv/pages/id-id/unipin_dcb.html?order=<订单ID>&price=<支付的价格>
    [self orderCreate:self.accountModel.uid withType:HuaFeiPay];
    
}
// 苹果支付
- (void)appleAC {
    [self orderCreate:self.accountModel.uid withType:AppPay];
}

- (void)orderCreate:(NSString *)uid withType:(PayType)type
{
    NSDictionary *params = @{@"uid":[NSString stringWithFormat:@"%@", uid], @"referee":[NSString stringWithFormat:@"%@", self.orderReferee], @"system":@4};
    [WXDataService requestAFWithURL:Url_ordercreate params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSString *uids = result[@"data"][@"uid"];
                
                OrderID *order = [[OrderID alloc] init];
                order.orderID = uids;
                [order save];
                
                if (type == AppPay) {
                    if([SKPaymentQueue canMakePayments]){
                        [self requestProductData:uid];
                    }else{
                        
                        [SVProgressHUD showErrorWithStatus:LXSring(@"不允许程序内付费...")];
                    }
                } else if (type == HuaFeiPay) {
                    NSString *price = [NSString stringWithFormat:@"%d", self.accountModel.price / 100];
                    NSString *url = [NSString stringWithFormat:@"http://demo.yizhiliao.tv/pages/id-id/unipin_dcb.html?order=%@&price=%@", uids, price];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }
                
                
                //                [self Pay:uid withType:type];
                
                
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

//请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:nil];
    
    NSArray *product = [[NSArray alloc] initWithObjects:type,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    [SVProgressHUD showWithStatus:LXSring(@"正在加載")];
    
}
//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈訊息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        [SVProgressHUD showErrorWithStatus:LXSring(@"ProductID为无效ID")];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
        });
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    //取到内购产品进行购买
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:response.products.firstObject];
    payment.applicationUsername = [LXUserDefaults objectForKey:UID];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:LXSring(@"支付失敗")];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
        
    });
}
- (void)requestDidFinish:(SKRequest *)request{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
    });
}
// 联系客服
- (void)kefuAC {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"Untuk top up manual, mohon hubungi line: CandyTalk" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Salin ID", nil];
    [alert show];
}

@end
