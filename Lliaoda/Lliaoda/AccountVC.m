

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
#import "AccountCollectionCell.h"
#import "CollectionHeaderView.h"
#import "PayWebViewVC.h"
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
    AccountModel *accountModel;
    int buyType;
    NSString *diamondCount;
    NSString *depositCount;
}
@property (nonatomic,strong) NSArray *profuctIdArr;
@property (nonatomic,copy) NSString *currentProId;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label1;

@end

@implementation AccountVC
static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.text = LXSring(@"帳戶");
    self.label1.text = LXSring(@"账户余额");
    self.label.text = LXSring(@"鑽石");
    
    
    self.nav.backgroundColor = [UIColor clearColor];
    self.titleLable.textColor = [UIColor whiteColor];
    [self.backButtton setImage:[UIImage imageNamed:@"back_bai"] forState:UIControlStateNormal];

//    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.dataList = [NSMutableArray array];
//    self.accountLab.text = [NSString stringWithFormat:@"%d",self.deposit];
//    self.headerView.width = kScreenWidth;
//    self.headerView.height = kScreenWidth / 750 * 478;
//    self.tableView.tableHeaderView = self.headerView;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.tableView.backgroundColor = [UIColor clearColor];
    
    _inst =  [AgoraAPI getInstanceWithoutMedia:agoreappID];
    // 注册cell、sectionHeader、sectionFooter
    _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionViewLayout.sectionInset=UIEdgeInsetsMake(0, 10, 10, 10);
    _collectionViewLayout.minimumLineSpacing = 10;
    _collectionViewLayout.minimumInteritemSpacing = 10;
    
    _collectionViewLayout.itemSize = CGSizeMake((SCREEN_W - 30) / 2, 220);
    [_collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//滚动方向
    _collectionViewLayout.headerReferenceSize = CGSizeMake(SCREEN_W, 246);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 0) collectionViewLayout:_collectionViewLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate=  self;
    _collectionView.hidden = NO;
    _collectionView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    [_collectionView registerNib:[UINib nibWithNibName:@"AccountChargeCell" bundle:nil] forCellWithReuseIdentifier:@"AccountChargeCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"AccountHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AccountHeaderView"];
//    [_collectionView registerNib:[UINib nibWithNibName:@"AccountCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"AccountCollectionCell"];
//    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderView"];
    _collectionView.tintColor = Color_nav;
    [self.view insertSubview:_collectionView atIndex:0];
//    _collectionViewLayout.minimumLineSpacing = .5;
//    _collectionViewLayout.minimumInteritemSpacing = .5;
//    CGFloat width = (SCREEN_W - 1) / 2;
//    _collectionViewLayout.itemSize = CGSizeMake(width, 240);
//    _collectionViewLayout.headerReferenceSize = CGSizeMake(SCREEN_W, 217);
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64) style:UITableViewStylePlain];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    _tableView.hidden = YES;
//    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiXinPay:) name:Notice_weiXinPay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appPaySugerss:) name:Notice_appPaySugerss object:nil];
    
    [self _loadData];
    if (self.isCall) {
        
        [self _loadData1];
        
    }
    
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [self createPay];
    
    if ([LXUserDefaults boolForKey:ISMEiGUO]){
        self.isRight = NO;
        
    }else{
        NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
        if ([lang hasPrefix:@"id"]){
            self.isRight = YES;
        }else{
            self.isRight = NO;
        }
    }
    
    
}

- (void)appPaySugerss:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    depositCount = [NSString stringWithFormat:@"%@",userInfo[@"data"][@"deposit"]];
    [_collectionView reloadData];
    
}


- (void)createPay
{
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
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
    accountModel = self.dataList[index];
    [self orderCreate:accountModel.uid withType:AppPay];
    
//    NSString *name = model.name;
//    if (name.length >= 3) {
//        NSString *count = [name substringToIndex:name.length - 3];
//        diamondCount = [NSString stringWithFormat:@"%@鉆", count];
//    }
//    
//    if([SKPaymentQueue canMakePayments]){
//        [self requestProductData:model.uid];
//    }else{
//        NSLog(LXSring(@"不允许程序内付费"));
//        [SVProgressHUD showErrorWithStatus:@"不允许程序内付费..."];
//    }
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
//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    //创建连接并发送同步请求
    NSError *error=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dic);
    if([dic[@"status"] intValue]==0){
        NSLog(@"购买成功！");
        
        NSDictionary *dicReceipt= dic[@"receipt"];
        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([productIdentifier isEqualToString:@"1"]) {
            NSInteger purchasedCount= [defaults integerForKey:productIdentifier];//已购买数量
            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
        }else{
            [defaults setBool:YES forKey:productIdentifier];
        }
        //在此处对购买记录进行存储，可以存储到开发商的服务器端
    }else{
        NSLog(@"购买失败，未通过验证！");
    }
}
////监听购买结果
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
//    
//    
//    for(SKPaymentTransaction *tran in transaction){
//        
//        switch (tran.transactionState) {
//            case SKPaymentTransactionStatePurchased:{
//                NSLog(LXSring(@"交易完成"));
//                [self verifyPurchaseWithPaymentTransaction];
//                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
//                
//            }
//                
//                break;
//            case SKPaymentTransactionStatePurchasing:
//                NSLog(LXSring(@"商品添加进列表"));
//                
//                break;
//            case SKPaymentTransactionStateRestored:{
//                NSLog(LXSring(@"已经购买过商品"));
//                
//                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
//            }
//                break;
//            case SKPaymentTransactionStateFailed:{
//                NSLog(LXSring(@"交易失败"));
//                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
//                [SVProgressHUD showErrorWithStatus:LXSring(@"购买失败")];
//            }
//                break;
//            default:
//                break;
//        }
//    }
//}
//
////交易结束
//- (void)completeTransaction:(SKPaymentTransaction *)transaction{
//    NSLog(LXSring(@"交易结束"));
//    
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//}

//- (void)dealloc
//{
//   
//    
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
            [SVProgressHUD showWithStatus:LXSring(@"支付成功")];
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
            });
            
            break;
        case -1:
            //                payResoult = @"支付结果：失败！";
            [SVProgressHUD showWithStatus:LXSring(@"支付失败")];
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
                [SVProgressHUD showWithStatus:LXSring(@"支付成功")];
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
                break;
            case -1:
                //                payResoult = @"支付结果：失败！";
                [SVProgressHUD showWithStatus:LXSring(@"支付失败")];
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
                
                myModel = [Mymodel mj_objectWithKeyValues:result[@"data"]];
//                self.accountLab.text = [NSString stringWithFormat:@"%d",myModel.deposit];
                depositCount = [NSString stringWithFormat:@"%d",myModel.deposit];
                [_collectionView reloadData];
//                [_tableView reloadData];
                
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
    if (self.payType == AppPay) {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:@0, @"pay", nil];
    } else if (self.payType == UnipinPay) {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:@1, @"pay", nil];
    } else if (self.payType == HuaFeiPay) {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:@2, @"pay", nil];
    }
    [WXDataService requestAFWithURL:Url_commodities params:params httpMethod:@"GET" isHUD:YES isErrorHud:YES  finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                NSArray *array = result[@"data"][@"commodities"];
                for (NSDictionary *dic in array) {
                    AccountModel *model = [AccountModel mj_objectWithKeyValues:dic];
                    [self.dataList addObject:model];
                }
                [_collectionView reloadData];
//                [_tableView reloadData];
                
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
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataList.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    static NSString *identifire = @"cellID";
//    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountCell" owner:nil options:nil] lastObject];
//        
//    }
//    
//    AccountModel *model = self.dataList[indexPath.row];
//    cell.valueLab.text = model.name;
//    
//    if (fmodf(model.price / 100.00, 1)==0) {//如果有一位小数点
//        [cell.priceBtn setTitle:[NSString stringWithFormat:@"￥%.0f",model.price / 100.00] forState:UIControlStateNormal];
//    } else if (fmodf(model.price / 100.00, 1)==0) {//如果有两位小数点
//        
//        [cell.priceBtn setTitle:[NSString stringWithFormat:@"￥%.1f",model.price / 100.00] forState:UIControlStateNormal];
//    } else {
//        
//        [cell.priceBtn setTitle:[NSString stringWithFormat:@"￥%.2f",model.price / 100.00] forState:UIControlStateNormal];
//    }
//    
//    [cell.headIG sd_setImageWithURL:[NSURL URLWithString:model.icon]];
//    cell.priceBtn.tag = indexPath.row;
//    [cell.priceBtn addTarget:self action:@selector(buttonAC:) forControlEvents:UIControlEventTouchUpInside];
//    cell.model = model;
//    
//    return cell;
//    
//    
//}

- (void)buttonAC:(UIButton *)sender
{
    accountModel = self.dataList[sender.tag];
//    if (self.payType == AppPay) {
        // 苹果支付
        [self orderCreate:accountModel.uid withType:self.payType];
        
//    } else if (self.payType == HuaFeiPay) {
//        // 话费支付
//        [self orderCreate:accountModel.uid withType:HuaFeiPay];
//        
//    } else if (self.payType == UnipinPay) {
//        // 印尼第三方支付
//        [self orderCreate:accountModel.uid withType:HuaFeiPay];
//    }
    
//    [self btnClick:sender.tag];
//    _tableView.hidden = NO;
    
    
    
//    AccountModel *model = self.dataList[sender.tag];
//    AccountPayTypeVC *vc = [[AccountPayTypeVC alloc] init];
//    vc.model = self.model;
//    vc.accountModel = model;
//    vc.depositCount = depositCount;
//    vc.orderReferee = self.orderReferee;
//    [self.navigationController pushViewController:vc animated:YES];

//    AccountModel *model = self.dataList[sender.tag];
//    
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"Apple Pay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        
//    }];
//    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:LXSring(@"微信支付") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        
//        [self orderCreate:model.uid withType:WeixinPay];
//        
//    }];
//    
//    UIAlertAction *aliAction1 = [UIAlertAction actionWithTitle:LXSring(@"支付宝支付") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        
//        [self orderCreate:model.uid withType:AliPay];
//        
//    }];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LXSring(@"取消") style:UIAlertActionStyleCancel handler:nil];
//    [cancelAction setValue:Color_Text_lightGray forKey:@"_titleTextColor"];
//    [defaultAction setValue:[MyColor colorWithHexString:@"#4FB854"] forKey:@"_titleTextColor"];
//    [aliAction1 setValue:[MyColor colorWithHexString:@"#4FB854"] forKey:@"_titleTextColor"];
//    
//    [defaultAction1 setValue:[MyColor colorWithHexString:@"#4FB854"] forKey:@"_titleTextColor"];
//    
////            [alertController addAction:defaultAction1];
//    
////            [alertController addAction:aliAction1];
//    
//    //    if ([LXUserDefaults boolForKey:payEnable]) {
//    [alertController addAction:defaultAction1];
//    //    }
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
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
            
                if (self.payType == AppPay) {
                    if([SKPaymentQueue canMakePayments]){
                        [self requestProductData:uid];
                    }else{
                        
                        [SVProgressHUD showErrorWithStatus:LXSring(@"不允许程序内付费...")];
                    }
                } else if (self.payType == HuaFeiPay) {
                    // 话费
                    NSString *price = [NSString stringWithFormat:@"%d", accountModel.price];
                    NSString *url = [NSString stringWithFormat:@"%@/pages/id-id/unipin_dcb.html?unipin=%@&order=%@&price=%@", payMainUrl, @0, uids, price];
                    PayWebViewVC *vc = [[PayWebViewVC alloc] init];
                    vc.urlString = url;
                    [self.navigationController pushViewController:vc animated:YES];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    
                } else if (self.payType == UnipinPay) {
                    // unipin
                    NSString *price = [NSString stringWithFormat:@"%d", accountModel.price];
                    NSString *url = [NSString stringWithFormat:@"%@/pages/id-id/unipin_dcb.html?unipin=%@&order=%@&price=%@", payMainUrl, @1, uids, price];
                    PayWebViewVC *vc = [[PayWebViewVC alloc] init];
                    vc.urlString = url;
                    [self.navigationController pushViewController:vc animated:YES];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                } else {
                    if([SKPaymentQueue canMakePayments]){
                        [self requestProductData:uid];
                    }else{
                        
                        [SVProgressHUD showErrorWithStatus:LXSring(@"不允许程序内付费...")];
                    }
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
        NSLog(@"%@", LXSring(@"支付成功"));
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        NSLog(@"%@", LXSring(@"支付失败"));
    }
}

#pragma mark ----支付完成
- (void)paymentAuthorizationViewControllerDidFinish:
(PKPaymentAuthorizationViewController *)controller {
    // 支付完成后让支付页面消失
    [controller dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AccountChargeCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"AccountChargeCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    AccountModel *model = self.dataList[indexPath.row];
    cell.countLabel.text = model.name;
    cell.chargeButton.layer.borderWidth = 1;
    cell.chargeButton.layer.borderColor = UIColorFromRGB(0x00ddcc).CGColor;
    cell.chargeButton.layer.cornerRadius = 15;
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    NSString *money = @"";
    if ([lang hasPrefix:@"ar"]){
//        cell.leftTopImageView.image = [UIImage imageNamed:@"biaoqian3"];
        money = @"$";
    }else if ([lang hasPrefix:@"id"]){
//        cell.leftTopImageView.image = [UIImage imageNamed:@"biaoqian2"];
        money = @"Rp.";
    }else{
//        cell.leftTopImageView.image = [UIImage imageNamed:@"biaoqian1"];
        money = @"NT $";
    }
    if (fmodf(model.price / 100.00, 1)==0) {//如果有一位小数点
        [cell.chargeButton setTitle:[NSString stringWithFormat:@"%@%.0f",money,model.price / 100.00] forState:UIControlStateNormal];
    } else if (fmodf(model.price / 100.00, 1)==0) {//如果有两位小数点

        [cell.chargeButton setTitle:[NSString stringWithFormat:@"%@%.1f",money,model.price / 100.00] forState:UIControlStateNormal];
    } else {

        [cell.chargeButton setTitle:[NSString stringWithFormat:@"%@%.2f",money,model.price / 100.00] forState:UIControlStateNormal];
    }
    if (myModel.totalInpour == 0 && model.isVipForFirstTopUp == 1) {
        cell.leftTopImageView.hidden = NO;
        
        if (model.vipDays > 0) {
            if (model.bonus > 0) {
                cell.textLabel.text = [NSString stringWithFormat:LXSring(@"首充贈送VIP %d 天 + %d 鑽"), model.vipDays, model.bonus];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:LXSring(@"首充贈送VIP %d 天"), model.vipDays];
            }
            
        } else {
            if (model.bonus > 0) {
                cell.textLabel.text = [NSString stringWithFormat:LXSring(@"首充贈送 %d 鑽"), model.bonus];
            } else {
                cell.textLabel.text = @"";
            }
        }
    } else {
        cell.leftTopImageView.hidden = YES;
        if (model.vipDays > 0) {
            if (model.bonus > 0) {
                cell.textLabel.text = [NSString stringWithFormat:LXSring(@"贈送VIP %d 天 + %d 鑽"), model.vipDays, model.bonus];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:LXSring(@"贈送VIP %d 天"), model.vipDays];
            }
            
        } else {
            if (model.bonus > 0) {
                cell.textLabel.text = [NSString stringWithFormat:LXSring(@"贈送 %d 鑽"), model.bonus];
            } else {
                cell.textLabel.text = @"";
            }
        }
    }
    [cell.zuanImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    cell.chargeButton.tag = indexPath.row;
    [cell.chargeButton addTarget:self action:@selector(buttonAC:) forControlEvents:UIControlEventTouchUpInside];
//    cell.bigBGView.layer.shadowColor = [UIColor blackColor].CGColor;
//    cell.bigBGView.layer.shadowRadius = 5.f;
//    cell.bigBGView.layer.shadowOpacity = .3f;
//    cell.bigBGView.layer.shadowOffset = CGSizeMake(0, 0);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        AccountHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AccountHeaderView" forIndexPath:indexPath];
        if (headerView == nil) {
            headerView = [[AccountHeaderView alloc] init];
        }
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.countLabel.text = depositCount;
        if([LXUserDefaults boolForKey:ISMEiGUO]) {
            headerView.inviteButton.hidden = YES;
        } else {
            headerView.inviteButton.hidden = NO;
        }
        [headerView.inviteButton addTarget:self action:@selector(inviteBtnAC) forControlEvents:UIControlEventTouchUpInside];
        if (myModel.vipEndTime == 0) {
            // 没有vip
//            headerView.vipImageView.image = [UIImage imageNamed:@"VIP-icon02"];
//            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:LXSring(@"儲值贈送VIP，私信暢聊無限制~")];
//            [attributedStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(2, 5)];
//            headerView.timeLabel.text = LXSring(@"儲值贈送VIP，私信暢聊無限制~");

        } else {
            // 有vip
//            long timeSp = myModel.vipEndTime;
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp / 1000];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"YYYY-MM-dd"];
//            NSString *string = [formatter stringFromDate:date];
//            headerView.timeLabel.text = [NSString stringWithFormat:LXSring(@"VIP有效期至：%@"), string];
//            headerView.vipImageView.image = [UIImage imageNamed:@"VIP-icon01"];
        }
        
        view = headerView;
        
//        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderView" forIndexPath:indexPath];
//        if (headerView == nil) {
//            headerView = [[CollectionHeaderView alloc] init];
//        }
//        headerView.backgroundColor = [UIColor whiteColor];
//        headerView.countLabel.text = depositCount;
//        if (myModel.vipEndTime == 0) {
//            // 没有vip
//            headerView.vipImageView.image = [UIImage imageNamed:@"VIP-icon02"];
////            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:LXSring(@"儲值贈送VIP，私信暢聊無限制~")];
////            [attributedStr addAttribute:NSForegroundColorAttributeName value:Color_nav range:NSMakeRange(2, 5)];
//            headerView.timeLabel.text = LXSring(@"儲值贈送VIP，私信暢聊無限制~");
//            
//        } else {
//            // 有vip
//            long timeSp = myModel.vipEndTime;
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp / 1000];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"YYYY-MM-dd"];
//            NSString *string = [formatter stringFromDate:date];
//            headerView.timeLabel.text = [NSString stringWithFormat:LXSring(@"VIP有效期至：%@"), string];
//            headerView.vipImageView.image = [UIImage imageNamed:@"VIP-icon01"];
//        }
//        
//        view = headerView;
    }
    return view;
}

- (void)inviteBtnAC {
    InvitationVC *vc = [[InvitationVC alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)sendMessageToPerson:(NSString *)uid diamonds:(NSString *)diamonds {
    NSString *content = [NSString stringWithFormat:LXSring(@"我已通過你的頁面儲值：%@"), diamonds];;
    long long idate = [[NSDate date] timeIntervalSince1970]*1000;
    __block Message *messageModel = [Message new];
    messageModel.isSender = YES;
    messageModel.isRead = NO;
    messageModel.status = MessageDeliveryState_Delivering;
    messageModel.date = idate;
    messageModel.messageID = [NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate];
    messageModel.chancelID = [NSString stringWithFormat:@"%@_%@",[LXUserDefaults objectForKey:UID],uid];
    messageModel.type = MessageBodyType_Text;
    messageModel.uid = [NSString stringWithFormat:@"%@",[LXUserDefaults objectForKey:UID]];
    messageModel.sendUid = uid;
    messageModel.content = content;
    [messageModel save];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
    });
    
    NSDictionary *dic = @{
                          @"message": @{
                                  @"messageID": messageModel.messageID,
                                  @"event": @"recharge",
                                  @"content": content,
                                  @"request": @"-3",
                                  @"time": [NSString stringWithFormat:@"%lld",idate]
                                  }
                          };
    
    NSString *msgStr = [InputCheck convertToJSONData:dic];
    [_inst messageInstantSend:self.orderReferee uid:0 msg:msgStr msgID:[NSString stringWithFormat:@"%@_%lld",[LXUserDefaults objectForKey:UID],idate]];
}



//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake((SCREEN_W- 10)/2, 240);
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(SCREEN_W, 217);
//}

@end
