//
//  NewMyVideoCell.m
//  Lliaoda
//
//  Created by 小牛 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "NewMyVideoCell.h"

@implementation NewMyVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 我的
- (void)setVideoArray:(NSMutableArray *)videoArray {
    if (videoArray.count >= 4) {
        for (int i = 0; i < videoArray.count; i++) {
            MyVideoModel *model = videoArray[i];
            switch (i) {
                case 0:
                    [_imageView1 sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                    break;
                case 1:
                    [_imageView2 sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                    break;
                case 2:
                    [_imageView3 sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                    break;
                case 3:
                    [_imageView4 sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                    break;
                    
                default:
                    break;
            }
        }
    }
}


#pragma mark - 个人中心
- (void)setVideosArray:(NSArray *)videosArray {
    for (int i = 0; i < videosArray.count; i++) {
        Video *video = videosArray[i];
        switch (i) {
            case 0:
                [_imageView1 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                break;
            case 1:
                [_imageView2 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                break;
            case 2:
                [_imageView3 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                break;
            case 3:
                [_imageView4 sd_setImageWithURL:[NSURL URLWithString:video.cover]];
                break;
            default:
                break;
        }
    }
}

- (IBAction)videoPlayAC:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(videoPlayAC:)]) {
        [_delegate videoPlayAC:self];
    }
//    UIButton *button = sender;
//    NSInteger tag = button.tag;
//    NSLog(@"%lu", (unsigned long)self.videosArray.count);
//    Video *video = self.videosArray[tag - 100];
//    if (video != nil) {
//        VideoPlayVC *vc = [[VideoPlayVC alloc] init];
//        vc.videoUrl = [NSURL URLWithString:video.url];
//        [[self viewController] presentViewController:vc animated:YES completion:nil];
//    }
    
}
@end
