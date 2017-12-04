//
//  VideoRZVC1.m
//  Lliaoda
//
//  Created by 小牛 on 2017/8/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoRZVC1.h"
#import "VideoRZVC2.h"
@interface VideoRZVC1 ()

@end

@implementation VideoRZVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.text = LXSring(@"視頻認證");
    self.nav.backgroundColor = [UIColor clearColor];
    self.titleLable.textColor = [UIColor whiteColor];
    [self.backButtton setImage:[UIImage imageNamed:@"back_bai"] forState:UIControlStateNormal];
    
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
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:LXSring(@"请确保视频为真人，否则将不通过！\n提交视频后，\n系统将在2天内给出审核结果，\n请耐心等待~") attributes:dic];
    self.approvingDetailLabel.attributedText = attributeStr;
//    self.approvingDetailLabel.text = LXSring(@"请确保视频为真人，否则将不通过！\n提交视频后，\n系统将在2天内给出审核结果，\n请内心等待~");
    [self.approvingUploadButton setTitle:LXSring(@"提交视频") forState:UIControlStateNormal];
    
    self.approvingView.layer.cornerRadius = 5;
    self.approvingView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.approvingView.layer.shadowRadius = 5.f;
    self.approvingView.layer.shadowOpacity = .3f;
    self.approvingView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.approvingVideoImageView.layer.cornerRadius = 5;
    self.approvingUploadButton.layer.cornerRadius = 22;
    self.approvingUploadButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.approvingUploadButton.layer.shadowRadius = 5.f;
    self.approvingUploadButton.layer.shadowOpacity = .3f;
    self.approvingUploadButton.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.approvingVideoImageView.image = [self thumbnailImageForVideo:[_info objectForKey:UIImagePickerControllerMediaURL]
                                                               atTime:1];
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
- (IBAction)approvingVideoPlayButtonAC:(id)sender {
    FMVideoPlayController *playVC = [[FMVideoPlayController alloc] init];
    playVC.videoUrl = [self.info objectForKey:UIImagePickerControllerMediaURL];
    [self.navigationController pushViewController:playVC animated:YES];
}
- (IBAction)approvingUploadButtonAC:(id)sender {
    VideoRZVC2 *vc = [[VideoRZVC2 alloc] init];
    vc.info = self.info;
    vc.isFirst = self.isFirst;
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
