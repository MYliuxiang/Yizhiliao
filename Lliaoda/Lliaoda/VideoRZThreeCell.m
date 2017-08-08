//
//  VideoRZThreeCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "VideoRZThreeCell.h"

@implementation VideoRZThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgImgeView.layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    self.bgImgeView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.bgImgeView.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    self.bgImgeView.layer.shadowRadius = 3;//阴影半径，默认3
    
   self.label.text = LXSring(@"範例錄影");
    self.bgImgeView.layer.masksToBounds = NO;
    self.bgImgeView.layer.cornerRadius = 5.f;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1495262516.mp4" ofType:nil];
        //第一次安装
    [self.playBtn setImage:[self thumbnailImageForVideo:[NSURL fileURLWithPath:filePath] atTime:1] forState:UIControlStateNormal];
    
}

#pragma mark - 取出視訊图片
- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playAC:(id)sender {
    
    FMVideoPlayController *playVC = [[FMVideoPlayController alloc] init];
    NSString *filePath = nil;
    //第一次安装
    filePath = [[NSBundle mainBundle] pathForResource:@"1495262516.mp4" ofType:nil];
    playVC.videoUrl = [NSURL fileURLWithPath:filePath];
    [[self viewController].navigationController pushViewController:playVC animated:YES];
}
@end
