//
//  VideoRZResultVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/20.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoRZResultVC.h"

@interface VideoRZResultVC ()

@end

@implementation VideoRZResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"視頻認證");
    self.failBtn.layer.cornerRadius = 22;
    self.failBtn.layer.masksToBounds = YES;
    [self.failBtn setTitle:LXSring(@"重新认证") forState:UIControlStateNormal];
    if (self.sucuress) {
        //成功
        [self loadData];
        self.stateLabel.text = LXSring(@"認證成功");
        self.stateLabel.textColor = [MyColor colorWithHexString:@"#46C6A9"];
        self.resultImageVIew.image = [UIImage imageNamed:@"chenggong"];
        self.stateTextLabel.text = @"恭喜你已通過認證！請遵守中華民國法律與平台規定，健康社交，安全使用APP。";
        self.sucuressView.hidden = YES;
        self.failBtn.hidden = YES;

    }else{
        
        //失败
        self.stateLabel.text = LXSring(@"認證失敗");
        self.stateLabel.textColor = Color_nav;
        self.resultImageVIew.image = [UIImage imageNamed:@"shibai"];
          self.stateTextLabel.text = @"以上認證失敗不符合要求，请确认当前大頭貼与自拍认证視訊都是您本人，完善个人主页照片和资料，并重新认证！";
        self.sucuressView.hidden = YES;
        self.failBtn.hidden = NO;
        
        
    }
}

- (void)loadData
{
//    [WXDataService requestAFWithURL:Url_accountmedia params:params httpMethod:@"GET" isHUD:YES finishBlock:^(id result) {
//        if(result){
//            if ([[result objectForKey:@"result"] integerValue] == 0) {
//                
//                NSArray *array = result[@"data"][@"medias"];
//                NSDictionary *dic = array.firstObject;
//                
//                for (NSDictionary *dic in array) {
//                    
//                    NSString *str = [NSString stringWithFormat:@"%@",dic[@"type"]];
//                    if ([str isEqualToString:@"photo"]) {
//                        
//                         [self.successImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"url"]]];
//                    }
//                }
//                
//                
//                
//                
//            } else{
//                [SVProgressHUD showErrorWithStatus:result[@"message"]];
//                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                    
//                    [SVProgressHUD dismiss];
//                });
//                
//            }
//        }
//        
//    } errorBlock:^(NSError *error) {
//        NSLog(@"%@",error);
//        
//    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)playAC:(id)sender {
    
}
- (IBAction)againVideoRZAC:(id)sender {
    
    VideoRZVC *vc = [[VideoRZVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end





