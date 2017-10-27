//
//  NewMyalbumCell.m
//  Lliaoda
//
//  Created by 小牛 on 2017/10/24.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "NewMyalbumCell.h"
#import "MyalbumVC.h"
#import "MyVideoVC.h"
@implementation NewMyalbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taoAC:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taoAC:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taoAC:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taoAC:)];
    [_imageView1 addGestureRecognizer:tap1];
    [_imageView2 addGestureRecognizer:tap2];
    [_imageView3 addGestureRecognizer:tap3];
    [_imageView4 addGestureRecognizer:tap4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setPhotoArray:(NSMutableArray *)photoArray {
//    if (photoArray.count >= 4) {
//        for (int i = 0; i < photoArray.count; i++) {
//            AlbumModel *model = photoArray[i];
//            switch (i) {
//                case 0:
//                    [_imageView1 sd_setImageWithURL:[NSURL URLWithString:model.url]];
//                    break;
//                case 1:
//                    [_imageView2 sd_setImageWithURL:[NSURL URLWithString:model.url]];
//                    break;
//                case 2:
//                    [_imageView3 sd_setImageWithURL:[NSURL URLWithString:model.url]];
//                    break;
//                case 3:
//                    [_imageView4 sd_setImageWithURL:[NSURL URLWithString:model.url]];
//                    break;
//
//                default:
//                    break;
//            }
//        }
//    }
//}
- (void)taoAC:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(imageShowAC:)]) {
        [_delegate imageShowAC:tap];
    }
}

- (IBAction)addButtonAC:(id)sender {
    MyalbumVC *vc = [[MyalbumVC alloc] init];
    [[self viewController].navigationController pushViewController:vc animated:YES];
}
@end
