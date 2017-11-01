//
//  VideoRZVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoRZVC.h"
#import "VideoRZVC1.h"
@interface VideoRZVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *infodic;
}
@end

@implementation VideoRZVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"視頻認證");
    self.nav.backgroundColor = Color_Text_origin;
    self.titleLable.textColor = Color_Text_black;
    [self.backButtton setImage:[UIImage imageNamed:@"back_hei"] forState:UIControlStateNormal];
//    self.topLabel.text = LXSring(@"女生可通过提交一下认证信息成为主播，设计收费，聊天赚钱哦!");
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 8; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
//    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
//                          };
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:LXSring(@"1.本人半身录影，10~15秒，正面，五官清晰，包含自我介绍；\n2.与登录后提交的个人主页照片为同一人，均为本人；\n3.模仿范例视频可提高认证通过率；\n注意：录影不会对外公开，我们将对你的视频严格保密！认证如果失败，登录后可重新提交~") attributes:dic];
//    self.unApproveDetailLabel.attributedText = attributeStr;
//    self.unApproveLeftLabel.text = LXSring(@"范例视频");
//    self.unApproveDetailLabel.text = LXSring(@"1.本人半身录影，10~15秒，正面，五官清晰，包含自我介绍；\n2.与登录后提交的个人主页照片为同一人，均为本人；\n3.模仿范例视频可提高认证通过率；\n注意：录影不会对外公开，我们将对你的视频严格保密！认证如果失败，登录后可重新提交~");
//    [self.unApproveUploadButton setTitle:LXSring(@"上传视频") forState:UIControlStateNormal];
//    self.unApproveTitleLabel.text = LXSring(@"認證要求");
    self.bgView1.layer.cornerRadius = 5;
    self.bgView1.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView1.layer.shadowRadius = 5.f;
    self.bgView1.layer.shadowOpacity = .3f;
    self.bgView1.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.bgView2.layer.cornerRadius = 5;
    self.bgView2.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView2.layer.shadowRadius = 5.f;
    self.bgView2.layer.shadowOpacity = .3f;
    self.bgView2.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.bgView3.layer.cornerRadius = 5;
    self.bgView3.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView3.layer.shadowRadius = 5.f;
    self.bgView3.layer.shadowOpacity = .3f;
    self.bgView3.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.unApproveUploadButton.layer.cornerRadius = 22;
    self.unApproveUploadButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.unApproveUploadButton.layer.shadowRadius = 5.f;
    self.unApproveUploadButton.layer.shadowOpacity = .3f;
    self.unApproveUploadButton.layer.shadowOffset = CGSizeMake(0, 0);
    
//    self.unApproveVideoImageView.layer.cornerRadius = 5;
//    self.unApproveVideoPlayButton.layer.cornerRadius = 5;
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.yanzBtn.layer.cornerRadius = 22;
    self.yanzBtn.layer.masksToBounds = YES;
  
    [self.yanzBtn setTitle:LXSring(@"馬上驗證") forState:UIControlStateNormal];
    
    self.footerView.width = kScreenWidth;
    self.footerView.height = 30 + 44;
    self.tableView.tableFooterView = self.footerView;
    
    [self getLocalVideo];
}

#pragma mark - 获取范例视频
- (void)getLocalVideo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1495262516.mp4" ofType:nil];
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"zh-Hant"]) {
        
        filePath = [[NSBundle mainBundle] pathForResource:@"1495262516.mp4" ofType:nil];
    }else if ([lang hasPrefix:@"id"]){
        
        filePath = [[NSBundle mainBundle] pathForResource:@"id1495262516.mp4" ofType:nil];
    }else if ([lang hasPrefix:@"ar"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"ar1502964098" ofType:@"mp4"];
    }else{
        filePath = [[NSBundle mainBundle] pathForResource:@"1495262516.mp4" ofType:nil];
    }
    //第一次安装
    self.unApproveVideoImageView.image = [self thumbnailImageForVideo:[NSURL fileURLWithPath:filePath] atTime:1];
//    [self.playBtn setImage:[self thumbnailImageForVideo:[NSURL fileURLWithPath:filePath] atTime:1] forState:UIControlStateNormal];
}
#pragma mark - 取出視訊图片
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
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

    cell.tLabel.text = LXSring(@"通過自拍認證後可以提高收入上限，還有機會上精選，獲得更多關注哦～");
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
    
    self.type = 0;
    if([self isVideoRecordingAvailable]){
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手機暫不支持錄製視屏" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}
- (IBAction)unApproveUploadButtonAC:(id)sender {

    
    self.type = 1;
    if([self isVideoRecordingAvailable]){
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手機暫不支持錄製視屏" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alertView show];
    }

    
}

#pragma mark - Private methods
- (BOOL)isVideoRecordingAvailable
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
            return YES;
        }
    }
    return NO;
}


#pragma mark - UIImagePickerController代理方法
//完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (self.type == 0) {
        
        VideoOneVC *VC = [[VideoOneVC alloc] init];
        VC.infodic = info;
        [self.navigationController pushViewController:VC animated:YES];
//    }else{
//
//        VideoRZVC1 *vc = [[VideoRZVC1 alloc] init];
//                vc.info = info;
//        [self.navigationController pushViewController:vc animated:YES];
    }
  
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 私有方法
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceFront;//设置使用哪个摄像头，这里设置为后置摄像头
            _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
            _imagePicker.videoQuality=UIImagePickerControllerQualityTypeIFrame1280x720;
            _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
            
       
        _imagePicker.allowsEditing=YES;//允许编辑
        _imagePicker.delegate=self;//设置代理，检测操作
    }
    return _imagePicker;
}

- (IBAction)unApproveVideoPlayButtonAC:(id)sender {
    FMVideoPlayController *playVC = [[FMVideoPlayController alloc] init];
    NSString *filePath = nil;
    //第一次安装
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"zh-Hant"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"1495262516.mp4" ofType:nil];
    }else if ([lang hasPrefix:@"id"]){
        filePath = [[NSBundle mainBundle] pathForResource:@"id1495262516.mp4" ofType:nil];
    }else if ([lang hasPrefix:@"ar"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"ar1502964098.mp4" ofType:@""];
    }else{
        filePath = [[NSBundle mainBundle] pathForResource:@"1495262516.mp4" ofType:nil];
    }
    //    filePath = [[NSBundle mainBundle] pathForResource:@"1495262516.mp4" ofType:nil];
    playVC.videoUrl = [NSURL fileURLWithPath:filePath];
    [self.navigationController pushViewController:playVC animated:YES];
}



@end




