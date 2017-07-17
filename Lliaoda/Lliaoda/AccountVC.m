

//
//  AccountVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/18.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "AccountVC.h"
#import <PassKit/PassKit.h>
#import <AddressBook/AddressBook.h>
#import <StoreKit/StoreKit.h>

enum{
    IAP0p20=20,
    IAP1p100,
    IAP4p600,
    IAP9p1000,
    IAP24p6000,
}buyCoinsTag;

//在内购项目中创的商品单号
#define ProductID_IAP0p20 @"1"//20
#define ProductID_IAP1p100 @"2" //100
#define ProductID_IAP4p600 @"Nada.JPYF03" //600
#define ProductID_IAP9p1000 @"Nada.JPYF04" //1000
#define ProductID_IAP24p6000 @"Nada.JPYF05" //6000


@interface AccountVC ()<PKPaymentAuthorizationViewControllerDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>
{
    
    int buyType;
    
}
@property (nonatomic,strong) NSArray *profuctIdArr;
@property (nonatomic,copy) NSString *currentProId;

@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.text = @"賬戶";
    self.dataList = [NSMutableArray array];
    self.accountLab.text = [NSString stringWithFormat:@"%d",self.deposit];
    self.headerView.width = kScreenWidth;
    self.headerView.height = kScreenWidth / 750 * 478;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiXinPay:) name:Notice_weiXinPay object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appPaySugerss:) name:Notice_appPaySugerss object:nil];
    
    [self _loadData];
    if (self.isCall) {
        
        [self _loadData1];
        
    }
    
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [self createPay];
    
    
}

- (void)appPaySugerss:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    self.accountLab.text = [NSString stringWithFormat:@"%@",userInfo[@"data"][@"deposit"]];
    
}

- (void)createPay
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = CGRectMake(100, 100, 100, 100);
    //    button.backgroundColor = [UIColor clearColor];
    //    [button setTitle:@"6元" forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    //    button.tag = 100;
    //    [self.view addSubview:button];
}

- (void)btnClick:(int)index
{
    AccountModel *model = self.dataList[index];
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData:model.uid];
    }else{
        NSLog(@"不允许程序内付费");
        [SVProgressHUD showErrorWithStatus:@"不允许程序内付费..."];
        
    }
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
    [SVProgressHUD showWithStatus:@"正在加載"];

    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈訊息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        [SVProgressHUD showErrorWithStatus:@"ProductID为无效ID"];
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
    [SVProgressHUD showErrorWithStatus:@"支付失敗"];
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

#pragma mark - PrivateMethod
//- (void)dl_completeTransaction:(SKPaymentTransaction *)transaction {
//    NSString *productIdentifier = transaction.payment.productIdentifier;
//    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
//     NSString *receipt = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符
//    if ([receipt length] > 0 && [productIdentifier length] > 0) {
//        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            
//            [SVProgressHUD dismiss];
//            
//        });
//        /**
//         可以将receipt发给服务器进行购买验证
//         */
//        [self appPayWithReceipt:receipt withTransaction:transaction];
//        
//    }
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//
//}
//
//- (void)appPayWithReceipt:(NSString *)receipt withTransaction:(SKPaymentTransaction *)transaction
//{
//    
//    NSDictionary *params;
//    params = @{@"receipt":receipt};
//    [WXDataService requestAFWithURL:Url_payiappaynotify params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES  finishBlock:^(id result) {
//        if(result){
//            if ([[result objectForKey:@"result"] integerValue] == 0) {
//                
//                self.accountLab.text = [NSString stringWithFormat:@"%@",result[@"data"][@"deposit"]];
////                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//  
//            }else{    //请求失败
//                
//                [SVProgressHUD showErrorWithStatus:result[@"message"]];
//                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                    
//                    [SVProgressHUD dismiss];
//                    
//                });
//                
//            }
//        }
//        
//    } errorBlock:^(NSError *error) {
//        NSLog(@"%@",error);
//        [SVProgressHUD dismiss];
//
//    }];
//
//
//}
//
//- (void)dl_failedTransaction:(SKPaymentTransaction *)transaction {
//    if(transaction.error.code != SKErrorPaymentCancelled) {
//        [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            
//            [SVProgressHUD dismiss];
//            
//        });
//
//    } else {
//        [SVProgressHUD showErrorWithStatus:@"支付失败"];
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            
//            [SVProgressHUD dismiss];
//            
//        });
//
//    }
//    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//}
//
//
//- (void)dl_restoreTransaction:(SKPaymentTransaction *)transaction {
//    
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//}
//
//-(void)dl_validateReceiptWiththeAppStore:(NSString *)receipt
//{
//    NSError *error;
//    NSDictionary *requestContents = @{@"receipt-data": receipt};
//    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
//    
//    if (!requestData) {
//        
//    }else{
//        
//    }
//    NSURL *storeURL;
//#ifdef DEBUG
//    storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
//#else
//    storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
//#endif
//    
//    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
//    [storeRequest setHTTPMethod:@"POST"];
//    [storeRequest setHTTPBody:requestData];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               if (connectionError) {
//                                   /* 处理error */
//                               } else {
//                                   NSError *error;
//                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//                                   if (!jsonResponse) {
//                                       /* 处理error */
//                                   }else{
//                                       /* 处理验证结果 */
//                                   }
//                               }
//                           }];
//    
//}
////监听购买结果
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
//    
//    
//    for (SKPaymentTransaction *transaction in transactions)
//    {
//        switch (transaction.transactionState)
//        {
//            case SKPaymentTransactionStatePurchased://购买成功
//                [self dl_completeTransaction:transaction];
//                break;
//            case SKPaymentTransactionStateFailed://购买失败
//                [self dl_failedTransaction:transaction];
//                break;
//            case SKPaymentTransactionStateRestored://恢复购买
//                [self dl_restoreTransaction:transaction];
//                break;
//            case SKPaymentTransactionStatePurchasing://正在处理
//                break;
//            default:
//                break;
//        }
//    }
//}
//
////交易结束
//- (void)completeTransaction:(SKPaymentTransaction *)transaction{
//    NSLog(@"交易结束");
//    
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//}
//


//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_weiXinPay object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_appPaySugerss object:nil];
//}

- (void)weiXinPay:(NSNotification *)notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    int errcode = [userInfo[@"errCode"] intValue];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    
    switch (errcode) {
        case 0:
            //payResoult = @"支付结果：成功！";
            [self _loadData1];
            [SVProgressHUD showWithStatus:@"支付成功"];
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
            });
            
            break;
        case -1:
            //                payResoult = @"支付结果：失败！";
            [SVProgressHUD showWithStatus:@"支付失败"];
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
            });
            break;
        case -2:
            //                payResoult = @用户已经退出支付！;
            [SVProgressHUD showWithStatus:@"用户已经退出支付！"];
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
            });
            break;
        default:
            //                payResoult = [NSString stringWithFormat:@支付结果：失败！retcode = %d, retstr = %@, resp.errCode,resp.errStr];
            break;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _loadData1];
    
}

-(void) onResp:(BaseResp*)resp
{
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        
        switch (resp.errCode) {
            case 0:
                //payResoult = @"支付结果：成功！";
                [self _loadData1];
                [SVProgressHUD showWithStatus:@"支付成功"];
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
                break;
            case -1:
                //                payResoult = @"支付结果：失败！";
                [SVProgressHUD showWithStatus:@"支付失败"];
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                break;
            case -2:
                //                payResoult = @用户已经退出支付！;
                [SVProgressHUD showWithStatus:@"用户已经退出支付！"];
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                break;
            default:
                //                payResoult = [NSString stringWithFormat:@支付结果：失败！retcode = %d, retstr = %@, resp.errCode,resp.errStr];
                break;
        }
    }
    
    
}

- (void)_loadData1
{
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"GET" isHUD:NO isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                Mymodel *model = [Mymodel mj_objectWithKeyValues:result[@"data"]];                self.accountLab.text = [NSString stringWithFormat:@"%d",model.deposit];
                [_tableView reloadData];
                
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

- (void)back
{
    
    if (self.isCall) {
        
        self.clickBlock();
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)_loadData
{
    NSDictionary *params;
    [WXDataService requestAFWithURL:Url_commodities params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES  finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSArray *array = result[@"data"][@"commodities"];
                for (NSDictionary *dic in array) {
                    AccountModel *model = [AccountModel mj_objectWithKeyValues:dic];
                    [self.dataList addObject:model];
                }
                
                [_tableView reloadData];
                
            }else{    //请求失败
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark --------UITableView Delegete----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifire = @"cellID";
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountCell" owner:nil options:nil] lastObject];
        
    }
    
    AccountModel *model = self.dataList[indexPath.row];
    cell.valueLab.text = model.name;
    
    if (fmodf(model.price / 100.00, 1)==0) {//如果有一位小数点
        [cell.priceBtn setTitle:[NSString stringWithFormat:@"NT$%.0f",model.price / 100.00] forState:UIControlStateNormal];
    } else if (fmodf(model.price / 100.00, 1)==0) {//如果有两位小数点
        
        [cell.priceBtn setTitle:[NSString stringWithFormat:@"NT$%.1f",model.price / 100.00] forState:UIControlStateNormal];
    } else {
        
        [cell.priceBtn setTitle:[NSString stringWithFormat:@"NT$%.2f",model.price / 100.00] forState:UIControlStateNormal];
    }
    
    [cell.headIG sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    cell.priceBtn.tag = indexPath.row;
    [cell.priceBtn addTarget:self action:@selector(buttonAC:) forControlEvents:UIControlEventTouchUpInside];
    cell.model = model;
    
    return cell;
    
    
}

- (void)buttonAC:(UIButton *)sender
{
    
    AccountModel *model = self.dataList[sender.tag];
    
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"立即支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        [self btnClick:sender.tag];
        
//    }];
//    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        
//        [self orderCreate:model.uid withType:WeixinPay];
//        
//    }];
//    
//    UIAlertAction *aliAction1 = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        
//        [self orderCreate:model.uid withType:AliPay];
//        
//    }];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [cancelAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
//    [defaultAction setValue:[MyColor colorWithHexString:@"#4FB854"] forKey:@"_titleTextColor"];
//    [aliAction1 setValue:[MyColor colorWithHexString:@"#4FB854"] forKey:@"_titleTextColor"];
//    
//    [defaultAction1 setValue:[MyColor colorWithHexString:@"#4FB854"] forKey:@"_titleTextColor"];
//    
//            [alertController addAction:defaultAction1];
//    
////            [alertController addAction:aliAction1];
//    
//    //    if ([LXUserDefaults boolForKey:payEnable]) {
////    [alertController addAction:defaultAction];
//    //    }
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)orderCreate:(NSString *)uid withType:(PayType)type
{
    
    NSDictionary *params = @{@"uid":uid};
    [WXDataService requestAFWithURL:Url_ordercreate params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSString *uid = result[@"data"][@"uid"];
                
                [self Pay:uid withType:type];
                
                
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


//微信支付
- (void)Pay:(NSString *)uid withType:(PayType)type
{
    
    if (type == WeixinPay) {
        
        NSDictionary *params = @{@"uid":uid};
        [WXDataService requestAFWithURL:Url_wechatpayapp params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
            if(result){
                NSDictionary *dic = result[@"data"];
                
                PayReq *request = [[PayReq alloc] init];
                request.openID = [dic objectForKey:@"appid"];
                request.partnerId = [dic objectForKey:@"partnerid"];
                request.prepayId= [dic objectForKey:@"prepayid"];
                request.package = [dic objectForKey:@"package"];
                request.nonceStr= [dic objectForKey:@"noncestr"];
                
                NSString *timestr = [NSString stringWithFormat:@"%@",dic[@"timestamp"]];
                UInt32 time = (UInt32)[timestr longLongValue];
                request.timeStamp = time;
                // 签名加密
                request.sign= [dic objectForKey:@"sign"];
                // 调用微信
                [WXApi sendReq:request];
                [WXApi sendAuthReq:result viewController:self delegate:self];
                
            }else{    //请求失败
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
            }
            
        } errorBlock:^(NSError *error) {
            
        }];
        
        
        return;
        
    }
    
    
}

#pragma mark ----支付状态
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)
controller   didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus  status))completion
{
    
    /*
     NSError *error;
     ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.billingAddress ,kABPersonAddressProperty);
     NSDictionary *addressDictionary = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);
     //这里模拟取出地址里的每一个信息。
     NSLog(@"%@",addressDictionary[@"State"]);
     NSData *json = [NSJSONSerialization dataWithJSONObject:addressDictionary options:NSJSONWritingPrettyPrinted error: &error];
     // 这里需要将Token和地址信息发送到自己的服务器上，进行订单处理，处理之后，根据自己的服务器返回的结果调用completion()代码块，根据传进去的参数界面的显示结果会不同
     PKPaymentAuthorizationStatus status; // From your server
     completion(status);
     */
    //拿到token，
    PKPaymentToken *token = payment.token;
    NSLog(@"花费: %@", payment);
    BOOL asyncSuccessful = FALSE;
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        NSLog(@"支付成功");
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        NSLog(@"支付失败");
    }
}

#pragma mark ----支付完成
- (void)paymentAuthorizationViewControllerDidFinish:
(PKPaymentAuthorizationViewController *)controller {
    // 支付完成后让支付页面消失
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
