//
//  VideoOneVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoOneVC.h"
#import <AVFoundation/AVFoundation.h>


@interface VideoOneVC ()
@property (weak, nonatomic) IBOutlet UILabel *label1;

@end

@implementation VideoOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"視訊上传");
    self.label1.text = LXSring(@"請確認當前大頭照與認證錄影都是您本人，否則無法通過認證！系統將在1-2個工作日完整審核，請耐心等待！");
    [self.doneBtn setTitle:LXSring(@"确认上传") forState:UIControlStateNormal];
    self.doneBtn.layer.cornerRadius = 22;
    self.doneBtn.layer.masksToBounds = YES;
    
    self.videlImageView.image = [self thumbnailImageForVideo:     [self.infodic objectForKey:UIImagePickerControllerMediaURL]
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


- (IBAction)doneAC:(id)sender{
    
    
//     [self revoverToMp4Whith:[self.infodic objectForKey:UIImagePickerControllerMediaURL]];
    VideoRZTwoVC *vc = [[VideoRZTwoVC alloc] init];
    vc.infoDic = self.infodic;
    [self.navigationController pushViewController:vc animated:YES];
    
}




- (IBAction)playAC:(id)sender {
    
    
    FMVideoPlayController *playVC = [[FMVideoPlayController alloc] init];
    playVC.videoUrl = [self.infodic objectForKey:UIImagePickerControllerMediaURL];
    [self.navigationController pushViewController:playVC animated:YES];
    
}


@end
