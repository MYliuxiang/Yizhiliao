//
//  MyVideoCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/5/31.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "MyVideoCell.h"

@implementation MyVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _fengMLabel.text = LXSring(@"封面");
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)setIsFirst:(BOOL)isFirst
{
    _isFirst = isFirst;
    if (_isFirst) {
        self.bgImageView.image = [UIImage imageNamed:@"tianjia"];
        
        self.bgImageView.contentMode = UIViewContentModeCenter;

        self.feiView.hidden = YES;
        self.videoIg.hidden = YES;
    }else{
    
        self.bgImageView.image = [UIImage imageNamed:@""];
        self.bgImageView.contentMode = UIViewContentModeScaleToFill;

    }
    
    
}

- (void)setVideo:(Video *)video
{
    _video = video;
    self.feiView.hidden = YES;
    if (self.model.selected == 1) {
        self.feiView.hidden = NO;
    }else{
        
        self.feiView.hidden = YES;
    }
    self.videoIg.hidden = NO;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.video.cover]];
    
}

- (void)setModel:(MyVideoModel *)model
{
    _model = model;
    self.feiView.hidden = YES;
    if (self.model.selected == 1) {
        self.feiView.hidden = NO;
    }else{
        
        self.feiView.hidden = YES;
    }
    self.videoIg.hidden = NO;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.model.cover]];
    
}


@end
