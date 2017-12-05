//
//  SelectSexVC.m
//  Lliaoda
//
//  Created by 小牛 on 2017/12/1.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "SelectSexVC.h"

@interface SelectSexVC ()

@end

@implementation SelectSexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"你是");
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowRadius = 5.f;
    self.bgView.layer.shadowOpacity = .3f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    
    _textLabel.text = LXSring(@"性别一旦选择后，不能自行更改");
    [_manButton setTitle:LXSring(@"男生") forState:UIControlStateNormal];
    [_womanButton setTitle:LXSring(@"女生") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)manButtonAC:(id)sender {
    self.manButton.selected = YES;
    self.womanButton.selected = NO;
    self.manImageView.layer.cornerRadius = 50;
    self.manImageView.layer.borderColor = UIColorFromRGB(0x00ddcc).CGColor;
    self.manImageView.layer.borderWidth = 2;
    self.womanImageView.layer.borderColor = [UIColor clearColor].CGColor;
    [self setSex:1];
}

- (IBAction)womanButtonAC:(id)sender {
    self.manButton.selected = NO;
    self.womanButton.selected = YES;
    self.womanImageView.layer.cornerRadius = 50;
    self.womanImageView.layer.borderColor = UIColorFromRGB(0x00ddcc).CGColor;
    self.womanImageView.layer.borderWidth = 2;
    self.manImageView.layer.borderColor = [UIColor clearColor].CGColor;
    [self setSex:0];
}

- (void)setSex:(int)sex {
    NSDictionary *params;
    params = @{@"gender":@(sex)};
    [WXDataService requestAFWithURL:Url_account params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                if (sex == 0) {
                    // 女生  前往视频认证页
                    VideoRZVC *vc = [[VideoRZVC alloc] init];
                    vc.isFirst = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    TJPTabBarController *rootVC = [[TJPTabBarController alloc] init];
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    delegate.window.rootViewController = rootVC;
                }
                
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
@end
