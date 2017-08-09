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
    NSString *lang = [LXUserDefaults valueForKey:@"appLanguage"];
    if ([lang hasPrefix:@"zh-Hant"]) {
       
        filePath = [[NSBundle mainBundle] pathForResource:@"1495262516.mp4" ofType:nil];
    }else if ([lang hasPrefix:@"id"]){
        
        filePath = [[NSBundle mainBundle] pathForResource:@"id1495262516.mp4" ofType:nil];
    }else{
       filePath = [[NSBundle mainBundle] pathForResource:@"1495262516.mp4" ofType:nil];
    }
    
        //第一次安装
    [self.playBtn setImage:[self thumbnailImageForVideo:[NSURL fileURLWithPath:filePath] atTime:1] forState:UIControlStateNormal];
    
}

//图片截取
-(UIImage *)getSubImageWith:(UIImage *)originalImage
{
    
    CGRect cropFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    CGRect squareFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    
    CGFloat oriWidth = cropFrame.size.width;
    CGFloat oriHeight = originalImage.size.height * (oriWidth / originalImage.size.width);
    CGFloat oriX = cropFrame.origin.x + (cropFrame.size.width - oriWidth) / 2;
    CGFloat oriY = cropFrame.origin.y + (cropFrame.size.height - oriHeight) / 2;
    CGRect oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    CGRect latestFrame = oldFrame;
    
    CGFloat scaleRatio = latestFrame.size.width / originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.width / scaleRatio;
    if (latestFrame.size.width < cropFrame.size.width) {
        CGFloat newW = originalImage.size.width;
        CGFloat newH = newW * (cropFrame.size.height /cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (latestFrame.size.height < cropFrame.size.height) {
        CGFloat newH = originalImage.size.height;
        CGFloat newW = newH * (cropFrame.size.width / cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
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
    
    return [self getSubImageWith:thumbnailImage];
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
