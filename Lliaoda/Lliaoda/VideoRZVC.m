//
//  VideoRZVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoRZVC.h"

@interface VideoRZVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation VideoRZVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = DTLocalizedString(@"視頻認證", nil);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.yanzBtn.layer.cornerRadius = 22;
    self.yanzBtn.layer.masksToBounds = YES;
  
    [self.yanzBtn setTitle:DTLocalizedString(@"馬上驗證", nil) forState:UIControlStateNormal];
    
    self.footerView.width = kScreenWidth;
    self.footerView.height = 30 + 44;
    self.tableView.tableFooterView = self.footerView;
    
    
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
    static NSString *identifire = @"cellID";
    VideoRZCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoRZCell" owner:nil options:nil]  lastObject];
        
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];

    cell.tLabel.text = @"通過自拍認證後可以提高收入上限，還有機會上精選，獲得更多關注哦～";
    return cell;
        
    }else if(indexPath.row == 1){
        
        static NSString *identifire = @"cellID";
        VideoRZTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoRZTwoCell" owner:nil options:nil]  lastObject];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.backgroundColor = [UIColor clearColor];


        return cell;

    
    }else{
        
        static NSString *identifire = @"cellID";
        VideoRZThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoRZThreeCell" owner:nil options:nil]  lastObject];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];


        return cell;

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VideoRZCell whc_CellHeightForIndexPath:indexPath tableView:tableView];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (IBAction)yanzhenAC:(id)sender {
    
//    NSString *urlStr = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url1 = [NSURL URLWithString:urlStr];
//    
//    FMVideoPlayController *playVC = [[FMVideoPlayController alloc] init];
//    playVC.videoUrl = url1;
//    [self.navigationController pushViewController:playVC animated:YES];
    FMImagePicker *picker = [[FMImagePicker alloc] init];
    picker.videoSucess = ^(NSDictionary *info){
    
        VideoOneVC *VC = [[VideoOneVC alloc] init];
        VC.infodic = info;
        [self.navigationController pushViewController:VC animated:YES];
    
    };

    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
@end




