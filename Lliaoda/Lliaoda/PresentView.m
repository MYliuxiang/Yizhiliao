//
//  PresentView.m
//  presentAnimation
//
//  Created by 许博 on 16/7/14.
//  Copyright © 2016年 许博. All rights reserved.
//

#import "PresentView.h"

@interface PresentView ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) void(^completeBlock)(BOOL finished,NSInteger finishCount); // 新增了回调参数 finishCount， 用来记录动画结束时累加数量，将来在3秒内，还能继续累加
@end

@implementation PresentView

// 根据礼物个数播放动画
- (void)animateWithCompleteBlock:(completeBlock)completed{

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self shakeNumberLabel];
    }];
    self.completeBlock = completed;
}

- (void)shakeNumberLabel{
    _animCount ++;
//    NSLog(@"shakeNumberLabel");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];//可以取消成功。
    [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:3];
    
    self.skLabel.text = [NSString stringWithFormat:@"X%ld",_animCount];
    [self.skLabel startAnimWithDuration:0.3];
}

- (void)hidePresendView
{
    [UIView animateWithDuration:0.30 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.completeBlock) {
            self.completeBlock(finished,_animCount);
        }
        [self reset];
        _finished = finished;
        [self removeFromSuperview];
    }];
}

// 重置
- (void)reset {
    
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
    self.skLabel.text = @"";
}

- (instancetype)init {
    if (self = [super init]) {
        _originFrame = self.frame;
        [self setUI];
    }
    return self;
}

#pragma mark 布局 UI
- (void)layoutSubviews {
    
    [super layoutSubviews];
    _giftLabel.frame = CGRectMake(15, 0,self.width - 30 - self.height / 2, self.height);
    _giftLabel.numberOfLines = 0;
    _giftLabel.width = self.width - 80 ;
    [_giftLabel sizeThatFits:CGSizeMake(self.width - 80, 50)];
    _giftLabel.top = (self.height - _giftLabel.height) / 2.0;

    _bgImageView.frame = CGRectMake(0, 0, self.width+ 20, 50);
    _bgImageView.left = -20;
    _bgImageView.layer.cornerRadius = self.frame.size.height / 2;
    _bgImageView.layer.masksToBounds = YES;
    
    _skLabel.frame = CGRectMake(CGRectGetMaxX(self.frame) + 5,-20, 60, 50);
    _giftImageView.frame = CGRectMake(self.width - 60, -30, 50, 50);
    
    _zuanImage.frame = CGRectMake(_giftImageView.left, _giftImageView.bottom + 2, 14, 14);
    _zuanImage.image = [UIImage imageNamed:@"鑽－小"];
    _countLabel.frame = CGRectMake(_zuanImage.right + 2, _zuanImage.top, 45, 14);
   

}

#pragma mark 初始化 UI
- (void)setUI {
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor blackColor];
    _bgImageView.alpha = 0.3;
   
    _zuanImage = [[UIImageView alloc] init];
    _giftImageView = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _giftLabel = [[UILabel alloc] init];
    _countLabel = [[UILabel alloc] init];

    _countLabel.textColor  = [UIColor whiteColor];
    _countLabel.font = [UIFont systemFontOfSize:10];
    _nameLabel.textColor  = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _giftLabel.textColor  = [UIColor yellowColor];
    _giftLabel.font = [UIFont systemFontOfSize:13];
    
    // 初始化动画label
    _skLabel =  [[ShakeLabel alloc] init];
    _skLabel.font = [UIFont systemFontOfSize:20];
    _skLabel.borderColor = [UIColor whiteColor];
    _skLabel.textColor = [UIColor yellowColor];
    _skLabel.textAlignment = NSTextAlignmentCenter;
    _animCount = 0;
    
    [self addSubview:_bgImageView];
    [self addSubview:_giftImageView];
    [self addSubview:_nameLabel];
    [self addSubview:_giftLabel];
    [self addSubview:_skLabel];
    [self addSubview:_zuanImage];
    [self addSubview:_countLabel];
    
}

- (void)setModel:(GiftModel *)model {
    _model = model;
    if (_model.headImage == nil) {
        
        [_giftImageView sd_setImageWithURL:[NSURL URLWithString:_model.giftImage]];
    }else{
    
         _giftImageView.image = [UIImage imageNamed:@"红包雨02"];
    }
    _nameLabel.text = model.name;
    _giftLabel.text = [NSString stringWithFormat:@"%@",model.giftName];
    _giftCount = model.giftCount;
    _countLabel.text = [NSString stringWithFormat:@"%d",_model.diamonds];
    
}


@end
