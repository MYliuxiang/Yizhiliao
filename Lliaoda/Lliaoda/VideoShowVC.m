//
//  VideoShowVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoShowVC.h"

@interface VideoShowVC ()

@end

@implementation VideoShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = @"视频秀";
    MEntrance *rance = [[MEntrance alloc] initWithVC:self withimageName:@"qipao" withBageColor:[UIColor whiteColor]];
    [self.nav addSubview:rance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
