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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPhotoArray:(NSMutableArray *)photoArray {
    if (photoArray.count >= 4) {
        for (int i = 0; i < photoArray.count; i++) {
            AlbumModel *model = photoArray[i];
            switch (i) {
                case 0:
                    [_imageView1 sd_setImageWithURL:model.url];
                    break;
                    
                    
                default:
                    break;
            }
        }
    }
}

- (IBAction)addButtonAC:(id)sender {
    MyalbumVC *vc = [[MyalbumVC alloc] init];
    [[self viewController].navigationController pushViewController:vc animated:YES];
}
@end
