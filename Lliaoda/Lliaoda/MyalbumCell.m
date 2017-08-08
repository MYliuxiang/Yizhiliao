//
//  MyalbumCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/27.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MyalbumCell.h"

@implementation MyalbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.label.text = LXSring(@"封面");
    
}

- (void)setModel:(AlbumModel *)model
{
    _model = model;
    self.feiView.hidden = YES;
    if (self.model.selected == 1) {
        self.feiView.hidden = NO;
    }else{
        
        self.feiView.hidden = YES;
    }
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.model.url]];
}

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    self.feiView.hidden = YES;
   
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.photo.url]];

}



- (void)setIsFirst:(BOOL)isFirst
{
    _isFirst = isFirst;
    if (_isFirst) {
        self.bgImageView.image = [UIImage imageNamed:@"album"];
        self.feiView.hidden = YES;
    }
    

}

@end
